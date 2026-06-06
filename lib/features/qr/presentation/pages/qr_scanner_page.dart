import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/qr_identity.dart';
import '../providers/qr_providers.dart';

class QrScannerPage extends ConsumerStatefulWidget {
  const QrScannerPage({super.key});

  @override
  ConsumerState<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends ConsumerState<QrScannerPage> {
  final TextEditingController _payloadController = TextEditingController();

  @override
  void dispose() {
    _payloadController.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    final bool success = await ref
        .read(qrControllerProvider.notifier)
        .scanPayload(_payloadController.text.trim());

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(qrControllerProvider).errorMessage ?? 'Scan failed.',
          ),
        ),
      );
      return;
    }

    context.push(AppRoutes.qrPreviewPath);
  }

  @override
  Widget build(BuildContext context) {
    final qrState = ref.watch(qrControllerProvider);

    return PwScaffold(
      title: 'QR Scanner',
      body: ListView(
        children: <Widget>[
          PwSectionCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Mock scanner',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'Paste a QR payload or choose one of the available demo identities below.',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PwTextField(
                    controller: _payloadController,
                    label: 'QR payload',
                    maxLength: 500,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  PwButton.primary(
                    label: 'Scan payload',
                    isLoading: qrState.isLoading,
                    onPressed: _scan,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Demo identities', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          ...qrState.knownIdentities.map(
            (QrIdentity identity) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: PwSectionCard(
                child: ListTile(
                  title: Text(identity.displayName),
                  subtitle: Text(identity.publicReferenceIdentifier),
                  trailing: PwButton.secondary(
                    label: 'Use',
                    onPressed: () {
                      _payloadController.text = identity.payload;
                      _scan();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
