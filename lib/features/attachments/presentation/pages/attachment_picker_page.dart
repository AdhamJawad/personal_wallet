import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/enums/attachment_kind.dart';
import '../../domain/enums/attachment_reference_type.dart';
import '../../domain/models/attachment_draft.dart';
import '../../domain/models/attachment_reference.dart';
import '../providers/attachment_providers.dart';

class AttachmentPickerPage extends ConsumerStatefulWidget {
  const AttachmentPickerPage({
    required this.entityType,
    required this.entityId,
    this.label,
    super.key,
  });

  final String entityType;
  final String entityId;
  final String? label;

  @override
  ConsumerState<AttachmentPickerPage> createState() =>
      _AttachmentPickerPageState();
}

class _AttachmentPickerPageState extends ConsumerState<AttachmentPickerPage> {
  final List<_AttachmentDraftForm> _draftForms = <_AttachmentDraftForm>[
    _AttachmentDraftForm(),
  ];

  AttachmentReference get _reference => AttachmentReference(
    type: AttachmentReferenceType.values.firstWhere(
      (AttachmentReferenceType item) => item.name == widget.entityType,
    ),
    entityId: widget.entityId,
    label: widget.label,
  );

  @override
  void dispose() {
    for (final _AttachmentDraftForm form in _draftForms) {
      form.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    final List<AttachmentDraft> drafts = _draftForms
        .where((form) => form.fileName.text.trim().isNotEmpty)
        .map(
          (form) => AttachmentDraft(
            kind: form.kind,
            fileName: form.fileName.text.trim(),
            localUri: form.localUri.text.trim(),
            mimeType: form.mimeType.text.trim().isEmpty
                ? null
                : form.mimeType.text.trim(),
            byteSize: int.tryParse(form.byteSize.text.trim()),
          ),
        )
        .where((draft) => draft.localUri.isNotEmpty)
        .toList(growable: false);

    if (drafts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add at least one attachment with file name and URI.'),
        ),
      );
      return;
    }

    final bool success = await ref
        .read(attachmentControllerProvider.notifier)
        .createAttachments(reference: _reference, drafts: drafts);

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(attachmentControllerProvider).errorMessage ??
                'Unable to add attachments.',
          ),
        ),
      );
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final attachmentState = ref.watch(attachmentControllerProvider);

    return PwScaffold(
      title: 'Attachment Picker',
      body: ListView(
        children: <Widget>[
          Text(
            widget.label ?? '${widget.entityType} ${widget.entityId}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          ..._draftForms.asMap().entries.map((entry) {
            final int index = entry.key;
            final _AttachmentDraftForm form = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: PwSectionCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(child: Text('File ${index + 1}')),
                          if (_draftForms.length > 1)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  form.dispose();
                                  _draftForms.removeAt(index);
                                });
                              },
                              child: const Text('Remove'),
                            ),
                        ],
                      ),
                      DropdownButtonFormField<AttachmentKind>(
                        initialValue: form.kind,
                        decoration: const InputDecoration(labelText: 'Type'),
                        items: AttachmentKind.values
                            .map(
                              (AttachmentKind kind) => DropdownMenuItem(
                                value: kind,
                                child: Text(kind.name),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (AttachmentKind? value) {
                          if (value != null) {
                            setState(() => form.kind = value);
                          }
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      PwTextField(
                        controller: form.fileName,
                        label: 'File name',
                        hint: 'receipt_june.jpg',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      PwTextField(
                        controller: form.localUri,
                        label: 'Local URI / path',
                        hint: '/local/storage/receipt_june.jpg',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      PwTextField(
                        controller: form.mimeType,
                        label: 'MIME type',
                        hint: 'image/jpeg',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      PwTextField(
                        controller: form.byteSize,
                        label: 'Byte size',
                        hint: '102400',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          Row(
            children: <Widget>[
              PwButton.secondary(
                label: 'Add another',
                onPressed: () {
                  setState(() => _draftForms.add(_AttachmentDraftForm()));
                },
              ),
              const SizedBox(width: AppSpacing.md),
              PwButton.primary(
                label: 'Save attachments',
                isLoading: attachmentState.isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AttachmentDraftForm {
  _AttachmentDraftForm();

  final TextEditingController fileName = TextEditingController();
  final TextEditingController localUri = TextEditingController();
  final TextEditingController mimeType = TextEditingController();
  final TextEditingController byteSize = TextEditingController();
  AttachmentKind kind = AttachmentKind.receipt;

  void dispose() {
    fileName.dispose();
    localUri.dispose();
    mimeType.dispose();
    byteSize.dispose();
  }
}
