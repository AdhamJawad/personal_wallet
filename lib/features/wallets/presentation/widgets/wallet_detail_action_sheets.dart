import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/presentation/widgets/app_modal_bottom_sheet.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../dashboard/presentation/widgets/dashboard_surface_card.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../../transactions/presentation/widgets/transaction_form_text_field.dart';
import '../../../transactions/presentation/widgets/transaction_form_validators.dart';
import '../providers/wallet_providers.dart';

Future<void> showWalletDepositSheet(
  BuildContext context, {
  required String walletId,
  required String walletName,
}) {
  return showAppModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return _WalletTransactionSheet(
        walletId: walletId,
        walletName: walletName,
        mode: _WalletActionSheetMode.deposit,
      );
    },
  );
}

Future<void> showWalletWithdrawSheet(
  BuildContext context, {
  required String walletId,
  required String walletName,
}) {
  return showAppModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return _WalletTransactionSheet(
        walletId: walletId,
        walletName: walletName,
        mode: _WalletActionSheetMode.withdraw,
      );
    },
  );
}

Future<void> showWalletExchangeSheet(
  BuildContext context, {
  required String walletId,
  required String walletName,
}) {
  return showAppModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return _WalletTransactionSheet(
        walletId: walletId,
        walletName: walletName,
        mode: _WalletActionSheetMode.exchange,
      );
    },
  );
}

Future<void> showEditWalletSheet(
  BuildContext context, {
  required String walletId,
}) {
  return showAppModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return _EditWalletSheet(walletId: walletId);
    },
  );
}

enum _WalletActionSheetMode { deposit, withdraw, exchange }

class _WalletTransactionSheet extends ConsumerStatefulWidget {
  const _WalletTransactionSheet({
    required this.walletId,
    required this.walletName,
    required this.mode,
  });

  final String walletId;
  final String walletName;
  final _WalletActionSheetMode mode;

  @override
  ConsumerState<_WalletTransactionSheet> createState() =>
      _WalletTransactionSheetState();
}

