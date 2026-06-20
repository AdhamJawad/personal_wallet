# ERD And Database Specification

## Database Notes
- Recommended relational engine: MySQL 8+.
- All primary business entities use `uuid` primary keys.
- Monetary values use `numeric(18,2)`.
- Exchange rates use `numeric(18,6)`.
- Timestamps use MySQL timestamp/datetime columns in UTC.
- Enumerations may be native database enums or validated strings.
- All write APIs should accept `client_generated_id` and `idempotency_key` for sync-safe replay.

## Approved Platform Notes
- Backend: Laravel 12 API
- Database: MySQL
- Authentication: WhatsApp OTP plus Laravel Sanctum
- Attachments: Cloudinary file storage plus MySQL metadata
- Push delivery: FCM only
- Laravel backend is the single source of truth.
- No business logic may live inside Flutter.

## Tables

### `users`
| Field | Type | Notes |
| --- | --- | --- |
| id | uuid pk | Primary key |
| full_name | varchar(150) | Required |
| phone_number | varchar(32) unique | Required, normalized E.164 |
| otp_verified_at | timestamp null | Set after verification |
| public_reference_code | varchar(32) unique | Used in QR/public identity |
| default_receiving_wallet_id | uuid fk wallets.id | Default inbound transfer destination. Must reference the auto-created `Main Wallet` at registration time until changed later |
| status | varchar(20) | `active`, `locked`, `disabled` |
| last_login_at | timestamp null |  |
| created_at | timestamp |  |
| updated_at | timestamp |  |

Indexes:
- unique `users_phone_number_uq (phone_number)`
- unique `users_public_reference_code_uq (public_reference_code)`
- index `users_status_idx (status)`
- index `users_default_receiving_wallet_idx (default_receiving_wallet_id)`

Registration constraints:
- successful registration must create one active wallet named `Main Wallet`
- `Main Wallet` creation must be atomic with user creation
- `Main Wallet` must become `default_receiving_wallet_id`
- a user must never exist without at least one wallet

### `user_devices`
| Field | Type | Notes |
| --- | --- | --- |
| id | uuid pk |  |
| user_id | uuid fk users.id |  |
| device_identifier | varchar(128) | Client/device id |
| device_name | varchar(150) null |  |
| platform | varchar(20) | `android`, `ios`, `web` |
| biometric_enabled | boolean | Default false |
| biometric_public_key | text null | Future-ready |
| last_used_at | timestamp null | Last authenticated or refreshed use |
| created_at | timestamp |  |
| updated_at | timestamp |  |

Indexes:
- unique `user_devices_user_device_uq (user_id, device_identifier)`
- index `user_devices_last_used_idx (last_used_at)`

### `personal_access_tokens`
| Field | Type | Notes |
| --- | --- | --- |
| id | bigint pk |  |
| tokenable_type | varchar(255) | Laravel Sanctum polymorphic owner type |
| tokenable_id | uuid | User id |
| name | varchar(255) | Token label or device/session label |
| token | varchar(64) unique | Hashed Sanctum token |
| abilities | text null | Token abilities |
| last_used_at | timestamp null |  |
| expires_at | timestamp null | Optional expiration policy |
| created_at | timestamp |  |
| updated_at | timestamp |  |

Indexes:
- unique `personal_access_tokens_token_uq (token)`
- index `personal_access_tokens_tokenable_idx (tokenable_type, tokenable_id)`

### `otp_challenges`
| Field | Type | Notes |
| --- | --- | --- |
| id | uuid pk |  |
| user_id | uuid fk users.id null | Null for pre-registration flows if needed |
| phone_number | varchar(32) |  |
| purpose | varchar(30) | `register`, `login`, `new_device_login` |
| otp_hash | varchar(255) |  |
| delivery_channel | varchar(30) | `whatsapp` |
| expires_at | timestamp |  |
| consumed_at | timestamp null |  |
| attempt_count | integer | Default 0 |
| created_at | timestamp |  |

