# Laravel Migration Checklist

## Goal
Rebuild the archived Firebase backend as a Laravel REST API without losing implemented business rules.

## 1. Authentication and Identity
- Rebuild phone-based OTP challenge lifecycle now handled by Firebase callable auth functions.
- Replace Firebase Auth user creation with Laravel-managed user accounts.
- Replace Firebase custom token issuance with Laravel-native auth tokens.
- Preserve these rules:
  - E.164 phone normalization
  - 6-digit OTP
  - 5-minute OTP expiry
  - 60-second resend cooldown
  - 5-attempt lockout
  - one effective pending challenge per phone number
- Rebuild persistence previously split across:
  - `phoneIndex`
  - `users`
  - `authOtpChallenges`

## 2. Authorization Model
- Replace `request.auth.uid` ownership checks with Laravel auth middleware and policies.
- Recreate all owner and participant checks currently enforced in services and Firebase rules.
- Preserve transfer participant access for shared transfer records and attachments.

## 3. API Surface Conversion
- Convert Firebase callable functions into REST endpoints under `/api/v1`.
- Keep a mapping table during migration:
  - `sendOtp`
  - `verifyOtp`
  - `createWallet`
  - `getWallets`
  - `createDeposit`
  - `createExchange`
  - `createInternalTransfer`
  - `getWalletLedger`
  - `getWalletBalances`
  - `createContact`
  - `getContacts`
  - `createDebt`
  - `getDebts`
  - `recordDebtSettlement`
  - `getDebtSettlements`
  - `createUserTransfer`
  - `getTransfers`
  - `getNotifications`
  - `markNotificationAsRead`
  - `createAttachmentUploadUrl`
  - `completeAttachmentUpload`
  - `getAttachments`
  - `getAuditLogs`

## 4. Data Model Rebuild
- Rebuild relational or UUID-based persistence for these Firebase collections:
  - `users`
  - `phoneIndex`
  - `authOtpChallenges`
  - `wallets`
  - `ledgerEntries`
  - `contacts`
  - `debts`
  - `debtSettlements`
  - `transfers`
  - `notifications`
  - `attachments`
  - `auditLogs`
- Preserve timestamps, ownership fields, status fields, and immutable history semantics.

## 5. Ledger and Accounting
- Rebuild immutable ledger entry creation.
- Preserve balance derivation from ledger rows only.
- Preserve signed-entry semantics for:
  - `deposit`
  - `withdrawal`
  - `transfer_in`
  - `transfer_out`
  - `exchange_in`
  - `exchange_out`
  - `debt_settlement_in`
  - `debt_settlement_out`
- Rebuild atomic balance checks and paired writes for:
  - internal transfers
  - user transfers
  - exchanges

## 6. Transactional Consistency
- Replace Firestore transactions with SQL transactions.
- Preserve atomic behavior for:
  - OTP challenge lifecycle changes
  - internal transfer paired ledger entries
  - exchange paired ledger entries
  - debt settlement record plus debt remaining update
  - user transfer record plus paired ledger entries

## 7. Notifications
- Rebuild notification creation and read-state updates.
- Preserve owner-only access and unread/read state semantics.
- Preserve cross-module side effects from wallets, debts, transfers, and settlements.

## 8. Audit Logging
- Rebuild append-only audit log creation.
- Preserve cross-module safe-write behavior so primary business writes do not fail solely because audit logging fails.
- Preserve owner visibility rules.

## 9. Attachments
- Replace Firebase Storage signed upload flow.
- Rebuild:
  - upload authorization
  - path ownership validation
  - object existence verification
  - attachment metadata persistence
- Preserve entity ownership rules for:
  - wallet
  - debt
  - settlement
  - transfer

## 10. Security Rules Replacement
- Convert Firestore/Storage rule intent into Laravel authorization and storage controls.
- Preserve these rule outcomes:
  - users are self-readable only
  - wallets, contacts, debts, settlements, notifications, attachments are owner-readable only
  - transfers are readable by sender or receiver only
  - ledger, OTP, phone index, and audit are not client-writable

## 11. Planned But Not Fully Implemented Features
- Decide whether Laravel parity target is:
  - exact Firebase callable behavior first
  - master-spec target behavior immediately
- Master-doc gaps not present in Firebase implementation include:
  - wallet archive/restore/rename endpoints
  - transfer fallback to recipient default wallet
  - linked debt-settlement plus financial transfer in one flow
  - QR APIs
  - sync APIs
  - device/session management
  - transaction REST surface
  - contact linking approval workflow

## 12. Flutter Integration Contract
- Do not let Laravel design assume current Flutter code is already REST-ready everywhere.
- Flutter auth currently depends directly on Firebase phone auth.
- Flutter Firebase dependencies that must eventually be removed or replaced at app level:
  - `firebase_core`
  - `firebase_auth`
  - `cloud_firestore`
  - `firebase_storage`
- Migration should define replacement mobile contracts before app-side cutover.

## 13. Handoff Deliverables for Laravel Engineer
- Use `docs/migration/LARAVEL_MIGRATION_REPORT.md` as module-level behavior reference.
- Use `archive/firebase-backend/functions/src` as executable business reference.
- Use `docs/Master/` as broader target architecture reference.
- Reconcile differences explicitly before implementation begins.
