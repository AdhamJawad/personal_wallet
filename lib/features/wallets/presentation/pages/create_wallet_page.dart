import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/create_wallet_sheet.dart';

class CreateWalletPage extends StatefulWidget {
  const CreateWalletPage({super.key});

  @override
  State<CreateWalletPage> createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWalletPage> {
  bool _didOpenSheet = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_didOpenSheet) {
      return;
    }

    _didOpenSheet = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showCreateWalletSheet(context);

      if (!mounted) {
        return;
      }

      if (context.canPop()) {
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.shrink(),
    );
  }
}
