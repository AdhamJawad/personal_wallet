import 'package:flutter/widgets.dart';

import '../../../../core/design_system/widgets/pw_placeholder_view.dart';

class TransactionsPlaceholderPage extends StatelessWidget {
  const TransactionsPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PwPlaceholderView(
      title: 'Transactions Module',
      description:
          'Deposits, withdrawals, transfers, exchange records, and immutable correction entries will be orchestrated here. Balances will always be derived from this ledger, never stored directly.',
    );
  }
}
