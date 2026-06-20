# Project Master Specification

## 1. Document Purpose
This document is the definitive master specification for the Personal Wallet project. It is intended to serve as the official reference for:
- backend engineers
- Flutter engineers
- architects
- QA engineers
- future maintainers
- AI coding agents working on the repository

The goal of this specification is to make the project understandable without requiring the reader to inspect the Flutter codebase. It consolidates the current application design, business rules, architectural constraints, integration model, data model expectations, API boundaries, and future roadmap into one authoritative narrative.

This document does not replace the detailed supporting documents already present in the repository. Instead, it acts as the top-level reference and points to those more detailed specifications where relevant:
- [ARCHITECTURE.md](/c:/Users/TOSHIBA/Desktop/wallet/docs/ARCHITECTURE.md)
- [AUTH_MODULE.md](/c:/Users/TOSHIBA/Desktop/wallet/docs/AUTH_MODULE.md)
- [WALLET_MODULE.md](/c:/Users/TOSHIBA/Desktop/wallet/docs/WALLET_MODULE.md)
- [TRANSACTIONS_MODULE.md](/c:/Users/TOSHIBA/Desktop/wallet/docs/TRANSACTIONS_MODULE.md)
- [DEBTS_MODULE.md](/c:/Users/TOSHIBA/Desktop/wallet/docs/DEBTS_MODULE.md)
- [TRANSFERS_MODULE.md](/c:/Users/TOSHIBA/Desktop/wallet/docs/TRANSFERS_MODULE.md)
- [SYNC_MODULE.md](/c:/Users/TOSHIBA/Desktop/wallet/docs/SYNC_MODULE.md)
- [ATTACHMENTS_NOTIFICATIONS_AUDIT.md](/c:/Users/TOSHIBA/Desktop/wallet/docs/ATTACHMENTS_NOTIFICATIONS_AUDIT.md)
- [BACKEND_CONTRACT.md](/c:/Users/TOSHIBA/Desktop/wallet/docs/BACKEND_CONTRACT.md)
- [ERD.md](/c:/Users/TOSHIBA/Desktop/wallet/docs/ERD.md)
- [API_SPECIFICATION.md](/c:/Users/TOSHIBA/Desktop/wallet/docs/API_SPECIFICATION.md)
- [SYNC_API_SPECIFICATION.md](/c:/Users/TOSHIBA/Desktop/wallet/docs/SYNC_API_SPECIFICATION.md)
- [SECURITY_SPECIFICATION.md](/c:/Users/TOSHIBA/Desktop/wallet/docs/SECURITY_SPECIFICATION.md)

## 2. Project Overview

### 2.1 Project Name
Personal Wallet

### 2.2 Vision
Personal Wallet is an offline-first personal finance system designed for a small trusted group of users. Its purpose is to help users manage multiple wallets, track financial activity through an immutable ledger, record debts independently from wallet balances, transfer money between trusted registered users, and preserve a verifiable history of actions and records.

The project is intentionally designed to start mobile-first with strong local capability and later evolve into a backend-driven distributed system where the Laravel backend becomes the canonical source of truth.

### 2.3 Goals
The project goals are:
- provide a reliable multi-wallet finance application for personal and small-group use
- track wallet activity through immutable accounting records
- support debt management independently from cash or wallet balances
- support contact management across both registered users and external contacts
- support trusted user-to-user transfers
- support QR-based identity discovery and transfer initiation
- preserve auditability and historical integrity
- support offline work from the beginning
- prepare every write flow for future synchronization with a backend
- make the application maintainable through clean architecture and explicit domain boundaries

### 2.4 Intended Users
The intended audience is a small, trusted user group, approximately 50 users. The system is not designed for open public banking-scale onboarding. It assumes controlled usage, but it must still be engineered with production-grade data integrity, security, auditability, and synchronization behavior.

Typical users include:
- an individual managing personal wallets
- a small business owner separating business and personal funds
- a trusted group that lends, borrows, and settles debts among members
- users who need offline-first finance tracking in environments with inconsistent connectivity

### 2.5 Supported Platforms
Current platform target:
- Flutter mobile application
  - Android
  - iOS

Future platform possibilities:
- web
- desktop
- admin/support dashboard

### 2.6 What The Application Is
Personal Wallet is:
- a personal finance management system
- a multi-wallet system
- an immutable ledger-driven accounting application
- a debt tracking system
- a user-to-user transfer system for trusted registered users
- a contact management system
- a QR-based identity and transfer initiation system
- an offline-first application with sync queue preparation

### 2.7 What The Application Is Not
Personal Wallet is not:
- a bank
- a payment gateway
- a card processor
- a Visa integration
- a MasterCard integration
- a direct banking integration
- a cryptocurrency wallet or exchange
- a public open-market payment network

This distinction is critical. The system tracks value, obligations, and transfers within its own application domain. It does not connect to external financial rails by default.

### 2.8 High-Level Architecture
At a high level, the project consists of:
- a Flutter client using clean architecture and feature-based modularity
- a local persistence layer that enables offline-first behavior
- a repository abstraction model that separates local and future remote data sources
- a sync queue that prepares user operations for eventual backend upload
- backend contract documentation specifying how a future server becomes the canonical authority

