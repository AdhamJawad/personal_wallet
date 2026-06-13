import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/enums/notification_type.dart';
import '../providers/notification_providers.dart';

class NotificationCenterPage extends ConsumerWidget {
  const NotificationCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationControllerProvider);

    return PwScaffold(
      title: 'Notifications',
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: DropdownButtonFormField<NotificationType?>(
                  initialValue: notificationState.filter,
                  decoration: const InputDecoration(labelText: 'Filter'),
                  items: <DropdownMenuItem<NotificationType?>>[
                    const DropdownMenuItem(value: null, child: Text('All')),
                    ...NotificationType.values.map(
                      (NotificationType type) =>
                          DropdownMenuItem(value: type, child: Text(type.name)),
                    ),
                  ],
                  onChanged: (NotificationType? value) {
                    ref
                        .read(notificationControllerProvider.notifier)
                        .setFilter(value);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              PwButton.secondary(
                label: 'Clear read',
                onPressed: () => ref
                    .read(notificationControllerProvider.notifier)
                    .clearRead(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          if (notificationState.visibleNotifications.isEmpty)
            const PwSectionCard(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text('No notifications available.'),
              ),
            )
          else
            ...notificationState.visibleNotifications.map((notification) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: PwSectionCard(
                  child: ListTile(
                    title: Text(notification.title),
                    subtitle: Text(
                      '${notification.message}\n${DateFormatter.full(notification.createdAt)}',
                    ),
                    isThreeLine: true,
                    trailing: notification.isRead
                        ? const Text('Read')
                        : TextButton(
                            onPressed: () => ref
                                .read(notificationControllerProvider.notifier)
                                .markAsRead(notification.id),
                            child: const Text('Mark read'),
                          ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
