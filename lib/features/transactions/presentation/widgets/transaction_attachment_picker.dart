import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/presentation/widgets/app_modal_bottom_sheet.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../features/attachments/domain/enums/attachment_kind.dart';

class TransactionAttachmentDraft {
  const TransactionAttachmentDraft({
    required this.fileName,
    required this.localUri,
    required this.bytes,
    required this.kind,
    this.mimeType,
  });

  final String fileName;
  final String localUri;
  final Uint8List bytes;
  final AttachmentKind kind;
  final String? mimeType;

  int get byteSize => bytes.lengthInBytes;
}

Future<TransactionAttachmentDraft?> showTransactionAttachmentSourceSheet({
  required BuildContext context,
}) {
  return showAppModalBottomSheet<TransactionAttachmentDraft>(
    context: context,
    builder: (BuildContext context) {
      return const _AttachmentSourceSheet();
    },
    isScrollControlled: true,
  );
}

class TransactionAttachmentList extends StatelessWidget {
  const TransactionAttachmentList({
    required this.attachments,
    required this.onRemove,
    super.key,
  });

  final List<TransactionAttachmentDraft> attachments;
  final ValueChanged<TransactionAttachmentDraft> onRemove;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: attachments
          .map(
            (TransactionAttachmentDraft attachment) => _AttachmentPreviewChip(
              attachment: attachment,
              onRemove: () => onRemove(attachment),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _AttachmentSourceSheet extends StatefulWidget {
  const _AttachmentSourceSheet();

  @override
  State<_AttachmentSourceSheet> createState() => _AttachmentSourceSheetState();
}

class _AttachmentSourceSheetState extends State<_AttachmentSourceSheet> {
  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false;

  Future<void> _pick(ImageSource source) async {
    if (_isPicking) {
      return;
    }

    setState(() => _isPicking = true);
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 88,
      );

      if (!mounted || file == null) {
        return;
      }

      final Uint8List bytes = await file.readAsBytes();
      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(
        TransactionAttachmentDraft(
          fileName: file.name,
          localUri: file.path,
          bytes: bytes,
          kind: source == ImageSource.camera
              ? AttachmentKind.proofOfPayment
              : AttachmentKind.receipt,
          mimeType: _inferMimeType(file.name),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    context.tr.addAttachment,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _AttachmentActionTile(
                    icon: Icons.camera_alt_outlined,
                    title: context.tr.takePhoto,
                    subtitle: context.tr.takePhotoSubtitle,
                    onTap: _isPicking ? null : () => _pick(ImageSource.camera),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _AttachmentActionTile(
                    icon: Icons.photo_library_outlined,
                    title: context.tr.chooseFromGallery,
                    subtitle: context.tr.chooseFromGallerySubtitle,
                    onTap:
                        _isPicking ? null : () => _pick(ImageSource.gallery),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton(
                    onPressed:
                        _isPicking ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.onSurface,
                    ),
                    child: Text(
                      _isPicking
                          ? context.tr.preparingPicker
                          : context.tr.cancel,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentActionTile extends StatelessWidget {
  const _AttachmentActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.outlineSoft.withValues(alpha: 0.7),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: colorScheme.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentPreviewChip extends StatelessWidget {
  const _AttachmentPreviewChip({
    required this.attachment,
    required this.onRemove,
  });

  final TransactionAttachmentDraft attachment;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(maxWidth: 220),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outlineSoft.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(
              attachment.bytes,
              width: 36,
              height: 36,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  attachment.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 28, height: 28),
            tooltip: context.tr.removeAttachment,
            icon: const Icon(Icons.close, size: 18),
          ),
        ],
      ),
    );
  }
}

String? _inferMimeType(String fileName) {
  final String normalized = fileName.toLowerCase();
  if (normalized.endsWith('.png')) {
    return 'image/png';
  }
  if (normalized.endsWith('.webp')) {
    return 'image/webp';
  }
  return 'image/jpeg';
}