The application should be understood as three layers of responsibility:

1. Local product experience
   - immediate UI response
   - local persistence
   - offline access

2. Domain integrity
   - immutable ledger
   - debt separation
   - audit history
   - explicit ownership and state transitions

3. Future distributed consistency
   - sync queue
   - idempotent operations
   - conflict detection
   - server-side canonical state

### 2.9 Approved Production Stack
- Flutter
- Laravel 12 API
- MySQL
- Cloudinary for attachment files
- WhatsApp API for OTP delivery
- FCM for push notifications only

### 2.10 Authority Boundary
- Laravel backend is the single source of truth.
- No business logic may live inside Flutter.
- Flutter may cache, queue, and render data locally, but it must not become the authoritative owner of business rules.

## 3. Core Business Concepts

### 3.1 Users
A user is a registered account holder in the system. User identity is based on phone number plus WhatsApp OTP verification, followed by Laravel Sanctum token issuance for authenticated API access.

Authentication and application unlock are separate concerns:
- authentication uses phone number plus WhatsApp OTP
- application unlock may use PIN
- application unlock may use fingerprint
- application unlock may use Face ID

PIN, fingerprint, and Face ID are local application-lock mechanisms only. They must never replace OTP-based identity verification, especially on new device login.

A user owns:
- wallets
- contacts
- debts
- attachments
- notifications
- audit events
- sync operations

A user may also:
- send transfers
- receive transfers
- expose a QR identity
- define a default receiving wallet for inbound transfers

The user account is the primary ownership boundary in the system.

Successful registration must also:
- create one active wallet named `Main Wallet`
- assign that wallet as `default_receiving_wallet_id`
- commit user creation and initial wallet creation atomically
- ensure no user account exists without at least one wallet

### 3.2 Wallets
A wallet is a logical container for financial activity. Users can create unlimited wallets to separate different purposes:
- Main Wallet
- Travel Wallet
- Business Wallet
- Savings Wallet

Wallets are intentionally lightweight metadata entities. They do not store authoritative balances. Instead, they provide:
- name
- status
- ownership
- timestamps
- optional role in receiving transfers

Balances shown on wallet screens are derived projections from immutable ledger entries.

### 3.3 Ledger
The ledger is the most important financial concept in the application. It is the authoritative accounting trail for wallet-affecting money movement. Every wallet balance in the UI must be computed from ledger entries. No wallet balance field may become the primary source of truth.

The ledger exists to guarantee:
- historical integrity
- traceable financial state
- deterministic balance recomputation
- compatibility with corrections via reversal transactions later

### 3.4 Transactions
Transactions are the business events that create financial impact in wallets. Supported transaction families are:
- deposit
- withdraw
- internal wallet transfer
- currency exchange
- user transfer

Transactions are immutable. Users must never edit or delete them. If correction is required in the future, the system must create a new correcting or reversing record rather than mutate an existing transaction.

### 3.5 Debts
Debts track obligations between a user and a counterparty. Debts are not wallet balances and must never be treated as wallet money. A debt captures:
- who owes whom
- in which currency
- the original amount
- settlements
- remaining obligation

Debts are accounting-adjacent, but they are not ledger balances.

### 3.6 Contacts
Contacts represent people or entities the user interacts with. The system supports:
- registered contacts
- external contacts

Registered contacts map to existing user accounts.

External contacts do not have an account in the system. They may represent:
- a friend who has not registered yet
- a shop owner
- a customer
- a supplier

The architecture is prepared for future linking between external contacts and future registered accounts through dual approval.

### 3.7 Transfers
Transfers represent money movement between registered users.

A standard transfer moves wallet value but does not affect debt balances.

Debt settlement is a separate debt-domain workflow. It may create linked wallet-affecting ledger records, but it is not modeled as a standard transfer subtype in the final backend architecture.

This distinction is one of the most important rules in the application.

### 3.8 QR Identities
Each registered user has a personal QR identity used for:
- user discovery
- contact addition
- transfer initiation

The QR payload is intentionally limited to one public-safe identifier:
- public reference code

It must never expose secrets or sensitive account information.

### 3.9 Attachments
Attachments are supporting records associated with other entities. They are independent and reference-based rather than embedded. Supported attachment parents are:
- transactions
- debts
- debt settlements
- contacts

Examples include:
- receipt images
- proof of payment
- supporting documents
- contact-related notes or files

### 3.10 Notifications
Notifications provide user-facing event awareness. They are generated from business actions but remain an independent subsystem. They support:
- unread/read state
- filtering
- cleanup of read items

Notifications are not the source of truth for any domain state. They are only a user-facing communication layer.

### 3.11 Audit Trail
Audit events are immutable records of significant business actions. They exist for:
- traceability
- debugging
- support operations
- security review
- future compliance needs

Audit events capture what happened, when it happened, who triggered it, and which entity was affected.

### 3.12 Offline Sync
Offline sync is the infrastructure that allows the app to function locally while preparing future writes for a backend. The app must remain usable offline, but once backend integration exists, the Laravel backend becomes the canonical source of truth.

