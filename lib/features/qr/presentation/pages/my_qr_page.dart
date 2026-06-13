import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/qr_providers.dart';
import '../widgets/qr_identity_card.dart';

class MyQrPage extends ConsumerWidget {
  const MyQrPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrState = ref.watch(qrControllerProvider);
    final identity = qrState.myIdentity;

    return PwScaffold(
      title: 'My QR Identity',
      body: qrState.isLoading && identity == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                if (identity != null) QrIdentityCard(identity: identity),
                const SizedBox(height: AppSpacing.xl),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: <Widget>[
                    PwButton.primary(
                      label: 'Scan QR',
                      onPressed: () => context.push(AppRoutes.qrScannerPath),
                    ),
                    PwButton.secondary(
                      label: 'Start transfer',
                      onPressed: () =>
                          context.push(AppRoutes.userTransferCreatePath),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
