import 'package:flutter/material.dart';

import '../../../../app/presentation/widgets/app_modal_bottom_sheet.dart';
import '../../../../core/theme/app_spacing.dart';
import 'transaction_operation_flow.dart';

Future<void> showTransactionBottomSheet(
  BuildContext context, {
  required TransactionOperationType type,
  String? initialWalletId,
}) {
  return showAppModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return TransactionBottomSheet(
        type: type,
        initialWalletId: initialWalletId,
      );
    },
  );
}

class TransactionBottomSheet extends StatelessWidget {
  const TransactionBottomSheet({
    required this.type,
    this.initialWalletId,
    super.key,
  });

  final TransactionOperationType type;
  final String? initialWalletId;

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
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.md,
            bottom: AppSpacing.lg,
          ),
          child: TransactionOperationFlow(
            operationType: type,
            embeddedInSheet: true,
            keyboardInset: keyboardInset,
            initialWalletId: initialWalletId,
            onCloseRequested: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }
}