Offline sync relies on:
- local-first persistence
- queued write operations
- operation statuses
- idempotency
- conflict tracking
- version reconciliation

## 4. Architecture Decisions

### 4.1 Feature-Based Architecture
The project is organized by features rather than by technical layer alone. Each feature owns its:
- domain models
- repository contracts
- mock or local repository implementations
- controllers
- providers
- presentation flow

This structure keeps related concerns close together and prevents uncontrolled cross-feature coupling.

Core features include:
- auth
- wallets
- transactions
- debts
- contacts
- transfers
- QR
- sync
- attachments
- notifications
- audit

### 4.2 Clean Architecture
The codebase follows a clean architecture style:
- presentation
- domain
- data

Responsibilities are separated as follows:

Presentation:
- screens
- widgets
- controllers
- route flow
- user interaction

Domain:
- business models
- repository interfaces
- business services
- domain rules

Data:
- repository implementations
- local persistence integration
- future remote data sources
- mapping between stored format and domain models

This structure ensures that business rules remain independent from UI and infrastructure.

### 4.3 Riverpod State Management
Riverpod is the state management and dependency injection mechanism. It is used for:
- controller lifecycle
- repository injection
- service injection
- reactive state propagation

The project avoids ad hoc local state for domain operations. Business state should flow through controllers and providers, not through uncontrolled widget-local mutation.

### 4.4 GoRouter Navigation
Navigation is structured through GoRouter. Routing is explicit and feature-aware. This supports:
- maintainable route definitions
- deep-link readiness
- route guards for authentication
- separation between auth flow and application flow

### 4.5 Offline-First Design
Offline-first is a fundamental design principle, not an afterthought. The application must remain useful in unreliable network conditions. This means:
- local persistence exists for primary user interaction
- repositories can write locally first
- future remote synchronization is planned from the beginning
- sync queue and conflict models are part of architecture, not add-ons

### 4.6 Local-First Repositories
Repositories are currently functional without a backend because local or mock implementations exist. This is intentional. Every repository is designed so the app can:
- read local state
- create local records
- update allowed metadata locally
- queue operations for later sync

This allows the product to behave as if a backend exists even before remote integration is implemented.

### 4.7 Remote Repository Preparation
The architecture already prepares for future:
- remote repositories
- remote data sources
- API client abstractions
- connectivity-aware sync execution

The domain layer should not need redesign when a real backend is introduced. Instead, local and remote implementations can be wired behind the same contracts.

### 4.8 Sync Queue Architecture
The sync queue is a central architectural decision. Every future write operation is expected to be expressible as a sync operation with:
- operation type
- operation status
- payload
- idempotency key
- entity reference
- device context
- version context

This ensures that offline-created operations can later be replayed safely against a backend.

### 4.9 Independent Supporting Subsystems
Attachments, notifications, and audit are intentionally modeled as independent subsystems. They integrate with other modules through references and services rather than direct tight coupling.

This reduces risk in three ways:
- core finance logic stays isolated
- future backend services can evolve independently
- testing and maintenance remain simpler

### 4.10 Mock-First But Production-Oriented
Even though there is no backend yet, the architecture avoids throwaway prototypes. Mock implementations behave like future production components:
- auth behaves like session-based authentication
- repositories return domain models that resemble real payloads
- sync queue behaves like future upload preparation
- reference numbers and immutable records are already modeled

## 5. Wallet Rules

Wallet rules are strict because wallets are central user-facing entities but should remain conceptually simple.

### 5.1 Unlimited Wallets
A user can create unlimited wallets. There is no product-level restriction on count unless future business or operational policy introduces one.

### 5.2 Supported Currencies
The system supports only:
- USD
- SYP

No other currencies are supported.

Each wallet may hold balances in both supported currencies at the same time because balance is derived by currency from ledger entries.

### 5.3 Wallets Are Metadata, Not Balances
A wallet stores metadata only. It does not hold authoritative balance fields. Any displayed balance is derived from ledger activity.

This means:
- no `balance_usd` field
- no `balance_syp` field
- no stored wallet balance columns

### 5.4 Wallet Lifecycle
Wallet lifecycle currently supports:
- create
- view
- rename
- archive
- restore

Permanent deletion is not allowed.

### 5.5 Archive Instead Of Delete
Archived wallets remain in history and remain valid for past financial records. This preserves historical integrity. If a wallet participated in transactions, those transactions must remain understandable forever.

### 5.6 Restore Behavior
An archived wallet can later be restored to active status. Restore is a controlled state transition, not a recreation of a deleted wallet.

### 5.7 Default Receiving Wallet
Because users may own many wallets, inbound user-to-user transfers require a receiving wallet strategy.

Rules:
- a transfer may explicitly specify `recipient_wallet_id`
- if it does, the backend must validate ownership and use that wallet
- if it does not, the backend must resolve the recipient account `default_receiving_wallet_id`
- if no valid receiving wallet can be resolved, the transfer must fail

### 5.8 Default Wallet Integrity
If a wallet is assigned as the default receiving wallet:
- it must belong to the same user
- it should generally be active
- archiving it must either be blocked or require reassignment in the same backend operation

