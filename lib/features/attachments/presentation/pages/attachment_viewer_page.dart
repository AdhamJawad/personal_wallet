import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/enums/attachment_kind.dart';
import '../../domain/enums/attachment_reference_type.dart';
import '../../domain/models/attachment.dart';
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
      title: context.tr.attachments,
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: <Widget>[
          _AttachmentsHeader(
            relationLabel: _relatedLabel(context),
            referenceLabel: widget.label?.trim().isNotEmpty == true
                ? widget.label!.trim()
                : widget.entityId,
          ),
          const SizedBox(height: AppSpacing.md),
          if (attachmentState.isLoading)
            const _AttachmentLoadingList()
          else if (attachmentState.attachments.isEmpty)
            const _AttachmentsEmptyState()
          else
            ...attachmentState.attachments.map(
              (Attachment attachment) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _AttachmentCard(
                  attachment: attachment,
                  onOpen: () => _openAttachment(attachment),
                  onActionSelected: (_AttachmentAction action) {
                    _handleAction(action, attachment);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _relatedLabel(BuildContext context) {
    return switch (_reference.type) {
      AttachmentReferenceType.transaction =>
        context.tr.attachmentsRelatedTransaction,
      _ => context.tr.attachmentsRelatedRecord,
    };
  }

  Future<void> _handleAction(
    _AttachmentAction action,
    Attachment attachment,
  ) async {
    switch (action) {
      case _AttachmentAction.open:
        await _openAttachment(attachment);
        break;
      case _AttachmentAction.share:
        await _shareAttachment(attachment);
        break;
      case _AttachmentAction.save:
        await _saveAttachmentToDevice(attachment);
        break;
    }
  }

  Future<void> _shareAttachment(Attachment attachment) async {
    final File? file = _existingFile(attachment);
    if (file == null) {
      _showMessage(context.tr.attachmentPreviewUnavailable);
      return;
    }

    try {
      final Rect shareOrigin = _shareOriginRect();
      await SharePlus.instance.share(
        ShareParams(
          files: <XFile>[XFile(file.path)],
          title: attachment.fileName,
          subject: attachment.fileName,
          text: attachment.fileName,
          sharePositionOrigin: shareOrigin,
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showMessage(context.tr.attachmentShareFailed);
    }
  }

  Future<void> _saveAttachmentToDevice(Attachment attachment) async {
    final File? file = _existingFile(attachment);
    if (file == null) {
      _showMessage(context.tr.attachmentPreviewUnavailable);
      return;
    }

    try {
      final String? savedPath = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
          sourceFilePath: file.path,
          fileName: attachment.fileName,
          mimeTypesFilter: attachment.mimeType == null
              ? null
              : <String>[attachment.mimeType!],
        ),
      );
      if (!mounted || savedPath == null) {
        return;
      }
      _showMessage(context.tr.attachmentSaved(attachment.fileName));
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showMessage(context.tr.attachmentDownloadFailed);
    }
  }

  Future<void> _openAttachment(Attachment attachment) async {
    final File? file = _existingFile(attachment);
    if (file == null) {
      _showMessage(context.tr.attachmentPreviewUnavailable);
      return;
    }

    if (_isImage(attachment)) {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return _AttachmentImageViewer(attachment: attachment);
          },
        ),
      );
      return;
    }

    final Uri fileUri = Uri.file(file.path);
    if (await canLaunchUrl(fileUri)) {
      final bool launched = await launchUrl(fileUri);
      if (!launched && mounted) {
        _showMessage(context.tr.attachmentPreviewUnavailable);
      }
      return;
    }

    if (!mounted) {
      return;
    }
    _showMessage(context.tr.attachmentPreviewUnavailable);
  }

  File? _existingFile(Attachment attachment) {
    final File file = File(attachment.localUri);
    if (!file.existsSync()) {
      return null;
    }
    return file;
  }

  Rect _shareOriginRect() {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      return const Rect.fromLTWH(0, 0, 1, 1);
    }
    final Offset origin = box.localToGlobal(Offset.zero);
    return origin & box.size;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

enum _AttachmentAction { open, share, save }

class _AttachmentsHeader extends StatelessWidget {
  const _AttachmentsHeader({
    required this.relationLabel,
    required this.referenceLabel,
  });

  final String relationLabel;
  final String referenceLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return PwSectionCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              context.tr.attachments,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              relationLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Directionality(
              textDirection: _resolveTextDirection(referenceLabel),
              child: Text(
                referenceLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentsEmptyState extends StatelessWidget {
  const _AttachmentsEmptyState();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return PwSectionCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.attach_file_rounded,
                size: 34,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.tr.attachmentsEmptyTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              context.tr.attachmentsEmptyMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  const _AttachmentCard({
    required this.attachment,
    required this.onOpen,
    required this.onActionSelected,
  });

  final Attachment attachment;
  final VoidCallback onOpen;
  final ValueChanged<_AttachmentAction> onActionSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isImage = _isImage(attachment);

    return PwSectionCard(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onOpen,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _AttachmentPreview(attachment: attachment),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Directionality(
                        textDirection: _resolveTextDirection(
                          attachment.fileName,
                        ),
                        child: Text(
                          attachment.fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_kindLabel(context, attachment.kind)} • ${_formatFileSize(attachment.byteSize)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat.yMMMMd(
                          Localizations.localeOf(context).toString(),
                        ).format(attachment.createdAt.toLocal()),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (!isImage &&
                          (attachment.mimeType ?? '').isNotEmpty) ...<Widget>[
                        const SizedBox(height: 4),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            attachment.mimeType!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                PopupMenuButton<_AttachmentAction>(
                  tooltip: context.tr.openActions,
                  onSelected: onActionSelected,
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<_AttachmentAction>>[
                        PopupMenuItem<_AttachmentAction>(
                          value: _AttachmentAction.open,
                          child: Text(context.tr.openAction),
                        ),
                        PopupMenuItem<_AttachmentAction>(
                          value: _AttachmentAction.share,
                          child: Text(context.tr.attachmentsShareAction),
                        ),
                        PopupMenuItem<_AttachmentAction>(
                          value: _AttachmentAction.save,
                          child: Text(context.tr.attachmentsSaveToDeviceAction),
                        ),
                      ],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AttachmentPreview extends StatelessWidget {
  const _AttachmentPreview({required this.attachment});

  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    final bool isImage = _isImage(attachment);
    final File file = File(attachment.localUri);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 72,
        height: 72,
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        child: isImage && file.existsSync()
            ? Image.file(file, fit: BoxFit.cover)
            : Center(
                child: Icon(
                  _fileIcon(attachment),
                  size: 28,
                  color: colorScheme.primary,
                ),
              ),
      ),
    );
  }
}

class _AttachmentImageViewer extends StatelessWidget {
  const _AttachmentImageViewer({required this.attachment});

  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    final File file = File(attachment.localUri);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Directionality(
          textDirection: _resolveTextDirection(attachment.fileName),
          child: Text(
            attachment.fileName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: Center(
        child: file.existsSync()
            ? InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.5,
                child: Image.file(file, fit: BoxFit.contain),
              )
            : Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  context.tr.attachmentPreviewUnavailable,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }
}

class _AttachmentLoadingList extends StatelessWidget {
  const _AttachmentLoadingList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(
        4,
        (int index) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: PwSectionCard(
            child: SizedBox(
              height: 96,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 16,
                            width: 140,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Container(
                            height: 12,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Container(
                            height: 12,
                            width: 90,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool _isImage(Attachment attachment) {
  return attachment.kind == AttachmentKind.image ||
      (attachment.mimeType ?? '').toLowerCase().startsWith('image/');
}

IconData _fileIcon(Attachment attachment) {
  if (_isImage(attachment)) {
    return Icons.image_outlined;
  }

  final String mimeType = (attachment.mimeType ?? '').toLowerCase();
  if (mimeType.contains('pdf')) {
    return Icons.picture_as_pdf_outlined;
  }
  if (mimeType.contains('sheet') || mimeType.contains('excel')) {
    return Icons.table_chart_outlined;
  }
  if (mimeType.contains('word') || mimeType.contains('document')) {
    return Icons.description_outlined;
  }
  return Icons.insert_drive_file_outlined;
}

String _kindLabel(BuildContext context, AttachmentKind kind) {
  return switch (kind) {
    AttachmentKind.image => context.tr.attachmentsTypeImage,
    AttachmentKind.receipt => context.tr.attachmentsTypeReceipt,
    AttachmentKind.proofOfPayment => context.tr.attachmentsTypeProofOfPayment,
    AttachmentKind.supportingDocument => context.tr.attachmentsTypeDocument,
  };
}

String _formatFileSize(int? bytes) {
  if (bytes == null || bytes <= 0) {
    return '--';
  }
  const List<String> units = <String>['B', 'KB', 'MB', 'GB'];
  double size = bytes.toDouble();
  int unitIndex = 0;
  while (size >= 1024 && unitIndex < units.length - 1) {
    size /= 1024;
    unitIndex += 1;
  }
  final String value = size >= 10 || unitIndex == 0
      ? size.toStringAsFixed(0)
      : size.toStringAsFixed(1);
  return '$value ${units[unitIndex]}';
}

TextDirection _resolveTextDirection(String value) {
  final String trimmed = value.trim();
  if (trimmed.isEmpty) {
    return TextDirection.rtl;
  }

  final RegExp arabicPattern = RegExp(r'[\u0600-\u06FF]');
  final RegExp latinPattern = RegExp(r'[A-Za-z0-9]');
  final bool hasArabic = arabicPattern.hasMatch(trimmed);
  final bool hasLatin = latinPattern.hasMatch(trimmed);

  if (hasArabic && !hasLatin) {
    return TextDirection.rtl;
  }
  if (hasLatin && !hasArabic) {
    return TextDirection.ltr;
  }
  return TextDirection.rtl;
}
