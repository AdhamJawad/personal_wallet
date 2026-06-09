import 'package:flutter/material.dart';

import '../../../../core/localization/localization_extensions.dart';
import '../widgets/transaction_operation_flow.dart';
import '../widgets/transaction_page_shell.dart';

class CreateWithdrawPage extends StatelessWidget {
  const CreateWithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TransactionPageShell(
      title: context.tr.withdraw,
      child: const TransactionOperationFlow(
        operationType: TransactionOperationType.withdraw,
      ),
    );
  }
}