### 5.9 Wallet Ownership
Wallets belong to one user only. There is no shared wallet concept in the current system.

## 6. Ledger Rules

This is a critical section.

### 6.1 Ledger Is The Single Source Of Truth
The ledger is the single source of truth for wallet balances. This rule is non-negotiable. Wallet balances must always be derived from ledger entries.

A team member must never introduce logic that treats a wallet balance field as canonical. Even if caching, denormalization, or summary tables are added later for performance, the immutable ledger remains the authoritative source.

### 6.2 Ledger Entry Characteristics
Ledger entries must be:
- immutable
- append-only
- traceable to a financial transaction
- attributable to a wallet
- attributable to a currency
- expressed as credit or debit effects

### 6.3 Supported Financial Transaction Types
The financial model currently supports:
- deposit
- withdraw
- internal transfer
- exchange
- user transfer

Each transaction type creates deterministic ledger effects.

### 6.4 Deposit
A deposit adds value to a wallet in a single currency.

Example:
- +100 USD into Main Wallet

Expected effect:
- credit Main Wallet USD by 100

### 6.5 Withdraw
A withdraw removes value from a wallet in a single currency.

Example:
- -150000 SYP from Business Wallet

Expected effect:
- debit Business Wallet SYP by 150000

### 6.6 Internal Transfer
An internal transfer moves value between two wallets owned by the same user.

Example:
- move 50 USD from Main Wallet to Travel Wallet

Expected effect:
- debit Main Wallet USD by 50
- credit Travel Wallet USD by 50

This is one business action but affects two wallet balance projections.

### 6.7 Currency Exchange
A currency exchange changes value within a single wallet between two currencies.

Example:
- give 100 USD
- exchange rate 9500
- receive 950000 SYP

Expected effect:
- debit wallet USD by 100
- credit wallet SYP by 950000

The application must not compute `amount_received` automatically as the sole truth. The user enters:
- amount given
- exchange rate
- amount received

This supports real-world differences, negotiated rates, rounding, and non-ideal market exchange outcomes.

### 6.8 User Transfer
A user transfer moves value from one user wallet to another user wallet.

Expected effect:
- debit sender wallet
- credit recipient wallet
- sender and recipient use the same currency

Cross-currency user-to-user transfer is not allowed.
Currency conversion must use the exchange workflow only.

If it is a standard transfer, the effect ends there.

Debt settlement is not a standard user transfer requirement. It is a debt-domain workflow with its own linked financial write and ledger effect.

### 6.9 Transaction References
Financial transactions must have generated reference numbers in a canonical format such as:
- `TX-2026-000001`

References should be server-generated once backend integration exists.

### 6.10 Immutability
Transactions and their resulting ledger entries must never be edited or deleted by users. Historical financial integrity depends on this.

### 6.11 Future Reversals
Corrections should eventually be implemented as reversal or adjustment transactions. A reversal is a new record, not a mutation of an old one.

## 7. Debt Rules

This is a critical section.

### 7.1 Debt Balances Are Separate From Wallet Balances
Debt state is a separate subsystem from wallet accounting. The existence of a debt does not mean money moved. The existence of a wallet transfer does not mean a debt changed.

This must remain true across:
- UI
- database model
- APIs
- sync semantics
- backend logic

### 7.2 Debt Creation
Debt creation behavior depends on direction.

If direction is `owed_by_contact`:
- the user is lending money
- a source wallet must be selected
- debt creation and wallet withdrawal must commit atomically

Example:
- Wallet USD = 500
- user lends 100 USD

Expected result:
- wallet USD = 400
- debt remaining = 100

If direction is `owed_to_contact`:
- the user owes someone money
- debt is recorded without creating an automatic wallet transaction

### 7.3 Debt Settlement
Debt settlement is the explicit action that reduces a debt and creates the corresponding financial impact when required.

For `owed_by_contact`:
- the user is receiving money back
- a destination wallet must be selected
- remaining debt must decrease
- a ledger-backed deposit must be created
- all related writes must commit atomically

For `owed_to_contact`:
- the user is paying money
- a source wallet must be selected
- remaining debt must decrease
- a ledger-backed withdrawal must be created
- all related writes must commit atomically

### 7.5 Partial Settlement
Debt settlements may be partial.

Example:
- debt is 70 USD
- settlement is 50 USD
- remaining debt becomes 20 USD

### 7.6 Full Settlement
When total settlements equal the original amount, the debt becomes completed.

### 7.7 Debt Completion
Debt completion is a derived state. It should be based on the relationship between:
- original amount
- settlements
- remaining amount

### 7.8 Debt Timeline
Debt details should expose a timeline including:
- debt created
- settlement events

This timeline helps the user understand how the remaining amount was reached.

### 7.9 Debt Ownership
Each debt belongs to one owner and one contact counterparty. The direction of the debt determines whether it is:
- `owed_by_contact`
- `owed_to_contact`

### 7.10 No Hidden Coupling
Debt and Wallet remain separate domains, but approved debt flows may create linked ledger-backed financial records.

### 7.11 Atomicity Rule
Debt updates and ledger updates must never become inconsistent. All related writes must commit atomically.

