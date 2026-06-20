# API Specification

## Conventions
- Base path: `/api/v1`
- Authentication: `Authorization: Bearer <access_token>`
- Content type: `application/json`, except attachment upload endpoints
- Idempotent writes must accept:
  - `Idempotency-Key` header
  - `X-Device-Id` header
  - `client_generated_id` in request body when applicable

## Approved Platform Notes
- Backend: Laravel 12 API
- Database: MySQL
- Authentication: WhatsApp OTP plus Laravel Sanctum
- Attachments: Cloudinary file storage plus MySQL metadata
- Push notifications: FCM only
- Laravel backend is the single source of truth.
- No business logic may live inside Flutter.

## Standard Response Shapes

### Success Envelope
```json
{
  "data": {},
  "meta": {
    "request_id": "req_01J...",
    "timestamp": "2026-06-06T12:00:00Z"
  }
}
```

### List Envelope
```json
{
  "data": [],
  "meta": {
    "page": 1,
    "per_page": 20,
    "total": 100
  }
}
```

### Error Envelope
```json
{
  "error": {
    "code": "validation_failed",
    "message": "Request validation failed.",
    "details": {
      "phone_number": ["Phone number is required."]
    }
  },
  "meta": {
    "request_id": "req_01J..."
  }
}
```

## Shared Schemas

### Wallet
```json
{
  "id": "uuid",
  "name": "Main Wallet",
  "status": "active",
  "created_at": "2026-06-06T12:00:00Z",
  "balances": {
    "USD": "1250.00",
    "SYP": "12500000.00"
  },
  "version": 3
}
```

### Financial Transaction
```json
{
  "id": "uuid",
  "reference_code": "TX-2026-000001",
  "type": "deposit",
  "wallet_id": "uuid",
  "destination_wallet_id": null,
  "currency": "USD",
  "amount": "100.00",
  "amount_given": null,
  "exchange_rate": null,
  "amount_received": null,
  "note": "Cash top-up",
  "attachment_count": 1,
  "created_at": "2026-06-06T12:00:00Z"
}
```

### Debt Summary
```json
{
  "id": "uuid",
  "direction": "owed_by_contact",
  "currency": "USD",
  "original_amount": "100.00",
  "settled_amount": "30.00",
  "remaining_amount": "70.00",
  "status": "open",
  "contact": {
    "id": "uuid",
    "display_name": "Ali",
    "type": "external"
  }
}
```

### Notification Item
```json
{
  "id": "uuid",
  "type": "transfer_received",
  "title": "Transfer received",
  "body": "You received 50 USD from Ali.",
  "read_at": null,
  "created_at": "2026-06-06T12:00:00Z",
  "related_entity": {
    "type": "user_transfer",
    "id": "uuid"
  }
}
```

## Authentication APIs

### `POST /auth/register`
Creates a user, creates one active wallet named `Main Wallet`, assigns it as `default_receiving_wallet_id`, and starts WhatsApp OTP verification. User creation, `Main Wallet` creation, default wallet assignment, and OTP challenge creation must commit atomically.

Request:
```json
{
  "full_name": "Adham Ahmad",
  "phone_number": "+963999999999",
  "client_generated_id": "uuid"
}
```

Response `201`:
```json
{
  "data": {
    "user_id": "uuid",
    "main_wallet_id": "uuid",
    "default_receiving_wallet_id": "uuid",
    "otp_challenge_id": "uuid",
    "otp_expires_at": "2026-06-06T12:05:00Z"
  }
}
```

### `POST /auth/verify-otp`
Verifies a WhatsApp OTP challenge for registration, login, or new-device verification and authorizes Laravel-side authentication continuation.

Request:
```json
{
  "otp_challenge_id": "uuid",
  "otp_code": "123456"
}
```

Response `200`:
```json
{
  "data": {
    "verified": true,
    "access_token": "sanctum-token",
    "token_type": "Bearer"
  }
}
```

### `POST /auth/login`
Starts OTP-based login. The backend validates the phone number and device metadata, creates an OTP challenge, and sends the OTP through WhatsApp.

