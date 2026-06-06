# Sync Module

## Scope

This phase prepares the application for future backend ownership without removing any current mock behavior.

The mobile app is now explicitly structured as:

- offline cache
- local write executor
- sync queue client

No real API calls or sync execution are implemented in this phase.

## Sync Architecture

### Core queue models

- `SyncOperation`
  - local record representing a future backend write
- `SyncOperationType`
  - categorized write intent such as deposit, wallet rename, debt creation, or contact creation
- `SyncOperationStatus`
  - `pending`, `synced`, `failed`, `conflict`

### Queue repository

- `SyncQueueRepository`
  - adds operations
  - fetches operations
  - retries operations
  - marks synced
  - marks failed
  - marks conflict
  - clears completed operations
- `MockSyncQueueRepository`
  - persists queue state in `sync_queue_box`
  - remains fully local and backend-free

### Controller layer

- `SyncController`
  - developer-facing queue orchestration
  - exposes grouped queue state for the sync dashboard
- `SyncState`
  - keeps operations, conflict summaries, and grouped pending/failed/synced/conflict views

## Queue Architecture

### Lifecycle

1. A mock repository completes its local write successfully.
2. The repository appends a `SyncOperation` to the local sync queue.
3. The operation starts as `pending`.
4. Future sync execution will attempt remote submission.
5. The operation will later move to:
   - `synced`
   - `failed`
   - `conflict`

### Current queue-integrated writes

- wallet create
- wallet rename
- wallet archive
- deposit
- withdraw
- internal transfer
- exchange
- debt create
- debt repayment
- debt settlement record
- external contact create
- registered contact create
- user transfer create

## Repository Strategy

### Current behavior

Existing mock repositories remain functional and still execute local writes immediately.

### Prepared structure

Each feature is now ready for repository splitting:

- `WalletRepository`
  - `LocalWalletRepository`
  - `RemoteWalletRepository`
- `TransactionRepository`
  - `LocalTransactionRepository`
  - `RemoteTransactionRepository`
- `DebtRepository`
  - `LocalDebtRepository`
  - `RemoteDebtRepository`
- `ContactRepository`
  - `LocalContactRepository`
  - `RemoteContactRepository`
- `TransferRepository`
  - `LocalTransferRepository`
  - `RemoteTransferRepository`
- `QrRepository`
  - `LocalQrRepository`
  - `RemoteQrRepository`
- `AuthRepository`
  - `LocalAuthRepository`
  - `RemoteAuthRepository`

This keeps the current domain contracts stable while allowing future composition such as:

- local-first read
- optimistic local write
- queued remote sync
- conflict reconciliation

## Local vs Remote Design

### Local layer

The current mock repositories act as local repositories backed by Hive/local storage.

Responsibilities:

- immediate persistence
- offline reads
- local projection updates
- queue registration after successful local write

### Remote layer

Remote repositories are not implemented yet, but the interface seams now exist.

Responsibilities for future phases:

- map domain writes to API requests
- hydrate local cache from backend snapshots
- return server-issued identifiers and canonical state
- surface server conflicts and validation failures

## Network Layer Preparation

Added core abstractions:

- `ApiClient`
- `ConnectivityService`
- `NetworkStatusService`
- `RemoteDataSource`

Added feature remote data source interfaces for:

- auth
- wallets
- transactions
- debts
- contacts
- transfers
- QR identity

No HTTP client or connectivity plugin is implemented in this phase.

## Conflict Strategy

### Conflict models

- `ConflictRecord`
  - stores local payload, optional remote payload, and a recommended strategy
- `ConflictResolutionStrategy`
  - `clientWins`
  - `serverWins`
  - `manualReview`
  - `mergeLater`
- `ConflictSummary`
  - developer-friendly wrapper for queue inspection

### Planned conflict flow

1. Remote write fails due to version or business mismatch.
2. Queue operation moves to `conflict`.
3. A `ConflictRecord` is attached with local and remote snapshots.
4. Future UI or service logic will resolve the conflict and requeue or finalize the record.

No end-user conflict resolution UI is implemented yet.

## Sync Dashboard

Route:

- `/developer/sync`

Current capabilities:

- inspect pending operations
- inspect failed operations
- inspect conflicts
- inspect synced operations
- retry failed/conflict operations
- manually mark synced/failed/conflict for development
- clear synced operations

This page is intentionally developer-oriented and not part of end-user finance flows.

## Backend Integration Plan

### Planned next composition

1. Add concrete remote data sources using `ApiClient`
2. Implement remote repositories per feature
3. Introduce a real sync executor that consumes `SyncOperation`
4. Add network-aware retry policies
5. Add idempotency keys and server-issued conflict metadata
6. Reconcile local temporary ids with backend canonical ids

### Final source-of-truth model

Future backend becomes the single source of truth.

The app will keep:

- local cache for reads
- local projections for offline mode
- queued writes for later delivery
- conflict records for reconciliation
