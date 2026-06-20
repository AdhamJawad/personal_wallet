# Backend Contract

## Purpose
This document defines the backend contract required to support the existing Personal Wallet mobile application without changing its architecture. The backend is intended to become the canonical system of record, while the mobile app remains an offline cache, sync client, and local operation queue.

## Approved Deployment Architecture
- Client: Flutter
- Backend: Laravel 12 API
- Database: MySQL
- Attachment file storage: Cloudinary
- OTP delivery: WhatsApp API
- Push notifications: Firebase Cloud Messaging (FCM) only

Explicit rules:
- Laravel backend is the single source of truth.
- No business logic may live inside Flutter.

## System Overview

### Users
- Users register with full name and phone number.
- Successful user registration must create one active wallet named `Main Wallet`.
- `Main Wallet` must be created atomically with the user record and assigned as `default_receiving_wallet_id`.
- A user account must never exist without at least one wallet.
- Authentication supports phone-number-based WhatsApp OTP verification, Laravel Sanctum session/token issuance, logout, biometric device registration, and device management.
- Password-based authentication is not part of the system.
- Email-based authentication is not part of the system.
- Password reset flows are not part of the system.
- Every new device login requires WhatsApp OTP verification before Sanctum token issuance.
- PIN, fingerprint, and Face ID are application-unlock mechanisms only and must never replace OTP-based identity verification.
- A user has one account, many wallets, many contacts, many transfers, many debt records, many notifications, many attachments, and many audit events.
- A user account may define `default_receiving_wallet_id` for inbound user-to-user transfers when the sender does not specify a recipient wallet.

### Wallets
- A user may create unlimited wallets.
- The backend must auto-create one active wallet named `Main Wallet` during successful registration.
- Wallets are metadata containers only.
- Wallet balances must not be stored as authoritative fields.
- Wallet lifecycle supports create, rename, archive, restore, and list/details.
- Wallet lifecycle states are:
  - `active`
  - `archived`
  - `restored` as an action that returns the wallet to `active`
- Permanent deletion is not supported.

### Ledger
- The ledger is the single source of truth for wallet balances.
- Ledger entries are immutable.
- Supported financial event categories are deposit, withdraw, internal transfer, exchange, and user transfer.
- Every committed financial write generates one or more immutable ledger rows.
- Reference numbers must be generated server-side in canonical format such as `TX-2026-000001`.

### Transactions
- Transactions represent wallet-affecting financial activity.
- Users must never edit or delete a transaction.
- Future corrections must be modeled as reversal or correction entries, not mutation of the original row.
- Currency exchange is user-entered and must persist:
  - amount given
  - exchange rate
  - amount received
- The backend must not silently recalculate `amount_received`.

### Transfers
- User-to-user transfers are distinct from internal wallet transfers.
- Standard user transfers affect wallet balances only.
- They do not reduce debt automatically.
- A transfer may optionally include `recipient_wallet_id`.
- If `recipient_wallet_id` is provided, the backend must validate that it belongs to `recipient_user_id` and credit that wallet.
- If `recipient_wallet_id` is omitted, the backend must resolve the destination wallet from the recipient account's `default_receiving_wallet_id`.
- If no recipient wallet can be resolved, the backend must reject the transfer with a validation or business-rule error.
- User-to-user transfers must use the same currency on both sides.
- Cross-currency user transfers are not allowed.
- Currency conversion must use the exchange workflow only.
- Debt settlement is not modeled as a standard user transfer.
- Debt settlement is a debt-domain flow that creates:
  - a linked financial transaction
  - one or more ledger entries
  - a debt settlement record
- All related writes must be linked and committed atomically.

### Debts
- Debt tracking is fully separate from wallet accounting.
- Creating a debt with direction `owed_by_contact` must create a linked wallet withdrawal.
- Creating a debt with direction `owed_to_contact` must not create a wallet transaction automatically.
- Settlement events reduce debt state and create corresponding ledger entries by direction.
- Standard transfers, gifts, and unrelated money movement must not reduce debt automatically.
- Debt updates and ledger updates must never become inconsistent.
- Ledger remains the financial source of truth.

### Contacts
- The system supports:
  - registered contacts
  - external contacts
- External contacts can later become link candidates if they register.
- Final linking requires approval from both parties.

### QR
- Each registered user has a QR identity.
- QR payload must contain only:
  - `public_reference_code`
- QR resolution must happen through backend APIs.
- QR payload must not include sensitive data such as phone, tokens, or internal secrets.

### Attachments
- Attachments are an independent subsystem.
- Supported parent entities:
  - transactions
  - debts
  - debt settlements
  - contacts
- Attachment files are stored in Cloudinary.
- Attachment metadata is stored in MySQL.
- Attachments may be deleted only through backend-authorized owner operations.
- Direct Cloudinary access must never bypass backend authorization.
- Physical Cloudinary deletion and metadata deletion must be performed together atomically where possible.

### Notifications
- Notifications are an independent subsystem.
- Supported event families:
  - transfer received
  - transfer sent
  - debt created
  - debt_settlement_created
  - wallet created
  - sync failure
  - sync success

