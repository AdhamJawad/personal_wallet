import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/enums/attachment_reference_type.dart';
import '../../domain/models/attachment_reference.dart';
import '../providers/attachment_providers.dart';

class AttachmentViewerPage extends ConsumerStatefulWidget {
  const AttachmentViewerPage({
    required this.entityType,
    required this.entityId,
    this.label,
    super.key,
  });

  final String entityType;
  final String entityId;
  final String? label;

  @override
  ConsumerState<AttachmentViewerPage> createState() =>
      _AttachmentViewerPageState();
}

class _AttachmentViewerPageState extends ConsumerState<AttachmentViewerPage> {
  late final AttachmentReference _reference;

  @override
  void initState() {
    super.initState();
    _reference = AttachmentReference(
      type: AttachmentReferenceType.values.firstWhere(
        (AttachmentReferenceType item) => item.name == widget.entityType,
      ),
      entityId: widget.entityId,
      label: widget.label,
    );
    Future<void>.microtask(() {
      ref.read(attachmentControllerProvider.notifier).loadReference(_reference);
    });
  }

  @override
  Widget build(BuildContext context) {
    final attachmentState = ref.watch(attachmentControllerProvider);
    return PwScaffold(
      title: 'Attachments',
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.label ?? '${widget.entityType} ${widget.entityId}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              PwButton.primary(
                label: 'Add files',
                onPressed: () => context.push(
                  '${AppRoutes.attachmentPickerPath}?entityType=${Uri.encodeComponent(widget.entityType)}&entityId=${Uri.encodeComponent(widget.entityId)}&label=${Uri.encodeComponent(widget.label ?? '')}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          if (attachmentState.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (attachmentState.attachments.isEmpty)
            const PwSectionCard(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Text('No attachments recorded yet.'),
              ),
            )
          else
            ...attachmentState.attachments.map((attachment) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: PwSectionCard(
                  child: ListTile(
                    title: Text(attachment.fileName),
                    subtitle: Text(
                      '${attachment.kind.name} | ${attachment.localUri}',
                    ),
                    trailing: Text(DateFormatter.short(attachment.createdAt)),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
