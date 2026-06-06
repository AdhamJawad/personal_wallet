# Sync API Specification

## Scope
This specification defines the backend contract for offline-originated writes. The backend is the canonical source of truth. The client submits queued commands and reconciles the server response back into local cache and queue state.

## Supported Sync Statuses
- `pending`
- `synced`
- `failed`
- `conflict`

## Supported Operation Types
- `wallet_create`
- `wallet_rename`
- `wallet_archive`
- `wallet_restore`
- `deposit_create`
- `withdraw_create`
- `internal_transfer_create`
- `exchange_create`
- `debt_create`
- `debt_repayment_create`
- `debt_settlement_create`
- `external_contact_create`
- `registered_contact_create`
- `user_transfer_create`
- `attachment_create`

## Sync Payload Rules
Each operation must carry:
- `operation_id`
- `operation_type`
- `entity_type`
- `entity_id`
- `client_generated_id`
- `idempotency_key`
- `base_version`
- `device_identifier`
- `occurred_at`
- `payload`

Example operation:
```json
{
  "operation_id": "uuid",
  "operation_type": "wallet_create",
  "entity_type": "wallet",
  "entity_id": "uuid",
  "client_generated_id": "uuid",
  "idempotency_key": "op_wallet_create_01",
  "base_version": null,
  "device_identifier": "device_123",
  "occurred_at": "2026-06-06T12:00:00Z",
  "payload": {
    "name": "Travel Wallet"
  }
}
```

## Endpoints

### `POST /api/v1/sync/batch`
Uploads a batch of operations in client order.

Request:
```json
{
  "device_identifier": "device_123",
  "operations": [
    {
      "operation_id": "uuid",
      "operation_type": "wallet_create",
      "entity_type": "wallet",
      "entity_id": "uuid",
      "client_generated_id": "uuid",
      "idempotency_key": "op_wallet_create_01",
      "base_version": null,
      "occurred_at": "2026-06-06T12:00:00Z",
      "payload": {
        "name": "Travel Wallet"
      }
    }
  ]
}
```

Response `200`:
```json
{
  "data": {
    "results": [
      {
        "operation_id": "uuid",
        "status": "synced",
        "entity_type": "wallet",
        "entity_id": "server-uuid",
        "client_generated_id": "uuid",
        "server_version": 1,
        "server_payload": {
          "id": "server-uuid",
          "name": "Travel Wallet",
          "status": "active"
        },
        "conflict": null,
        "error": null
      }
    ]
  }
}
```

### `GET /api/v1/sync/operations/{operation_id}`
Returns last known backend processing state for one operation.

### `GET /api/v1/sync/operations`
Query params:
- `status`
- `operation_type`
- `from`
- `to`

### `POST /api/v1/sync/conflicts/{conflict_id}/resolve`
Submits a conflict decision.

Request:
```json
{
  "resolution_strategy": "server_wins",
  "merged_payload": null
}
```

Response `200`:
```json
{
  "data": {
    "conflict_id": "uuid",
    "status": "resolved",
    "resulting_operation_status": "synced"
  }
}
```

### `POST /api/v1/sync/operations/{operation_id}/retry`
Optional endpoint if the backend tracks retryable failed operations separately.

## Operation Result Contract

### `synced`
Returned when:
- validation passed
- authorization passed
- operation applied successfully
- canonical entity persisted

Required fields:
- `server_version`
- `server_payload`

### `failed`
Returned when:
- validation failed
- business rules failed
- prerequisite entity missing
- operation cannot be retried without payload change

Required fields:
- `error.code`
- `error.message`

### `conflict`
Returned when:
- base version is stale
- remote state diverged from client assumption
- operation would overwrite a newer server state

Required fields:
- `conflict.conflict_id`
- `conflict.entity_type`
- `conflict.entity_id`
- `conflict.local_payload`
- `conflict.remote_payload`
- `conflict.recommended_strategy`
- `conflict.summary`

## Conflict Payload
```json
{
  "conflict_id": "uuid",
  "entity_type": "wallet",
  "entity_id": "uuid",
  "local_payload": {
    "name": "Business Wallet"
  },
  "remote_payload": {
    "id": "uuid",
    "name": "Corporate Wallet",
    "version": 5
  },
  "recommended_strategy": "manual_review",
  "summary": "Wallet name was updated on another device."
}
```

## Conflict Resolution Flow
1. Client uploads queued operation.
2. Backend detects stale `base_version` or incompatible state.
3. Backend stores a `conflict_record`.
4. Backend returns `status=conflict`.
5. Client marks queue item as `conflict`.
6. User or support chooses a resolution strategy later.
7. Client submits decision through resolve endpoint.
8. Backend either:
   - reapplies with merged payload
   - accepts server version
   - rejects client change permanently

## Retry Strategy

### Client Responsibilities
- Retry `failed` operations only when error code is retryable.
- Retry `pending` operations automatically when network is restored.
- Never retry `conflict` operations automatically.
- Preserve original `idempotency_key` across retries.

### Backend Responsibilities
- Treat same `idempotency_key` as the same command.
- Return the previously applied result if the command already succeeded.
- Distinguish between:
  - transient failure
  - terminal validation failure
  - conflict

Suggested retryable error codes:
- `network_timeout`
- `temporary_unavailable`
- `rate_limited`
- `dependency_unavailable`

Suggested non-retryable error codes:
- `validation_failed`
- `forbidden`
- `entity_not_found`
- `unsupported_currency`
- `recipient_default_wallet_missing`
- `recipient_wallet_invalid`

## Versioning Strategy
- Mutable entities such as wallets and contacts should carry integer `version`.
- Immutable entities such as financial transactions and debt repayments do not require update versions for state mutation, but sync responses should still provide canonical metadata.
- Sync write endpoints should reject stale `base_version` with `409`.
- Wallet restore and archive operations must reconcile both wallet `version` and any change to `default_receiving_wallet_id` when the backend couples those writes.

## Server-Side Ordering Rules
- Operations within a batch should be processed in the submitted order.
- Dependencies must be honored:
  - wallet create before wallet rename
  - wallet restore before assigning it as `default_receiving_wallet_id`
  - contact create before debt create against that contact
  - transfer create before debt settlement link finalization if modeled separately
- Backend may short-circuit later operations in the same batch if an earlier prerequisite fails.

## Reconciliation Rules
The backend response must give the client enough data to:
- replace temporary ids with canonical server ids
- update versions
- mark queue records as synced
- persist any conflict metadata
- refresh derived read models

## Security For Sync Endpoints
- Require valid access token.
- Require `X-Device-Id`.
- Enforce rate limits per user and device.
- Reject operations for entities not owned by the user.
- Audit every accepted sync batch and every conflict resolution.
