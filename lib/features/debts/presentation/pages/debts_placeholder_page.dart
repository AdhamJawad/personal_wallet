import 'package:flutter/widgets.dart';

import '../../../../core/design_system/widgets/pw_placeholder_view.dart';

class DebtsPlaceholderPage extends StatelessWidget {
  const DebtsPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PwPlaceholderView(
      title: 'Debt Module',
      description:
          'Debt tracking is modeled separately from wallet balances. Lending, repayments, and dispute workflows will be added later without contaminating wallet ledger calculations.',
    );
  }
}
