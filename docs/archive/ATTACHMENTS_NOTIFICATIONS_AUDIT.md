# Attachments, Notifications, and Audit

## Scope

This phase adds three independent subsystems:

- attachments
- notifications
- audit trail

They integrate with existing repositories and sync readiness without becoming part of wallet, debt, transfer, or transaction business logic.

## Attachment Architecture

### Core models

- `Attachment`
  - immutable local metadata record for a file reference
- `AttachmentReference`
  - points to the related entity
  - supported types:
    - transaction
    - debt
    - debt settlement
    - contact
- `AttachmentDraft`
  - temporary creation payload used by the picker flow

### Repository structure

- `AttachmentRepository`
- `LocalAttachmentRepository`
- `RemoteAttachmentRepository`
- `MockAttachmentRepository`

Current local behavior:

- stores attachment metadata in `attachments_box`
- supports multiple attachments per creation request
- queues `attachmentCreate` sync operations
- writes audit events through `AuditLogger`

### UI flow

- `AttachmentViewerPage`
  - lists attachment metadata for a reference
- `AttachmentPickerPage`
  - developer-oriented local metadata entry flow
  - supports multiple files in one submit

No real file picker or upload implementation exists yet.

## Notification Architecture

### Core models

- `NotificationItem`
- `NotificationType`

Supported notification types:

- transfer received
- transfer sent
- debt created
- debt repaid
- debt settled
- wallet created
- sync failure
- sync success

### Repository and service

- `NotificationRepository`
- `LocalNotificationRepository`
- `RemoteNotificationRepository`
- `MockNotificationRepository`
- `NotificationPublisher`

`NotificationPublisher` is the centralized integration seam. Repositories and sync infrastructure publish notifications through it instead of creating notification records directly in UI code.

### Current producers

- wallet repository
  - wallet created
- transfer repository
  - transfer sent
  - transfer received
- debt repository
  - debt created
  - debt repaid
  - debt settled
- sync controller
  - sync failure
  - sync success

### UI

- `NotificationCenterPage`
  - filter by notification type
  - mark as read
  - clear read notifications

## Audit Architecture

### Core models

- `AuditEvent`
- `AuditEventType`

Current event types include:

- transaction created
- debt created
- debt repaid
- debt settled
- transfer executed
- wallet created
- wallet renamed
- wallet archived
- contact created
- attachment created

### Repository and service

- `AuditRepository`
- `LocalAuditRepository`
- `RemoteAuditRepository`
- `MockAuditRepository`
- `AuditLogger`

`AuditLogger` is the repository-facing write seam. Existing repositories log immutable audit events after successful local writes.

### Captured fields

Each audit event stores:

- event id
- event type
- timestamp
- related entity id
- related entity type
- device identifier placeholder
- sync status snapshot
- metadata map

Audit events are immutable. If sync status changes later, future phases should create new audit events rather than mutating history.

### UI

- `AuditHistoryPage`
  - developer-oriented event history view

## Sync Integration Strategy

### Attachments

Attachment creation is sync-aware immediately:

1. local attachment metadata is stored
2. a sync operation with type `attachmentCreate` is queued
3. an audit event is written

### Notifications

Notifications are not queued for backend sync in this phase. They act as a local user-facing event stream. Future backend integration can decide whether notifications are:

- local-only device events
- server-originated inbox items
- or a hybrid model

### Audit

Audit events are currently local immutable records. They are not uploaded yet, but the repository split is prepared for future remote replication or server-issued audit records.

## Future Backend Upload Strategy

### Attachments

Future upload path should separate:

1. local metadata record
2. upload request descriptor
3. remote file reference
4. final attachment confirmation

Recommended future additions:

- upload session id
- local file hash
- remote blob id
- upload progress tracking
- retry policy for failed uploads

### Notifications

Potential backend models:

- server-originated notification feed
- local device notifications generated from synced events
- push-token aware delivery for cross-device alerts

### Audit

Potential backend models:

- append-only server audit stream
- device-side audit replication
- server-enriched compliance events

## Integration Notes

The current architecture keeps these subsystems independent:

- attachments never alter business balances
- notifications never own business logic
- audit events never mutate domain state

They attach to existing repositories only through small service seams and remain compatible with the local/remote repository split introduced in the sync phase.
