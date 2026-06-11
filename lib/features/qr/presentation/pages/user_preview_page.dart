import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/domain/enums/contact_entity_type.dart';
import '../../../contacts/presentation/providers/contact_providers.dart';
import '../../domain/models/qr_scan_result.dart';
import '../providers/qr_providers.dart';

class UserPreviewPage extends ConsumerWidget {
  const UserPreviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrState = ref.watch(qrControllerProvider);
    final QrScanResult? result = qrState.scanResult;

    return PwScaffold(
      title: 'User Preview',
      body: result == null
          ? const Center(child: Text('No QR scan result available.'))
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: PwSectionCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          result.identity.displayName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(result.identity.publicReferenceIdentifier),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          result.isSelf
                              ? 'This QR belongs to your own profile.'
                              : result.isKnownContact
                              ? 'This registered user is already in your contacts.'
                              : 'This registered user is not in your contacts yet.',
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Wrap(
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.md,
                          children: <Widget>[
                            if (!result.isSelf && !result.isKnownContact)
                              PwButton.secondary(
                                label: 'Add contact',
                                onPressed: () async {
                                  final bool success = await ref
                                      .read(contactControllerProvider.notifier)
                                      .createRegisteredContact(
                                        linkedUserId: result.identity.userId,
                                        entityType: ContactEntityType.person,
                                        name: result.identity.displayName,
                                        note: 'Added from QR identity',
                                      );

                                  if (!context.mounted) {
                                    return;
                                  }

                                  if (!success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          ref
                                                  .read(
                                                    contactControllerProvider,
                                                  )
                                                  .errorMessage ??
                                              'Unable to add contact.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  await ref
                                      .read(qrControllerProvider.notifier)
                                      .scanPayload(result.identity.payload);

                                  if (!context.mounted) {
                                    return;
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Registered contact added.',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            if (!result.isSelf)
                              PwButton.primary(
                                label: 'Start transfer',
                                onPressed: () => context.push(
                                  '${AppRoutes.userTransferCreatePath}?recipientUserId=${Uri.encodeComponent(result.identity.userId)}&recipientName=${Uri.encodeComponent(result.identity.displayName)}',
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
