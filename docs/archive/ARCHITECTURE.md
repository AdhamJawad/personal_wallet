# Architecture

## Principles

- Clean architecture with explicit separation between presentation, domain, data, and core infrastructure.
- Feature-first organization so each business area can evolve independently.
- Offline-first design where repositories depend on local persistence first and can later coordinate with remote sources and a sync engine.
- Immutable records for financial history. Wallet balances are derived from transactions instead of stored directly.

## Folder Structure

```text
lib/
  app/
    app.dart
    bootstrap/
    router/
  core/
    constants/
    design_system/
    storage/
    sync/
    theme/
    utils/
  shared/
    domain/
      enums/
      models/
  features/
    auth/
      data/
      domain/
      presentation/
    contacts/
      data/
      domain/
      presentation/
    dashboard/
      presentation/
    debts/
      data/
      domain/
      presentation/
    qr/
      data/
      domain/
      presentation/
    transactions/
      data/
      domain/
      presentation/
    wallets/
      data/
      domain/
      presentation/
```

## Layer Responsibilities

### `app`

- Application bootstrap
- Dependency graph entry points
- Top-level router configuration

### `core`

- Cross-cutting infrastructure
- Theme and design system primitives
- Local storage abstraction
- Future sync engine contracts

### `shared`

- App-wide enums and shared value objects such as `Money`

### `features/<feature>`

- `domain`: entities, value objects, repository contracts, future use cases
- `data`: repository implementations, local data sources, future remote data sources
- `presentation`: Riverpod providers, route entry points, future UI

## Offline-First Strategy

### Current skeleton

- `LocalStore` abstracts persistence from feature code.
- `HiveLocalStore` is the initial implementation.
- `SyncEngine` is defined now even though no backend exists yet.
- Mock repositories stand in for production repositories and preserve boundaries.

### Future production flow

1. Presentation triggers a use case.
2. Use case writes an immutable local record immediately.
3. Repository updates local projections and queues sync work.
4. Sync engine reconciles with backend when connectivity returns.
5. Conflicts are resolved through server timestamps, versioning, and domain rules.

## Domain Modeling Notes

- `Wallet` stores metadata only, never balances.
- `TransactionRecord` is immutable and supports reversal/correction references.
- `DebtRecord` is isolated from wallet ledger records.
- `ContactProfile` supports registered and external contacts plus future linking.
- `QrProfile` separates QR token concerns from user identity details.

## Packages

- `flutter_riverpod`: dependency injection and state management
- `go_router`: route graph and guarded navigation foundation
- `freezed_annotation` and `json_annotation`: immutable DTO/domain models
- `hive` and `hive_flutter`: local storage for offline-first foundation
- `uuid`: stable client-side IDs for offline-created records
- `intl`: future formatting and localization support
- `google_fonts`: typography foundation

## Code Generation Note

This SDK includes transitive packages with Dart build hooks, so `build_runner` should be executed with JIT mode in this project:

```bash
dart run build_runner build --force-jit
```

## Why Hive Here

Hive is sufficient for the current phase because:

- there is no relational query requirement yet
- the user asked for architecture, not complex persistence logic
- JSON-based storage preserves flexibility for future model evolution

If future reporting, indexing, or advanced local queries become central, migrating persistence internals to Isar can happen behind the same repository and local-store boundaries.