### 7.12 Financial Source Of Truth
Ledger remains the financial source of truth. Debt records never become an alternate source of wallet-balance truth.

The system must never silently infer:
- "transfer to same person means debt settlement"
- "debt settlement means transfer"
- "settlement means debt is closed"

Every debt-affecting action must be explicit.

## 8. Transfer Rules

### 8.1 Standard Transfer Versus Debt Settlement
This distinction must remain explicit throughout the product.

Standard transfer:
- moves wallet value
- does not change debt

Debt settlement:
- moves wallet value
- reduces debt
- creates a linked financial transaction, ledger entries, and settlement record

### 8.2 Standard Transfer Example
Ali owes Adham 70 USD.

Ali sends Adham 50 USD as a gift.

Result:
- wallet balances change
- debt remains 70 USD

### 8.3 Debt Settlement Example
Ali owes Adham 70 USD.

Ali settles 50 USD against the debt.

Result:
- wallet balances change
- debt remaining becomes 20 USD
- linked settlement record is created

### 8.4 Registered Users Only
Current user-to-user transfers are defined for registered users. External contacts cannot fully participate in transfer flows until they are linked or otherwise supported by future business rules.

### 8.5 Receiving Wallet Resolution
Transfers must resolve a destination wallet as follows:
- if `recipient_wallet_id` is provided, use it after ownership validation
- otherwise use recipient `default_receiving_wallet_id`
- reject the transfer if no valid destination wallet exists

### 8.6 Transfer Immutability
Transfers are immutable business records. They should be traceable through both:
- transfer-facing records
- underlying financial transaction and ledger entries

### 8.7 Transfer History
The system should support viewing transfer history by:
- sent
- received
- date
- currency
- participant

## 9. Contact Rules

### 9.1 Contact Types
The system supports two primary contact types:
- registered user
- external contact

### 9.2 Registered Contacts
Registered contacts correspond to existing user accounts. They can participate directly in:
- user-to-user transfers
- QR flows
- preview-based actions

### 9.3 External Contacts
External contacts are locally created identities not yet tied to a registered account. They support:
- debt creation
- contact organization
- future link preparation

### 9.4 Future Linking
If an external contact later registers, the architecture must support linking the external record to that registered user.

This is important because historical data should stay meaningful. A user may have months of debt or contact history under a local external contact before the real person registers.

### 9.5 Dual Approval Requirement
Linking must require approval from both parties:
- the contact owner
- the candidate registered user

This prevents silent or abusive identity merging.

### 9.6 Historical Integrity
Linking should preserve history. Old debts, attachments, and references should remain understandable even after the contact gains a linked user identity.

### 9.7 Ownership
Contacts belong to the owning user. There is no global shared address book in the current model.

### 9.8 Contact Lifecycle
Contacts must not support permanent deletion.

Contacts may only be:
- active
- archived

Historical debts, settlements, transfers, and audit records must never lose referential integrity because a contact was removed.

## 10. QR Rules

### 10.1 Personal QR Identity
Each registered user has a personal QR identity. It exists to make discovery and interaction easier in trusted settings.

### 10.2 QR Payload Content
Allowed content:
- public reference code

Not allowed:
- phone number
- tokens
- secrets
- internal device data
- authentication credential information

### 10.3 QR Use Cases
Supported uses:
- show my QR
- scan QR
- preview user
- add contact
- start transfer

### 10.4 QR Scan Flow
The expected flow is:
1. user scans QR
2. app sends the QR payload to backend resolution APIs
3. app presents limited user preview
4. user chooses an action
   - add contact
   - start transfer

### 10.5 Security Considerations
QR identities are public-facing enough to be shared, so they must only contain safe identifiers. Future backend implementations should consider:
- signed QR payloads
- payload versioning
- rotation support
- server-side resolution

QR resolution must happen through backend APIs.

## 11. Attachment Rules

### 11.1 Supported Attachment Types
Supported attachments may include:
- images
- receipts
- proof of payment
- supporting documents

### 11.2 Supported Parent Entities
Attachments may belong to:
- transactions
- debts
- debt settlements
- contacts

### 11.3 Multiple Attachments
An entity may have multiple attachments.

### 11.4 Attachment Ownership
Attachments belong to the owning user and reference a parent entity. They are not embedded inside business entities as raw file payloads.

### 11.5 Attachment Metadata
Attachment metadata should include at least:
- id
- owner
- parent entity type
- parent entity id
- original file name
- content type
- size
- storage key
- checksum
- upload status

### 11.6 Local-Only Today, Remote Tomorrow
Current app behavior is local-first. Future backend implementation should support:
- upload initiation
- metadata persistence
- authorized download
- backend-authorized deletion by the owner
- coordinated Cloudinary file deletion and metadata deletion where possible

### 11.7 Sync Queue Readiness
Attachment creation must be representable as a sync operation because file-related records are part of future remote consistency.

## 12. Notification Rules

### 12.1 Notification Types
Current supported event families include:
- transfer received
- transfer sent
- debt created
- debt_settlement_created
- wallet created
- sync failure
- sync success

