import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../../features/attachments/domain/models/attachment_draft.dart';
import '../../../../features/attachments/domain/models/attachment_reference.dart';
import '../../../../features/attachments/domain/enums/attachment_reference_type.dart';
import '../../../../shared/domain/enums/contact_kind.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../attachments/presentation/providers/attachment_providers.dart';
import '../../../contacts/domain/models/contact.dart';
import '../../../contacts/presentation/providers/contact_providers.dart';
import '../../../qr/domain/models/qr_identity.dart';
import '../../../qr/presentation/providers/qr_providers.dart';
import '../../../transactions/presentation/widgets/transaction_attachment_picker.dart';
import '../../../transactions/presentation/widgets/transaction_flow_support.dart';
import '../../../transactions/presentation/widgets/transaction_form_validators.dart';
import '../../../wallets/domain/models/wallet_overview.dart';
import '../../../wallets/presentation/providers/wallet_providers.dart';
import '../../domain/models/transfer_summary.dart';
import '../providers/transfer_providers.dart';
import '../widgets/transfer_page_shell.dart';

enum _RecipientMethod { qr, contacts, manual }

class TransferPage extends ConsumerStatefulWidget {
  const TransferPage({
    this.preselectedRecipientUserId,
    this.preselectedRecipientName,
    super.key,
  });

  final String? preselectedRecipientUserId;
  final String? preselectedRecipientName;

  @override
  ConsumerState<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends ConsumerState<TransferPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _manualUserIdController = TextEditingController();
  final TextEditingController _manualNameController = TextEditingController();
  final FocusNode _manualUserIdFocusNode = FocusNode();
  final FocusNode _manualNameFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();
  final List<TransactionAttachmentDraft> _attachments =
      <TransactionAttachmentDraft>[];

  _RecipientMethod _recipientMethod = _RecipientMethod.contacts;
  String? _senderWalletId;
  String? _recipientUserId;
  String? _recipientDisplayName;
  String? _recipientError;
  Currency _currency = Currency.usd;
  bool _showReview = false;
  bool _showSuccess = false;
  bool _isRouteReversed = false;
  String? _attachmentWarning;

  @override
  void initState() {
    super.initState();
    _recipientUserId = widget.preselectedRecipientUserId;
    _recipientDisplayName = widget.preselectedRecipientName;
    _manualUserIdController.text = widget.preselectedRecipientUserId ?? '';
    _manualNameController.text = widget.preselectedRecipientName ?? '';
    if (_recipientUserId != null) {
      _recipientMethod = _RecipientMethod.manual;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _manualUserIdController.dispose();
    _manualNameController.dispose();
    _manualUserIdFocusNode.dispose();
    _manualNameFocusNode.dispose();
    _amountFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickWallet(List<WalletOverview> wallets) async {
    final WalletOverview? result = await showModalBottomSheet<WalletOverview>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _TransferPickerSheet<WalletOverview>(
          title: context.tr.selectWallet,
          items: wallets,
          titleBuilder: (WalletOverview wallet) => wallet.wallet.name,
          subtitleBuilder: (WalletOverview wallet) =>
              context.tr.walletBalanceSummary(
                AmountFormatter.format(wallet.balance.usdBalance.amount),
                AmountFormatter.format(wallet.balance.sypBalance.amount),
              ),
        );
      },
    );

    if (result != null) {
      setState(() {
        _senderWalletId = result.wallet.id;
      });
    }
  }