Indexes:
- index `otp_challenges_phone_purpose_idx (phone_number, purpose, consumed_at)`
- index `otp_challenges_expires_idx (expires_at)`

### `wallets`
| Field | Type | Notes |
| --- | --- | --- |
| id | uuid pk |  |
| user_id | uuid fk users.id | Owner |
| client_generated_id | uuid null | Offline-created id |
| name | varchar(120) | Required |
| status | varchar(20) | `active`, `archived` |
| archived_at | timestamp null |  |
| restored_at | timestamp null | Last restore timestamp |
| created_at | timestamp |  |
| updated_at | timestamp |  |
| version | integer | Optimistic concurrency |

Indexes:
- index `wallets_user_status_idx (user_id, status)`
- index `wallets_user_created_idx (user_id, created_at desc)`

Wallet constraints:
- no stored wallet balance columns are allowed
- no `balance_usd` field is allowed
- no `balance_syp` field is allowed
- all wallet balances are derived from `ledger_entries`

### `transaction_references`
| Field | Type | Notes |
| --- | --- | --- |
| id | bigint pk |  |
| reference_year | integer |  |
| sequence_number | bigint |  |
| reference_code | varchar(32) unique | `TX-YYYY-######` |
| created_at | timestamp |  |

Indexes:
- unique `transaction_references_code_uq (reference_code)`
- unique `transaction_references_year_seq_uq (reference_year, sequence_number)`

### `financial_transactions`
| Field | Type | Notes |
| --- | --- | --- |
| id | uuid pk | Aggregate id |
| user_id | uuid fk users.id | Actor/owner |
| wallet_id | uuid fk wallets.id | Primary wallet |
| destination_wallet_id | uuid fk wallets.id null | Internal transfer only |
| transaction_reference_id | bigint fk transaction_references.id |  |
| client_generated_id | uuid null | Offline-created id |
| idempotency_key | varchar(128) unique | Replay-safe |
| type | varchar(30) | `deposit`, `withdraw`, `internal_transfer`, `exchange`, `user_transfer`, `debt_settlement` |
| currency | varchar(3) null | Used for single-currency flows. Allowed values: `USD`, `SYP` |
| source_currency | varchar(3) null | Exchange. Allowed values: `USD`, `SYP` |
| destination_currency | varchar(3) null | Exchange. Allowed values: `USD`, `SYP` |
| amount | numeric(18,2) null | Single amount |
| amount_given | numeric(18,2) null | Exchange source amount |
| exchange_rate | numeric(18,6) null | User-entered |
| amount_received | numeric(18,2) null | User-entered |
| note | text null |  |
| attachment_count | integer | Default 0 |
| created_at | timestamp | Immutable event time |
| created_by_device_id | uuid fk user_devices.id null |  |
| version | integer | For sync reconciliation only |

Indexes:
- unique `financial_transactions_idempotency_key_uq (idempotency_key)`
- index `financial_transactions_user_created_idx (user_id, created_at desc)`
- index `financial_transactions_wallet_created_idx (wallet_id, created_at desc)`
- index `financial_transactions_type_idx (type, created_at desc)`

### `ledger_entries`
| Field | Type | Notes |
| --- | --- | --- |
| id | uuid pk |  |
| financial_transaction_id | uuid fk financial_transactions.id |  |
| wallet_id | uuid fk wallets.id | Affected wallet |
| direction | varchar(10) | `credit`, `debit` |
| currency | varchar(3) | Allowed values: `USD`, `SYP` |
| amount | numeric(18,2) | Positive number |
| related_user_id | uuid fk users.id null | Used in user transfers |
| linked_transfer_id | uuid fk user_transfers.id null |  |
| linked_debt_settlement_id | uuid fk debt_settlements.id null |  |
| created_at | timestamp |  |

