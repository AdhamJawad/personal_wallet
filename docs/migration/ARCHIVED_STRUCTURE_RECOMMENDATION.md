# Archived Structure Recommendation

## Current Archive Decision
Firebase backend implementation has been moved into:

```text
archive/
  firebase-backend/
    .firebaserc
    firebase.json
    firestore.rules
    storage.rules
    functions/
      package.json
      package-lock.json
      tsconfig.json
      tsconfig.dev.json
      src/
        auth/
        wallets/
        contacts/
        debts/
        transfers/
        notifications/
        attachments/
        audit/
        transactions/
        users/
        shared/
```

## Why This Structure Is Safe
- Keeps all Firebase backend source intact as historical reference.
- Removes Firebase deployment artifacts from the active root project path.
- Preserves exact implementation details for later review.
- Separates archived backend implementation from the active Flutter plus Laravel architecture.

## Recommended Archive Usage Rules
- Treat `archive/firebase-backend/` as read-only historical reference.
- Do not delete source from the archive during Laravel migration.
- Do not continue feature development inside archived Firebase code.
- Do not treat archived Firebase code as production architecture.
- The approved production stack is Flutter -> Laravel 12 API -> MySQL, with Cloudinary, WhatsApp API, and FCM as supporting integrations.
- Use archived code to verify:
  - validation rules
  - ownership checks
  - Firestore collection design
  - transaction boundaries
  - notification and audit side effects

## Recommended Future Additions
- Add any Firebase emulator data exports under `archive/firebase-backend/emulator-data/` if they exist later.
- Add one migration mapping document per Laravel module if implementation begins in parallel.
- Add endpoint parity matrix under `docs/migration/` once Laravel API design is finalized.
