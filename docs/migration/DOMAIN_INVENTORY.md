# Domain Inventory

## Objective
Provide the Laravel backend engineer with a final domain map aligned to the approved production architecture.

The approved backend architecture is:
- Flutter client
- Laravel 12 API
- MySQL
- Cloudinary for attachment files
- WhatsApp API for OTP delivery
- FCM for push notifications only

Laravel backend is the single source of truth. No business logic may live inside Flutter.

## Active Flutter Domain Folders
- `lib/features/auth`
- `lib/features/wallets`
- `lib/features/transactions`
- `lib/features/transfers`
- `lib/features/contacts`
- `lib/features/debts`
- `lib/features/attachments`
- `lib/features/notifications`
- `lib/features/audit`
- `lib/features/qr`
- `lib/features/dashboard`
- `lib/features/profile`
- `lib/features/sync`

## Production Backend Domain Map

| Module | Laravel ownership | Notes |
|---|---|---|
| Auth | Yes | Phone number plus WhatsApp OTP, then Laravel Sanctum |
| Wallets | Yes | Metadata lifecycle, default receiving wallet integrity |
| Ledger | Yes | Financial source of truth |
| Transactions | Yes | Deposits, withdrawals, internal transfers, exchanges, user transfers, debt-linked financial writes |
| Contacts | Yes | External and registered contacts |
| Debts | Yes | Separate domain with ledger-linked creation and settlement rules |
| Transfers | Yes | Standard user-to-user transfers only |
| Attachments | Yes | Cloudinary file storage plus MySQL metadata |
| Notifications | Yes | MySQL state plus optional FCM push delivery |
| Audit | Yes | Append-only backend audit trail |
| QR | Yes | Backend-issued QR identity and resolution support |
| Sync | Yes | Offline-originated write reconciliation |

## Historical Reference Material

### Archived Firebase Source
- `archive/firebase-backend/`

This archive remains available only as historical context.

Rules:
- do not treat archived Firebase code as production architecture
- do not preserve Firebase-specific assumptions in new Laravel design
- do not reintroduce Firebase Auth, Firestore, Firebase Storage, Cloud Functions, custom tokens, or Firestore transactions into production planning

## Master Architecture Documents
- `docs/Master/PROJECT_MASTER_SPECIFICATION.md`
- `docs/Master/API_SPECIFICATION.md`
- `docs/Master/BACKEND_CONTRACT.md`
- `docs/Master/SECURITY_SPECIFICATION.md`
- `docs/Master/SYNC_API_SPECIFICATION.md`
- `docs/Master/ERD.md`

## Key Domain Truths To Preserve
- Laravel backend is the single source of truth.
- Ledger is the single source of truth for wallet balances.
- Wallet balances must never be authoritative fields.
- Successful registration must create one active wallet named `Main Wallet`.
- `Main Wallet` must become `default_receiving_wallet_id`.
- A user account must never exist without at least one wallet.
- User identity is based on phone number plus WhatsApp OTP.
- Password-based authentication is not part of the system.
- Email-based authentication is not part of the system.
- Password reset flows are not part of the system.
- Every new device login requires WhatsApp OTP verification.
- PIN, fingerprint, and Face ID are local application-unlock mechanisms only.
- Debt and Wallet are separate domains.
- Debt and Wallet may be linked through approved atomic debt workflows.
- Standard transfers do not reduce debt automatically.
- Debt creation and debt settlement business rules belong to Laravel, not Flutter.
- Attachments use Cloudinary for files and MySQL for metadata.
- Attachment deletion requires backend authorization and coordinated Cloudinary plus metadata removal where possible.
- Notifications may use FCM for delivery, but notification state remains backend-owned.
- Audit behavior is append-only.
- Ownership checks are central in every module.

## Debt Domain Final Inventory

### Debt Directions
- `owed_by_contact`
- `owed_to_contact`

### Debt Creation Rules
- `owed_by_contact`
  - requires source wallet selection
  - creates debt plus linked wallet withdrawal
  - commits atomically
- `owed_to_contact`
  - creates debt only
  - no automatic wallet transaction

### Debt Settlement Rules
- `owed_by_contact`
  - requires destination wallet
  - reduces remaining amount
  - creates ledger deposit
  - commits atomically
- `owed_to_contact`
  - requires source wallet
  - reduces remaining amount
  - creates ledger withdrawal
  - commits atomically

### Debt Integrity Rules
- debt updates and ledger updates must never become inconsistent
- all related writes must commit atomically
- ledger remains the financial source of truth

## Unified Transaction History
Laravel must support a consolidated chronological transaction history view combining:
- deposits
- transfers
- exchanges
- debt settlements

This view is a derived read model over canonical Laravel-managed financial records.

## Handoff Rule
- Use the master docs and migration docs as the approved architecture.
- Use the Firebase archive only for historical context when clarifying legacy intent.
- If Flutter behavior conflicts with approved backend rules, the approved backend rules win.
