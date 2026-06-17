# Personal Wallet Firebase-to-Laravel Migration Report

## Purpose
This document preserves the Firebase backend as the authoritative implementation reference while preparing the project for a Laravel REST API migration. It reflects the callable Firebase backend currently archived under `archive/firebase-backend/`.

## Scope Boundary
- Flutter code was not modified.
- Existing business and architecture documents were preserved.
- Firebase implementation was moved to `archive/firebase-backend/` intact for reference.
- This report distinguishes between:
  - implemented Firebase callable behavior
  - broader planned capabilities documented in `docs/Master/`

## Authoritative Archived Sources
- `archive/firebase-backend/functions/src`
- `archive/firebase-backend/firebase.json`
- `archive/firebase-backend/.firebaserc`
- `archive/firebase-backend/firestore.rules`
- `archive/firebase-backend/storage.rules`

## Firebase-Specific Dependency Inventory

### Firebase Auth
- Backend:
  - `firebase-admin/auth`
  - Creates Firebase Auth users by phone number
  - Generates Firebase custom tokens after OTP verification
  - Deletes orphaned Firebase users during race-condition cleanup
- Flutter:
  - `firebase_auth`
  - Direct phone OTP flow in `lib/features/auth/data/datasources/firebase_phone_auth_remote_data_source.dart`
  - Session restore and profile updates through Firebase client auth

### Firestore
- Backend:
  - `firebase-admin/firestore`
  - Primary persistence store for all implemented backend modules
- Flutter:
  - `cloud_firestore` is present in dependencies, but the current app structure is mainly repository-driven and backend-facing domain logic is still abstracted

### Cloud Functions
- Backend:
  - `firebase-functions/https`
  - All implemented backend endpoints are Firebase callable functions, not REST endpoints

### Firebase Storage
- Backend:
  - `firebase-admin/storage`
  - Used for signed upload URLs and object metadata validation in attachments
- Flutter:
  - `firebase_storage` dependency exists
  - Firebase configuration includes a storage bucket

### Security Rules
- `archive/firebase-backend/firestore.rules`
- `archive/firebase-backend/storage.rules`
- These currently enforce read-only client access patterns and force all writes through trusted backend code

### Firebase Transactions
- Used in:
  - auth OTP lifecycle
  - wallet internal transfers and exchange balance checks
  - debt settlement amount updates
  - user transfers with ledger writes

### Firebase Custom Tokens
- Generated in auth verification flow after successful OTP verification
- Required today because the backend issues Firebase identities rather than Laravel-native tokens

## Module-by-Module Migration Detail

### 1. Auth Module

#### Existing callable functions
- `sendOtp`
- `verifyOtp`

#### Request structure
- `sendOtp`
```json
{
  "phoneNumber": "+963999999999"
}
```
- `verifyOtp`
```json
{
  "phoneNumber": "+963999999999",
  "otp": "123456"
}
```

#### Response structure
- `sendOtp`
```json
{
  "challengeId": "firestore-doc-id",
  "expiresAt": "2026-06-17T12:00:00.000Z",
  "status": "pending"
}
```
or
```json
{
  "status": "otp_already_sent",
  "retryAfterSeconds": 60
}
```
- `verifyOtp`
```json
{
  "status": "verified",
  "isNewUser": true,
  "uid": "firebase-auth-uid",
  "customToken": "firebase-custom-token",
  "profile": {
    "uid": "firebase-auth-uid",
    "phoneNumber": "+963999999999",
    "displayName": null,
    "emailAddress": null,
    "profileImageUrl": null,
    "status": "active"
  }
}
```

#### Firestore collections used
- `authOtpChallenges`
- `phoneIndex`
- `users`

#### Validation rules
- `phoneNumber` must be a string and valid E.164 after normalization
- `otp` must be exactly 6 digits

#### Security assumptions
- No authentication required for OTP challenge creation or verification
- Auth identity becomes trusted only after successful OTP verification
- Phone-to-UID uniqueness is enforced by `phoneIndex`
- User profile creation tolerates race conditions and recovers existing mappings

