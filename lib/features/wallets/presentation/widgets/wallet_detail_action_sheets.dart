import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_wallet/l10n/app_localizations.dart';

import '../../../../app/presentation/widgets/app_modal_bottom_sheet.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../dashboard/presentation/widgets/dashboard_surface_card.dart';
import '../../../transactions/presentation/widgets/transaction_bottom_sheet.dart';
import '../../../transactions/presentation/widgets/transaction_operation_flow.dart';
import '../providers/wallet_providers.dart';

Future<void> showWalletDepositSheet(
  BuildContext context, {
  required String walletId,
  required String walletName,
}) {
  return showTransactionBottomSheet(
    context,
    type: TransactionOperationType.deposit,
    initialWalletId: walletId,
  );
}

Future<void> showWalletWithdrawSheet(
  BuildContext context, {
  required String walletId,
  required String walletName,
}) {
  return showTransactionBottomSheet(
    context,
    type: TransactionOperationType.withdraw,
    initialWalletId: walletId,
  );
}

Future<void> showWalletExchangeSheet(
  BuildContext context, {
  required String walletId,
  required String walletName,
}) {
  return showTransactionBottomSheet(
    context,
    type: TransactionOperationType.exchange,
    initialWalletId: walletId,
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
      SnackBar(content: Text(errorMessage ?? context.tr.failedSaveWallet)),
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
      SnackBar(content: Text(errorMessage ?? context.tr.failedArchiveWallet)),
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
                    context.tr.editWallet,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    context.tr.editWalletHelper,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextFormField(
                    controller: _nameController,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      labelText: context.tr.walletNameLabel,
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.tr.walletNameRequired;
                      }
                      if (value.trim().length < 3) {
                        return context.tr.walletNameTooShort;
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _save(),
                  ),
                  if (walletOverview != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      context.tr.walletPreview,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _EditWalletPreviewCard(
                      walletName: previewName,
                      statusLabel: walletOverview.wallet.isArchived
                          ? context.tr.archived
                          : context.tr.active,
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
                      child: Text(
                        isLoading ? context.tr.saving : context.tr.saveChanges,
                      ),
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
                            ? context.tr.walletArchivedLabel
                            : context.tr.archiveWallet,
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
                  color: statusLabel == AppLocalizations.of(context)!.active
                      ? colorScheme.primary.withValues(alpha: 0.10)
                      : colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.50,
                        ),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  statusLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: statusLabel == AppLocalizations.of(context)!.active
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
            '${AppLocalizations.of(context)!.usdShort} ${usdAmount.trim().isEmpty ? '0' : usdAmount}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${AppLocalizations.of(context)!.sypShort} ${sypAmount.trim().isEmpty ? '0' : sypAmount}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
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
