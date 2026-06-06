# Debts Module

## Debt Architecture

- `Debt` stores the original obligation and ownership direction.
- `DebtRepayment` stores immutable settlement events for a debt.
- `DebtSummary` is the read model used by the UI and includes contact resolution plus computed remaining balance.
- `MockDebtRepository` persists debt records and repayments in the local debts box.
- Debt data never writes to wallets or ledger transactions in this phase.

## Contact Architecture

- `Contact` is the primary read model used by the debts and contacts UI.
- `ExternalContact` and `RegisteredContact` exist as dedicated models for future specialization.
- `FutureLinkCandidate` stores the metadata required for later dual-approval linking when an external contact becomes a registered user.
- `MockContactRepository` persists contacts in the local contacts box and seeds both registered and external contacts.

## Debt Lifecycle

1. Create debt.
2. Debt appears under either `Debts Owed To Me` or `Debts I Owe`.
3. Record one or more repayments.
4. Repository recomputes repaid and remaining values.
5. When remaining amount reaches zero, the debt is considered completed.

## Future Contact Linking Strategy

- External contacts can hold `FutureLinkCandidate` metadata from the start.
- A future registration match can populate `matchingRegisteredUserId`.
- Linking should require approval from both the owner of the external contact and the newly registered user.
- Linking should preserve historical debt references by keeping the original external contact ID stable and mapping it to the registered account.

## Future Ledger Integration Strategy

- Debt events remain independent from financial transactions by default.
- Later phases may offer optional “record repayment and create ledger entry” flows, but that must be an explicit action.
- Even after future integration, debt repayment should reference ledger transactions rather than mutate wallet balances directly.

## Notes

- Debt balances never affect wallet balances automatically.
- Transfers or gifts do not reduce debt unless recorded as debt repayments.
