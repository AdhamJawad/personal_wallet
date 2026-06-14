import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/presentation/widgets/app_modal_bottom_sheet.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/feedback/app_feedback.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../features/attachments/domain/enums/attachment_reference_type.dart';
import '../../../../features/attachments/domain/models/attachment_draft.dart';
import '../../../../features/attachments/domain/models/attachment_reference.dart';
import '../../../../features/attachments/presentation/providers/attachment_providers.dart';
import '../../../dashboard/presentation/widgets/dashboard_surface_card.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../../transactions/presentation/widgets/transaction_attachment_picker.dart';
import '../../../transactions/presentation/widgets/transaction_flow_support.dart';
import '../../../transactions/presentation/widgets/transaction_form_validators.dart';
import '../../../wallets/domain/models/wallet_overview.dart';
import '../../../wallets/presentation/providers/wallet_providers.dart';
import '../providers/debt_providers.dart';

Future<void> showCreateDebtRepaymentSheet(
  BuildContext context, {
  required String debtId,
}) {
  return showAppModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return _CreateDebtRepaymentSheet(debtId: debtId);
    },
  );
}

class CreateDebtRepaymentPage extends ConsumerStatefulWidget {
  const CreateDebtRepaymentPage({
    required this.debtId,
    this.embeddedInSheet = false,
    this.keyboardInset = 0,
    this.onCloseRequested,
    super.key,
  });

  final String debtId;
  final bool embeddedInSheet;
  final double keyboardInset;
  final VoidCallback? onCloseRequested;

  @override
  ConsumerState<CreateDebtRepaymentPage> createState() =>
      _CreateDebtRepaymentPageState();
}

