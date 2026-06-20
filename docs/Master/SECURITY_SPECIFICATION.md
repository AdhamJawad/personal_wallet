# Security Specification

## Objectives
The backend must support a small trusted-group finance product with production-grade controls. Security requirements here are designed for the approved Laravel 12 API architecture and must preserve the app's domain rules.

## Approved Security Context
- Backend: Laravel 12 API
- Database: MySQL
- Authentication: WhatsApp OTP plus Laravel Sanctum
- Attachments: Cloudinary file storage plus MySQL metadata
- Push notifications: FCM only
- Laravel backend is the single source of truth.
- No business logic may live inside Flutter.

## Authentication Model

### Identity Rules
- User identity is based on phone number plus WhatsApp OTP.
- Password-based authentication is not part of the system.
- Email-based authentication is not part of the system.
- Password reset flows are not part of the system.
- Every new device login must complete WhatsApp OTP verification before Sanctum token issuance.

### Access Tokens
- Use Laravel Sanctum personal access tokens or session-backed tokens.
- Recommended policy: short-lived or revocable device-bound tokens enforced by Laravel.
- Token issuance and revocation are backend-managed.

### Session Binding
- Bind authenticated Sanctum sessions/tokens to a registered device record where device-aware policy is enabled.
- Reject sensitive session continuation flows from mismatched or unknown device identifiers.
- Device removal must revoke all active Sanctum sessions/tokens bound to that device immediately.

## OTP Security
- OTP codes must be hashed at rest.
- OTP delivery channel is WhatsApp API.
- Recommended expiry: 5 minutes.
- Recommended attempt limit: 5 attempts per challenge.
- OTP challenges must be single-use.
- Rate limit OTP issuance and verification per phone number and device.

## Biometric Device Registration
- Biometrics should never be transmitted as raw biometric data.
- Backend should store a device registration record and optional public key or attestation material only.
- PIN, fingerprint, and Face ID are local application-unlock controls only.
- Client biometric success should unlock a device-bound application session locally, not bypass server authorization.
- Device registration should require an already authenticated session.

## Device Management APIs
- `GET /auth/devices` must return only devices owned by the authenticated user.
- `DELETE /auth/devices/{device_id}` must:
  - revoke active Sanctum sessions/tokens for that device
  - disable biometric trust for that device
  - write an audit event for device removal
- The backend should prevent accidental deletion of the current device without explicit confirmation in product policy.

## Authorization Rules
- Every endpoint must enforce owner-based authorization.
- Users may only access:
  - their own wallets
  - their own contacts
  - their own debts
  - their own attachments
  - their own notifications
  - their own audit views unless admin tooling is added
- User transfer preview and QR resolution endpoints must expose limited public-safe information only.
- If `recipient_wallet_id` is supplied on a transfer, the backend must verify that the wallet belongs to `recipient_user_id`.
- User-to-user transfers must remain same-currency transfers only.
- Cross-currency value movement must use the exchange workflow, not transfer APIs.

## Rate Limiting

### Recommended Limits
- `POST /auth/login`: 5 requests per minute per phone and IP
- `POST /auth/register`: 3 requests per hour per phone and IP
- `POST /auth/verify-otp`: 10 requests per 10 minutes per challenge
- `POST /sync/batch`: 60 requests per minute per user/device
- `POST /attachments`: based on file size and daily quota

### Abuse Controls
- Add exponential backoff after repeated auth failures.
- Lock or challenge suspicious accounts temporarily.
- Audit repeated failed login and OTP attempts.

## Device Identifier Requirements
- Client must send a stable application-scoped device identifier.
- Backend must persist the device identifier with sessions, sync operations, and relevant audit events.
- Treat device identifier as sensitive metadata, not as sole authentication.
- Device listings should expose `device_identifier`, `device_name`, `platform`, `created_at`, and `last_used_at` to the owning user only.

## Attachment Security
- Validate content type and file extension independently.
- Enforce maximum file size per file and per entity.
- Virus scanning is recommended before final publish.
- Store attachments outside the public web root.
- Serve downloads through short-lived signed URLs or authorized streaming endpoints.
- Keep attachment metadata separate from binary storage implementation.
- Record upload status and checksum.
- Attachment deletion must require owner authorization.
- Direct Cloudinary access must never bypass backend authorization.
- Physical Cloudinary deletion and metadata deletion must be coordinated atomically where possible.

## Transport Security
- Require HTTPS only.
- Enforce TLS 1.2 or newer.
- Reject plaintext HTTP except local development.

## Data Protection
- Encrypt secrets and token hashes at rest where appropriate.
- Minimize personally identifiable information exposure in logs.
- Use field-level redaction for phone numbers, tokens, and attachment storage keys in logs.

## Audit And Security Logging
- Log:
  - login success/failure
  - logout
  - OTP issuance/verification
  - wallet create/archive
  - transaction create
  - debt create/settle
  - contact create/link approval
  - sync conflict resolution
- Security logs must be append-only and tamper-evident where possible.

## Sync Security
- Require valid access token for all sync endpoints.
- Require idempotency keys for all offline-originated writes.
- Reject duplicate operations with altered payload under the same key.
- Include device identifier in sync audit trails.
- Never auto-resolve ownership conflicts in favor of the client.

## Notification Security
- Notifications must be scoped to the authenticated recipient only.
- Push integration, when added later, must avoid embedding sensitive transaction details on locked-screen payloads unless explicitly allowed by user settings.

## QR Security
- QR payload must contain only `public_reference_code`.
- QR resolution must occur through backend APIs.
- QR payload should be signed or indirectly resolvable through a server-issued public reference in future production rollout.
- QR resolution endpoint must not reveal hidden account metadata.

## Recommended Security Headers
- `Strict-Transport-Security`
- `Content-Security-Policy` for any web consoles
- `X-Content-Type-Options: nosniff`
- `Referrer-Policy: no-referrer`
- `X-Frame-Options: DENY`

## Backup And Recovery
- Back up relational data and attachment metadata regularly.
- Test point-in-time recovery.
- Ensure audit and ledger tables are included in high-integrity backup policy.

## Operational Recommendations
- Use secrets management for Sanctum/session secrets, WhatsApp API credentials, Cloudinary credentials, and storage credentials.
- Rotate signing keys with a documented process.
- Separate production and non-production environments strictly.
- Add monitoring for:
  - auth failures
  - sync failure spikes
  - attachment upload failure spikes
  - unusual transfer patterns

## Minimum Production Checklist
- Laravel Sanctum token or session management
- OTP throttling and hashing
- owner-based authorization on all resources
- signed attachment downloads
- immutable audit logs
- idempotent sync writes
- device-bound session tracking
