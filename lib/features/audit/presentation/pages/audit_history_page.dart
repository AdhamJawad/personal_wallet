import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../providers/audit_providers.dart';

class AuditHistoryPage extends ConsumerWidget {
  const AuditHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auditState = ref.watch(auditControllerProvider);
    return PwScaffold(
      title: 'Audit History',
      body: ListView(
        children: <Widget>[
          if (auditState.events.isEmpty)
            const PwSectionCard(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text('No audit events recorded yet.'),
              ),
            )
          else
            ...auditState.events.map((event) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: PwSectionCard(
                  child: ListTile(
                    title: Text(event.type.name),
                    subtitle: Text(
                      '${event.relatedEntityType} | ${event.entityId}\n${DateFormatter.full(event.createdAt)}',
                    ),
                    isThreeLine: true,
                    trailing: Text(event.syncStatus.name),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
