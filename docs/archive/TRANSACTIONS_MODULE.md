# Transactions Module

## Ledger Architecture

- `LedgerTransaction` is the immutable source-of-truth record.
- `TransactionReference` stores the generated external reference such as `TX-2026-000001`.
- `MockLedgerStore` persists the owner-scoped ledger in local storage and owns reference sequencing.
- `TransactionRepository` creates and reads immutable ledger entries only.
- `BalanceCalculatorService` derives wallet balances by replaying ledger transactions.
- `MockWalletRepository` now reads wallet metadata plus ledger-derived balances instead of stored balance fields.

## Balance Calculation Strategy

Wallet balances are derived by replaying every immutable transaction for each wallet:

- `deposit`: add amount to destination wallet
- `withdraw`: subtract amount from source wallet
- `transfer`: subtract from source wallet and add to destination wallet
- `exchange`: subtract source amount and add destination amount within the same wallet

No screen stores balances directly. Dashboard totals and wallet balances are projections created at repository level from the ledger.

## Transaction Flow

```text
Dashboard / Wallets
  -> create transaction route
  -> form validation
  -> TransactionController
  -> TransactionRepository
  -> MockLedgerStore append
  -> WalletController refresh
  -> updated balances on dashboard and wallet screens
```

## Supported Transactions

- Deposit
- Withdraw
- Internal Transfer
- Exchange

Each record supports note and optional attachment label metadata in this phase.

## Future Debt Integration Points

- Debt repayments can later create linked ledger entries without changing the immutable ledger rule.
- Transaction references can be associated with future debt records for traceability.
- Wallet-level debt activity can consume the same ledger transaction IDs rather than duplicating financial state.

## Future User-to-User Transfer Integration Points

- Current internal transfers are wallet-to-wallet within one owner only.
- Later user-to-user transfers can be modeled as paired immutable ledger entries with ownership boundaries.
- Reference generation and immutable history rules can remain unchanged for that future expansion.

## Notes

- Transactions cannot be edited or deleted.
- Corrections should later be implemented using reversal entries, not mutation.
- Amount received for exchange is entered manually by design.
