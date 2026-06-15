import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/presentation/providers/app_preferences_provider.dart';
import '../../../../app/presentation/widgets/app_modal_bottom_sheet.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../../features/attachments/domain/models/attachment_draft.dart';
import '../../../../features/attachments/domain/models/attachment_reference.dart';
import '../../../../features/attachments/domain/enums/attachment_reference_type.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../attachments/presentation/providers/attachment_providers.dart';
import '../../../wallets/domain/models/wallet_overview.dart';
import '../../../wallets/presentation/providers/wallet_providers.dart';
import '../../domain/models/ledger_transaction.dart';
import '../providers/transaction_providers.dart';
import 'transaction_attachment_picker.dart';
import 'transaction_flow_support.dart';
import 'transaction_form_validators.dart';

enum TransactionOperationType { deposit, withdraw, exchange }

class TransactionOperationFlow extends ConsumerStatefulWidget {
  const TransactionOperationFlow({
    required this.operationType,
    this.onCloseRequested,
    this.embeddedInSheet = false,
    this.keyboardInset = 0,
    this.initialWalletId,
    super.key,
  });

  final TransactionOperationType operationType;
  final VoidCallback? onCloseRequested;
  final bool embeddedInSheet;
  final double keyboardInset;
  final String? initialWalletId;

  @override
  ConsumerState<TransactionOperationFlow> createState() =>
      _TransactionOperationFlowState();
}

