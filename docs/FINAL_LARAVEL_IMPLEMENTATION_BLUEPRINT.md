# FINAL_LARAVEL_IMPLEMENTATION_BLUEPRINT

## 1. Final System Overview

Personal Wallet is a Flutter mobile client backed by a Laravel 12 REST API and MySQL database.

Final production stack:
- Flutter
- Laravel 12 API
- MySQL
- Cloudinary for attachment file storage
- WhatsApp API for OTP delivery
- Firebase Cloud Messaging (FCM) for push notifications only

Authority boundaries:
- Laravel backend is the single source of truth.
- No business logic may live inside Flutter.
- Flutter may cache, queue, and render data locally, but all canonical business rules and final write validation belong to Laravel.
- Ledger is the financial source of truth for wallet balances.

Core implementation posture:
- API-first backend under `/api/v1`
- UUID primary keys for public entities
- Sanctum-protected authenticated endpoints
- MySQL transactions for atomic multi-table writes
- Immutable financial history
- Derived balances and summaries
- Idempotent write handling for offline-safe replay

## 2. Final Domain List

Primary backend domains:
- Users
- Authentication
- Wallets
- Ledger
- Transfers
- Debts
- Debt Settlements
- Contacts
- Notifications
- Attachments
- Audit Logs

Supporting backend infrastructure already defined in the finalized docs:
- QR Identity
- Device Management
- Sync Operations
- Conflict Records
- Transaction References

## 3. Final Database Design

### `users`
Purpose:
- Canonical user account record.

Primary key:
- `id` uuid

Important fields:
- `full_name`
- `phone_number`
- `otp_verified_at`
- `public_reference_code`
- `default_receiving_wallet_id`
- `status`
- `last_login_at`

Relationships:
- has many `user_devices`
- has many Sanctum `personal_access_tokens`
- has many `wallets`
- has many `contacts`
- has many `debts`
- has many `notifications`
- has many `audit_events`
- has many `sync_operations`
- has one `qr_identities`
- may reference one default wallet through `default_receiving_wallet_id`

Indexes:
- unique `users_phone_number_uq`
- unique `users_public_reference_code_uq`
- `users_status_idx`
- `users_default_receiving_wallet_idx`

Constraints:
- `phone_number` must be unique and normalized E.164
- `default_receiving_wallet_id` must reference a wallet owned by the same user
- `status` limited to `active`, `locked`, `disabled`
- successful registration must create one active wallet named `Main Wallet`
- `Main Wallet` must become `default_receiving_wallet_id`
- a user account must never exist without at least one wallet

### `user_devices`
Purpose:
- Tracks registered devices for session binding, trust management, and local unlock convenience.

Primary key:
- `id` uuid

Important fields:
- `user_id`
- `device_identifier`
- `device_name`
- `platform`
- `biometric_enabled`
- `biometric_public_key`
- `last_used_at`

Relationships:
- belongs to `users`
- referenced by `financial_transactions.created_by_device_id`
- referenced by `debt_settlements.created_by_device_id`

Indexes:
- unique `user_devices_user_device_uq (user_id, device_identifier)`
- `user_devices_last_used_idx`

Constraints:
- one logical device identifier per user
- biometric data itself is not stored; only registration/attestation material

### `personal_access_tokens`
Purpose:
- Laravel Sanctum token storage for authenticated API access.

Primary key:
- `id` bigint

Important fields:
- `tokenable_type`
- `tokenable_id`
- `name`
- `token`
- `abilities`
- `last_used_at`
- `expires_at`

Relationships:
- polymorphic ownership by `users`

Indexes:
- unique `personal_access_tokens_token_uq`
- `personal_access_tokens_tokenable_idx`

Constraints:
- token hashes must be unique
- tokens are backend-managed and revocable

### `otp_challenges`
Purpose:
- Stores OTP issuance and verification state for registration, login, and new-device verification.

Primary key:
- `id` uuid

Important fields:
- `user_id`
- `phone_number`
- `purpose`
- `otp_hash`
- `delivery_channel`
- `expires_at`
- `consumed_at`
- `attempt_count`

Relationships:
- optionally belongs to `users`

Indexes:
- `otp_challenges_phone_purpose_idx`
- `otp_challenges_expires_idx`

Constraints:
- `purpose` limited to `register`, `login`, `new_device_login`
- `delivery_channel` is `whatsapp`
- OTP must be single-use
- OTP hash only; raw OTP must never be stored

### `wallets`
Purpose:
- Stores wallet metadata only.