Indexes:
- index `ledger_entries_wallet_currency_idx (wallet_id, currency, created_at)`
- index `ledger_entries_transaction_idx (financial_transaction_id)`

### `user_transfers`
| Field | Type | Notes |
| --- | --- | --- |
| id | uuid pk |  |
| sender_user_id | uuid fk users.id |  |
| sender_wallet_id | uuid fk wallets.id |  |
| recipient_user_id | uuid fk users.id |  |
| recipient_wallet_id | uuid fk wallets.id null | Explicit destination or resolved from default_receiving_wallet_id |
| financial_transaction_id | uuid fk financial_transactions.id | Canonical money movement |
| reference_code | varchar(32) unique | Transfer-facing ref if separate |
| currency | varchar(3) | Allowed values: `USD`, `SYP` |
| amount | numeric(18,2) |  |
| note | text null |  |
| created_at | timestamp |  |

Indexes:
- index `user_transfers_sender_idx (sender_user_id, created_at desc)`
- index `user_transfers_recipient_idx (recipient_user_id, created_at desc)`

Transfer constraints:
- transfer currency must be the same on sender and recipient sides
- cross-currency user transfers are not allowed
- currency conversion must use exchange workflow only

### `contacts`
| Field | Type | Notes |
| --- | --- | --- |
| id | uuid pk |  |
| owner_user_id | uuid fk users.id | Contact owner |
| type | varchar(20) | `external`, `registered` |
| status | varchar(20) | `active`, `archived` |
| display_name | varchar(150) |  |
| phone_number | varchar(32) null |  |
| note | text null |  |
| linked_user_id | uuid fk users.id null | For registered or linked contacts |
| link_status | varchar(20) | `none`, `pending`, `linked`, `rejected` |
| created_at | timestamp |  |
| updated_at | timestamp |  |
| archived_at | timestamp null | Set when archived |
| version | integer |  |

Indexes:
- index `contacts_owner_type_idx (owner_user_id, type)`
- index `contacts_owner_name_idx (owner_user_id, display_name)`
- index `contacts_phone_idx (phone_number)`

Contact constraints:
- contacts must not support permanent deletion
- contacts may only be `active` or `archived`
- historical debts, settlements, transfers, and audit records must retain referential integrity after contact archival

### `contact_link_requests`
| Field | Type | Notes |
| --- | --- | --- |
| id | uuid pk |  |
| owner_user_id | uuid fk users.id | Contact owner |
| contact_id | uuid fk contacts.id | External contact |
| candidate_user_id | uuid fk users.id | Registered account candidate |
| owner_approved_at | timestamp null |  |
| candidate_approved_at | timestamp null |  |
| rejected_at | timestamp null |  |
| status | varchar(20) | `pending`, `approved`, `rejected`, `expired` |
| created_at | timestamp |  |
| updated_at | timestamp |  |

Indexes:
- index `contact_link_requests_contact_idx (contact_id, status)`
- index `contact_link_requests_candidate_idx (candidate_user_id, status)`

### `debts`
| Field | Type | Notes |
| --- | --- | --- |
| id | uuid pk |  |
| owner_user_id | uuid fk users.id | User who owns the record |
| contact_id | uuid fk contacts.id | Counterparty |
| direction | varchar(20) | `owed_by_contact`, `owed_to_contact` |
| currency | varchar(3) | Allowed values: `USD`, `SYP` |
| original_amount | numeric(18,2) |  |
| origin_financial_transaction_id | uuid fk financial_transactions.id null | Required for `owed_by_contact`, null for `owed_to_contact` |
| note | text null |  |
| status | varchar(20) | `open`, `completed` |
| created_at | timestamp |  |
| updated_at | timestamp |  |
| version | integer |  |

Indexes:
- index `debts_owner_direction_idx (owner_user_id, direction, status)`
- index `debts_contact_idx (contact_id, status)`