### 12.2 Generation Rules
Notifications are generated through a centralized service rather than hardcoded directly into random UI flows. This preserves consistency and allows the backend to eventually control notification creation rules.

### 12.3 Notification State
Notifications support:
- unread
- read

### 12.4 Notification Center Behavior
Notification center should support:
- list notifications
- filter notifications
- mark individual notifications as read
- mark all as read
- clear read notifications from active view

### 12.5 Not Source Of Truth
Notifications are a communication layer only. If a notification is dismissed or cleared, the underlying transfer, debt, or wallet event still exists independently.

## 13. Audit Trail Rules

### 13.1 Immutable Audit History
Audit history is append-only and immutable. Audit records must never be user-editable.

### 13.2 Automatic Generation
Audit events should be generated automatically by repositories or backend services after successful domain operations.

### 13.3 Supported Event Examples
Examples include:
- transaction created
- debt created
- debt settlement created
- transfer executed
- wallet created
- wallet renamed
- wallet archived
- contact created
- attachment created

### 13.4 Audit Event Data
Audit events should include:
- event id
- event type
- timestamp
- actor or system source
- related entity type
- related entity id
- device identifier when available
- sync status snapshot when relevant
- metadata payload

### 13.5 Ownership And Scope
Audit history is generally user-scoped in the current application model, though future admin tooling may introduce broader support visibility.

## 14. Sync Rules

This is a critical section.

### 14.1 Server As Future Source Of Truth
The mobile app is offline-capable, but once backend integration exists, the backend becomes the source of truth. This means:
- local state is authoritative only temporarily
- sync results may replace local assumptions
- server-generated ids and versions must win in canonical state

### 14.2 Sync Queue States
Supported sync operation states are:
- pending
- synced
- failed
- conflict

### 14.3 Pending
Pending means:
- operation was created locally
- operation is queued
- server has not yet confirmed canonical application

### 14.4 Synced
Synced means:
- backend accepted the operation
- canonical state is known
- client should reconcile local cache with server payload

### 14.5 Failed
Failed means:
- backend rejected the operation for a non-conflict reason
- operation may or may not be retryable depending on error type

### 14.6 Conflict
Conflict means:
- local assumptions no longer match server state
- operation needs explicit reconciliation
- automatic retry is unsafe

### 14.7 Sync Queue Responsibilities
The sync queue must be able to:
- add operation
- inspect operation
- retry operation
- mark synced
- mark failed
- mark conflict
- clear completed records where product policy allows

### 14.8 Sync-Safe Operation Types
Operations expected to be sync-capable include:
- wallet create
- wallet rename
- wallet archive
- wallet restore
- deposit create
- withdraw create
- internal transfer create
- exchange create
- debt create
- debt settlement create
- external contact create
- registered contact create
- contact archive
- user transfer create
- attachment create

### 14.9 Idempotency
Every replayable operation must have a stable idempotency key. If the same write is retried due to network problems, the backend must recognize it as the same business command rather than creating duplicates.

Idempotency is non-negotiable for:
- transaction creation
- transfer creation
- debt settlement creation
- contact creation
- attachment creation
- wallet lifecycle changes

### 14.10 Versioning
Mutable entities such as wallets and contacts should carry version numbers. Sync uploads should include the base version known by the client. If the server sees a stale base version, it may reject with conflict.

### 14.11 Conflict Handling
Conflicts should capture:
- operation context
- local payload
- remote payload
- recommended strategy
- summary

Expected resolution strategies include:
- server wins
- client wins
- merge
- manual review

### 14.12 Conflict Examples
Examples:
- wallet renamed on two devices differently
- contact updated locally while changed remotely
- archived wallet restored elsewhere before local update replayed
- default receiving wallet changed on server while transfer target assumptions differ

### 14.13 Batch Ordering
Sync batches should preserve operation order because later operations may depend on earlier local creations or updates.

### 14.14 Offline-First Behavior
Offline-first means:
- user can continue working locally
- app persists operations immediately
- app does not require network for basic interaction
- sync is eventual, not immediate

### 14.15 No Hidden Auto-Merge For Critical Finance Records
Conflict resolution for sensitive financial entities must be conservative. Silent auto-merge for finance records is risky. The backend should prefer explicit failure or structured conflict for ambiguous cases.

## 15. Database Overview

This section summarizes the backend data model at a high level. The full field-level schema is defined in [ERD.md](/c:/Users/TOSHIBA/Desktop/wallet/docs/ERD.md).

### 15.1 Major Table Groups

Identity and access:
- users
- user_devices
- personal_access_tokens
- otp_challenges

Wallet and financial accounting:
- wallets
- transaction_references
- financial_transactions
- ledger_entries
- user_transfers

Contacts and debts:
- contacts
- contact_link_requests
- debts
- debt_settlements

User identity and collaboration:
- qr_identities

Supporting subsystems:
- attachments
- notifications
- audit_events
- sync_operations
- conflict_records

### 15.2 Ownership Model
Primary ownership is user-scoped. Most tables tie directly or indirectly to a user account. This is important for:
- authorization
- query scoping
- data isolation
- sync security