Primary key:
- `id` uuid

Important fields:
- `user_id`
- `client_generated_id`
- `name`
- `status`
- `archived_at`
- `restored_at`
- `version`

Relationships:
- belongs to `users`
- may be referenced by `users.default_receiving_wallet_id`
- has many `financial_transactions`
- has many `ledger_entries`
- has many `user_transfers` as sender
- has many `debt_settlements`

Indexes:
- `wallets_user_status_idx`
- `wallets_user_created_idx`

Constraints:
- `status` limited to `active`, `archived`
- no authoritative balance field
- no stored wallet balance columns are allowed
- no `balance_usd` field is allowed
- no `balance_syp` field is allowed
- optimistic concurrency via `version`
- archive must not break default wallet invariant

### `transaction_references`
Purpose:
- Generates canonical transaction reference codes such as `TX-YYYY-######`.

Primary key:
- `id` bigint

Important fields:
- `reference_year`
- `sequence_number`
- `reference_code`

Relationships:
- referenced by `financial_transactions`

Indexes:
- unique `transaction_references_code_uq`
- unique `transaction_references_year_seq_uq`

Constraints:
- each year/sequence pair must be unique
- reference format is backend-generated only

### `financial_transactions`
Purpose:
- Immutable transaction aggregate for every wallet-affecting financial write.

Primary key:
- `id` uuid

Important fields:
- `user_id`
- `wallet_id`
- `destination_wallet_id`
- `transaction_reference_id`
- `client_generated_id`
- `idempotency_key`
- `type`
- `currency`
- `source_currency`
- `destination_currency`
- `amount`
- `amount_given`
- `exchange_rate`
- `amount_received`
- `note`
- `attachment_count`
- `created_by_device_id`
- `version`

Relationships:
- belongs to `users`
- belongs to primary `wallets`
- may belong to destination `wallets`
- belongs to `transaction_references`
- may belong to `user_devices`
- has many `ledger_entries`
- may back one `user_transfers`
- may back many `debt_settlements`
- may be referenced by `debts.origin_financial_transaction_id`

Indexes:
- unique `financial_transactions_idempotency_key_uq`
- `financial_transactions_user_created_idx`
- `financial_transactions_wallet_created_idx`
- `financial_transactions_type_idx`

Constraints:
- immutable after creation
- `type` limited to `deposit`, `withdraw`, `internal_transfer`, `exchange`, `user_transfer`, `debt_settlement`
- all currency fields are limited to `USD` and `SYP`
- exchange rows must preserve user-entered `amount_given`, `exchange_rate`, `amount_received`
- idempotency key must be unique

### `ledger_entries`
Purpose:
- Append-only ledger rows used to derive wallet balances.

Primary key:
- `id` uuid

Important fields:
- `financial_transaction_id`
- `wallet_id`
- `direction`
- `currency`
- `amount`
- `related_user_id`
- `linked_transfer_id`
- `linked_debt_settlement_id`
- `created_at`

Relationships:
- belongs to `financial_transactions`
- belongs to `wallets`
- may belong to `users`
- may reference `user_transfers`
- may reference `debt_settlements`

Indexes:
- `ledger_entries_wallet_currency_idx`
- `ledger_entries_transaction_idx`

Constraints:
- append-only
- `direction` limited to `credit`, `debit`
- `currency` is limited to `USD` and `SYP`
- `amount` must be positive

### `user_transfers`
Purpose:
- Stores standard registered-user transfer records separate from debt settlement.

Primary key:
- `id` uuid

Important fields:
- `sender_user_id`
- `sender_wallet_id`
- `recipient_user_id`
- `recipient_wallet_id`
- `financial_transaction_id`
- `reference_code`
- `currency`
- `amount`
- `note`

Relationships:
- belongs to sender `users`
- belongs to recipient `users`
- belongs to sender `wallets`
- may belong to recipient `wallets`
- belongs to `financial_transactions`
- may be linked from `ledger_entries`

Indexes:
- `user_transfers_sender_idx`
- `user_transfers_recipient_idx`

Constraints:
- standard transfer must not reduce debt
- if `recipient_wallet_id` is null, backend must resolve recipient `default_receiving_wallet_id`
- transfer currency must be the same on sender and recipient sides
- cross-currency user transfers are not allowed
- currency conversion must use exchange workflow only

### `contacts`
Purpose:
- Stores user-owned contact records for external and registered contacts.

Primary key:
- `id` uuid