Request:
```json
{
  "phone_number": "+963999999999",
  "device_identifier": "device_123",
  "device_name": "iPhone 15"
}
```

Response `202`:
```json
{
  "data": {
    "otp_challenge_id": "uuid",
    "otp_expires_at": "2026-06-06T12:05:00Z",
    "requires_verification": true
  }
}
```

Behavior:
- Passwords are not accepted by this endpoint.
- Email-based login is not supported.
- New device login always requires WhatsApp OTP verification before access token issuance.

### `POST /auth/logout`
Revokes the current Sanctum-authenticated session or selected session scope.

Request:
```json
{
  "scope": "current_device"
}
```

Response `204`

### `POST /auth/biometric-devices`
Registers a device for application-unlock convenience on a trusted device. This does not replace server-side OTP identity verification for new device login.

Request:
```json
{
  "device_identifier": "device_123",
  "device_name": "Pixel 10",
  "platform": "android",
  "biometric_public_key": "base64-public-key"
}
```

Response `201`

### `GET /auth/devices`
Returns the authenticated user's registered devices.

Response `200`:
```json
{
  "data": [
    {
      "id": "uuid",
      "device_identifier": "device_123",
      "device_name": "Pixel 10",
      "platform": "android",
      "biometric_enabled": true,
      "created_at": "2026-06-06T12:00:00Z",
      "last_used_at": "2026-06-06T13:00:00Z"
    }
  ]
}
```

### `DELETE /auth/devices/{device_id}`
Revokes the selected device, disables biometric trust for that device, and invalidates its active Sanctum sessions/tokens.

Response `204`

## Wallet APIs

### `GET /wallets`
Query params:
- `search`
- `status=active|archived`
- `sort=created_desc|created_asc|name_asc|name_desc`

Response `200`: list of wallet schema.

Rules:
- Every user must always have at least one wallet.
- The backend creates `Main Wallet` automatically during successful registration.

### `POST /wallets`
Request:
```json
{
  "name": "Travel Wallet",
  "set_as_default_receiving_wallet": false,
  "client_generated_id": "uuid"
}
```

Response `201`: wallet schema.

### `GET /wallets/{wallet_id}`
Returns wallet details plus derived balances and placeholder counters.

### `PATCH /wallets/{wallet_id}`
Supports rename.

Request:
```json
{
  "name": "Business Wallet",
  "set_as_default_receiving_wallet": true,
  "version": 3
}
```

### `POST /wallets/{wallet_id}/archive`
Request:
```json
{
  "version": 3
}
```

Response `200`: archived wallet schema.

Archive rule:
- If the wallet is the current `default_receiving_wallet_id`, the request must either fail or include a replacement wallet strategy defined by the backend implementation.

### `POST /wallets/{wallet_id}/restore`
Restores an archived wallet to active status.

Request:
```json
{
  "version": 4,
  "set_as_default_receiving_wallet": false
}
```

Response `200`: active wallet schema.

## Transaction APIs

### `GET /transactions`
Query params:
- `wallet_id`
- `type=deposit|withdraw|internal_transfer|exchange|user_transfer|debt_settlement`
- `currency`
- `search`
- `sort=created_desc|created_asc|amount_desc|amount_asc`
- `from`
- `to`

Currency rules:
- Allowed values for `currency`, `source_currency`, and `destination_currency`: `USD`, `SYP`
- No other currencies are supported.

### `POST /transactions/deposits`
```json
{
  "wallet_id": "uuid",
  "currency": "USD",
  "amount": "100.00",
  "note": "Cash deposit",
  "attachment_ids": ["uuid"],
  "client_generated_id": "uuid"
}
```

### `POST /transactions/withdrawals`
```json
{
  "wallet_id": "uuid",
  "currency": "SYP",
  "amount": "150000.00",
  "note": "Office cash",
  "attachment_ids": [],
  "client_generated_id": "uuid"
}
```

### `POST /transactions/internal-transfers`
```json
{
  "source_wallet_id": "uuid",
  "destination_wallet_id": "uuid",
  "currency": "USD",
  "amount": "50.00",
  "note": "Trip budget",
  "client_generated_id": "uuid"
}
```