#### Business rules
- OTP expires after 5 minutes
- OTP resend cooldown is 60 seconds
- Max failed attempts is 5, then challenge locks
- Only one effective pending challenge should exist per phone number
- Existing verified phone numbers resolve to the same identity
- New users are created in Firebase Auth plus canonical user profile storage
- Response issues Firebase custom token, not app-native access token

### 2. Wallets Module

#### Existing callable functions
- `createWallet`
- `getWallets`

#### Request structure
- `createWallet`
```json
{
  "name": "Main Wallet"
}
```
- `getWallets`
```json
{}
```

#### Response structure
- `createWallet` and `getWallets`
```json
{
  "walletId": "wallet-doc-id",
  "ownerUid": "firebase-auth-uid",
  "name": "Main Wallet",
  "status": "active",
  "supportedCurrencies": ["USD", "SYP"],
  "createdAt": "date",
  "updatedAt": "date"
}
```

#### Firestore collections used
- `wallets`
- `auditLogs`

#### Validation rules
- Caller must be authenticated
- `name` must be a non-empty trimmed string

#### Security assumptions
- Wallet ownership is determined by `ownerUid == request.auth.uid`
- Wallet writes are backend-only; Firestore rules deny client-side writes

#### Business rules
- New wallets default to `active`
- Supported currencies default to `USD` and `SYP`
- Wallet creation emits an audit event
- Firebase implementation currently does not implement archive/restore/rename callable functions even though master docs describe them

### 3. Ledger Module

#### Existing callable functions
- `createDeposit`
- `createExchange`
- `createInternalTransfer`
- `getWalletLedger`
- `getWalletBalances`

#### Request structure
- `createDeposit`
```json
{
  "walletId": "wallet-id",
  "currency": "USD",
  "amount": 100,
  "reason": "Cash top-up"
}
```
- `createExchange`
```json
{
  "walletId": "wallet-id",
  "fromCurrency": "USD",
  "toCurrency": "SYP",
  "fromAmount": 100,
  "exchangeRate": 9500
}
```
- `createInternalTransfer`
```json
{
  "fromWalletId": "wallet-a",
  "toWalletId": "wallet-b",
  "currency": "USD",
  "amount": 50,
  "reason": "Trip budget"
}
```
- `getWalletLedger`
```json
{
  "walletId": "wallet-id"
}
```
- `getWalletBalances`
```json
{
  "walletId": "wallet-id"
}
```

#### Response structure
- `createDeposit`
```json
{
  "success": true,
  "ledgerEntryId": "ledger-entry-id"
}
```
- `createExchange`
```json
{
  "success": true,
  "referenceId": "uuid",
  "fromAmount": 100,
  "toAmount": 950000
}
```
- `createInternalTransfer`
```json
{
  "success": true,
  "referenceId": "uuid"
}
```
- `getWalletLedger`
```json
[
  {
    "entryId": "ledger-entry-id",
    "walletId": "wallet-id",
    "ownerUid": "firebase-auth-uid",
    "entryType": "deposit",
    "currency": "USD",
    "amount": 100,
    "referenceId": null,
    "metadata": {},
    "createdAt": "date"
  }
]
```
- `getWalletBalances`
```json
{
  "walletId": "wallet-id",
  "balances": {
    "USD": 1200,
    "SYP": 950000
  }
}
```

#### Firestore collections used
- `wallets`
- `ledgerEntries`
- `auditLogs`
- `notifications`

#### Validation rules
- Caller must be authenticated
- `walletId`, `fromWalletId`, `toWalletId` must be non-empty strings
- `currency`, `fromCurrency`, `toCurrency` must be non-empty strings and are normalized to uppercase
- `amount` and `fromAmount` must be numeric
- `exchangeRate` must be numeric
- Positive amounts required for deposits, transfers, and exchanges

#### Security assumptions
- Every wallet read/write checks owner UID
- Internal transfer source and destination must both belong to the caller
- Ledger writes are trusted backend writes only