### 15.3 Key Relationships
Important relationships include:
- user owns many wallets
- user owns many contacts
- wallet participates in many financial transactions
- financial transaction produces one or more ledger entries
- debt belongs to a contact and an owning user
- debt has many settlements
- debt settlement references a linked financial transaction
- user has one QR identity
- sync operations may create conflict records

### 15.4 Default Receiving Wallet Relationship
The user account may reference one wallet as `default_receiving_wallet_id`. This is a convenience for inbound transfers and creates an important ownership invariant:
- the default receiving wallet must belong to the same user

### 15.5 Derived Models
The backend may expose summary read models such as:
- wallet balances by currency
- dashboard totals
- debt summaries
- notification unread counts

These read models may be cached or materialized, but their authoritative source remains the base domain records.

## 16. API Overview

This section summarizes the API surface. Detailed endpoint definitions are in [API_SPECIFICATION.md](/c:/Users/TOSHIBA/Desktop/wallet/docs/API_SPECIFICATION.md) and [SYNC_API_SPECIFICATION.md](/c:/Users/TOSHIBA/Desktop/wallet/docs/SYNC_API_SPECIFICATION.md).

### 16.1 Auth APIs
Auth covers:
- register
- request login OTP
- verify OTP
- logout
- biometric device registration
- list devices
- revoke device

### 16.2 Wallet APIs
Wallet APIs cover:
- list wallets
- create wallet
- wallet details
- rename wallet
- archive wallet
- restore wallet

### 16.3 Transaction APIs
Transaction APIs cover:
- create deposit
- create withdraw
- create internal transfer
- create exchange
- list transaction history
- transaction details

### 16.3.1 Unified Transaction History
The system must support a consolidated history view ordered chronologically and combining:
- deposits
- transfers
- exchanges
- debt settlements

### 16.4 Debt APIs
Debt APIs cover:
- create debt
- debt details
- debt history
- create settlement

### 16.5 Contact APIs
Contact APIs cover:
- create contact
- list contacts
- update contact
- archive contact
- discover link candidate
- approve link
- reject link

### 16.6 Transfer APIs
Transfer APIs cover:
- create user transfer
- list transfer history
- transfer details

### 16.7 QR APIs
QR APIs cover:
- generate or retrieve QR identity
- resolve QR payload
- preview user

### 16.8 Attachment APIs
Attachment APIs cover:
- create or upload attachment
- list attachments
- read attachment metadata
- delete attachment

### 16.9 Notification APIs
Notification APIs cover:
- list notifications
- mark notification read
- mark all read
- clear read items

### 16.10 Audit APIs
Audit APIs cover:
- list audit events
- read audit event details

### 16.11 Sync APIs
Sync APIs cover:
- upload batch operations
- inspect operation status
- resolve conflicts
- retry failed operations where supported

## 17. Security Overview

This section summarizes the security model. Full detail is in [SECURITY_SPECIFICATION.md](/c:/Users/TOSHIBA/Desktop/wallet/docs/SECURITY_SPECIFICATION.md).

### 17.1 Access Tokens
Laravel Sanctum access tokens authorize normal API access.

### 17.2 Sanctum Sessions And Tokens
Laravel Sanctum tokens support authenticated API access and session revocation. Token records must remain backend-managed and revocable per session or device policy.

### 17.3 OTP
OTP is delivered through WhatsApp API and used for identity verification, registration verification, and new-device login verification. OTPs must be:
- hashed at rest
- time-limited
- attempt-limited
- single-use

### 17.4 Device Binding
Sessions are tied to registered device records. Device metadata matters for:
- refresh validation
- biometric trust
- audit context
- sync context

### 17.5 Biometrics
Biometrics are a device convenience and local application-unlock mechanism, not a standalone backend trust model. The backend should store device registration or attestation data, not raw biometric data.

### 17.6 Rate Limiting
Rate limiting is required for:
- login
- register
- OTP issue and verify
- sync upload
- attachment upload

### 17.7 Attachment Security
Attachments require:
- file validation
- size limits
- secure storage
- authorized download
- future malware scanning

### 17.8 Transport Security
All production traffic must use HTTPS.

## 18. Non-Negotiable Rules

This section defines rules that must never be violated by application code, backend code, database shortcuts, reporting logic, or future AI-generated changes.

1. The ledger is the only source of wallet balances.
2. Wallet balances must never be stored as the authoritative truth.
3. Debts are completely separate from wallet balances.
4. Creating a debt with `owed_by_contact` must create a linked wallet withdrawal atomically.
5. Creating a debt with `owed_to_contact` must not create an automatic wallet transaction.
6. Recording a standard transfer does not automatically reduce debt.
7. Only debt settlement reduces debt through a linked ledger-backed financial write.
8. Transactions are immutable.
9. Ledger entries are immutable.
10. Audit events are immutable.
11. Wallets are archived, not permanently deleted.
12. Archived wallets must remain available for historical interpretation.
13. User-to-user transfers must resolve an explicit or default receiving wallet.
14. A user's default receiving wallet must belong to that same user.
15. User-to-user transfers must remain same-currency only.
16. Contact linking requires approval from both parties.
17. Contacts are archived, not permanently deleted.
18. QR payloads must contain only `public_reference_code`.
19. Sync operations must be idempotent.
20. Sync conflicts must not be silently hidden.
21. Laravel backend is the canonical source of truth.
22. Local cache, summaries, and projections may optimize reads, but they never replace canonical domain records.