### `POST /transactions/exchanges`
```json
{
  "wallet_id": "uuid",
  "source_currency": "USD",
  "destination_currency": "SYP",
  "amount_given": "100.00",
  "exchange_rate": "9500.00",
  "amount_received": "950000.00",
  "note": "Market exchange",
  "client_generated_id": "uuid"
}
```

Response `201` for all create transaction endpoints:
```json
{
  "data": {
    "transaction": {},
    "wallet_balances": {
      "USD": "1200.00",
      "SYP": "950000.00"
    }
  }
}
```

### `GET /transactions/{transaction_id}`
Returns full financial transaction details, ledger effect summary, attachments, and linked entities.

### Unified Transaction History
The transactions surface must support a consolidated chronological history combining:
- deposits
- transfers
- exchanges
- debt settlements

## Debt APIs

### `GET /debts`
Query params:
- `direction=owed_by_contact|owed_to_contact`
- `status=open|completed`
- `contact_id`

Currency rule:
- Allowed `currency` values: `USD`, `SYP`

### `POST /debts`
```json
{
  "contact_id": "uuid",
  "currency": "USD",
  "amount": "100.00",
  "direction": "owed_by_contact",
  "source_wallet_id": "uuid",
  "note": "Personal loan",
  "attachment_ids": ["uuid"],
  "client_generated_id": "uuid"
}
```

Behavior:
- If `direction=owed_by_contact`, `source_wallet_id` is required and the backend must create the debt plus linked wallet withdrawal atomically.
- If `direction=owed_to_contact`, no automatic wallet transaction is created.
- Debt state writes, transaction writes, and ledger writes must commit inside a single database transaction.

### `GET /debts/{debt_id}`
Returns debt summary and timeline.

### `POST /debts/{debt_id}/settlements`
Creates debt settlement plus corresponding ledger-backed financial write.

```json
{
  "source_wallet_id": "uuid",
  "destination_wallet_id": "uuid",
  "amount": "50.00",
  "currency": "USD",
  "note": "Debt settlement",
  "client_generated_id": "uuid"
}
```

Behavior:
- For debts with direction `owed_by_contact`, `destination_wallet_id` is required and `source_wallet_id` must be omitted.
- For debts with direction `owed_to_contact`, `source_wallet_id` is required and `destination_wallet_id` must be omitted.
- Debt state writes, settlement writes, transaction writes, and ledger writes must commit inside a single database transaction.

Response `201`:
```json
{
  "data": {
    "settlement": {
      "id": "uuid",
      "debt_id": "uuid",
      "financial_transaction_id": "uuid",
      "amount": "50.00"
    },
    "debt_summary": {}
  }
}
```

### `GET /debts/{debt_id}/history`
Returns timeline entries including:
- debt_created
- debt_settlement

## Contact APIs

### `GET /contacts`
Query params:
- `type=external|registered`
- `status=active|archived`
- `search`

### `POST /contacts`
```json
{
  "type": "external",
  "display_name": "Abu Khaled",
  "phone_number": "+9639xxxxxxx",
  "note": "Shop owner",
  "client_generated_id": "uuid"
}
```

### `PATCH /contacts/{contact_id}`
```json
{
  "display_name": "Ali Ahmad",
  "phone_number": "+9639xxxxxxx",
  "note": "Updated note",
  "version": 2
}
```

### `POST /contacts/{contact_id}/archive`
Archives the contact. Permanent deletion is not supported.

Request:
```json
{
  "version": 2
}
```

### `GET /contacts/{contact_id}/link-candidate`
Returns whether a registered user is a potential match.

### `POST /contacts/{contact_id}/link-requests`
Starts dual-approval linking.

Request:
```json
{
  "candidate_user_id": "uuid"
}
```

### `POST /contact-link-requests/{request_id}/approve`

### `POST /contact-link-requests/{request_id}/reject`

## User Transfer APIs

### `POST /user-transfers`
Standard transfer with no debt impact.

```json
{
  "sender_wallet_id": "uuid",
  "recipient_user_id": "uuid",
  "recipient_wallet_id": "uuid",
  "currency": "USD",
  "amount": "50.00",
  "note": "Gift",
  "client_generated_id": "uuid"
}
```