class _TransactionOperationFlowState
    extends ConsumerState<TransactionOperationFlow> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _exchangeRateController = TextEditingController();
  final TextEditingController _amountReceivedController =
      TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final GlobalKey _amountFieldKey = GlobalKey();
  final GlobalKey _amountReceivedFieldKey = GlobalKey();
  final GlobalKey _exchangeRateFieldKey = GlobalKey();
  final GlobalKey _noteFieldKey = GlobalKey();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _amountReceivedFocusNode = FocusNode();
  final FocusNode _exchangeRateFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();
  final List<TransactionAttachmentDraft> _attachments =
      <TransactionAttachmentDraft>[];

  String? _walletId;
  Currency _primaryCurrency = Currency.usd;
  Currency _secondaryCurrency = Currency.syp;
  bool _showReview = false;
  bool _showSuccess = false;
  String? _walletError;
  String? _exchangeError;
  String? _attachmentWarning;

  bool get _isExchange =>
      widget.operationType == TransactionOperationType.exchange;

  @override
  void initState() {
    super.initState();
    final preferences = ref.read(appPreferencesProvider);
    _walletId = widget.initialWalletId;
    _primaryCurrency = preferences.defaultCurrency;
    _secondaryCurrency = preferences.secondaryCurrency;
    _amountFocusNode.addListener(
      () => _handleFocusChange(_amountFocusNode, _amountFieldKey),
    );
    _amountReceivedFocusNode.addListener(
      () =>
          _handleFocusChange(_amountReceivedFocusNode, _amountReceivedFieldKey),
    );
    _exchangeRateFocusNode.addListener(
      () => _handleFocusChange(_exchangeRateFocusNode, _exchangeRateFieldKey),
    );
    _noteFocusNode.addListener(
      () => _handleFocusChange(_noteFocusNode, _noteFieldKey),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _exchangeRateController.dispose();
    _amountReceivedController.dispose();
    _noteController.dispose();
    _amountFocusNode.dispose();
    _amountReceivedFocusNode.dispose();
    _exchangeRateFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  String _currencyLabel(Currency currency) => currency.name.toUpperCase();

  void _handleFocusChange(FocusNode focusNode, GlobalKey fieldKey) {
    if (!focusNode.hasFocus) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !focusNode.hasFocus) {
          return;
        }

        final BuildContext? fieldContext = fieldKey.currentContext;
        if (fieldContext == null) {
          return;
        }

        Scrollable.ensureVisible(
          fieldContext,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          alignment: 0.18,
        );
      });
    });
  }

  String get _title => switch (widget.operationType) {
    TransactionOperationType.deposit => context.tr.deposit,
    TransactionOperationType.withdraw => context.tr.withdraw,
    TransactionOperationType.exchange => context.tr.exchange,
  };

  String get _continueLabel => context.tr.continueReview;

  String get _confirmLabel => switch (widget.operationType) {
    TransactionOperationType.deposit => context.tr.confirmDeposit,
    TransactionOperationType.withdraw => context.tr.confirmWithdrawal,
    TransactionOperationType.exchange => context.tr.confirmExchange,
  };

  String get _successMessage => switch (widget.operationType) {
    TransactionOperationType.deposit => context.tr.depositSuccessMessage,
    TransactionOperationType.withdraw => context.tr.withdrawSuccessMessage,
    TransactionOperationType.exchange => context.tr.exchangeSuccessMessage,
  };

  Future<void> _selectWallet(List<WalletOverview> wallets) async {
    final String? result = await showAppModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _PickerSheet<String>(
          title: context.tr.selectWallet,
          items: wallets
              .map(
                (WalletOverview wallet) => _PickerItem<String>(
                  value: wallet.wallet.id,
                  title: wallet.wallet.name,
                  subtitle: context.tr.walletBalanceSummary(
                    AmountFormatter.format(wallet.balance.usdBalance.amount),
                    AmountFormatter.format(wallet.balance.sypBalance.amount),
                  ),
                ),
              )
              .toList(growable: false),
        );
      },
    );

    if (result != null) {
      setState(() {
        _walletId = result;
        _walletError = null;
      });
    }
  }

  List<SelectionChipOption<Currency>> get _currencyOptions => Currency.values
      .map(
        (Currency currency) => SelectionChipOption<Currency>(
          value: currency,
          label: _currencyLabel(currency),
        ),
      )
      .toList(growable: false);

  void _setCurrency(Currency currency, {required bool primary}) {
    setState(() {
      if (primary) {
        _primaryCurrency = currency;
      } else {
        _secondaryCurrency = currency;
      }
      _exchangeError = null;
    });
  }

  Future<void> _addAttachment() async {
    final TransactionAttachmentDraft? attachment =
        await showTransactionAttachmentSourceSheet(context: context);
    if (attachment != null) {
      setState(() => _attachments.add(attachment));
    }
  }

  bool _validateForReview() {
    final bool isFormValid = _formKey.currentState?.validate() ?? false;
    final bool hasWallet = _walletId != null;
    final bool exchangeCurrenciesValid =
        !_isExchange || _primaryCurrency != _secondaryCurrency;

    setState(() {
      _walletError = hasWallet ? null : context.tr.walletRequired;
      _exchangeError = exchangeCurrenciesValid
          ? null
          : context.tr.sourceDestinationDifferent;
    });

    return isFormValid && hasWallet && exchangeCurrenciesValid;
  }

  Future<void> _confirm() async {
    final notifier = ref.read(transactionControllerProvider.notifier);
    bool success = false;

    switch (widget.operationType) {
      case TransactionOperationType.deposit:
        success = await notifier.createDeposit(
          walletId: _walletId!,
          currency: _primaryCurrency,
          amount: _amountController.text.trim(),
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
          attachmentLabel: _attachmentLabel,
        );
        break;
      case TransactionOperationType.withdraw:
        success = await notifier.createWithdraw(
          walletId: _walletId!,
          currency: _primaryCurrency,
          amount: _amountController.text.trim(),
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
          attachmentLabel: _attachmentLabel,
        );
        break;
      case TransactionOperationType.exchange:
        success = await notifier.createExchange(
          walletId: _walletId!,
          sourceCurrency: _primaryCurrency,
          destinationCurrency: _secondaryCurrency,
          amountGiven: _amountController.text.trim(),
          exchangeRate: _exchangeRateController.text.trim(),
          amountReceived: _amountReceivedController.text.trim(),
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
          attachmentLabel: _attachmentLabel,
        );
        break;
    }

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(transactionControllerProvider).errorMessage ??
                context.tr.transactionSubmitFailed,
          ),
        ),
      );
      return;
    }

    await ref.read(walletControllerProvider.notifier).initialize();
    await _persistAttachments();

    if (!mounted) {
      return;
    }

    setState(() => _showSuccess = true);
  }

  String? get _attachmentLabel => _attachments.isEmpty
      ? null
      : _attachments
            .map((TransactionAttachmentDraft item) => item.fileName)
            .join(', ');

  Future<void> _persistAttachments() async {
    _attachmentWarning = null;
    if (_attachments.isEmpty) {
      return;
    }

    final LedgerTransaction? transaction = ref
        .read(transactionControllerProvider)
        .selectedTransaction;
    if (transaction == null) {
      return;
    }

    final bool saved = await ref
        .read(attachmentControllerProvider.notifier)
        .createAttachments(
          reference: AttachmentReference(
            entityType: AttachmentReferenceType.transaction,
            entityId: transaction.id,
            label: context.tr.transactionReferenceLabel(
              _title,
              transaction.reference.value,
            ),
          ),
          drafts: _attachments
              .map(
                (TransactionAttachmentDraft item) => AttachmentDraft(
                  kind: item.kind,
                  fileName: item.fileName,
                  localUri: item.localUri,
                  mimeType: item.mimeType,
                  byteSize: item.byteSize,
                ),
              )
              .toList(growable: false),
        );

    if (!saved && mounted) {
      setState(() {
        _attachmentWarning = context.tr.transactionAttachmentSaveFailed;
      });
    }
  }

  void _resetFlow() {
    final preferences = ref.read(appPreferencesProvider);
    setState(() {
      _showSuccess = false;
      _showReview = false;
      _walletError = null;
      _exchangeError = null;
      _attachmentWarning = null;
      _walletId = null;
      _primaryCurrency = preferences.defaultCurrency;
      _secondaryCurrency = preferences.secondaryCurrency;
      _attachments.clear();
      _amountController.clear();
      _exchangeRateController.clear();
      _amountReceivedController.clear();
      _noteController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final transactionState = ref.watch(transactionControllerProvider);
    final List<WalletOverview> wallets = walletState.wallets
        .where((WalletOverview item) => !item.wallet.isArchived)
        .toList(growable: false);
    if (_walletId != null &&
        wallets.every((WalletOverview item) => item.wallet.id != _walletId)) {
      _walletId = null;
    }
    final WalletOverview? selectedWallet = wallets
        .cast<WalletOverview?>()
        .firstWhere(
          (WalletOverview? item) => item?.wallet.id == _walletId,
          orElse: () => null,
        );

    if (_showSuccess) {
      return _buildSuccess(selectedWallet);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: _showReview
          ? _buildReview(selectedWallet, transactionState.isLoading)
          : _buildForm(
              walletState.isLoading,
              transactionState.isLoading,
              wallets,
              selectedWallet,
            ),
    );
  }

  Widget _buildForm(
    bool isWalletLoading,
    bool isSubmitting,
    List<WalletOverview> wallets,
    WalletOverview? selectedWallet,
  ) {
    final double gap = widget.embeddedInSheet ? AppSpacing.sm : AppSpacing.md;

    if (isWalletLoading) {
      return const TransactionFormSkeleton();
    }

    if (wallets.isEmpty) {
      return TransactionEmptyState(
        icon: Icons.account_balance_wallet_outlined,
        title: context.tr.noTransactionWalletsTitle,
        message: context.tr.noTransactionWalletsMessage,
        action: PwButton.primary(
          label: context.tr.createWallet,
          onPressed: widget.onCloseRequested,
        ),
      );
    }

    return TransactionFlowLayout(
      compact: widget.embeddedInSheet,
      extraScrollBottomSpacing: widget.embeddedInSheet
          ? (widget.keyboardInset > 0
                ? widget.keyboardInset + AppSpacing.sm
                : 0)
          : 0,
      primaryLabel: _continueLabel,
      onPrimaryPressed: isSubmitting
          ? null
          : () {
              if (_validateForReview()) {
                setState(() => _showReview = true);
              }
            },
      isPrimaryLoading: isSubmitting,
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TransactionFormSection(
              title: _title,
              compact: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TransactionPickerField(
                    label: context.tr.wallet,
                    value: selectedWallet?.wallet.name,
                    hint: context.tr.walletPickerHint,
                    errorText: _walletError,
                    onTap: () => _selectWallet(wallets),
                  ),
                  SizedBox(height: gap),
                  if (_isExchange) ...<Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: KeyedSubtree(
                            key: _amountFieldKey,
                            child: PwTextField(
                              controller: _amountController,
                              focusNode: _amountFocusNode,
                              label: context.tr.amountGiven,
                              hint: context.tr.enterAmountHint,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              textInputAction: TextInputAction.next,
                              validator: (String? value) =>
                                  amountValidator(context, value),
                              onFieldSubmitted: (_) {
                                _amountReceivedFocusNode.requestFocus();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        CurrencyChip(
                          value: _primaryCurrency,
                          label: _currencyLabel(_primaryCurrency),
                          options: _currencyOptions,
                          onSelected: (Currency value) {
                            _setCurrency(value, primary: true);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: gap),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: KeyedSubtree(
                            key: _amountReceivedFieldKey,
                            child: PwTextField(
                              controller: _amountReceivedController,
                              focusNode: _amountReceivedFocusNode,
                              label: context.tr.amountReceived,
                              hint: context.tr.enterAmountHint,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              textInputAction: TextInputAction.next,
                              validator: (String? value) =>
                                  amountValidator(context, value),
                              onFieldSubmitted: (_) {
                                _exchangeRateFocusNode.requestFocus();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        CurrencyChip(
                          value: _secondaryCurrency,
                          label: _currencyLabel(_secondaryCurrency),
                          options: _currencyOptions,
                          onSelected: (Currency value) {
                            _setCurrency(value, primary: false);
                          },
                        ),
                      ],
                    ),
                    if (_exchangeError != null) ...<Widget>[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _exchangeError!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    SizedBox(height: gap),
                    KeyedSubtree(
                      key: _exchangeRateFieldKey,
                      child: PwTextField(
                        controller: _exchangeRateController,
                        focusNode: _exchangeRateFocusNode,
                        label: context.tr.exchangeRate,
                        hint: context.tr.enterExchangeRateHint,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (String? value) =>
                            amountValidator(context, value),
                        onFieldSubmitted: (_) {
                          _noteFocusNode.requestFocus();
                        },
                      ),
                    ),
                  ] else ...<Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: KeyedSubtree(
                            key: _amountFieldKey,
                            child: PwTextField(
                              controller: _amountController,
                              focusNode: _amountFocusNode,
                              label: context.tr.amount,
                              hint: context.tr.enterAmountHint,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              textInputAction: TextInputAction.next,
                              validator: (String? value) =>
                                  amountValidator(context, value),
                              onFieldSubmitted: (_) {
                                _noteFocusNode.requestFocus();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        CurrencyChip(
                          value: _primaryCurrency,
                          label: _currencyLabel(_primaryCurrency),
                          options: _currencyOptions,
                          onSelected: (Currency value) {
                            _setCurrency(value, primary: true);
                          },
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: gap),
                  KeyedSubtree(
                    key: _noteFieldKey,
                    child: PwTextField(
                      controller: _noteController,
                      focusNode: _noteFocusNode,
                      label: context.tr.note,
                      hint: context.tr.transactionNoteHint,
                      maxLines: 2,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  SizedBox(height: gap),
                  AttachmentCompactField(
                    label: context.tr.addAttachment,
                    value: transactionAttachmentSummary(
                      context,
                      _attachments.length,
                      fileName: _attachments.isEmpty
                          ? null
                          : _attachments.first.fileName,
                    ),
                    onTap: _addAttachment,
                    thumbnails: _attachmentThumbnails(context),
                  ),
                  if (_attachments.isNotEmpty) ...<Widget>[
                    SizedBox(
                      height: widget.embeddedInSheet
                          ? AppSpacing.xs
                          : AppSpacing.sm,
                    ),
                    TransactionAttachmentList(
                      attachments: _attachments,
                      onRemove: (TransactionAttachmentDraft attachment) {
                        setState(() => _attachments.remove(attachment));
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReview(WalletOverview? selectedWallet, bool isSubmitting) {
    if (selectedWallet == null) {
      return const TransactionReviewSkeleton();
    }

    return TransactionFlowLayout(
      compact: widget.embeddedInSheet,
      primaryLabel: _confirmLabel,
      onPrimaryPressed: isSubmitting ? null : _confirm,
      secondaryLabel: context.tr.back,
      onSecondaryPressed: isSubmitting
          ? null
          : () => setState(() => _showReview = false),
      isPrimaryLoading: isSubmitting,
      content: TransactionFormSection(
        title: context.tr.review,
        compact: true,
        child: Column(
          children: <Widget>[
            TransactionSummaryRow(
              label: context.tr.wallet,
              value: selectedWallet.wallet.name,
            ),
            if (_isExchange) ...<Widget>[
              TransactionSummaryRow(
                label: context.tr.amountGiven,
                value:
                    '${AmountFormatter.format(_amountController.text.trim())} ${_currencyLabel(_primaryCurrency)}',
              ),
              TransactionSummaryRow(
                label: context.tr.amountReceived,
                value:
                    '${AmountFormatter.format(_amountReceivedController.text.trim())} ${_currencyLabel(_secondaryCurrency)}',
              ),
              TransactionSummaryRow(
                label: context.tr.exchangeRate,
                value: _exchangeRateController.text.trim(),
              ),
            ] else ...<Widget>[
              TransactionSummaryRow(
                label: context.tr.amount,
                value:
                    '${AmountFormatter.format(_amountController.text.trim())} ${_currencyLabel(_primaryCurrency)}',
              ),
            ],
            TransactionSummaryRow(
              label: context.tr.note,
              value: _noteController.text.trim().isEmpty
                  ? context.tr.noDescriptionAdded
                  : _noteController.text.trim(),
            ),
            TransactionSummaryRow(
              label: context.tr.attachments,
              value: _attachments.isEmpty
                  ? context.tr.noAttachments
                  : context.tr.attachmentsSelected(_attachments.length),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess(WalletOverview? selectedWallet) {
    return TransactionSuccessState(
      compact: widget.embeddedInSheet,
      title: context.tr.success,
      message: _attachmentWarning ?? _successMessage,
      primaryLabel: context.tr.done,
      secondaryLabel: context.tr.returnAction,
      onPrimaryPressed:
          widget.onCloseRequested ?? () => Navigator.of(context).pop(),
      onSecondaryPressed: _resetFlow,
      summary: Column(
        children: <Widget>[
          if (selectedWallet != null)
            TransactionSummaryRow(
              label: context.tr.wallet,
              value: selectedWallet.wallet.name,
            ),
          TransactionSummaryRow(
            label: _isExchange ? context.tr.amountGiven : context.tr.amount,
            value:
                '${AmountFormatter.format(_amountController.text.trim())} ${_currencyLabel(_primaryCurrency)}',
          ),
          if (_isExchange)
            TransactionSummaryRow(
              label: context.tr.amountReceived,
              value:
                  '${AmountFormatter.format(_amountReceivedController.text.trim())} ${_currencyLabel(_secondaryCurrency)}',
            ),
          TransactionSummaryRow(
            label: context.tr.note,
            value: _noteController.text.trim().isEmpty
                ? context.tr.noDescriptionAdded
                : _noteController.text.trim(),
          ),
        ],
      ),
    );
  }

  List<Widget> _attachmentThumbnails(BuildContext context) {
    return _attachments
        .take(3)
        .map(
          (TransactionAttachmentDraft attachment) => Padding(
            padding: const EdgeInsetsDirectional.only(start: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(
                attachment.bytes,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
        .toList(growable: false);
  }
}

class _PickerSheet<T> extends StatelessWidget {
  const _PickerSheet({required this.title, required this.items});

  final String title;
  final List<_PickerItem<T>> items;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (BuildContext context, int index) {
                  final _PickerItem<T> item = items[index];
                  return ListTile(
                    onTap: () => Navigator.of(context).pop(item.value),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    tileColor: Theme.of(context).colorScheme.surface,
                    title: Text(item.title),
                    subtitle: item.subtitle == null
                        ? null
                        : Text(item.subtitle!),
                    trailing: const Icon(Icons.chevron_right_rounded),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerItem<T> {
  const _PickerItem({required this.value, required this.title, this.subtitle});

  final T value;
  final String title;
  final String? subtitle;
}