### Audit
- Audit is immutable and append-only.
- Audit events must be generated automatically by backend write flows, not by client trust alone.
- Audit rows must include event type, timestamp, actor, related entity, and sync-aware metadata.

### Sync
- The backend must support offline-originated writes uploaded later by the client.
- All future write operations must be compatible with sync queue semantics:
  - pending
  - synced
  - failed
  - conflict
- The backend must accept idempotent batch submissions with client-generated identifiers.

## Core Domain Rules

### Accounting Rules
- Wallet balances are derived from the ledger only.
- Debt balances are derived from debt records and debt settlement records only.
- Wallet and debt balances must never be merged into one model.

### Immutability Rules
- Ledger transactions are immutable.
- Debt settlements are immutable.
- Audit events are immutable.

### Ownership Rules
- Wallets belong to one user.
- Internal transfers occur between wallets of the same user.
- User transfers occur between two registered users.
- A user's `default_receiving_wallet_id`, if set, must always reference a wallet owned by that same user.
- A debt belongs to one owner and one counterparty contact.

### Sync Rules
- Backend responses must support client reconciliation through:
  - server ids
  - client-generated ids
  - idempotency keys
  - version numbers
  - conflict payloads

## Recommended Backend Modules
- `Identity/Auth`
- `Wallets`
- `Ledger`
- `Transfers`
- `Debts`
- `Contacts`
- `QR Identity`
- `Attachments`
- `Notifications`
- `Audit`
- `Sync`

## Write Path Expectations

### Wallet Create
1. Validate authenticated user.
2. Create wallet metadata row.
3. Emit audit event.
4. Emit notification if applicable.
5. Return canonical wallet payload.

### Wallet Archive
1. Validate authenticated user and wallet ownership.
2. Move wallet status from `active` to `archived`.
3. Prevent archive if this would violate a required `default_receiving_wallet_id` invariant unless another default is assigned first.
4. Emit audit event.
5. Return canonical wallet payload.

### Wallet Restore
1. Validate authenticated user and wallet ownership.
2. Move wallet status from `archived` back to `active`.
3. Optionally allow the restored wallet to become the account's `default_receiving_wallet_id`.
4. Emit audit event.
5. Return canonical wallet payload.

### Financial Transaction Create
1. Validate actor and wallet ownership.
2. Generate transaction reference.
3. Persist immutable transaction aggregate.
4. Persist one or more ledger entries.
5. Emit audit event.
6. Emit notification if applicable.
7. Return transaction and updated derived balances.

### Debt Create
1. Validate debt ownership context, contact ownership, direction, amount, and currency.
2. If direction is `owed_by_contact`, validate `source_wallet_id` and sufficient funds.
3. Create debt record.
4. If direction is `owed_by_contact`, create linked financial withdrawal and ledger debit.
5. Commit all related writes atomically.
6. Emit audit event.
7. Emit notification when applicable.
8. Return canonical debt summary and linked financial metadata when present.

### Debt Settlement Create
1. Validate debt ownership and remaining balance.
2. Resolve wallet requirement by debt direction.
3. If direction is `owed_by_contact`, validate `destination_wallet_id` and create linked financial deposit.
4. If direction is `owed_to_contact`, validate `source_wallet_id` and create linked financial withdrawal.
5. Create linked debt settlement event.
6. Commit debt and ledger writes atomically.
7. Emit audit event.
8. Emit notification.
9. Return debt summary plus linked financial metadata.

### Contact Link Approval
1. Validate pending link request.
2. Require both approvals.
3. Link external contact to registered user.
4. Preserve historical references.
5. Emit audit event.

## Read Model Expectations
- Dashboard totals should be derived from current ledger state.
- Wallet list should expose derived balances, not stored balances.
- Debt details should expose original amount, settled amount, and remaining amount.
- Transaction history should be queryable by wallet, type, currency, date, and reference.
- Notification center should support unread counters and filtering.
- Audit history should support developer and admin investigation.

## Unified Transaction History
- The backend must support a consolidated chronological transaction history view.
- The unified history must combine:
  - deposits
  - transfers
  - exchanges
  - debt settlements
- This history is a derived read model over canonical financial transactions and ledger records.

## Cross-Cutting Backend Requirements
- API versioning via `/api/v1`.
- UUID primary keys for public entities.
- Soft deletion only where explicitly allowed.
- Server-side authorization on every resource.
- Idempotent write endpoints for offline replay.
- Structured error payloads with machine-readable codes.
- Background-capable processing for uploads, notifications, and sync reconciliation.
- Device management endpoints must allow the user to list trusted devices and revoke a specific device.

## Technology-Neutral Guidance
This contract is intentionally implementation-neutral and can be implemented in Laravel, FastAPI, Node.js, NestJS, Django, Spring, or similar platforms as long as the backend preserves:
- immutable ledger semantics
- debt isolation from wallet balances
- sync-safe idempotent writes
- explicit transfer versus debt-settlement behavior
- append-only audit behavior