Important fields:
- `owner_user_id`
- `type`
- `display_name`
- `phone_number`
- `note`
- `linked_user_id`
- `link_status`
- `archived_at`
- `version`

Relationships:
- belongs to owning `users`
- may reference linked `users`
- has many `debts`
- has many `contact_link_requests`

Indexes:
- `contacts_owner_type_idx`
- `contacts_owner_name_idx`
- `contacts_phone_idx`

Constraints:
- `type` limited to `external`, `registered`
- `status` limited to `active`, `archived`
- `link_status` limited to `none`, `pending`, `linked`, `rejected`
- optimistic concurrency via `version`
- contacts must not support permanent deletion

### `contact_link_requests`
Purpose:
- Supports dual-approval linking between external contacts and registered users.

Primary key:
- `id` uuid

Important fields:
- `owner_user_id`
- `contact_id`
- `candidate_user_id`
- `owner_approved_at`
- `candidate_approved_at`
- `rejected_at`
- `status`

Relationships:
- belongs to contact owner `users`
- belongs to `contacts`
- belongs to candidate `users`

Indexes:
- `contact_link_requests_contact_idx`
- `contact_link_requests_candidate_idx`

Constraints:
- final linking requires both approvals
- `status` limited to `pending`, `approved`, `rejected`, `expired`

### `debts`
Purpose:
- Stores obligation records independent from wallet balances.

Primary key:
- `id` uuid

Important fields:
- `owner_user_id`
- `contact_id`
- `direction`
- `currency`
- `original_amount`
- `origin_financial_transaction_id`
- `note`
- `status`
- `version`

Relationships:
- belongs to `users`
- belongs to `contacts`
- may belong to origin `financial_transactions`
- has many `debt_settlements`

Indexes:
- `debts_owner_direction_idx`
- `debts_contact_idx`

Constraints:
- `direction` limited to `owed_by_contact`, `owed_to_contact`
- `status` limited to `open`, `completed`
- `currency` is limited to `USD` and `SYP`
- `origin_financial_transaction_id` is required for `owed_by_contact`
- `origin_financial_transaction_id` must be null for `owed_to_contact`

### `debt_settlements`
Purpose:
- Stores immutable settlement records linked to debt reductions and ledger-backed financial writes.

Primary key:
- `id` uuid

Important fields:
- `debt_id`
- `financial_transaction_id`
- `wallet_id`
- `wallet_role`
- `amount`
- `note`
- `created_by_device_id`

Relationships:
- belongs to `debts`
- belongs to `financial_transactions`
- belongs to `wallets`
- may belong to `user_devices`
- may be referenced by `ledger_entries`

Indexes:
- `debt_settlements_debt_created_idx`
- `debt_settlements_financial_tx_idx`

Constraints:
- immutable after creation
- `wallet_role` limited to `source`, `destination`
- every settlement must reference the financial transaction that created ledger impact

### `qr_identities`
Purpose:
- Stores public-safe QR identity metadata.

Primary key:
- `id` uuid

Important fields:
- `user_id`
- `public_reference_code`
- `payload_version`
- `generated_at`
- `rotated_at`

Relationships:
- belongs to `users`

Indexes:
- unique `qr_identities_user_uq`
- unique `qr_identities_public_ref_uq`

Constraints:
- one QR identity per user
- QR payload must contain only `public_reference_code`
- QR resolution must happen through backend APIs

### `attachments`
Purpose:
- Stores attachment metadata while Cloudinary stores the actual file.

Primary key:
- `id` uuid

Important fields:
- `owner_user_id`
- `entity_type`
- `entity_id`
- `original_file_name`
- `content_type`
- `file_size_bytes`
- `storage_key`
- `storage_provider`
- `checksum_sha256`
- `upload_status`
- `version`

Relationships:
- belongs to `users`
- polymorphic logical relationship to domain entities through `entity_type` and `entity_id`

Indexes:
- `attachments_owner_entity_idx`
- `attachments_upload_status_idx`

Constraints:
- `entity_type` limited to `transaction`, `debt`, `debt_settlement`, `contact`
- `storage_provider` is `cloudinary`
- attachment deletion requires backend ownership validation
- direct Cloudinary access must never bypass backend authorization
- physical Cloudinary deletion and metadata deletion must be coordinated atomically where possible

### `notifications`
Purpose:
- Stores backend-owned notification state and rendering data.

Primary key:
- `id` uuid

Important fields:
- `user_id`
- `type`
- `title`
- `body`
- `related_entity_type`
- `related_entity_id`
- `payload_json`
- `read_at`

Relationships:
- belongs to `users`

