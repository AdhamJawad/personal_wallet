import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/presentation/providers/app_preferences_provider.dart';
import '../../../../app/presentation/widgets/app_modal_bottom_sheet.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/feedback/app_feedback.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../features/attachments/domain/enums/attachment_reference_type.dart';
import '../../../../features/attachments/domain/models/attachment_draft.dart';
import '../../../../features/attachments/domain/models/attachment_reference.dart';
import '../../../../features/attachments/presentation/providers/attachment_providers.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../contacts/domain/models/contact.dart';
import '../../../contacts/presentation/providers/contact_providers.dart';
import '../../../transactions/presentation/widgets/transaction_attachment_picker.dart';
import '../../../transactions/presentation/widgets/transaction_flow_support.dart';
import '../../../transactions/presentation/widgets/transaction_form_validators.dart';
import '../providers/debt_providers.dart';

Future<void> showCreateDebtSheet(
  BuildContext context, {
  String? initialContactId,
  bool lockContact = false,
}) {
  return showAppModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return _CreateDebtSheet(
        initialContactId: initialContactId,
        lockContact: lockContact,
      );
    },
  );
}

class CreateDebtPage extends ConsumerStatefulWidget {
  const CreateDebtPage({
    this.embeddedInSheet = false,
    this.keyboardInset = 0,
    this.initialContactId,
    this.lockContact = false,
    this.onCloseRequested,
    super.key,
  });

  final bool embeddedInSheet;
  final double keyboardInset;
  final String? initialContactId;
  final bool lockContact;
  final VoidCallback? onCloseRequested;

  @override
  ConsumerState<CreateDebtPage> createState() => _CreateDebtPageState();
}

