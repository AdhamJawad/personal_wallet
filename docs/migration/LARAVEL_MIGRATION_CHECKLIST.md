# Laravel Migration Checklist

## Goal
Finalize the backend handoff around the approved production architecture:
- Flutter
- Laravel 12 API
- MySQL
- Cloudinary
- WhatsApp API
- FCM

Laravel backend is the single source of truth. No business logic may live inside Flutter.

## 1. Authentication And Identity
- Implement authentication as WhatsApp OTP plus Laravel Sanctum.
- Remove all Firebase Auth assumptions from backend planning.
- Remove all Firebase custom token assumptions from backend planning.
- Remove all password-based authentication assumptions from backend planning.
- Remove all email-based authentication assumptions from backend planning.
- Remove all password-reset assumptions from backend planning.
- Keep these rules:
  - E.164 phone normalization
  - 6-digit OTP
  - bounded OTP lifetime
  - resend cooldown
  - attempt lockout
  - one effective pending challenge per phone number and purpose
- Store all OTP lifecycle state in MySQL.
- Issue Laravel Sanctum tokens only after approved verification or login flow.
- Require WhatsApp OTP verification on every new device login.
- Treat PIN, fingerprint, and Face ID as application-unlock controls only.

## 2. Backend Authority Boundary
- Document and enforce that Laravel owns all business rules.
- Keep Flutter limited to UI, local caching, and sync-safe request submission.
- Ensure no debt, ledger, wallet, or transfer rule is defined as client-authoritative.

## 3. Data Platform
- Use MySQL as the production persistence layer.
- Remove all Firestore persistence assumptions.
- Replace Firestore transactions with Laravel-managed SQL transactions.
- Keep UUID-based public entity identifiers and idempotent write semantics where documented.

## 4. Attachment Platform
- Replace Firebase Storage assumptions with Cloudinary for file storage.
- Store attachment metadata in MySQL.
- Rebuild:
  - upload authorization
  - ownership validation
  - metadata persistence
  - attachment lifecycle states
  - secure download or delivery flow
  - backend-authorized attachment deletion
  - coordinated Cloudinary plus metadata deletion where possible

## 5. Notifications Platform
- Keep notification state in MySQL.
- Use FCM for push delivery only.
- Do not treat FCM as canonical notification storage.

## 6. API Surface
- Keep REST endpoints under `/api/v1`.
- Align API documentation to Laravel-first contracts, not Firebase callable parity.
- Ensure all financial write endpoints support idempotency.

## 7. Wallet And Ledger Rules
- Preserve ledger as the financial source of truth.
- Preserve derived wallet balances only.
- Prevent wallet balance fields from becoming authoritative.
- Preserve atomic write guarantees for all wallet-affecting operations.

## 8. Debt Architecture
- Implement final debt directions:
  - `owed_by_contact`
  - `owed_to_contact`
- For `owed_by_contact` debt creation:
  - require `source_wallet_id`
  - create linked wallet withdrawal
  - commit debt and ledger writes atomically
- For `owed_to_contact` debt creation:
  - create debt only
  - no wallet transaction
- For settlements on `owed_by_contact`:
  - require `destination_wallet_id`
  - reduce remaining debt
  - create ledger deposit
  - commit atomically
- For settlements on `owed_to_contact`:
  - require `source_wallet_id`
  - reduce remaining debt
  - create ledger withdrawal
  - commit atomically
- Preserve rule that debt updates and ledger updates must never become inconsistent.

## 9. Transfers
- Preserve standard user-to-user transfers as separate from debt settlements.
- Preserve rule that standard transfers do not reduce debt automatically.
- Preserve same-currency-only user transfer rule.
- Preserve rule that cross-currency movement must use exchange workflow only.
- Remove transfer-backed debt-settlement assumptions from final backend architecture.

## 10. Unified Transaction History
- Provide a consolidated chronological transaction history view.
- Combine:
  - deposits
  - transfers
  - exchanges
  - debt settlements
- Ensure the view is derived from canonical Laravel-managed financial records.

## 11. Audit Logging
- Keep audit logging append-only.
- Generate audit events from backend write flows.
- Avoid relying on Flutter for authoritative audit generation.

## 12. Authorization Model
- Replace Firebase rule assumptions with Laravel middleware, policies, and service-level authorization.
- Preserve:
  - owner-only access where applicable
  - participant-scoped access for shared transfer records
  - backend-only control of sensitive writes

## 13. Historical Firebase Archive Handling
- Keep `archive/firebase-backend/` for historical reference only.
- Do not use Firebase archive semantics as the production target when they conflict with approved Laravel architecture.
- Remove all production planning assumptions tied to:
  - Firebase Auth
  - Firestore
  - Firebase Storage
  - Cloud Functions
  - Firebase custom tokens
  - Firestore transactions

## 14. Flutter Cutover Guidance
- Remove long-term architectural dependence on:
  - `firebase_auth`
  - `cloud_firestore`
  - `firebase_storage`
- Retain FCM-related mobile integration only for push delivery.
- Align Flutter request models with Laravel-owned business rules before implementation cutover.

## 15. Handoff Deliverables
- Use `docs/migration/LARAVEL_MIGRATION_REPORT.md` for final architecture position.
- Use `docs/migration/DOMAIN_INVENTORY.md` for domain ownership and rule map.
- Use `docs/Master/` documents for final backend contract, ERD, API, and system rules.
- Use archived Firebase source only as historical context when needed.
