# Domain Inventory

## Objective
Provide the Laravel backend engineer with a domain map that preserves both implemented Firebase behavior and broader business architecture already documented for Personal Wallet.

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

## Archived Firebase Backend Domains
- `archive/firebase-backend/functions/src/auth`
- `archive/firebase-backend/functions/src/wallets`
- `archive/firebase-backend/functions/src/contacts`
- `archive/firebase-backend/functions/src/debts`
- `archive/firebase-backend/functions/src/transfers`
- `archive/firebase-backend/functions/src/notifications`
- `archive/firebase-backend/functions/src/attachments`
- `archive/firebase-backend/functions/src/audit`
- `archive/firebase-backend/functions/src/transactions`
- `archive/firebase-backend/functions/src/users`
- `archive/firebase-backend/functions/src/shared`

## Implemented Backend Domain Status

| Module | Firebase callable implementation | Notes |
|---|---|---|
| Auth | Yes | OTP plus Firebase identity/custom token flow |
| Wallets | Yes | Create/list only at wallet metadata level |
| Ledger | Yes | Deposit, exchange, internal transfer, ledger read, balances |
| Contacts | Yes | Create/list external contacts |
| Debts | Yes | Create/list debt records |
| Debt Settlements | Yes | Settlement record and remaining balance update only |
| Transfers | Yes | User transfer between explicit wallet IDs |
| Notifications | Yes | List and mark as read |
| Attachments | Yes | Signed upload URL, completion, list |
| Audit Logs | Yes | Read audit history |
| Transactions | Placeholder only | Source folder exists, no callable exports |
| Users | Placeholder only | Source folder exists, no callable exports |
| QR | No Firebase backend implementation | Flutter/domain docs only |
| Sync | No Firebase backend implementation | Flutter/domain docs only |

## Master Architecture Documents Preserved
- `docs/Master/PROJECT_MASTER_SPECIFICATION.md`
- `docs/Master/API_SPECIFICATION.md`
- `docs/Master/BACKEND_CONTRACT.md`
- `docs/Master/SECURITY_SPECIFICATION.md`
- `docs/Master/SYNC_API_SPECIFICATION.md`
- `docs/Master/ERD.md`

## Historical Analysis Documents Preserved
- `docs/archive/AUTH_MODULE.md`
- `docs/archive/WALLET_MODULE.md`
- `docs/archive/DEBTS_MODULE.md`
- `docs/archive/TRANSFERS_MODULE.md`
- `docs/archive/TRANSACTIONS_MODULE.md`
- `docs/archive/ATTACHMENTS_NOTIFICATIONS_AUDIT.md`
- `docs/archive/ARCHITECTURE.md`
- `docs/archive/IMPLEMENTATION_PLAN.md`
- `docs/archive/SYNC_MODULE.md`
- `docs/archive/UI_IMPLEMENTATION_STATUS.md`

## Key Domain Truths to Preserve
- Wallet accounting and debt accounting are separate systems.
- Ledger entries are the wallet balance source of truth.
- Debt remaining amount is tracked separately from wallet balances.
- Transfers and debt settlements are distinct concepts.
- Audit behavior is append-only.
- Notifications are side effects, not primary state.
- Ownership checks are central in every module.
- Firebase callable implementation is the authoritative executable reference for current backend behavior.

## Migration Handoff Rule
- Use archived Firebase source for exact current behavior.
- Use master documents for broader architecture and future-scope intent.
- Do not assume every master-spec capability exists in current Firebase code.
