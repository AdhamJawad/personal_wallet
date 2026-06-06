# Initial Implementation Plan

## Phase 1: Architecture Foundation

- Finalize repository contracts per feature
- Add secure storage abstraction for auth/session secrets
- Introduce app environment configuration
- Expand route guards for auth and biometric checks

## Phase 2: Local-First Data Layer

- Add feature local data sources on top of `LocalStore`
- Implement serialization mappers and cache schemas
- Build local write pipelines for immutable transaction and debt records
- Add projection services for computed wallet balances

## Phase 3: Domain Use Cases

- Auth use cases
- Wallet creation and archive use cases
- Transaction creation and reversal use cases
- Debt issue and repayment use cases
- Contact linking approval use cases

## Phase 4: Screens

- Auth flow
- Wallet list and wallet detail
- Transaction composer and history
- Debt overview and detail
- Contacts and QR flows

## Phase 5: Backend and Sync

- Remote data sources and DTO contracts
- Background sync queue
- Conflict handling rules
- Telemetry and audit trail

## Production Notes

- Monetary values should remain strings or decimal wrappers, never `double`.
- Sensitive auth artifacts should move to secure storage rather than Hive.
- Biometric capability must be wrapped behind a platform service.
- Every ledger mutation should create a new immutable record and audit event.