#### Business rules
- Ledger is the balance source of truth
- Balances are derived by summing immutable ledger entries
- Signed amounts:
  - positive: `deposit`, `transfer_in`, `exchange_in`, `debt_settlement_in`
  - negative: `withdrawal`, `transfer_out`, `exchange_out`, `debt_settlement_out`
- Internal transfer cannot use the same wallet on both sides
- Exchange cannot use the same currency pair
- Supported wallet currencies are currently limited to `USD` and `SYP`
- Insufficient balance blocks internal transfer and exchange outflows
- Exchange destination amount is computed as `fromAmount * exchangeRate`
- Internal transfer and exchange create paired ledger rows with shared `referenceId`
- Audit events are emitted
- Notifications are integrated as service dependencies, though ledger flows shown here primarily use audit logging

### 4. Contacts Module

#### Existing callable functions
- `createContact`
- `getContacts`

#### Request structure
- `createContact`
```json
{
  "displayName": "Ali Ahmad",
  "phoneNumber": "+963999999999"
}
```
- `getContacts`
```json
{}
```

#### Response structure
```json
{
  "contactId": "contact-id",
  "ownerUid": "firebase-auth-uid",
  "displayName": "Ali Ahmad",
  "phoneNumber": "+963999999999",
  "linkedUserUid": null,
  "createdAt": "date",
  "updatedAt": "date"
}
```

#### Firestore collections used
- `contacts`
- `auditLogs`

#### Validation rules
- Caller must be authenticated
- `displayName` must be a non-empty string
- `phoneNumber`, if provided, must be valid E.164 after normalization

#### Security assumptions
- Contacts are private to owner
- Duplicate detection is application-enforced, not Firestore-unique-index-enforced

#### Business rules
- Duplicate contact is defined by same owner, same normalized display name, and same phone number
- New contacts default to `linkedUserUid: null`
- Contact creation emits an audit event
- Planned registered-contact linking workflow from master docs is not implemented in callable Firebase code yet

### 5. Debts Module

#### Existing callable functions
- `createDebt`
- `getDebts`

#### Request structure
- `createDebt`
```json
{
  "contactId": "contact-id",
  "direction": "owed_by_contact",
  "currency": "USD",
  "amount": 100,
  "description": "Short-term loan"
}
```
- `getDebts`
```json
{}
```

#### Response structure
```json
{
  "debtId": "debt-id",
  "ownerUid": "firebase-auth-uid",
  "contactId": "contact-id",
  "direction": "owed_by_contact",
  "currency": "USD",
  "originalAmount": 100,
  "remainingAmount": 100,
  "status": "active",
  "description": "Short-term loan",
  "createdAt": "date",
  "updatedAt": "date"
}
```

#### Firestore collections used
- `debts`
- `contacts`
- `auditLogs`
- `notifications`

#### Validation rules
- Caller must be authenticated
- `contactId`, `direction`, `currency` must be non-empty strings
- `currency` is normalized to uppercase
- `amount` must be numeric and greater than zero
- Direction must be one of:
  - `owed_by_contact`
  - `owed_to_contact`

#### Security assumptions
- Debt owner must also own the referenced contact
- Client cannot write debts directly in Firestore

#### Business rules
- Debt creation does not touch wallet balances
- Debt starts with `remainingAmount == originalAmount`
- Default debt status is `active`
- Debt creation emits audit log and notification

### 6. Debt Settlements Module

#### Existing callable functions
- `recordDebtSettlement`
- `getDebtSettlements`

#### Request structure
- `recordDebtSettlement`
```json
{
  "debtId": "debt-id",
  "amount": 40
}
```
- `getDebtSettlements`
```json
{
  "debtId": "debt-id"
}
```

