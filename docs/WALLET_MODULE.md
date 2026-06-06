# Wallet Module

## Wallet Architecture

- `Wallet` remains metadata-only.
- `WalletBalanceSnapshot` holds the current mock USD/SYP view used by the UI.
- `WalletOverview` combines metadata and the balance snapshot for list/detail/dashboard rendering.
- `WalletDashboardSnapshot` aggregates total balances, wallet summaries, and recent activity.
- `MockWalletRepository` persists wallet records through the existing `LocalStore` abstraction and seeds realistic wallets for new users.

## Screen Flow

```text
Dashboard
  -> Wallets
  -> Wallet Details

Wallets
  -> Create Wallet
  -> Wallet Details

Wallet Details
  -> Edit Wallet

Edit Wallet
  -> Rename wallet
  -> Archive wallet
```

## Repository Design

`WalletRepository` currently provides:

- `fetchDashboardSnapshot`
- `fetchWallets`
- `getWalletById`
- `createWallet`
- `renameWallet`
- `archiveWallet`

The repository writes mock wallet records to the local `wallets_box`, which keeps this phase offline-friendly and ready for later swap-out behind the same interface.

## State Management

- `walletControllerProvider` exposes `WalletController`.
- `WalletController` owns loading, search, sort, selected wallet, create, rename, archive, and dashboard refresh.
- `WalletState` contains repository output plus UI-driving state such as `searchQuery`, `sortOption`, and `selectedWallet`.
- The UI reads derived `visibleWallets` from `WalletState`; widget trees do not manage wallet business state directly.

## Future Transaction Integration Points

- Replace mock `WalletBalanceSnapshot` generation with ledger-derived balance projections.
- Recent activity should be sourced from immutable transaction records once the transaction module exists.
- Quick actions on the dashboard should become transaction entry points without changing the dashboard route structure.
- Wallet details already reserve visual space for transactions and debt-related wallet activity.

## Future Backend Integration Points

- Replace `MockWalletRepository` with a repository that coordinates local cache and remote API.
- Sync wallet metadata changes such as create, rename, and archive through the future sync engine.
- Keep balance computation local-first, then reconcile with backend projections when available.

## Notes

- Wallets are never permanently deleted.
- Archived wallets remain visible for history and future linkage.
- USD and SYP totals are mock values in this phase only.
