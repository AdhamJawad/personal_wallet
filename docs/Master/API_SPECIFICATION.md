# API Specification

## Conventions
- Base path: `/api/v1`
- Authentication: `Authorization: Bearer <access_token>`
- Content type: `application/json`, except attachment upload endpoints
- Idempotent writes must accept:
  - `Idempotency-Key` header
  - `X-Device-Id` header
  - `client_generated_id` in request body when applicable

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
  "direction": "owed_to_me",
  "currency": "USD",
  "original_amount": "100.00",
  "repaid_amount": "20.00",
  "settled_amount": "10.00",
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
Creates a user and starts OTP verification.

Request:
```json
{
  "full_name": "Adham Ahmad",
  "phone_number": "+963999999999",
  "password": "123456",
  "client_generated_id": "uuid"
}
```

Response `201`:
```json
{
  "data": {
    "user_id": "uuid",
    "otp_challenge_id": "uuid",
    "otp_expires_at": "2026-06-06T12:05:00Z"
  }
}
```

### `POST /auth/verify-otp`
Verifies registration or password-reset OTP.

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
    "verified": true
  }
}
```

### `POST /auth/login`
Password-based login.

Request:
```json
{
  "phone_number": "+963999999999",
  "password": "123456",
  "device_identifier": "device_123",
  "device_name": "iPhone 15"
}
```

Response `200`:
```json
{
  "data": {
    "access_token": "jwt",
    "refresh_token": "opaque_or_jwt",
    "expires_in": 900,
    "user": {
      "id": "uuid",
      "full_name": "Adham Ahmad",
      "phone_number": "+963999999999"
    }
  }
}
```

### `POST /auth/logout`
Revokes the current refresh token or all sessions.

Request:
```json
{
  "scope": "current_device"
}
```

Response `204`

### `POST /auth/refresh-token`
Rotates refresh token and returns a new access token.

Request:
```json
{
  "refresh_token": "opaque_or_jwt",
  "device_identifier": "device_123"
}
```

Response `200`: same shape as login.

### `POST /auth/forgot-password`
Starts reset flow.

Request:
```json
{
  "phone_number": "+963999999999"
}
```

Response `202`

### `POST /auth/reset-password`
Consumes reset token or verified OTP.

Request:
```json
{
  "reset_token": "token",
  "new_password": "newSecret123"
}
```

Response `200`

### `POST /auth/biometric-devices`
Registers a device for future biometric-based login delegation.

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
Revokes the selected device, disables biometric trust for that device, and invalidates its active refresh tokens.

Response `204`

## Wallet APIs

### `GET /wallets`
Query params:
- `search`
- `status=active|archived`
- `sort=created_desc|created_asc|name_asc|name_desc`

Response `200`: list of wallet schema.

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
- `type=deposit|withdraw|internal_transfer|exchange|user_transfer`
- `currency`
- `search`
- `sort=created_desc|created_asc|amount_desc|amount_asc`
- `from`
- `to`

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

## Debt APIs

### `GET /debts`
Query params:
- `direction=owed_to_me|i_owe`
- `status=open|completed`
- `contact_id`

### `POST /debts`
```json
{
  "contact_id": "uuid",
  "currency": "USD",
  "amount": "100.00",
  "direction": "owed_to_me",
  "note": "Personal loan",
  "attachment_ids": ["uuid"],
  "client_generated_id": "uuid"
}
```

### `GET /debts/{debt_id}`
Returns debt summary and timeline.

### `POST /debts/{debt_id}/repayments`
```json
{
  "amount": "30.00",
  "note": "Cash repayment",
  "attachment_ids": [],
  "client_generated_id": "uuid"
}
```

### `POST /debts/{debt_id}/settlements`
Creates both transfer and debt settlement.

```json
{
  "sender_wallet_id": "uuid",
  "recipient_user_id": "uuid",
  "recipient_wallet_id": "uuid",
  "amount": "50.00",
  "currency": "USD",
  "note": "Debt settlement",
  "client_generated_id": "uuid"
}
```

Behavior:
- If `recipient_wallet_id` is provided, the backend must validate ownership and use it.
- If omitted, the backend must use the recipient account `default_receiving_wallet_id`.

Response `201`:
```json
{
  "data": {
    "transfer": {},
    "settlement": {
      "id": "uuid",
      "debt_id": "uuid",
      "user_transfer_id": "uuid",
      "amount": "50.00"
    },
    "debt_summary": {}
  }
}
```

### `GET /debts/{debt_id}/history`
Returns timeline entries including:
- debt_created
- debt_repayment
- debt_settlement

## Contact APIs

### `GET /contacts`
Query params:
- `type=external|registered`
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

### `GET /user-transfers/{transfer_id}`
Returns sender, recipient, wallet, ledger reference, and any linked settlement.

## QR APIs

### `GET /qr/identity`
Returns or generates the current user QR identity.

Response:
```json
{
  "data": {
    "user_id": "uuid",
    "display_name": "Adham Ahmad",
    "public_reference_code": "USR-9B81D1",
    "qr_payload": "base64-or-json-string",
    "payload_version": 1
  }
}
```

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
Creates attachment metadata and optionally initiates upload.

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
    "upload_status": "uploaded"
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
Soft delete only.

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
