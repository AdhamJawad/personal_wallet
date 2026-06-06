# Personal Wallet

Production-grade Flutter architecture scaffold for an offline-first personal wallet, debt tracking, and money management app. This phase intentionally excludes business logic, backend APIs, and feature screens.

## Stack

- Flutter
- Riverpod
- GoRouter
- Freezed + JsonSerializable
- Hive
- Clean Architecture
- Feature-first folder structure

## Scope In This Phase

- Application architecture
- Shared design system and theme foundation
- Navigation graph and route registry
- Immutable domain models
- Repository contracts and mock repositories
- Offline-first local storage seams
- Project documentation

## Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Auth Module](docs/AUTH_MODULE.md)
- [Wallet Module](docs/WALLET_MODULE.md)
- [Implementation Plan](docs/IMPLEMENTATION_PLAN.md)

## Commands

```bash
flutter pub get
dart run build_runner build --force-jit
flutter analyze
flutter test
```