class _CreateDebtRepaymentPageState
    extends ConsumerState<CreateDebtRepaymentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final GlobalKey _amountFieldKey = GlobalKey();
  final GlobalKey _noteFieldKey = GlobalKey();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();
  final List<TransactionAttachmentDraft> _attachments =
      <TransactionAttachmentDraft>[];
  String? _walletId;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() async {
      await ref.read(debtControllerProvider.notifier).loadDebt(widget.debtId);
      if (!mounted) {
        return;
      }
      await ref.read(walletControllerProvider.notifier).initialize();
    });
    _amountFocusNode.addListener(
      () => _handleFocusChange(_amountFocusNode, _amountFieldKey),
    );
    _noteFocusNode.addListener(
      () => _handleFocusChange(_noteFocusNode, _noteFieldKey),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _amountFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

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

  Future<void> _addAttachment() async {
    final TransactionAttachmentDraft? attachment =
        await showTransactionAttachmentSourceSheet(context: context);
    if (attachment != null) {
      setState(() => _attachments.add(attachment));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final debtSummary = ref.read(debtControllerProvider).selectedDebt;
    if (debtSummary == null || _walletId == null) {
      return;
    }

    final String? note = _noteController.text.trim().isEmpty
        ? null
        : _noteController.text.trim();

    final bool transactionSaved = debtSummary.debt.isOwedToMe
        ? await ref
              .read(transactionControllerProvider.notifier)
              .createDeposit(
                walletId: _walletId!,
                currency: debtSummary.currency,
                amount: _amountController.text.trim(),
                note: note,
              )
        : await ref
              .read(transactionControllerProvider.notifier)
              .createWithdraw(
                walletId: _walletId!,
                currency: debtSummary.currency,
                amount: _amountController.text.trim(),
                note: note,
              );

    if (!mounted) {
      return;
    }

    if (!transactionSaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(transactionControllerProvider).errorMessage ??
                (debtSummary.debt.isOwedToMe
                    ? context.tr.failedCreateDeposit
                    : context.tr.failedCreateWithdrawal),
          ),
        ),
      );
      return;
    }

    final bool success = await ref
        .read(debtControllerProvider.notifier)
        .createRepayment(
          debtId: widget.debtId,
          amount: _amountController.text.trim(),
          note: note,
        );

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(debtControllerProvider).errorMessage ??
                context.tr.failedCreateRepayment,
          ),
        ),
      );
      return;
    }

    await ref.read(walletControllerProvider.notifier).initialize();
    await ref.read(transactionControllerProvider.notifier).initialize();

    if (!mounted) {
      return;
    }

    final String? warning = await _persistAttachments();
    if (!mounted) {
      return;
    }

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    if (widget.onCloseRequested != null) {
      widget.onCloseRequested!.call();
    } else {
      Navigator.of(context).pop();
    }
    messenger.showSnackBar(
      buildAppSuccessSnackBar(
        context,
        context.tr.debtPaymentRecordedSuccessfully,
      ),
    );
    if (warning != null) {
      messenger.showSnackBar(SnackBar(content: Text(warning)));
    }
  }

  Future<String?> _persistAttachments() async {
    if (_attachments.isEmpty) {
      return null;
    }
    final String warningMessage = context.tr.repaymentAttachmentSaveFailed;

    final summary = ref.read(debtControllerProvider).selectedDebt;
    if (summary == null) {
      return null;
    }
    final String referenceLabel = context.tr.transactionReferenceLabel(
      context.tr.debt,
      summary.contact.name,
    );

    final bool saved = await ref
        .read(attachmentControllerProvider.notifier)
        .createAttachments(
          reference: AttachmentReference(
            type: AttachmentReferenceType.debt,
            entityId: summary.debt.id,
            label: referenceLabel,
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

    return saved ? null : warningMessage;
  }

  @override
  Widget build(BuildContext context) {
    final debtState = ref.watch(debtControllerProvider);
    final walletState = ref.watch(walletControllerProvider);
    final debtSummary = debtState.selectedDebt;
    final bool isIncomingRepayment = debtSummary?.debt.isOwedToMe ?? false;
    final List<WalletOverview> activeWallets = walletState.wallets
        .where((WalletOverview item) => !item.wallet.isArchived)
        .toList(growable: false);
    final double gap = widget.embeddedInSheet ? AppSpacing.sm : AppSpacing.md;
    final Widget content = DashboardSurfaceCard(
      padding: EdgeInsets.all(
        widget.embeddedInSheet ? AppSpacing.md : AppSpacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(
            bottom: widget.embeddedInSheet ? widget.keyboardInset : 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.embeddedInSheet) ...<Widget>[
                Text(
                  context.tr.recordPayment,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.tr.debtRepaymentDescription,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: gap),
                if (walletState.isLoading && activeWallets.isEmpty)
                  const Center(child: CircularProgressIndicator())
                else if (activeWallets.isEmpty)
                  TransactionEmptyState(
                    icon: Icons.account_balance_wallet_outlined,
                    title: context.tr.noTransactionWalletsTitle,
                    message: context.tr.debtRepaymentNoWalletsMessage,
                  )
                else
                  DropdownButtonFormField<String>(
                    initialValue: _walletId,
                    decoration: InputDecoration(
                      labelText: isIncomingRepayment
                          ? context.tr.debtRepaymentDepositWalletLabel
                          : context.tr.debtRepaymentWithdrawWalletLabel,
                      prefixIcon: const Icon(
                        Icons.account_balance_wallet_outlined,
                      ),
                    ),
                    items: activeWallets
                        .map(
                          (WalletOverview item) => DropdownMenuItem<String>(
                            value: item.wallet.id,
                            child: Text(item.wallet.name),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (String? value) {
                      setState(() => _walletId = value);
                    },
                    validator: (String? value) =>
                        value == null ? context.tr.walletRequired : null,
                  ),
                SizedBox(height: gap),
              ],
              KeyedSubtree(
                key: _amountFieldKey,
                child: PwTextField(
                  controller: _amountController,
                  focusNode: _amountFocusNode,
                  label: context.tr.amount,
                  hint: context.tr.enterAmountHint,
                  prefixIcon: const Icon(Icons.payments_outlined),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (String? value) => amountValidator(context, value),
                  onFieldSubmitted: (_) {
                    _noteFocusNode.requestFocus();
                  },
                ),
              ),
              SizedBox(height: gap),
              KeyedSubtree(
                key: _noteFieldKey,
                child: PwTextField(
                  controller: _noteController,
                  focusNode: _noteFocusNode,
                  label: context.tr.note,
                  hint: context.tr.transactionNoteHint,
                  prefixIcon: const Icon(Icons.edit_note_rounded),
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
                thumbnails: _attachmentThumbnails(),
              ),
              if (_attachments.isNotEmpty) ...<Widget>[
                const SizedBox(height: AppSpacing.xs),
                TransactionAttachmentList(
                  attachments: _attachments,
                  onRemove: (TransactionAttachmentDraft item) {
                    setState(() => _attachments.remove(item));
                  },
                ),
              ],
              SizedBox(
                height: widget.embeddedInSheet ? AppSpacing.md : AppSpacing.lg,
              ),
              Row(
                children: <Widget>[
                  if (widget.embeddedInSheet) ...<Widget>[
                    Expanded(
                      child: PwButton.secondary(
                        label: context.tr.cancel,
                        onPressed: widget.onCloseRequested,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    child: PwButton.primary(
                      label: context.tr.saveRepayment,
                      onPressed:
                          debtState.isLoading ||
                              walletState.isLoading ||
                              activeWallets.isEmpty
                          ? null
                          : _submit,
                      isLoading: debtState.isLoading || walletState.isLoading,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.embeddedInSheet) {
      return content;
    }

    final Widget formContent = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth > 920 ? 820 : 760,
              minHeight: constraints.maxHeight,
            ),
            child: content,
          ),
        );
      },
    );

    return PwScaffold(title: context.tr.debtRepaymentTitle, body: formContent);
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
}

class _CreateDebtRepaymentSheet extends StatelessWidget {
  const _CreateDebtRepaymentSheet({required this.debtId});

  final String debtId;

  @override
  Widget build(BuildContext context) {
    final double keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return MediaQuery.removeViewInsets(
      removeBottom: true,
      context: context,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.sm,
          bottom: AppSpacing.sm,
        ),
        child: CreateDebtRepaymentPage(
          debtId: debtId,
          embeddedInSheet: true,
          keyboardInset: keyboardInset,
          onCloseRequested: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