Indexes:
- `notifications_user_created_idx`
- `notifications_user_read_idx`

Constraints:
- notification state is backend-owned
- notification rows are not the source of truth for domain state

### `audit_events`
Purpose:
- Append-only audit log for significant backend actions.

Primary key:
- `id` uuid

Important fields:
- `actor_user_id`
- `event_type`
- `related_entity_type`
- `related_entity_id`
- `device_identifier`
- `sync_status`
- `metadata_json`
- `created_at`

Relationships:
- may belong to `users`

Indexes:
- `audit_events_entity_idx`
- `audit_events_actor_idx`
- `audit_events_type_idx`

Constraints:
- immutable and append-only
- no user edits or deletes

### `sync_operations`
Purpose:
- Stores offline-originated operation tracking and replay state.

Primary key:
- `id` uuid

Important fields:
- `user_id`
- `device_identifier`
- `operation_type`
- `status`
- `entity_type`
- `entity_id`
- `client_generated_id`
- `idempotency_key`
- `base_version`
- `payload_json`
- `server_response_json`
- `error_code`
- `error_message`
- `synced_at`

Relationships:
- belongs to `users`
- has many `conflict_records`

Indexes:
- unique `sync_operations_idempotency_key_uq`
- `sync_operations_user_status_idx`
- `sync_operations_type_status_idx`

Constraints:
- `status` limited to `pending`, `synced`, `failed`, `conflict`
- idempotency key must be unique

### `conflict_records`
Purpose:
- Stores conflict resolution details for sync failures requiring review.

Primary key:
- `id` uuid

Important fields:
- `sync_operation_id`
- `entity_type`
- `entity_id`
- `resolution_strategy`
- `local_payload_json`
- `remote_payload_json`
- `summary`
- `status`
- `resolved_at`

Relationships:
- belongs to `sync_operations`

Indexes:
- `conflict_records_operation_idx`
- `conflict_records_status_idx`

Constraints:
- `resolution_strategy` limited to `server_wins`, `client_wins`, `manual_review`, `merge`
- `status` limited to `open`, `resolved`, `ignored`

## 4. Domain Dependencies

### Users
- Base dependency for nearly every domain.
- Wallets, contacts, debts, notifications, audit, devices, and attachments are all user-scoped.

### Authentication
- Depends on `users`, `otp_challenges`, `user_devices`, and `personal_access_tokens`.
- Provides authenticated context for every protected domain.

### Wallets
- Depends on `users`.
- Referenced by ledger, transactions, debt settlements, and user transfers.

### Ledger
- Depends on `financial_transactions` and `wallets`.
- Serves as the downstream balance source for wallets, dashboard totals, and unified transaction history.

### Transfers
- Depends on `users`, `wallets`, `financial_transactions`, and `ledger_entries`.
- Must validate recipient wallet or resolve recipient default wallet.

### Debts
- Depends on `users`, `contacts`, and optionally `financial_transactions` for `owed_by_contact`.
- Depends on ledger-backed writes when creating wallet-linked debt flows.

### Debt Settlements
- Depends on `debts`, `wallets`, `financial_transactions`, and `ledger_entries`.
- Must be executed inside the same database transaction as debt updates.

### Contacts
- Depends on `users`.
- Supports debt ownership context and future registered-contact linking.

### Notifications
- Depends on user-scoped domain events from wallets, transfers, debts, sync, and attachment workflows.
- FCM delivery depends on backend-owned notification records, not the reverse.

### Attachments
- Depends on `users` plus target parent entities.
- Depends on Cloudinary for binary storage and MySQL for metadata.

### Audit Logs
- Cross-cutting dependency on successful writes from authentication, wallets, transactions, contacts, debts, transfers, attachments, and sync handling.

### QR Identity
- Depends on `users`.
- Supports contact-add and transfer initiation flows.

### Sync
- Depends on authenticated user context, idempotent write endpoints, versioned mutable entities, and stable API responses.

## 5. API Implementation Order

### Phase 1: Authentication
Deliver:
- `POST /auth/register`
- `POST /auth/login`
- `POST /auth/verify-otp`
- `POST /auth/logout`
- `GET /auth/devices`
- `POST /auth/biometric-devices`
- `DELETE /auth/devices/{device_id}`

Required outcomes:
- phone-number-based identity
- WhatsApp OTP issuance and verification
- Sanctum token issuance and revocation
- device-bound session tracking
- atomic creation of user, active `Main Wallet`, and `default_receiving_wallet_id`