#### Response structure
- `recordDebtSettlement`
```json
{
  "settlementId": "settlement-id",
  "debtId": "debt-id",
  "ownerUid": "firebase-auth-uid",
  "amount": 40,
  "currency": "USD",
  "createdAt": "date"
}
```
- `getDebtSettlements`
```json
[
  {
    "settlementId": "settlement-id",
    "debtId": "debt-id",
    "ownerUid": "firebase-auth-uid",
    "amount": 40,
    "currency": "USD",
    "createdAt": "date"
  }
]
```

#### Firestore collections used
- `debts`
- `debtSettlements`
- `auditLogs`
- `notifications`

#### Validation rules
- Caller must be authenticated
- `debtId` must be a non-empty string
- `amount` must be numeric and greater than zero

#### Security assumptions
- Debt must exist and belong to the caller
- Settlement write and debt remaining update are performed inside one Firestore transaction

#### Business rules
- Only `active` debts can receive settlements
- Settlement amount cannot exceed remaining debt amount
- Remaining amount is decremented atomically
- Debt becomes `settled` when remaining amount reaches zero
- Settlement emits audit log and notification
- Important gap: current Firebase implementation records a debt settlement record only; it does not create the linked financial transfer described in master docs

### 7. Transfers Module

#### Existing callable functions
- `createUserTransfer`
- `getTransfers`

#### Request structure
- `createUserTransfer`
```json
{
  "sourceWalletId": "sender-wallet-id",
  "destinationWalletId": "recipient-wallet-id",
  "amount": 50,
  "currency": "USD"
}
```
- `getTransfers`
```json
{}
```

#### Response structure
- `createUserTransfer`
```json
{
  "success": true,
  "transferId": "transfer-id"
}
```
- `getTransfers`
```json
[
  {
    "transferId": "transfer-id",
    "senderUid": "sender-uid",
    "receiverUid": "receiver-uid",
    "sourceWalletId": "sender-wallet-id",
    "destinationWalletId": "recipient-wallet-id",
    "currency": "USD",
    "amount": 50,
    "status": "completed",
    "createdAt": "date"
  }
]
```

#### Firestore collections used
- `transfers`
- `wallets`
- `ledgerEntries`
- `auditLogs`
- `notifications`

#### Validation rules
- Caller must be authenticated
- `sourceWalletId`, `destinationWalletId` must be non-empty strings
- `amount` must be numeric and greater than zero
- `currency` must be non-empty and normalized to uppercase

#### Security assumptions
- Source wallet must belong to sender
- Destination wallet must exist
- Sender cannot transfer to own wallet as a user transfer
- Ledger writes are trusted server-side only

#### Business rules
- User transfer is distinct from internal transfer
- Destination owner is inferred from destination wallet owner
- Sender must have sufficient balance
- Both wallets must support the currency
- Creates one transfer record plus paired ledger entries
- Creates sender and receiver audit logs
- Creates receiver notification
- Important gap versus master docs: current implementation requires `destinationWalletId`; it does not support recipient-user lookup plus fallback to `default_receiving_wallet_id`

### 8. Notifications Module

#### Existing callable functions
- `getNotifications`
- `markNotificationAsRead`

#### Request structure
- `getNotifications`
```json
{}
```
- `markNotificationAsRead`
```json
{
  "notificationId": "notification-id"
}
```

#### Response structure
- `getNotifications`
```json
[
  {
    "notificationId": "notification-id",
    "ownerUid": "firebase-auth-uid",
    "type": "transfer_received",
    "title": "Transfer received",
    "body": "You received a wallet transfer.",
    "isRead": false,
    "metadata": {},
    "createdAt": "date"
  }
]
```
- `markNotificationAsRead`
```json
{
  "success": true
}
```

#### Firestore collections used
- `notifications`

#### Validation rules
- Caller must be authenticated
- `notificationId` must be a non-empty string

#### Security assumptions
- Only notification owner may mark it as read

#### Business rules
- Notifications are ordered newest first
- New notifications start with `isRead: false`
- Several other modules create notifications through a safe, non-throwing helper

### 9. Attachments Module

#### Existing callable functions
- `createAttachmentUploadUrl`
- `completeAttachmentUpload`
- `getAttachments`