## 19. Operational Guidance For Developers

### 19.1 For Flutter Developers
Flutter contributors should treat repository interfaces and domain models as stable contracts. New UI should not bypass controllers or repositories. Any feature that introduces financial state must respect:
- immutable transaction modeling
- ledger-derived balance projection
- explicit debt separation
- sync queue compatibility

### 19.2 For Backend Developers
Backend contributors should treat the documented business rules as primary requirements, not implementation suggestions. In particular:
- do not denormalize wallet balances into mutable truth
- do not auto-close debt because a transfer exists
- do not allow archive or restore logic to violate default receiving wallet rules
- require idempotency for replayed write operations

### 19.3 For AI Coding Agents
AI-generated changes must preserve:
- the clean architecture boundaries
- repository abstractions
- immutable finance records
- debt separation from wallet balances
- explicit distinction between transfer and settlement
- sync-safe write semantics

If an AI-generated change weakens one of those rules, it is architecturally incorrect even if the code compiles.

### 19.4 For QA And Test Authors
Tests should focus heavily on:
- derived wallet balances
- transaction immutability
- debt separation
- transfer versus settlement distinction
- archive and restore lifecycle
- default receiving wallet behavior
- sync conflict edge cases
- idempotent replay behavior

## 20. Example Domain Scenarios

### 20.1 Multiple Wallet Usage
User creates:
- Main Wallet
- Business Wallet
- Travel Wallet

Later:
- deposits 1000 USD into Main Wallet
- transfers 200 USD internally to Travel Wallet
- exchanges 100 USD in Travel Wallet into SYP

Expected result:
- all balances are derived from ledger activity
- no wallet stores an authoritative direct balance field

### 20.2 Debt Without Money Movement
User records:
- I owe Ali 100 USD

Expected result:
- debt summary shows 100 USD owed
- no wallet balance changes

### 20.3 Standard Transfer With Existing Debt
User A is owed 70 USD by User B.
User B sends User A 50 USD as a gift.

Expected result:
- sender and recipient wallet balances change
- debt remains 70 USD

### 20.4 Debt Settlement
User is owed 70 USD by a contact.
User records a 50 USD settlement into a destination wallet.

Expected result:
- linked financial transaction is created
- wallet balances change
- linked debt settlement is created
- debt remaining becomes 20 USD

### 20.5 External Contact Later Registers
User creates external contact:
- Ali
- phone number

Months later Ali registers.

Expected result:
- the system may surface a link candidate
- final link requires both parties to approve
- history remains intact

### 20.6 Offline Create Then Sync
User is offline and:
- creates wallet
- creates contact
- creates debt

Expected result:
- all actions are available locally
- each write becomes a pending sync operation
- when backend sync is enabled later, the operations upload with idempotency keys

## 21. Future Roadmap

The current project is intentionally scoped, but several future enhancements are already implied by the architecture.

### 21.1 Currency Scope
The system supports only:
- USD
- SYP

No other currencies are part of the approved implementation scope.

### 21.2 Push Notifications
Notifications are currently modeled as app-visible records. Future work may add:
- push delivery
- notification preferences
- locked-screen privacy controls

### 21.3 Advanced Reporting
Possible future reporting features:
- spending summaries
- category insights
- debt aging
- settlement trends
- wallet performance over time

### 21.4 Analytics
Future analytics may include:
- user activity analytics
- financial usage patterns
- sync health metrics
- reliability dashboards

### 21.5 Web Platform
The architecture could support:
- Flutter web client
- admin tooling
- support dashboard

### 21.6 Admin Dashboard
An internal admin or support dashboard may later provide:
- user support views
- audit review
- sync conflict review
- attachment moderation or investigation

### 21.7 Reversal Transactions
Future transaction corrections should be implemented through:
- reversal transactions
- reason tracking
- original reference linkage

### 21.8 Signed QR Payloads
Future QR enhancement may include:
- signed payloads
- rotation
- anti-tamper validation

### 21.9 Real Backend Sync Execution
The queue architecture is ready, but full future work includes:
- actual API client implementation
- background sync execution
- robust retry policies
- conflict resolution UI

### 21.10 Attachment Upload Pipeline
Future attachment enhancements may include:
- resumable upload
- storage provider abstraction
- malware scanning
- image optimization

## 22. Final Summary

Personal Wallet is a disciplined finance application for a small trusted group, designed around strict accounting and synchronization rules. Its architecture is deliberately stronger than a prototype because the core domain is sensitive:
- wallets must be balance-projected, not mutable-balance-driven
- debts must remain isolated from wallet accounting
- transfers must remain distinct from settlements
- history must remain immutable where it matters
- offline capability must not undermine future server authority

Anyone extending this project should begin from these principles rather than from visible UI behavior alone. The screens may evolve, the backend stack may change, and implementation details may be optimized, but the business model defined in this document must remain stable unless there is an explicit architectural decision to change the product itself.

