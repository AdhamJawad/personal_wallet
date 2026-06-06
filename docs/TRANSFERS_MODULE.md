# Transfers Module

## Scope

This phase adds three connected capabilities:

1. User-to-user transfers between registered users
2. QR-based public identity discovery
3. Debt settlement through linked transfer + debt event creation

Wallet balances remain ledger-derived. Debt balances remain separate from wallet balances and are reduced only by explicit debt events.

## Transfer Architecture

### Feature boundaries

- `features/transfers`
  - Owns user-to-user transfer models, repository, controller, and transfer/debt-settlement screens
- `features/transactions`
  - Remains the immutable ledger source of truth
- `features/debts`
  - Owns debt summaries and debt settlement records
- `features/qr`
  - Owns identity payload generation, scan parsing, and preview flow

### Core models

- `UserTransfer`
  - Business record for a user transfer
  - Stored per owner for inbox/outbox style visibility
- `TransferSummary`
  - Read model for UI, including direction and counterparty label
- `DebtSettlement`
  - Debt-side settlement event linked to a transfer and ledger entry
- `SettlementSummary`
  - UI-friendly settlement projection for debt timelines

### Repositories

- `TransferRepository`
  - Creates immutable user transfers
  - Creates linked debt settlements
  - Reads transfer history
- `MockTransferRepository`
  - Persists transfer business records in local storage
  - Appends immutable ledger entries through `MockLedgerStore`
  - Calls `DebtRepository.createSettlement` for linked settlements

## QR Architecture

### Public identity payload

The QR payload contains only:

- `userId`
- `displayName`
- `publicReferenceIdentifier`

No phone number, password, session token, or biometric data is encoded.

### Core models

- `QrIdentity`
  - Public identity payload shown in “My QR”
- `QrScanResult`
  - Scan result enriched with self/contact awareness

### Repository flow

- `QrRepository.fetchIdentity`
  - Builds and caches the current user’s public payload
- `QrRepository.fetchKnownIdentities`
  - Returns demo identities for registered users
- `QrRepository.scanPayload`
  - Parses payload
  - Verifies it against registered local users
  - Checks whether the scanned user already exists in contacts

## Debt Settlement Flow

Debt settlement is intentionally different from standard transfer.

### Standard transfer

1. User selects wallet, recipient, currency, amount, note
2. `TransferRepository.createTransfer` creates a transfer business record
3. Sender ledger receives an immutable transfer entry
4. Recipient ledger receives a mirrored immutable transfer entry
5. Debt data is unchanged

### Debt settlement transfer

1. User opens debt settlement from debt details
2. User chooses wallet and settlement amount
3. `TransferRepository.createDebtSettlement` creates the financial transfer
4. `DebtRepository.createSettlement` creates the debt-side settlement event
5. The transfer and debt settlement are linked through identifiers
6. Debt remaining amount decreases
7. Wallet balances change only because of the transfer ledger entry

## Ledger Integration Flow

### Transfer ledger strategy

Transfers append immutable `LedgerTransaction` records with extra metadata:

- `senderDisplayName`
- `recipientUserId`
- `recipientDisplayName`
- `transferRecordId`
- `debtSettlementId` when applicable

### Balance calculation

Wallet balances are still calculated by replaying ledger transactions:

- Sender-side user transfer subtracts from `sourceWalletId`
- Recipient-side mirrored transfer adds to `destinationWalletId`
- Debt records never contribute to balance calculation

## Contact Integration

Transfers can start from:

- Registered contacts list
- QR preview
- Standalone transfer form

QR preview can create a registered contact through the existing contacts controller before starting a transfer.

## State Management

- `TransferController`
  - Creates transfers and settlements
  - Reloads owner transfer history
  - Exposes `lastCompletedTransfer` and `lastCompletedSettlement`
- `QrController`
  - Loads current identity
  - Loads known identities
  - Scans payloads and stores the active preview result

All dependencies are injected through Riverpod providers.

## Future Backend Integration Points

- Replace local registered-user directory reads with API-backed user lookup
- Replace mirrored local ledger writes with server-coordinated transfer creation
- Replace local QR verification with signed or server-issued public identity payloads
- Replace local debt settlement linking with backend-issued canonical linkage ids
- Introduce sync-safe conflict handling for transfer references and mirrored records
