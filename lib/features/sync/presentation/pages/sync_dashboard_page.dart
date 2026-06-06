import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/sync/controllers/sync_state.dart';
import '../../../../core/sync/enums/conflict_resolution_strategy.dart';
import '../../../../core/sync/enums/sync_operation_status.dart';
import '../../../../core/sync/models/sync_operation.dart';
import '../../../../core/sync/providers/sync_providers.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';

class SyncDashboardPage extends ConsumerStatefulWidget {
  const SyncDashboardPage({super.key});

  @override
  ConsumerState<SyncDashboardPage> createState() => _SyncDashboardPageState();
}

class _SyncDashboardPageState extends ConsumerState<SyncDashboardPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      ref.read(syncControllerProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final SyncState syncState = ref.watch(syncControllerProvider);

    return PwScaffold(
      title: 'Sync Queue',
      body: RefreshIndicator(
        onRefresh: () => ref.read(syncControllerProvider.notifier).initialize(),
        child: ListView(
          children: <Widget>[
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: <Widget>[
                _SyncMetricCard(
                  label: 'Pending',
                  count: syncState.pendingOperations.length,
                ),
                _SyncMetricCard(
                  label: 'Failed',
                  count: syncState.failedOperations.length,
                ),
                _SyncMetricCard(
                  label: 'Conflicts',
                  count: syncState.conflictOperations.length,
                ),
                _SyncMetricCard(
                  label: 'Synced',
                  count: syncState.syncedOperations.length,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: <Widget>[
                PwButton.secondary(
                  label: 'Refresh',
                  onPressed: () => ref
                      .read(syncControllerProvider.notifier)
                      .initialize(),
                ),
                const SizedBox(width: AppSpacing.md),
                PwButton.primary(
                  label: 'Clear completed',
                  onPressed: () => ref
                      .read(syncControllerProvider.notifier)
                      .clearCompleted(),
                ),
                const SizedBox(width: AppSpacing.md),
                PwButton.secondary(
                  label: 'Audit history',
                  onPressed: () => context.push(AppRoutes.auditHistoryPath),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _SyncSection(
              title: 'Pending Operations',
              operations: syncState.pendingOperations,
            ),
            const SizedBox(height: AppSpacing.xl),
            _SyncSection(
              title: 'Failed Operations',
              operations: syncState.failedOperations,
            ),
            const SizedBox(height: AppSpacing.xl),
            _SyncSection(
              title: 'Conflict Operations',
              operations: syncState.conflictOperations,
            ),
            const SizedBox(height: AppSpacing.xl),
            _SyncSection(
              title: 'Synced Operations',
              operations: syncState.syncedOperations,
            ),
          ],
        ),
      ),
    );
  }
}

class _SyncMetricCard extends StatelessWidget {
  const _SyncMetricCard({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: PwSectionCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label),
              const SizedBox(height: AppSpacing.sm),
              Text('$count', style: context.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _SyncSection extends ConsumerWidget {
  const _SyncSection({required this.title, required this.operations});

  final String title;
  final List<SyncOperation> operations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: context.titleLarge),
        const SizedBox(height: AppSpacing.md),
        if (operations.isEmpty)
          const PwSectionCard(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text('No operations in this state.'),
            ),
          )
        else
          ...operations.map((SyncOperation operation) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: PwSectionCard(
                child: ListTile(
                  title: Text(operation.type.name),
                  subtitle: Text(
                    '${operation.entityId} | ${DateFormatter.full(operation.createdAt)}',
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String value) async {
                      switch (value) {
                        case 'retry':
                          await ref
                              .read(syncControllerProvider.notifier)
                              .retryOperation(operation.id);
                          return;
                        case 'synced':
                          await ref
                              .read(syncControllerProvider.notifier)
                              .markSynced(operation.id);
                          return;
                        case 'failed':
                          await ref
                              .read(syncControllerProvider.notifier)
                              .markFailed(
                                operationId: operation.id,
                                errorMessage: 'Manually marked as failed.',
                              );
                          return;
                        case 'conflict':
                          await ref
                              .read(syncControllerProvider.notifier)
                              .markConflict(
                                operationId: operation.id,
                                entityId: operation.entityId,
                                localPayload: operation.payload,
                                summary: 'Developer-marked conflict.',
                                recommendedStrategy:
                                    ConflictResolutionStrategy.manualReview,
                              );
                          return;
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      if (operation.status == SyncOperationStatus.failed ||
                          operation.status == SyncOperationStatus.conflict)
                        const PopupMenuItem<String>(
                          value: 'retry',
                          child: Text('Retry'),
                        ),
                      if (operation.status != SyncOperationStatus.synced)
                        const PopupMenuItem<String>(
                          value: 'synced',
                          child: Text('Mark synced'),
                        ),
                      if (operation.status != SyncOperationStatus.failed)
                        const PopupMenuItem<String>(
                          value: 'failed',
                          child: Text('Mark failed'),
                        ),
                      if (operation.status != SyncOperationStatus.conflict)
                        const PopupMenuItem<String>(
                          value: 'conflict',
                          child: Text('Mark conflict'),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}
