import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../wallets/domain/models/wallet_overview.dart';
import '../../../wallets/presentation/providers/wallet_providers.dart';
import '../../domain/enums/transaction_filter_option.dart';
import '../../domain/enums/transaction_sort_option.dart';
import '../providers/transaction_providers.dart';
import '../widgets/transaction_list_card.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  late final TextEditingController _searchController;
  late final VoidCallback _searchListener;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchListener = () {
      ref
          .read(transactionControllerProvider.notifier)
          .setSearchQuery(_searchController.text);
    };
    _searchController.addListener(_searchListener);
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchListener);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionControllerProvider);
    final walletState = ref.watch(walletControllerProvider);
    final transactions = transactionState.visibleTransactions;

    String resolveWalletName(String? walletId) {
      final WalletOverview? wallet = walletState.wallets
          .cast<WalletOverview?>()
          .firstWhere(
            (WalletOverview? item) => item?.wallet.id == walletId,
            orElse: () => null,
          );
      return wallet?.wallet.name ?? context.tr.unknownWallet;
    }

    return PwScaffold(
      title: context.tr.transactions,
      body: ListView(
        children: <Widget>[
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: <Widget>[
              SizedBox(
                width: 320,
                child: PwTextField(
                  controller: _searchController,
                  label: context.tr.searchTransactions,
                  hint: context.tr.transactionReferenceHint,
                ),
              ),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<TransactionFilterOption>(
                  initialValue: transactionState.filterOption,
                  decoration: InputDecoration(labelText: context.tr.filter),
                  items: TransactionFilterOption.values
                      .map(
                        (TransactionFilterOption option) => DropdownMenuItem(
                          value: option,
                          child: Text(_filterLabel(context, option)),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (TransactionFilterOption? value) {
                    if (value != null) {
                      ref
                          .read(transactionControllerProvider.notifier)
                          .setFilter(value);
                    }
                  },
                ),
              ),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<TransactionSortOption>(
                  initialValue: transactionState.sortOption,
                  decoration: InputDecoration(labelText: context.tr.sort),
                  items: TransactionSortOption.values
                      .map(
                        (TransactionSortOption option) => DropdownMenuItem(
                          value: option,
                          child: Text(_sortLabel(context, option)),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (TransactionSortOption? value) {
                    if (value != null) {
                      ref
                          .read(transactionControllerProvider.notifier)
                          .setSortOption(value);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: <Widget>[
              PwButton.primary(
                label: context.tr.deposit,
                onPressed: () => context.push(AppRoutes.depositCreatePath),
              ),
              PwButton.secondary(
                label: context.tr.withdraw,
                onPressed: () => context.push(AppRoutes.withdrawCreatePath),
              ),
              PwButton.secondary(
                label: context.tr.transfer,
                onPressed: () => context.push(AppRoutes.transferCreatePath),
              ),
              PwButton.secondary(
                label: context.tr.exchange,
                onPressed: () => context.push(AppRoutes.exchangeCreatePath),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (transactionState.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (transactions.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(context.tr.noTransactionsForFilters),
            )
          else
            ...transactions.map(
              (transaction) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: TransactionListCard(
                  transaction: transaction,
                  walletNameResolver: resolveWalletName,
                  onTap: () => context.push(
                    AppRoutes.transactionDetailsLocation(transaction.id),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

String _filterLabel(BuildContext context, TransactionFilterOption option) {
  switch (option) {
    case TransactionFilterOption.all:
      return context.tr.allTypes;
    case TransactionFilterOption.deposit:
      return context.tr.deposits;
    case TransactionFilterOption.withdraw:
      return context.tr.withdrawals;
    case TransactionFilterOption.transfer:
      return context.tr.transfers;
    case TransactionFilterOption.exchange:
      return context.tr.exchanges;
  }
}

String _sortLabel(BuildContext context, TransactionSortOption option) {
  switch (option) {
    case TransactionSortOption.newest:
      return context.tr.newest;
    case TransactionSortOption.oldest:
      return context.tr.oldest;
    case TransactionSortOption.highestAmount:
      return context.tr.highestAmount;
    case TransactionSortOption.lowestAmount:
      return context.tr.lowestAmount;
  }
}