#### Request structure
- `createAttachmentUploadUrl`
```json
{
  "entityType": "debt",
  "entityId": "entity-id",
  "fileName": "receipt.jpg",
  "contentType": "image/jpeg"
}
```
- `completeAttachmentUpload`
```json
{
  "entityType": "debt",
  "entityId": "entity-id",
  "fileName": "receipt.jpg",
  "contentType": "image/jpeg",
  "storagePath": "attachments/user/debt/entity/uuid-receipt.jpg",
  "fileSize": 124050
}
```
- `getAttachments`
```json
{
  "entityType": "debt",
  "entityId": "entity-id"
}
```

#### Response structure
- `createAttachmentUploadUrl`
```json
{
  "uploadUrl": "signed-url",
  "storagePath": "attachments/user/debt/entity/uuid-receipt.jpg"
}
```
- `completeAttachmentUpload`
```json
{
  "attachmentId": "attachment-id",
  "ownerUid": "firebase-auth-uid",
  "entityType": "debt",
  "entityId": "entity-id",
  "fileName": "receipt.jpg",
  "contentType": "image/jpeg",
  "storagePath": "attachments/user/debt/entity/uuid-receipt.jpg",
  "fileSize": 124050,
  "createdAt": "date"
}
```
- `getAttachments`
```json
[
  {
    "attachmentId": "attachment-id",
    "ownerUid": "firebase-auth-uid",
    "entityType": "debt",
    "entityId": "entity-id",
    "fileName": "receipt.jpg",
    "contentType": "image/jpeg",
    "storagePath": "attachments/user/debt/entity/uuid-receipt.jpg",
    "fileSize": 124050,
    "createdAt": "date"
  }
]
```

#### Firestore collections used
- `attachments`
- `wallets`
- `debts`
- `debtSettlements`
- `transfers`

#### Validation rules
- Caller must be authenticated
- `entityType` must be one of:
  - `debt`
  - `transfer`
  - `wallet`
  - `settlement`
- `entityId`, `fileName`, `contentType`, `storagePath` must be non-empty strings where applicable
- `fileSize` must be numeric

#### Security assumptions
- Ownership is resolved against the parent entity
- Transfer attachments are accessible to either sender or receiver
- Upload completion validates storage path prefix: `attachments/{ownerUid}/{entityType}/{entityId}/`
- Storage object metadata is validated against actual bucket object state

#### Business rules
- File name is sanitized before composing storage path
- Signed upload URLs expire after 15 minutes
- Attachment metadata is written only after object existence is verified in storage
- Current Firebase implementation depends on Firebase Storage signed URLs and bucket metadata inspection

### 10. Audit Logs Module

#### Existing callable functions
- `getAuditLogs`

#### Request structure
- `getAuditLogs`
```json
{}
```

#### Response structure
```json
[
  {
    "auditId": "audit-id",
    "ownerUid": "firebase-auth-uid",
    "entityType": "wallet",
    "entityId": "entity-id",
    "action": "wallet_created",
    "metadata": {},
    "createdAt": "date"
  }
]
```

#### Firestore collections used
- `auditLogs`

#### Validation rules
- Caller must be authenticated

#### Security assumptions
- Audit reads are owner-scoped
- Audit writes happen only through backend services

#### Business rules
- Audit is append-only in practice
- Audit service offers safe non-throwing writes for cross-module side effects
- Implemented entity types are currently `wallet`, `debt`, `contact`, `transfer`

## Non-Implemented or Placeholder Firebase Modules
- `transactions` module exists as source folder but exports no callable functions
- `users` module exists as source folder but exports no callable functions
- QR, sync, device management, refresh tokens, wallet archive/restore, contact linking, and REST-style endpoints are described in master docs but not implemented in callable Firebase source

## Migration Notes for Laravel Engineer
- The archived Firebase code is the closest executable business specification.
- Where master docs and Firebase code differ, preserve both:
  - implement current Firebase behavior first if parity is required
  - treat master-doc-only behaviors as planned enhancements or phase-two scope