class _WalletTransactionSheetState
    extends ConsumerState<_WalletTransactionSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _attachmentController = TextEditingController();
  final TextEditingController _exchangeRateController = TextEditingController();
  final TextEditingController _amountReceivedController =
      TextEditingController();

  Currency _currency = Currency.usd;
  Currency _sourceCurrency = Currency.usd;
  Currency _destinationCurrency = Currency.syp;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _attachmentController.dispose();
    _exchangeRateController.dispose();
    _amountReceivedController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    bool success = false;

    switch (widget.mode) {
      case _WalletActionSheetMode.deposit:
        success = await ref
            .read(transactionControllerProvider.notifier)
            .createDeposit(
              walletId: widget.walletId,
              currency: _currency,
              amount: _amountController.text.trim(),
              note: _nullableText(_noteController),
              attachmentLabel: _nullableText(_attachmentController),
            );
      case _WalletActionSheetMode.withdraw:
        success = await ref
            .read(transactionControllerProvider.notifier)
            .createWithdraw(
              walletId: widget.walletId,
              currency: _currency,
              amount: _amountController.text.trim(),
              note: _nullableText(_noteController),
              attachmentLabel: _nullableText(_attachmentController),
            );
      case _WalletActionSheetMode.exchange:
        if (_sourceCurrency == _destinationCurrency) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Source and destination currencies must be different.',
              ),
            ),
          );
          return;
        }

        success = await ref
            .read(transactionControllerProvider.notifier)
            .createExchange(
              walletId: widget.walletId,
              sourceCurrency: _sourceCurrency,
              destinationCurrency: _destinationCurrency,
              amountGiven: _amountController.text.trim(),
              exchangeRate: _exchangeRateController.text.trim(),
              amountReceived: _amountReceivedController.text.trim(),
              note: _nullableText(_noteController),
              attachmentLabel: _nullableText(_attachmentController),
            );
    }

    if (!mounted) {
      return;
    }

    if (success) {
      ref.read(walletControllerProvider.notifier).initialize();
      Navigator.of(context).pop();
      return;
    }

    final String fallback = switch (widget.mode) {
      _WalletActionSheetMode.deposit => 'Failed to create deposit.',
      _WalletActionSheetMode.withdraw => 'Failed to create withdrawal.',
      _WalletActionSheetMode.exchange => 'Failed to create exchange.',
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ref.read(transactionControllerProvider).errorMessage ?? fallback,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isLoading = ref.watch(transactionControllerProvider).isLoading;
    final String title = switch (widget.mode) {
      _WalletActionSheetMode.deposit => 'Create Deposit',
      _WalletActionSheetMode.withdraw => 'Create Withdraw',
      _WalletActionSheetMode.exchange => 'Create Exchange',
    };
    final String helper = switch (widget.mode) {
      _WalletActionSheetMode.deposit =>
        'Record a new deposit directly into this wallet.',
      _WalletActionSheetMode.withdraw =>
        'Record a withdrawal from this wallet.',
      _WalletActionSheetMode.exchange =>
        'Exchange balances within this wallet.',
    };

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
        ),
        child: DashboardSurfaceCard(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    helper,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SheetValueCard(label: 'Wallet', value: widget.walletName),
                  const SizedBox(height: AppSpacing.md),
                  if (widget.mode ==
                      _WalletActionSheetMode.exchange) ...<Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: DropdownButtonFormField<Currency>(
                            initialValue: _sourceCurrency,
                            decoration: const InputDecoration(
                              labelText: 'Source currency',
                            ),
                            items: Currency.values
                                .map(
                                  (currency) => DropdownMenuItem(
                                    value: currency,
                                    child: Text(currency.name.toUpperCase()),
                                  ),
                                )
                                .toList(growable: false),
                            onChanged: isLoading
                                ? null
                                : (Currency? value) {
                                    if (value != null) {
                                      setState(() => _sourceCurrency = value);
                                    }
                                  },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: DropdownButtonFormField<Currency>(
                            initialValue: _destinationCurrency,
                            decoration: const InputDecoration(
                              labelText: 'Destination currency',
                            ),
                            items: Currency.values
                                .map(
                                  (currency) => DropdownMenuItem(
                                    value: currency,
                                    child: Text(currency.name.toUpperCase()),
                                  ),
                                )
                                .toList(growable: false),
                            onChanged: isLoading
                                ? null
                                : (Currency? value) {
                                    if (value != null) {
                                      setState(
                                        () => _destinationCurrency = value,
                                      );
                                    }
                                  },
                          ),
                        ),
                      ],
                    ),
                  ] else
                    DropdownButtonFormField<Currency>(
                      initialValue: _currency,
                      decoration: const InputDecoration(labelText: 'Currency'),
                      items: Currency.values
                          .map(
                            (currency) => DropdownMenuItem(
                              value: currency,
                              child: Text(currency.name.toUpperCase()),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: isLoading
                          ? null
                          : (Currency? value) {
                              if (value != null) {
                                setState(() => _currency = value);
                              }
                            },
                    ),
                  const SizedBox(height: AppSpacing.md),
                  TransactionFormTextField(
                    controller: _amountController,
                    label: widget.mode == _WalletActionSheetMode.exchange
                        ? 'Amount given'
                        : 'Amount',
                    keyboardType: TextInputType.number,
                    validator: amountValidator,
                  ),
                  if (widget.mode ==
                      _WalletActionSheetMode.exchange) ...<Widget>[
                    const SizedBox(height: AppSpacing.md),
                    TransactionFormTextField(
                      controller: _exchangeRateController,
                      label: 'Exchange rate',
                      keyboardType: TextInputType.number,
                      validator: amountValidator,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TransactionFormTextField(
                      controller: _amountReceivedController,
                      label: 'Amount received',
                      keyboardType: TextInputType.number,
                      validator: amountValidator,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  TransactionFormTextField(
                    controller: _noteController,
                    label: 'Note',
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TransactionFormTextField(
                    controller: _attachmentController,
                    label: 'Attachment label',
                    hint: 'receipt.jpg',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isLoading ? null : _submit,
                      child: Text(
                        isLoading
                            ? 'Saving...'
                            : switch (widget.mode) {
                                _WalletActionSheetMode.deposit =>
                                  'Save deposit',
                                _WalletActionSheetMode.withdraw =>
                                  'Save withdrawal',
                                _WalletActionSheetMode.exchange =>
                                  'Save exchange',
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EditWalletSheet extends ConsumerStatefulWidget {
  const _EditWalletSheet({required this.walletId});

  final String walletId;

  @override
  ConsumerState<_EditWalletSheet> createState() => _EditWalletSheetState();
}

class _EditWalletSheetState extends ConsumerState<_EditWalletSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool _didSeedName = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_handleNameChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_handleNameChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _handleNameChanged() {
    setState(() {});
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final bool success = await ref
        .read(walletControllerProvider.notifier)
        .renameSelectedWallet(_nameController.text);

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.of(context).pop();
      return;
    }

    final errorMessage = ref.read(walletControllerProvider).errorMessage;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage ?? 'Failed to save wallet.')),
    );
  }

  Future<void> _archive() async {
    final bool success = await ref
        .read(walletControllerProvider.notifier)
        .archiveSelectedWallet();

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.of(context).pop();
      return;
    }

    final errorMessage = ref.read(walletControllerProvider).errorMessage;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage ?? 'Failed to archive wallet.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final walletOverview = walletState.selectedWallet;
    final bool isLoading = walletState.isLoading;
    final String previewName = _nameController.text.trim().isEmpty
        ? walletOverview?.wallet.name ?? 'Wallet'
        : _nameController.text.trim();

    if (!_didSeedName &&
        walletOverview != null &&
        walletOverview.wallet.id == widget.walletId) {
      _nameController.text = walletOverview.wallet.name;
      _didSeedName = true;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
        ),
        child: DashboardSurfaceCard(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Edit Wallet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Update the wallet name or archive it when needed.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextFormField(
                    controller: _nameController,
                    enabled: !isLoading,
                    decoration: const InputDecoration(labelText: 'Wallet name'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Wallet name is required.';
                      }
                      if (value.trim().length < 3) {
                        return 'Wallet name must be at least 3 characters.';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _save(),
                  ),
                  if (walletOverview != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Preview',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _EditWalletPreviewCard(
                      walletName: previewName,
                      statusLabel: walletOverview.wallet.isArchived
                          ? 'Archived'
                          : 'Active',
                      indicatorColor: _sheetWalletIndicatorColor(
                        previewName,
                        walletOverview.wallet.id,
                      ),
                      usdAmount: walletOverview.balance.usdBalance.amount,
                      sypAmount: walletOverview.balance.sypBalance.amount,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isLoading ? null : _save,
                      child: Text(isLoading ? 'Saving...' : 'Save changes'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed:
                          walletOverview?.wallet.isArchived == true || isLoading
                          ? null
                          : _archive,
                      child: Text(
                        walletOverview?.wallet.isArchived == true
                            ? 'Wallet archived'
                            : 'Archive wallet',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetValueCard extends StatelessWidget {
  const _SheetValueCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditWalletPreviewCard extends StatelessWidget {
  const _EditWalletPreviewCard({
    required this.walletName,
    required this.statusLabel,
    required this.indicatorColor,
    required this.usdAmount,
    required this.sypAmount,
  });

  final String walletName;
  final String statusLabel;
  final Color indicatorColor;
  final String usdAmount;
  final String sypAmount;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  walletName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusLabel == 'Active'
                      ? colorScheme.primary.withValues(alpha: 0.10)
                      : colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.50,
                        ),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  statusLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: statusLabel == 'Active'
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'USD ${usdAmount.trim().isEmpty ? '0' : usdAmount}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'SYP ${sypAmount.trim().isEmpty ? '0' : sypAmount}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

String? _nullableText(TextEditingController controller) {
  final String value = controller.text.trim();
  return value.isEmpty ? null : value;
}

Color _sheetWalletIndicatorColor(String walletName, String walletId) {
  final String normalized = walletName.toLowerCase();

  if (normalized.contains('home') || normalized.contains('main')) {
    return const Color(0xFF0E5A8A);
  }
  if (normalized.contains('saving')) {
    return const Color(0xFF1E8E5A);
  }
  if (normalized.contains('business')) {
    return const Color(0xFFCC7A00);
  }
  if (normalized.contains('travel')) {
    return const Color(0xFF7A52C7);
  }

  const List<Color> palette = <Color>[
    Color(0xFF0E5A8A),
    Color(0xFF1E8E5A),
    Color(0xFFCC7A00),
    Color(0xFF7A52C7),
    Color(0xFF0097A7),
  ];

  return palette[walletId.hashCode.abs() % palette.length];
}