class _CreateDebtPageState extends ConsumerState<CreateDebtPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final GlobalKey _amountFieldKey = GlobalKey();
  final GlobalKey _noteFieldKey = GlobalKey();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();
  final List<TransactionAttachmentDraft> _attachments =
      <TransactionAttachmentDraft>[];

  String? _contactId;
  Currency _currency = Currency.usd;
  bool _isOwedToMe = true;

  @override
  void initState() {
    super.initState();
    _currency = ref.read(appPreferencesProvider).defaultCurrency;
    _contactId = widget.initialContactId;
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
    if (!_formKey.currentState!.validate() || _contactId == null) {
      return;
    }

    final bool success = await ref
        .read(debtControllerProvider.notifier)
        .createDebt(
          contactId: _contactId!,
          isOwedToMe: _isOwedToMe,
          currencyCode: _currency.name,
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
            ref.read(debtControllerProvider).errorMessage ??
                context.tr.failedCreateDebt,
          ),
        ),
      );
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
      buildAppSuccessSnackBar(context, context.tr.debtCreatedSuccessfully),
    );
    if (warning != null) {
      messenger.showSnackBar(SnackBar(content: Text(warning)));
    }
  }

  Future<String?> _persistAttachments() async {
    if (_attachments.isEmpty) {
      return null;
    }
    final String warningMessage = context.tr.debtAttachmentSaveFailed;

    final debtState = ref.read(debtControllerProvider);
    final summary = debtState.selectedDebt;
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
            entityType: AttachmentReferenceType.debt,
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
    final contacts = ref.watch(contactControllerProvider).contacts;
    final Contact? selectedContact = contacts.cast<Contact?>().firstWhere(
      (Contact? item) => item?.id == _contactId,
      orElse: () => null,
    );
    final double gap = widget.embeddedInSheet ? AppSpacing.sm : AppSpacing.md;
    final List<SelectionChipOption<Currency>> currencyOptions = Currency.values
        .map(
          (Currency currency) => SelectionChipOption<Currency>(
            value: currency,
            label: currency.name.toUpperCase(),
          ),
        )
        .toList(growable: false);

    final Widget formContent = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Widget content = PwSectionCard(
          child: Padding(
            padding: EdgeInsets.all(
              widget.embeddedInSheet ? AppSpacing.sm : AppSpacing.md,
            ),
            child: TransactionFlowLayout(
              compact: widget.embeddedInSheet,
              extraScrollBottomSpacing: widget.embeddedInSheet
                  ? (widget.keyboardInset > 0
                        ? widget.keyboardInset + AppSpacing.sm
                        : 0)
                  : 0,
              primaryLabel: context.tr.saveDebtRecord,
              onPrimaryPressed: debtState.isLoading ? null : _submit,
              isPrimaryLoading: debtState.isLoading,
              content: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _FormLabel(context.tr.debtDirectionTitle),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: <Widget>[
                        _DebtDirectionChip(
                          icon: Icons.arrow_downward_rounded,
                          label: context.tr.debtDirectionOwedToMeShort,
                          selected: _isOwedToMe,
                          onTap: () => setState(() => _isOwedToMe = true),
                        ),
                        _DebtDirectionChip(
                          icon: Icons.arrow_upward_rounded,
                          label: context.tr.debtDirectionIOweShort,
                          selected: !_isOwedToMe,
                          onTap: () => setState(() => _isOwedToMe = false),
                        ),
                      ],
                    ),
                    SizedBox(height: gap),
                    _FormLabel(context.tr.debtContactTitle),
                    if (contacts.isEmpty)
                      TransactionEmptyState(
                        icon: Icons.person_outline_rounded,
                        title: context.tr.noTransferContactsTitle,
                        message: context.tr.noTransferContactsMessage,
                      )
                    else if (widget.lockContact && selectedContact != null)
                      _LockedContactField(contact: selectedContact)
                    else
                      DropdownButtonFormField<String>(
                        initialValue: _contactId,
                        decoration: InputDecoration(
                          hintText: context.tr.debtContactHint,
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                        ),
                        items: contacts
                            .map(
                              (Contact contact) => DropdownMenuItem(
                                value: contact.id,
                                child: Text(contact.name),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (String? value) {
                          setState(() => _contactId = value);
                        },
                        validator: (String? value) => value == null
                            ? context.tr.debtContactRequired
                            : null,
                      ),
                    SizedBox(height: gap),
                    _FormLabel('${context.tr.amount} / ${context.tr.currency}'),
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
                              prefixIcon: const Icon(Icons.payments_outlined),
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
                        CurrencyChip<Currency>(
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
                    SizedBox(height: gap),
                    KeyedSubtree(
                      key: _noteFieldKey,
                      child: PwTextField(
                        controller: _noteController,
                        focusNode: _noteFocusNode,
                        label: context.tr.note,
                        hint: context.tr.transactionNoteHint,
                        prefixIcon: const Icon(Icons.edit_note_rounded),
                        maxLines: 3,
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
                      SizedBox(
                        height: widget.embeddedInSheet
                            ? AppSpacing.xs
                            : AppSpacing.sm,
                      ),
                      TransactionAttachmentList(
                        attachments: _attachments,
                        onRemove: (TransactionAttachmentDraft item) {
                          setState(() => _attachments.remove(item));
                        },
                      ),
                    ],
                    SizedBox(height: gap),
                    _DebtCreateSummaryCard(
                      directionLabel: _isOwedToMe
                          ? context.tr.debtDirectionOwedToMeShort
                          : context.tr.debtDirectionIOweShort,
                      contactName: selectedContact?.name ?? context.tr.none,
                      amountLabel: _amountController.text.trim().isEmpty
                          ? context.tr.none
                          : '${_amountController.text.trim()} ${_currency.name.toUpperCase()}',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth > 920 ? 820 : 760,
              minHeight: widget.embeddedInSheet ? 0 : constraints.maxHeight,
            ),
            child: content,
          ),
        );
      },
    );

    if (widget.embeddedInSheet) {
      return formContent;
    }

    return PwScaffold(title: context.tr.createDebt, body: formContent);
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

class _DebtDirectionChip extends StatelessWidget {
  const _DebtDirectionChip({
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
          vertical: 8,
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

class _FormLabel extends StatelessWidget {
  const _FormLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class _CreateDebtSheet extends StatelessWidget {
  const _CreateDebtSheet({this.initialContactId, this.lockContact = false});

  final String? initialContactId;
  final bool lockContact;

  @override
  Widget build(BuildContext context) {
    final double keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final double maxHeight = MediaQuery.sizeOf(context).height * 0.92;

    return MediaQuery.removeViewInsets(
      removeBottom: true,
      context: context,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.sm,
            bottom: AppSpacing.sm,
          ),
          child: CreateDebtPage(
            embeddedInSheet: true,
            keyboardInset: keyboardInset,
            initialContactId: initialContactId,
            lockContact: lockContact,
            onCloseRequested: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }
}

class _LockedContactField extends StatelessWidget {
  const _LockedContactField({required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.person_outline_rounded,
            size: 18,
            color: colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              contact.name,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Icon(
            Icons.lock_outline_rounded,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _DebtCreateSummaryCard extends StatelessWidget {
  const _DebtCreateSummaryCard({
    required this.directionLabel,
    required this.contactName,
    required this.amountLabel,
  });

  final String directionLabel;
  final String contactName;
  final String amountLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.tr.review,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          TransactionSummaryRow(
            label: context.tr.debtDirectionTitle,
            value: directionLabel,
          ),
          TransactionSummaryRow(
            label: context.tr.debtContactTitle,
            value: contactName,
          ),
          TransactionSummaryRow(label: context.tr.amount, value: amountLabel),
        ],
      ),
    );
  }
}