### Phase 2: Users
Deliver:
- authenticated user profile retrieval as needed by Flutter
- `GET /users/{user_id}/preview`
- QR identity support if required for preview-dependent screens

Required outcomes:
- canonical user identity exposure
- public-safe user preview
- default receiving wallet visibility where needed

### Phase 3: Wallets + Ledger
Deliver:
- `GET /wallets`
- `POST /wallets`
- `GET /wallets/{wallet_id}`
- `PATCH /wallets/{wallet_id}`
- `POST /wallets/{wallet_id}/archive`
- `POST /wallets/{wallet_id}/restore`

Required outcomes:
- wallet lifecycle
- derived balances
- default wallet invariants
- ledger-aware wallet detail responses

### Phase 4: Deposits + Internal Transfers + Exchange
Deliver:
- `POST /transactions/deposits`
- `POST /transactions/withdrawals`
- `POST /transactions/internal-transfers`
- `POST /transactions/exchanges`
- `GET /transactions`
- `GET /transactions/{transaction_id}`

Required outcomes:
- immutable transaction creation
- deterministic ledger entry generation
- unified transaction list groundwork

### Phase 5: Contacts
Deliver:
- `GET /contacts`
- `POST /contacts`
- `PATCH /contacts/{contact_id}`
- `POST /contacts/{contact_id}/archive`
- `GET /contacts/{contact_id}/link-candidate`
- `POST /contacts/{contact_id}/link-requests`
- `POST /contact-link-requests/{request_id}/approve`
- `POST /contact-link-requests/{request_id}/reject`

Required outcomes:
- external and registered contact support
- dual-approval contact linking

### Phase 6: Debts + Settlements
Deliver:
- `GET /debts`
- `POST /debts`
- `GET /debts/{debt_id}`
- `GET /debts/{debt_id}/history`
- `POST /debts/{debt_id}/settlements`

Required outcomes:
- debt creation by direction
- wallet-linked `owed_by_contact` origination
- wallet-linked settlements by direction
- atomic debt plus ledger writes

### Phase 7: User Transfers
Deliver:
- `POST /user-transfers`
- `GET /user-transfers`
- `GET /user-transfers/{transfer_id}`

Required outcomes:
- explicit or default recipient wallet resolution
- ledger-backed standard transfer flow
- no debt side effects

### Phase 8: Notifications
Deliver:
- `GET /notifications`
- `POST /notifications/{notification_id}/read`
- `POST /notifications/mark-all-read`
- `DELETE /notifications/read`

Required outcomes:
- backend-owned notification state
- FCM-triggerable event pipeline

### Phase 9: Attachments (Cloudinary)
Deliver:
- `POST /attachments`
- `GET /attachments`
- `GET /attachments/{attachment_id}`
- `DELETE /attachments/{attachment_id}`

Required outcomes:
- attachment metadata lifecycle
- authorized file access
- Cloudinary integration

### Phase 10: Audit Logs
Deliver:
- `GET /audit-events`
- `GET /audit-events/{audit_event_id}`

Required outcomes:
- append-only audit read surface
- event coverage across all critical writes

## 6. Financial Integrity Rules

- Ledger is immutable.
- Ledger entries are append-only.
- Financial transactions are immutable.
- No financial delete is allowed for committed transactions.
- No financial edit is allowed for committed transactions.
- Wallet balances are always derived from ledger entries.
- Debt balances are derived from debt records and debt settlement records.
- Standard transfers must never reduce debt automatically.
- Debt settlement is the only debt-reducing money-linked workflow.
- Every wallet-affecting multi-row write must commit atomically.
- Every debt write that also affects ledger state must commit atomically.
- Corrections, if later added, must be reversal-style records, not updates in place.

## 7. Authentication Rules

- User identity is based on phone number.
- Verification is performed through WhatsApp OTP.
- Access tokens are issued through Laravel Sanctum.
- Password login is not part of the system.
- Email login is not part of the system.
- Password reset flows are not part of the system.
- OTP must be hashed at rest.
- OTP must be time-limited.
- OTP must be attempt-limited.
- OTP must be single-use.
- New device login always requires WhatsApp OTP verification.
- PIN, fingerprint, and Face ID are local application unlock controls only.

## 8. Wallet Rules

