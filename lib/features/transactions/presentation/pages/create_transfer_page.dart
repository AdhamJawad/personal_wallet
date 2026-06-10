import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/presentation/widgets/app_modal_bottom_sheet.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../wallets/presentation/providers/wallet_providers.dart';
import '../providers/transaction_providers.dart';
import '../widgets/transaction_flow_support.dart';
import '../widgets/transaction_form_validators.dart';

Future<void> showCreateTransferSheet(BuildContext context) {
  return showAppModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return const _CreateTransferSheet();
    },
  );
}

class CreateTransferPage extends ConsumerStatefulWidget {
  const CreateTransferPage({
    this.embeddedInSheet = false,
    this.keyboardInset = 0,
    this.onCloseRequested,
    super.key,
  });

  final bool embeddedInSheet;
  final double keyboardInset;
  final VoidCallback? onCloseRequested;

  @override
  ConsumerState<CreateTransferPage> createState() => _CreateTransferPageState();
}

class _CreateTransferPageState extends ConsumerState<CreateTransferPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final GlobalKey _amountFieldKey = GlobalKey();
  final GlobalKey _noteFieldKey = GlobalKey();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();
  String? _sourceWalletId;
  String? _destinationWalletId;
  Currency _currency = Currency.usd;

  @override
  void initState() {
    super.initState();
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() ||
        _sourceWalletId == null ||
        _destinationWalletId == null) {
      return;
    }

    if (_sourceWalletId == _destinationWalletId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr.sourceDestinationWalletsDifferent)),
      );
      return;
    }

    final bool success = await ref
        .read(transactionControllerProvider.notifier)
        .createTransfer(
          sourceWalletId: _sourceWalletId!,
          destinationWalletId: _destinationWalletId!,
          currency: _currency,
          amount: _amountController.text.trim(),
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    if (success) {
      ref.read(walletControllerProvider.notifier).initialize();
      if (widget.onCloseRequested != null) {
        widget.onCloseRequested!.call();
      } else {
        Navigator.of(context).pop();
      }
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ref.read(transactionControllerProvider).errorMessage ??
              context.tr.failedCreateTransfer,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final transactionState = ref.watch(transactionControllerProvider);
    final double gap = widget.embeddedInSheet ? AppSpacing.sm : AppSpacing.md;
    final activeWallets = walletState.wallets
        .where((item) => !item.wallet.isArchived)
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
                  ? widget.keyboardInset + 84
                  : 0,
              primaryLabel: context.tr.saveTransfer,
              onPrimaryPressed: transactionState.isLoading ? null : _submit,
              isPrimaryLoading: transactionState.isLoading,
              content: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      initialValue: _sourceWalletId,
                      decoration: InputDecoration(
                        labelText: context.tr.sourceWallet,
                      ),
                      items: activeWallets
                          .map(
                            (item) => DropdownMenuItem(
                              value: item.wallet.id,
                              child: Text(item.wallet.name),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (String? value) {
                        setState(() => _sourceWalletId = value);
                      },
                      validator: (String? value) =>
                          value == null ? context.tr.sourceWalletRequired : null,
                    ),
                    SizedBox(height: gap),
                    DropdownButtonFormField<String>(
                      initialValue: _destinationWalletId,
                      decoration: InputDecoration(
                        labelText: context.tr.destinationWallet,
                      ),
                      items: activeWallets
                          .map(
                            (item) => DropdownMenuItem(
                              value: item.wallet.id,
                              child: Text(item.wallet.name),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (String? value) {
                        setState(() => _destinationWalletId = value);
                      },
                      validator: (String? value) => value == null
                          ? context.tr.destinationWalletRequired
                          : null,
                    ),
                    SizedBox(height: gap),
                    DropdownButtonFormField<Currency>(
                      initialValue: _currency,
                      decoration: InputDecoration(labelText: context.tr.currency),
                      items: Currency.values
                          .map(
                            (Currency currency) => DropdownMenuItem(
                              value: currency,
                              child: Text(currency.name.toUpperCase()),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (Currency? value) {
                        if (value != null) {
                          setState(() => _currency = value);
                        }
                      },
                    ),
                    SizedBox(height: gap),
                    KeyedSubtree(
                      key: _amountFieldKey,
                      child: PwTextField(
                        controller: _amountController,
                        focusNode: _amountFocusNode,
                        label: context.tr.amount,
                        hint: context.tr.enterAmountHint,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (String? value) =>
                            amountValidator(context, value),
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
                        maxLines: 2,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        return Center(
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

    return PwScaffold(
      title: context.tr.createInternalTransferTitle,
      body: formContent,
    );
  }
}

class _CreateTransferSheet extends StatelessWidget {
  const _CreateTransferSheet();

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
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          child: CreateTransferPage(
            embeddedInSheet: true,
            keyboardInset: keyboardInset,
            onCloseRequested: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }
}