### `debt_settlements`
| Field | Type | Notes |
| --- | --- | --- |
| id | uuid pk |  |
| debt_id | uuid fk debts.id |  |
| financial_transaction_id | uuid fk financial_transactions.id | Linked financial write |
| wallet_id | uuid fk wallets.id | Source or destination wallet used in settlement |
| wallet_role | varchar(20) | `source`, `destination` |
| amount | numeric(18,2) |  |
| note | text null |  |
| created_at | timestamp | Immutable |
| created_by_device_id | uuid fk user_devices.id null |  |

Indexes:
- index `debt_settlements_debt_created_idx (debt_id, created_at)`
- index `debt_settlements_financial_tx_idx (financial_transaction_id)`

### `qr_identities`
| Field | Type | Notes |
| --- | --- | --- |
| id | uuid pk |  |
| user_id | uuid fk users.id unique |  |
| public_reference_code | varchar(32) unique | Public lookup |
| payload_version | integer |  |
| generated_at | timestamp |  |
| rotated_at | timestamp null | Future rotation support |

Indexes:
- unique `qr_identities_user_uq (user_id)`
- unique `qr_identities_public_ref_uq (public_reference_code)`

QR constraints:
- QR payload must contain only `public_reference_code`
- QR resolution must happen through backend APIs

### `attachments`
| Field | Type | Notes |
| --- | --- | --- |
| id | uuid pk |  |
| owner_user_id | uuid fk users.id |  |
| entity_type | varchar(30) | `transaction`, `debt`, `debt_settlement`, `contact` |
| entity_id | uuid | Parent entity id |
| original_file_name | varchar(255) |  |
| content_type | varchar(120) |  |
| file_size_bytes | bigint |  |
| storage_key | varchar(255) | Cloudinary public id or storage key |
| storage_provider | varchar(30) | `cloudinary` |
| checksum_sha256 | varchar(64) null |  |
| upload_status | varchar(20) | `local_only`, `pending`, `uploaded`, `failed` |
| created_at | timestamp |  |
| version | integer |  |

Indexes:
- index `attachments_owner_entity_idx (owner_user_id, entity_type, entity_id)`
- index `attachments_upload_status_idx (upload_status)`

Attachment constraints:
- attachment deletion requires backend ownership validation
- direct Cloudinary access must never bypass backend authorization
- physical Cloudinary deletion and metadata deletion must be performed together atomically where possible

### `notifications`
| Field | Type | Notes |
| --- | --- | --- |
| id | uuid pk |  |
| user_id | uuid fk users.id | Recipient |
| type | varchar(30) |  |
| title | varchar(160) |  |
| body | text |  |
| related_entity_type | varchar(30) null |  |
| related_entity_id | uuid null |  |
| payload_json | json | Extra rendering data |
| read_at | timestamp null |  |
| created_at | timestamp |  |

Indexes:
- index `notifications_user_created_idx (user_id, created_at desc)`
- index `notifications_user_read_idx (user_id, read_at)`

### `audit_events`
| Field | Type | Notes |
| --- | --- | --- |
| id | uuid pk |  |
| actor_user_id | uuid fk users.id null | System events may be null |
| event_type | varchar(40) |  |
| related_entity_type | varchar(30) |  |
| related_entity_id | uuid |  |
| device_identifier | varchar(128) null | Future-ready |
| sync_status | varchar(20) null | Snapshot at creation time |
| metadata_json | json |  |
| created_at | timestamp | Immutable |

Indexes:
- index `audit_events_entity_idx (related_entity_type, related_entity_id, created_at desc)`
- index `audit_events_actor_idx (actor_user_id, created_at desc)`
- index `audit_events_type_idx (event_type, created_at desc)`

