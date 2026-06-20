# Personal Wallet Laravel Migration Report

## Purpose
This document defines the approved production architecture for Personal Wallet and replaces the earlier Firebase-to-Laravel transition framing.

The target production stack is:
- Flutter client
- Laravel 12 API
- MySQL
- Cloudinary for attachment file storage
- WhatsApp API for OTP delivery
- Firebase Cloud Messaging (FCM) for push notifications only

Archived Firebase code remains historical reference material only. It is not part of the production architecture and must not be treated as an implementation baseline for new backend work.

## Final Architecture

### Runtime Topology
```text
Flutter
  -> Laravel 12 API
  -> MySQL

Supporting integrations
  - Cloudinary: attachment file storage
  - WhatsApp API: OTP delivery
  - FCM: push notifications only
```

### Source Of Truth
- Laravel backend is the single source of truth.
- No business logic may live inside Flutter.
- Flutter may cache, queue, and render data locally for offline behavior, but it must not become the authoritative home of business rules.
- Wallet balances are derived from ledger data only.
- Debt balances are derived from debt records and debt settlement events only.

## Production Architecture Corrections

### Removed Production Assumptions
The following are no longer part of the production backend architecture:
- Firebase Auth
- Firestore
- Firebase Storage
- Cloud Functions
- Firebase custom tokens
- Firestore transactions

### Current Approved Replacements
- Authentication: WhatsApp OTP plus Laravel Sanctum
- Persistence: MySQL
- File storage: Cloudinary for files plus MySQL for attachment metadata
- Push delivery: FCM only
- Server-side transactions: MySQL database transactions managed by Laravel

## Module Alignment Summary

### 1. Authentication
- Production authentication is WhatsApp OTP plus Laravel Sanctum.
- OTP generation, hashing, expiry, attempt limits, verification, and account trust decisions belong to Laravel.
- Flutter must not perform OTP verification logic locally.
- Firebase identity issuance and Firebase custom token issuance are removed from the architecture.

Required rules:
- phone numbers normalized to E.164
- 6-digit OTP
- 5-minute expiry
- resend cooldown
- attempt lockout
- Sanctum token issuance after successful verification or login flow
- no password-based login
- no email-based login
- no password reset flows
- every new device login requires WhatsApp OTP verification
- PIN, fingerprint, and Face ID remain local application-unlock mechanisms only

### 2. Wallets
- Wallets remain metadata-only domain entities.
- Successful registration must create one active wallet named `Main Wallet`.
- `Main Wallet` must be assigned as `default_receiving_wallet_id`.
- User creation, `Main Wallet` creation, and default wallet assignment must commit atomically.
- A user account must never exist without at least one wallet.
- No wallet balance field is authoritative.
- Laravel owns wallet lifecycle rules, validation, and default receiving wallet integrity.
- Wallet balances are derived from ledger-backed transaction history in MySQL.

### 3. Ledger
- Ledger remains the financial source of truth.
- Every wallet-affecting operation must result in immutable financial transaction and ledger records.
- Deposits, withdrawals, internal transfers, exchanges, user transfers, debt-origin withdrawals, and debt settlements must be queryable through unified transaction history.

### 4. Debts
- Debt and Wallet are separate domains, but they are financially linked through approved debt workflows.
- Debt writes and ledger writes must remain consistent through atomic Laravel database transactions.

Approved debt creation rules:
- `owed_by_contact`
  - user is lending money
  - requires `source_wallet_id`
  - creates debt plus wallet withdrawal atomically
- `owed_to_contact`
  - user owes someone money
  - creates debt only
  - no automatic wallet transaction

Approved debt settlement rules:
- for `owed_by_contact`
  - user receives money back
  - requires `destination_wallet_id`
  - reduces remaining debt
  - creates ledger deposit
  - commits atomically
- for `owed_to_contact`
  - user pays money
  - requires `source_wallet_id`
  - reduces remaining debt
  - creates ledger withdrawal
  - commits atomically

### 5. Transfers
- Standard user transfers remain separate from debts.
- Standard transfers do not reduce debt automatically.
- User transfers must be same-currency only.
- Cross-currency transfer is not allowed.
- Currency conversion must use the exchange workflow only.
- Debt settlement is not modeled as a transfer-to-registered-user requirement.
- Debt settlement is a debt-domain workflow with a linked financial transaction and ledger effect, regardless of whether the counterparty is external or registered.

### 6. Attachments
- Attachment files are stored in Cloudinary.
- Attachment metadata is stored in MySQL.
- Authorization, ownership validation, and lifecycle rules are enforced by Laravel.
- Firebase Storage signed upload assumptions are removed.
- Attachments may be deleted by the owner only through backend-authorized operations.
- Physical Cloudinary deletion and metadata deletion must be coordinated atomically where possible.

### 7. Notifications
- Notification records are owned by Laravel.
- Push delivery may use FCM.
- FCM is not a source of truth for notification state.
- Read/unread notification state remains in MySQL.

## Unified Transaction History
The system must support a consolidated transaction history view ordered chronologically and sourced from canonical Laravel-managed financial records.

The unified history must combine:
- deposits
- transfers
- exchanges
- debt settlements

The unified history may expose filtering and projection layers, but those views must be derived from canonical transaction and ledger records owned by Laravel.

## Data Ownership And Processing Boundaries

### Flutter Responsibilities
- render UI
- collect input
- cache server data locally
- queue sync-safe operations for later upload
- display unified transaction history and debt history from backend-shaped models

### Laravel Responsibilities
- all business validation
- authentication and authorization
- OTP lifecycle
- wallet rules
- ledger rules
- debt rules
- attachment ownership and metadata
- transaction orchestration
- audit logging
- notification persistence
- conflict handling for synchronized writes

### MySQL Responsibilities
- persistent relational storage
- transaction boundaries for atomic writes
- canonical query source for read models

### External Service Responsibilities
- Cloudinary stores attachment binaries
- WhatsApp API delivers OTP messages
- FCM delivers push notifications

## Migration Guidance For Laravel Handoff

### Backend Direction
The Laravel engineer should implement directly against the approved architecture, not against archived Firebase callable behavior.

### Historical Archive Rule
- `archive/firebase-backend/` is historical reference only.
- It may help explain earlier product behavior.
- It must not override the approved Laravel architecture.
- Where archived Firebase behavior conflicts with the approved rules, the approved rules win.

### Required Migration Corrections
- remove Firebase-auth-based login assumptions
- remove Firestore collection-based design assumptions
- remove Firebase Storage upload and verification assumptions
- remove transfer-backed debt settlement assumptions
- remove client-owned business rule assumptions from Flutter
- replace all transaction consistency assumptions with Laravel + MySQL atomic write paths

## Final Handoff Position
The backend target is no longer a parity migration from Firebase callable functions.

It is a clean Laravel 12 + MySQL production architecture with:
- WhatsApp OTP plus Laravel Sanctum authentication
- Cloudinary attachments with MySQL metadata
- FCM for push only
- Laravel as the single source of truth
- ledger as the financial source of truth
- approved debt-wallet atomic workflows
- unified transaction history across all financial event types