- Wallets are metadata, not balances.
- A user may create unlimited wallets.
- Wallet balances are derived by currency from ledger entries.
- Successful registration must create one active wallet named `Main Wallet`.
- `Main Wallet` must become `default_receiving_wallet_id`.
- A user account must never exist without at least one wallet.
- Default wallet support exists through `users.default_receiving_wallet_id`.
- If a recipient wallet is not supplied for a user transfer, the backend must resolve the default receiving wallet.
- The default receiving wallet must belong to the same user.
- Archiving a default receiving wallet must either fail or reassign the default inside the same backend operation.
- Supported currencies only:
  - USD
  - SYP

## 9. Debt Rules

Debt directions:
- `owed_by_contact`
- `owed_to_contact`

Creation rules:
- `owed_by_contact` means the user is lending money.
- `owed_by_contact` requires `source_wallet_id`.
- `owed_by_contact` must create the debt and linked wallet withdrawal atomically.
- `owed_to_contact` means the user owes someone money.
- `owed_to_contact` creates a debt record only.
- `owed_to_contact` must not create an automatic wallet transaction.

Settlement rules:
- `owed_by_contact` settlement means the user is receiving money back.
- `owed_by_contact` settlement requires `destination_wallet_id`.
- `owed_by_contact` settlement must reduce remaining debt and create a ledger-backed deposit atomically.
- `owed_to_contact` settlement means the user is paying money.
- `owed_to_contact` settlement requires `source_wallet_id`.
- `owed_to_contact` settlement must reduce remaining debt and create a ledger-backed withdrawal atomically.

Integrity rules:
- debt updates and ledger updates must never become inconsistent
- standard transfers do not settle debt
- ledger remains the financial source of truth for wallet balances

## 10. Attachment Rules

- Cloudinary stores files.
- MySQL stores attachment metadata.
- Attachments are supported for:
  - transactions
  - debts
  - debt settlements
  - contacts
- Attachment authorization must be based on parent entity ownership.
- Attachment metadata is backend-owned.
- Attachments may be deleted only by the owner through backend-authorized operations.
- Direct Cloudinary access must never bypass backend authorization.
- Physical Cloudinary deletion and metadata deletion must be coordinated atomically where possible.

## 11. Push Notification Rules

- FCM is used for push delivery only.
- Notification state remains in MySQL.
- FCM is not a source of truth.
- Notifications are generated from backend domain events.
- Read/unread state is owned by Laravel.

## 12. Open Questions

These items are not architecture contradictions. They are implementation decisions not fully finalized in the current approved docs.

1. What exact policy should Sanctum use for token expiration and token abilities?
Sanctum is finalized, but token TTL and ability scoping are not fully specified.

2. What exact Cloudinary upload pattern should Laravel implement?
The architecture finalizes Cloudinary plus MySQL metadata, but the docs do not fully lock down direct signed upload versus backend-mediated upload orchestration.

3. Should notifications be persisted synchronously in the request transaction or dispatched asynchronously after commit?
The docs require backend-owned notification state, but exact queue timing is not fully specified.

4. What is the exact initial scope for QR APIs in the first Laravel delivery?
QR is present in the master docs and API spec, but it is not included in the user-requested phased implementation list.

5. What is the exact initial scope for sync endpoints and sync persistence?
Sync tables and rules are fully modeled, but sync was not requested in the current phase order and may be deferred.

6. Which derived read-model strategy should be used first?
The docs allow SQL views, materialized views, or query-side aggregation, but do not fix one approach.

## 13. Laravel Readiness Score

Readiness score: `95/100`

Assessment:
- The domain model is mature.
- The production stack is finalized.
- Authentication architecture is finalized.
- Debt and ledger rules are finalized and internally consistent.
- API surface is largely defined.
- ERD coverage is strong and implementation-oriented.
- Source-of-truth boundaries are explicit.

Why not 100:
- a small number of implementation choices remain open
- QR and sync rollout scope are not fully staged
- token policy and upload orchestration details still need engineering decisions

Implementation readiness conclusion:
- The project is ready for Laravel implementation.
- The backend engineer should begin implementation against this blueprint and resolve the listed open questions early, before deep controller/service work starts.

## 14. Governance

Version: `1.0`

Status: `Approved`

Document Authority:
- This blueprint is the authoritative implementation document for the Laravel backend.
- If any conflict exists between `PROJECT_MASTER_SPECIFICATION.md`, `BACKEND_CONTRACT.md`, `API_SPECIFICATION.md`, `ERD.md`, `SECURITY_SPECIFICATION.md`, or the migration documents, this blueprint takes precedence.

Change Control:
- Any future architectural change must update this blueprint first.
- Supporting architecture, API, ERD, security, and migration documents must then be brought into alignment with the updated blueprint.