  Future<void> _pickContact(List<Contact> contacts) async {
    if (contacts.isEmpty) {
      return;
    }

    final Contact? result = await showModalBottomSheet<Contact>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _TransferPickerSheet<Contact>(
          title: context.tr.selectContact,
          items: contacts,
          titleBuilder: (Contact contact) => contact.name,
          subtitleBuilder: (Contact contact) =>
              contact.phoneNumber ?? contact.linkedUserId ?? '',
        );
      },
    );

    if (result != null) {
      setState(() {
        _recipientMethod = _RecipientMethod.contacts;
        _recipientUserId = result.linkedUserId;
        _recipientDisplayName = result.name;
        _recipientError = null;
      });
    }
  }

  Future<void> _pickQrIdentity(List<QrIdentity> identities) async {
    if (identities.isEmpty) {
      return;
    }

    final QrIdentity? result = await showModalBottomSheet<QrIdentity>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _TransferPickerSheet<QrIdentity>(
          title: context.tr.scanQrRecipient,
          items: identities,
          titleBuilder: (QrIdentity identity) => identity.displayName,
          subtitleBuilder: (QrIdentity identity) =>
              identity.publicReferenceIdentifier,
        );
      },
    );

    if (result != null) {
      setState(() {
        _recipientMethod = _RecipientMethod.qr;
        _recipientUserId = result.userId;
        _recipientDisplayName = result.displayName;
        _recipientError = null;
      });
    }
  }

  Future<void> _addAttachment() async {
    final TransactionAttachmentDraft? attachment =
        await showTransactionAttachmentSourceSheet(context: context);
    if (attachment != null) {
      setState(() => _attachments.add(attachment));
    }
  }

  bool _validateRecipient() {
    switch (_recipientMethod) {
      case _RecipientMethod.manual:
        final String userId = _manualUserIdController.text.trim();
        final String name = _manualNameController.text.trim();
        final bool isValid = userId.isNotEmpty && name.isNotEmpty;
        setState(() {
          _recipientUserId = userId.isEmpty ? null : userId;
          _recipientDisplayName = name.isEmpty ? null : name;
          _recipientError = isValid ? null : context.tr.transferRecipientRequired;
        });
        return isValid;
      case _RecipientMethod.contacts:
      case _RecipientMethod.qr:
        final bool isValid =
            _recipientUserId != null && _recipientDisplayName != null;
        setState(() {
          _recipientError = isValid ? null : context.tr.transferRecipientRequired;
        });
        return isValid;
    }
  }

  bool _validateForReview() {
    final bool isFormValid = _formKey.currentState?.validate() ?? false;
    final bool hasWallet = _senderWalletId != null;
    final bool hasRecipient = _validateRecipient();

    return isFormValid && hasWallet && hasRecipient;
  }

  Future<void> _confirmTransfer() async {
    final bool success = await ref
        .read(transferControllerProvider.notifier)
        .createTransfer(
          senderWalletId: _senderWalletId!,
          recipientUserId: _recipientUserId!,
          recipientDisplayName: _recipientDisplayName!,
          currency: _currency,
          amount: _amountController.text.trim(),
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(transferControllerProvider).errorMessage ??
                context.tr.failedCreateTransfer,
          ),
        ),
      );
      return;
    }

    await ref.read(walletControllerProvider.notifier).initialize();
    await ref.read(contactControllerProvider.notifier).initialize();
    await ref.read(qrControllerProvider.notifier).initialize();
    await _persistAttachments();

    if (!mounted) {
      return;
    }

    setState(() => _showSuccess = true);
  }

  Future<void> _persistAttachments() async {
    _attachmentWarning = null;
    if (_attachments.isEmpty) {
      return;
    }

    final TransferSummary? transfer =
        ref.read(transferControllerProvider).lastCompletedTransfer;
    if (transfer == null) {
      return;
    }

    final bool saved = await ref
        .read(attachmentControllerProvider.notifier)
        .createAttachments(
          reference: AttachmentReference(
            type: AttachmentReferenceType.transaction,
            entityId: transfer.transfer.ledgerTransactionId,
            label: context.tr.transactionReferenceLabel(
              context.tr.transfer,
              transfer.transfer.reference.value,
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
        _attachmentWarning = context.tr.transferAttachmentSaveFailed;
      });
    }
  }

  void _resetFlow() {
    setState(() {
      _showSuccess = false;
      _showReview = false;
      _senderWalletId = null;
      _recipientError = null;
      _attachmentWarning = null;
      _currency = Currency.usd;
      _recipientMethod = _RecipientMethod.contacts;
      _recipientUserId = null;
      _recipientDisplayName = null;
      _amountController.clear();
      _noteController.clear();
      _manualUserIdController.clear();
      _manualNameController.clear();
      _attachments.clear();
    });
    ref.read(transferControllerProvider.notifier).clearCompletionState();
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final contactState = ref.watch(contactControllerProvider);
    final qrState = ref.watch(qrControllerProvider);
    final transferState = ref.watch(transferControllerProvider);
    final List<WalletOverview> activeWallets = walletState.wallets
        .where((WalletOverview item) => !item.wallet.isArchived)
        .toList(growable: false);
    final List<Contact> registeredContacts = contactState.contacts
        .where(
          (Contact item) =>
              item.kind == ContactKind.registered && item.linkedUserId != null,
        )
        .toList(growable: false);
    final WalletOverview? selectedWallet = activeWallets
        .cast<WalletOverview?>()
        .firstWhere(
          (WalletOverview? item) => item?.wallet.id == _senderWalletId,
          orElse: () => null,
        );

    return TransferPageShell(
      title: context.tr.transfer,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: _showSuccess
            ? _buildSuccess(selectedWallet)
            : _showReview
                ? _buildReview(selectedWallet, transferState.isLoading)
                : _buildForm(
                    walletState.isLoading,
                    contactState.isLoading,
                    qrState.isLoading,
                    transferState.isLoading,
                    activeWallets,
                    registeredContacts,
                    qrState.knownIdentities.toList(growable: false),
                    selectedWallet,
                  ),
      ),
    );
  }

  Widget _buildForm(
    bool isWalletLoading,
    bool isContactLoading,
    bool isQrLoading,
    bool isSubmitting,
    List<WalletOverview> wallets,
    List<Contact> contacts,
    List<QrIdentity> identities,
    WalletOverview? selectedWallet,
  ) {
    if (isWalletLoading) {
      return const TransactionFormSkeleton();
    }

    if (wallets.isEmpty) {
      return TransactionEmptyState(
        icon: Icons.account_balance_wallet_outlined,
        title: context.tr.noTransactionWalletsTitle,
        message: context.tr.noTransferWalletsMessage,
      );
    }

    final List<SelectionChipOption<Currency>> currencyOptions = Currency.values
        .map(
          (Currency currency) => SelectionChipOption<Currency>(
            value: currency,
            label: currency.name.toUpperCase(),
          ),
        )
        .toList(growable: false);

    return TransactionFlowLayout(
      primaryLabel: context.tr.continueReview,
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
              title: context.tr.transferRecipientTitle,
              subtitle: context.tr.transferRecipientDescription,
              compact: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    context.tr.recipientMethodHint,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: _RecipientMethod.values
                        .map(
                          (_RecipientMethod method) => _CompactSelectionChip(
                            icon: _recipientMethodIcon(method),
                            label: _recipientMethodLabel(method),
                            selected: _recipientMethod == method,
                            onTap: () {
                              setState(() {
                                _recipientMethod = method;
                                _recipientError = null;
                              });
                            },
                          ),
                        )
                        .toList(growable: false),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (_recipientMethod == _RecipientMethod.qr)
                    isQrLoading
                        ? const TransactionSkeletonBlock(height: 56)
                        : identities.isEmpty
                            ? TransactionEmptyState(
                                icon: Icons.qr_code_scanner_outlined,
                                title: context.tr.noQrRecipientsTitle,
                                message: context.tr.noQrRecipientsMessage,
                              )
                            : TransactionPickerField(
                                label: context.tr.qrScan,
                                value: _recipientDisplayName,
                                hint: context.tr.scanRecipientHint,
                                errorText: _recipientError,
                                leading: const Icon(Icons.qr_code_scanner_rounded),
                                onTap: () => _pickQrIdentity(identities),
                              ),
                  if (_recipientMethod == _RecipientMethod.contacts)
                    isContactLoading
                        ? const TransactionSkeletonBlock(height: 56)
                        : contacts.isEmpty
                            ? TransactionEmptyState(
                                icon: Icons.contacts_outlined,
                                title: context.tr.noTransferContactsTitle,
                                message: context.tr.noTransferContactsMessage,
                              )
                            : TransactionPickerField(
                                label: context.tr.contacts,
                                value: _recipientDisplayName,
                                hint: context.tr.selectSavedContactHint,
                                errorText: _recipientError,
                                leading: const Icon(Icons.person_outline_rounded),
                                onTap: () => _pickContact(contacts),
                              ),
                  if (_recipientMethod == _RecipientMethod.manual) ...<Widget>[
                    PwTextField(
                      controller: _manualUserIdController,
                      focusNode: _manualUserIdFocusNode,
                      label: context.tr.recipientUserId,
                      hint: context.tr.enterRecipientUserIdHint,
                      prefixIcon: const Icon(Icons.badge_outlined),
                      textInputAction: TextInputAction.next,
                      validator: (String? value) {
                        if (_recipientMethod != _RecipientMethod.manual) {
                          return null;
                        }
                        if (value == null || value.trim().isEmpty) {
                          return context.tr.transferRecipientRequired;
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        _manualNameFocusNode.requestFocus();
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PwTextField(
                      controller: _manualNameController,
                      focusNode: _manualNameFocusNode,
                      label: context.tr.recipientName,
                      hint: context.tr.enterRecipientNameHint,
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      textInputAction: TextInputAction.next,
                      validator: (String? value) {
                        if (_recipientMethod != _RecipientMethod.manual) {
                          return null;
                        }
                        if (value == null || value.trim().isEmpty) {
                          return context.tr.transferRecipientRequired;
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        _amountFocusNode.requestFocus();
                      },
                    ),
                    if (_recipientError != null) ...<Widget>[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _recipientError!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TransactionFormSection(
              title: context.tr.transferRouteTitle,
              subtitle: context.tr.transferRouteDescription,
              compact: true,
              child: _TransferRouteFlow(
                isReversed: _isRouteReversed,
                sourceLabel: context.tr.transferRouteSourceLabel,
                destinationLabel: context.tr.transferRouteDestinationLabel,
                sourceValue: selectedWallet?.wallet.name,
                destinationValue: _recipientDisplayName,
                sourceHint: context.tr.transferRouteSourceHint,
                destinationHint: context.tr.transferRecipientPreviewHint,
                onSourceTap: () => _pickWallet(wallets),
                onSwapTap: () {
                  setState(() => _isRouteReversed = !_isRouteReversed);
                },
                swapLabel: context.tr.transferRouteSwap,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TransactionFormSection(
              title: context.tr.transferDetailsTitle,
              subtitle: context.tr.transferDetailsDescription,
              compact: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: PwTextField(
                          controller: _amountController,
                          focusNode: _amountFocusNode,
                          label: context.tr.amount,
                          hint: context.tr.enterAmountHint,
                          prefixIcon: const Icon(Icons.payments_outlined),
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          textInputAction: TextInputAction.next,
                          validator: (String? value) =>
                              amountValidator(context, value),
                          onFieldSubmitted: (_) {
                            _noteFocusNode.requestFocus();
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      CurrencyChip(
                        value: _currency,
                        label: _currency.name.toUpperCase(),
                        icon: Icons.currency_exchange_rounded,
                        options: currencyOptions,
                        onSelected: (Currency value) {
                          setState(() => _currency = value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PwTextField(
                    controller: _noteController,
                    focusNode: _noteFocusNode,
                    label: context.tr.note,
                    hint: context.tr.transactionNoteHint,
                    helper: context.tr.transactionNoteHint,
                    prefixIcon: const Icon(Icons.edit_note_rounded),
                    maxLines: 2,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AttachmentCompactField(
                    label: context.tr.addAttachment,
                    value: transactionAttachmentSummary(
                      context,
                      _attachments.length,
                      fileName:
                          _attachments.isEmpty ? null : _attachments.first.fileName,
                    ),
                    subtitle: context.tr.debtAttachmentHint,
                    onTap: _addAttachment,
                    thumbnails: _attachmentThumbnails(),
                  ),
                  if (_attachments.isNotEmpty) ...<Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    TransactionAttachmentList(
                      attachments: _attachments,
                      onRemove: (TransactionAttachmentDraft item) {
                        setState(() => _attachments.remove(item));
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
    if (selectedWallet == null || _recipientDisplayName == null) {
      return const TransactionReviewSkeleton();
    }

    return TransactionFlowLayout(
      primaryLabel: context.tr.confirmTransfer,
      onPrimaryPressed: isSubmitting ? null : _confirmTransfer,
      secondaryLabel: context.tr.back,
      onSecondaryPressed:
          isSubmitting ? null : () => setState(() => _showReview = false),
      isPrimaryLoading: isSubmitting,
      content: TransactionFormSection(
        title: context.tr.review,
        compact: true,
        child: Column(
          children: <Widget>[
            TransactionSummaryRow(
              label: context.tr.recipient,
              value: _recipientDisplayName!,
            ),
            TransactionSummaryRow(
              label: context.tr.recipientUserId,
              value: _recipientUserId ?? '',
            ),
            TransactionSummaryRow(
              label: context.tr.wallet,
              value: selectedWallet.wallet.name,
            ),
            TransactionSummaryRow(
              label: context.tr.amount,
              value:
                  '${AmountFormatter.format(_amountController.text.trim())} ${_currency.name.toUpperCase()}',
            ),
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
      title: context.tr.success,
      message: _attachmentWarning ?? context.tr.transferSuccessMessage,
      primaryLabel: context.tr.done,
      secondaryLabel: context.tr.returnAction,
      onPrimaryPressed: () => Navigator.of(context).pop(),
      onSecondaryPressed: _resetFlow,
      summary: Column(
        children: <Widget>[
          TransactionSummaryRow(
            label: context.tr.recipient,
            value: _recipientDisplayName ?? '',
          ),
          if (selectedWallet != null)
            TransactionSummaryRow(
              label: context.tr.wallet,
              value: selectedWallet.wallet.name,
            ),
          TransactionSummaryRow(
            label: context.tr.amount,
            value:
                '${AmountFormatter.format(_amountController.text.trim())} ${_currency.name.toUpperCase()}',
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

  List<Widget> _attachmentThumbnails() {
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

  String _recipientMethodLabel(_RecipientMethod method) {
    switch (method) {
      case _RecipientMethod.qr:
        return context.tr.qrScan;
      case _RecipientMethod.contacts:
        return context.tr.contacts;
      case _RecipientMethod.manual:
        return context.tr.manualEntry;
    }
  }

  IconData _recipientMethodIcon(_RecipientMethod method) {
    switch (method) {
      case _RecipientMethod.qr:
        return Icons.qr_code_scanner_rounded;
      case _RecipientMethod.contacts:
        return Icons.person_outline_rounded;
      case _RecipientMethod.manual:
        return Icons.edit_outlined;
    }
  }
}

class _TransferRouteFlow extends StatelessWidget {
  const _TransferRouteFlow({
    required this.isReversed,
    required this.sourceLabel,
    required this.destinationLabel,
    required this.sourceValue,
    required this.destinationValue,
    required this.sourceHint,
    required this.destinationHint,
    required this.onSourceTap,
    required this.onSwapTap,
    required this.swapLabel,
  });

  final bool isReversed;
  final String sourceLabel;
  final String destinationLabel;
  final String? sourceValue;
  final String? destinationValue;
  final String sourceHint;
  final String destinationHint;
  final VoidCallback onSourceTap;
  final VoidCallback onSwapTap;
  final String swapLabel;

  @override
  Widget build(BuildContext context) {
    final List<Widget> nodes = <Widget>[
      _RouteNode(
        label: sourceLabel,
        value: sourceValue,
        hint: sourceHint,
        icon: Icons.account_balance_wallet_outlined,
        onTap: onSourceTap,
        interactive: true,
      ),
      _TransferRouteSwapButton(label: swapLabel, onTap: onSwapTap),
      _RouteNode(
        label: destinationLabel,
        value: destinationValue,
        hint: destinationHint,
        icon: Icons.person_outline_rounded,
      ),
    ];

    return Column(
      children: (isReversed ? nodes.reversed : nodes).toList(growable: false),
    );
  }
}

class _RouteNode extends StatelessWidget {
  const _RouteNode({
    required this.label,
    required this.hint,
    required this.icon,
    this.value,
    this.onTap,
    this.interactive = false,
  });

  final String label;
  final String hint;
  final IconData icon;
  final String? value;
  final VoidCallback? onTap;
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final Widget child = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: colorScheme.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value?.trim().isNotEmpty == true ? value! : hint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: value?.trim().isNotEmpty == true
                      ? theme.textTheme.titleSmall
                      : theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                ),
              ],
            ),
          ),
          if (interactive)
            Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
        ],
      ),
    );

    if (!interactive) {
      return child;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: child,
    );
  }
}

class _TransferRouteSwapButton extends StatelessWidget {
  const _TransferRouteSwapButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        children: <Widget>[
          Icon(Icons.south_rounded, color: color),
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.swap_vert_rounded, size: 18),
            label: Text(label),
          ),
          const SizedBox(height: 4),
          Icon(Icons.south_rounded, color: color),
        ],
      ),
    );
  }
}

class _CompactSelectionChip extends StatelessWidget {
  const _CompactSelectionChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary.withValues(alpha: 0.12)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.28)
                : colorScheme.outline.withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 16,
              color: selected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: selected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransferPickerSheet<T> extends StatelessWidget {
  const _TransferPickerSheet({
    required this.title,
    required this.items,
    required this.titleBuilder,
    this.subtitleBuilder,
  });

  final String title;
  final List<T> items;
  final String Function(T item) titleBuilder;
  final String? Function(T item)? subtitleBuilder;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.md,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
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
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (BuildContext context, int index) {
                  final T item = items[index];
                  return ListTile(
                    onTap: () => Navigator.of(context).pop(item),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    tileColor: Theme.of(context).colorScheme.surface,
                    title: Text(titleBuilder(item)),
                    subtitle: subtitleBuilder == null
                        ? null
                        : Text(subtitleBuilder!(item) ?? ''),
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