### `sync_operations`
| Field | Type | Notes |
| --- | --- | --- |
| id | uuid pk |  |
| user_id | uuid fk users.id |  |
| device_identifier | varchar(128) |  |
| operation_type | varchar(40) |  |
| status | varchar(20) | `pending`, `synced`, `failed`, `conflict` |
| entity_type | varchar(30) |  |
| entity_id | uuid null | Local or server entity |
| client_generated_id | uuid null |  |
| idempotency_key | varchar(128) unique |  |
| base_version | integer null | Client version when queued |
| payload_json | json | Submitted command |
| server_response_json | json null | Last server response |
| error_code | varchar(60) null |  |
| error_message | text null |  |
| created_at | timestamp |  |
| updated_at | timestamp |  |
| synced_at | timestamp null |  |

Indexes:
- unique `sync_operations_idempotency_key_uq (idempotency_key)`
- index `sync_operations_user_status_idx (user_id, status, created_at)`
- index `sync_operations_type_status_idx (operation_type, status)`

### `conflict_records`
| Field | Type | Notes |
| --- | --- | --- |
| id | uuid pk |  |
| sync_operation_id | uuid fk sync_operations.id |  |
| entity_type | varchar(30) |  |
| entity_id | uuid null |  |
| resolution_strategy | varchar(30) | `server_wins`, `client_wins`, `manual_review`, `merge` |
| local_payload_json | json |  |
| remote_payload_json | json |  |
| summary | text |  |
| status | varchar(20) | `open`, `resolved`, `ignored` |
| resolved_at | timestamp null |  |
| created_at | timestamp |  |

Indexes:
- index `conflict_records_operation_idx (sync_operation_id)`
- index `conflict_records_status_idx (status, created_at desc)`

## Mermaid ERD
```mermaid
erDiagram
  users ||--o{ user_devices : has
  wallets o|--o{ users : default_receives_into
  users ||--o{ personal_access_tokens : has
  users ||--o{ wallets : owns
  users ||--o{ contacts : owns
  users ||--o{ debts : owns
  users ||--o{ notifications : receives
  users ||--o{ audit_events : acts
  users ||--o{ sync_operations : queues
  users ||--|| qr_identities : has

  wallets ||--o{ financial_transactions : primary_wallet
  wallets ||--o{ ledger_entries : affected_by
  wallets ||--o{ user_transfers : sender_wallet

  transaction_references ||--o{ financial_transactions : identifies
  financial_transactions ||--o{ ledger_entries : produces
  financial_transactions ||--o| user_transfers : may_back
  financial_transactions ||--o{ debt_settlements : may_back

  users ||--o{ user_transfers : sends
  users ||--o{ user_transfers : receives

  contacts ||--o{ debts : counterparty
  contacts ||--o{ contact_link_requests : links
  users ||--o{ contact_link_requests : candidate

  debts ||--o{ debt_settlements : has

  users ||--o{ attachments : owns
  sync_operations ||--o{ conflict_records : may_create
```

## Derived Read Models
The following should be computed from base tables rather than stored as authoritative balance fields:
- wallet USD balance
- wallet SYP balance
- total dashboard USD
- total dashboard SYP
- debt settlement total
- debt remaining amount
- unified transaction history

Suggested implementation:
- SQL views
- materialized views
- query-side service aggregation

The backend may cache these read models, but the source of truth remains immutable base records.

## Debt Integrity Rules
- `debts.direction = owed_by_contact` requires `origin_financial_transaction_id`.
- `debts.direction = owed_to_contact` must not have `origin_financial_transaction_id`.
- Every debt settlement must reference the financial transaction that created the ledger impact.
- Debt writes and linked financial writes must commit atomically.

## Additional Integrity Rules
- `users.default_receiving_wallet_id` must reference a wallet owned by the same user.
- If a wallet is archived and is currently referenced by `users.default_receiving_wallet_id`, the backend must either:
  - reject the archive request, or
  - require reassignment of `default_receiving_wallet_id` within the same transaction.
- Restoring a wallet does not automatically make it the default receiving wallet unless explicitly requested.