Behavior:
- If `recipient_wallet_id` is provided, the backend credits that wallet.
- If `recipient_wallet_id` is omitted, the backend credits the recipient account `default_receiving_wallet_id`.
- If neither can be resolved, the backend must reject the request.
- Allowed `currency` values: `USD`, `SYP`
- Sender and recipient sides must use the same currency.
- Cross-currency user transfer is not allowed.
- Currency conversion must use the exchange workflow only.

Response `201`:
```json
{
  "data": {
    "transfer": {
      "id": "uuid",
      "reference_code": "TX-2026-000010",
      "amount": "50.00",
      "currency": "USD"
    }
  }
}
```

### `GET /user-transfers`
Query params:
- `direction=sent|received`
- `currency`
- `from`
- `to`

Currency rule:
- Allowed `currency` values: `USD`, `SYP`

### `GET /user-transfers/{transfer_id}`
Returns sender, recipient, wallet, and ledger reference.

## QR APIs

### `GET /qr/identity`
Returns or generates the current user QR identity.

Response:
```json
{
  "data": {
    "public_reference_code": "USR-9B81D1",
    "qr_payload": "base64-or-json-string",
    "payload_version": 1
  }
}
```

QR payload rule:
- `qr_payload` should contain only `public_reference_code`.
- User resolution must happen through backend QR resolution APIs.

### `POST /qr/resolve`
Request:
```json
{
  "payload": "base64-or-json-string"
}
```

Response:
```json
{
  "data": {
    "user_id": "uuid",
    "display_name": "Ali Ahmad",
    "public_reference_code": "USR-A12F33",
    "is_self": false,
    "is_existing_contact": true
  }
}
```

### `GET /users/{user_id}/preview`
Returns limited user preview suitable for transfer or contact-add start.

## Attachment APIs

### `POST /attachments`
Creates attachment metadata and optionally initiates upload. Direct Cloudinary access must remain backend-authorized.

Multipart fields:
- `entity_type`
- `entity_id`
- `file`
- `client_generated_id`

Response `201`:
```json
{
  "data": {
    "id": "uuid",
    "entity_type": "transaction",
    "entity_id": "uuid",
    "original_file_name": "receipt.jpg",
    "content_type": "image/jpeg",
    "file_size_bytes": 124050,
    "upload_status": "uploaded",
    "storage_provider": "cloudinary"
  }
}
```

### `GET /attachments`
Query params:
- `entity_type`
- `entity_id`

### `GET /attachments/{attachment_id}`
Returns metadata and a temporary download URL if authorized.

### `DELETE /attachments/{attachment_id}`
Deletes the attachment through a backend-authorized owner operation.

Deletion rules:
- ownership validation is mandatory
- Cloudinary file deletion and metadata deletion must occur together atomically where possible
- direct Cloudinary access must never bypass backend authorization

## Notification APIs

### `GET /notifications`
Query params:
- `type`
- `read=true|false`

### `POST /notifications/{notification_id}/read`

### `POST /notifications/mark-all-read`

### `DELETE /notifications/read`
Clears read notifications from active lists. Backend may archive rather than hard-delete.

## Audit APIs

### `GET /audit-events`
Query params:
- `event_type`
- `related_entity_type`
- `related_entity_id`
- `from`
- `to`

### `GET /audit-events/{audit_event_id}`
Returns immutable audit details.

## Status Codes
- `200` success
- `201` created
- `202` accepted
- `204` no content
- `400` validation/business rule error
- `401` unauthenticated
- `403` forbidden
- `404` not found
- `409` version or conflict error
- `422` semantic validation error
- `429` rate limited

## OpenAPI Readiness Notes
This document is structured to map directly into an OpenAPI 3.1 definition. Suggested reusable schema components:
- `User`
- `Wallet`
- `WalletBalance`
- `FinancialTransaction`
- `UserTransfer`
- `Debt`
- `DebtSummary`
- `Contact`
- `QrIdentity`
- `Attachment`
- `NotificationItem`
- `AuditEvent`
- `ErrorResponse`
