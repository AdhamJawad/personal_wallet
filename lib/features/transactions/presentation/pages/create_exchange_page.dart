import 'package:flutter/material.dart';

import '../../../../core/localization/localization_extensions.dart';
import '../widgets/transaction_operation_flow.dart';
import '../widgets/transaction_page_shell.dart';

class CreateExchangePage extends StatelessWidget {
  const CreateExchangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return TransactionPageShell(
      title: context.tr.exchange,
      child: const TransactionOperationFlow(
        operationType: TransactionOperationType.exchange,
      ),
    );
  }
}
