import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/presentation/widgets/app_modal_bottom_sheet.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../attachments/domain/enums/attachment_reference_type.dart';
import '../../../attachments/domain/models/attachment.dart';
import '../../../attachments/domain/models/attachment_reference.dart';
import '../../../attachments/presentation/providers/attachment_providers.dart';
import '../../../audit/presentation/providers/audit_providers.dart';
import '../../../dashboard/presentation/widgets/dashboard_empty_state.dart';
import '../../../dashboard/presentation/widgets/dashboard_surface_card.dart';
import '../../../debts/domain/models/debt_summary.dart';
import '../../../debts/presentation/pages/create_debt_page.dart';
import '../../../debts/presentation/providers/debt_providers.dart';
import '../../domain/models/contact.dart';
import '../../presentation/providers/contact_providers.dart';

class ContactDetailsPage extends ConsumerStatefulWidget {
  const ContactDetailsPage({required this.contactId, super.key});

  final String contactId;

  @override
  ConsumerState<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends ConsumerState<ContactDetailsPage> {
  AttachmentReference get _attachmentReference => AttachmentReference(
    type: AttachmentReferenceType.contact,
    entityId: widget.contactId,
  );

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_loadData);
  }

  @override
  void didUpdateWidget(covariant ContactDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contactId != widget.contactId) {
      Future<void>.microtask(_loadData);
    }
  }

  Future<void> _loadData() async {
    await Future.wait(<Future<void>>[
      ref.read(contactControllerProvider.notifier).initialize(),
      ref.read(debtControllerProvider.notifier).initialize(),
      ref.read(auditControllerProvider.notifier).initialize(),
      ref
          .read(attachmentControllerProvider.notifier)
          .loadReference(_attachmentReference),
    ]);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    final bool launched = await launchUrl(uri);
    if (!launched && mounted) {
      _showMessage(context.tr.contactCallUnavailable);
    }
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final String digits = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri uri = Uri.parse('https://wa.me/${digits.replaceAll('+', '')}');
    final bool launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && mounted) {
      _showMessage(context.tr.contactWhatsAppUnavailable);
    }
  }

  Future<void> _downloadAttachment(Attachment attachment) async {
    final File source = File(attachment.localUri);
    if (!await source.exists()) {
      if (mounted) {
        _showMessage(context.tr.attachmentDownloadFailed);
      }
      return;
    }

    final String? downloadsDirectoryPath = _downloadsDirectoryPath();
    if (downloadsDirectoryPath == null) {
      if (mounted) {
        _showMessage(context.tr.attachmentDownloadUnsupported);
      }
      return;
    }

    try {
      final Directory downloadsDirectory = Directory(downloadsDirectoryPath);
      if (!await downloadsDirectory.exists()) {
        await downloadsDirectory.create(recursive: true);
      }

      final String targetPath = await _uniqueDownloadPath(
        directory: downloadsDirectory.path,
        fileName: attachment.fileName,
      );
      await source.copy(targetPath);

      if (mounted) {
        _showMessage(context.tr.attachmentDownloaded(attachment.fileName));
      }
    } catch (_) {
      if (mounted) {
        _showMessage(context.tr.attachmentDownloadFailed);
      }
    }
  }

  String? _downloadsDirectoryPath() {
    if (Platform.isWindows) {
      final String? userProfile = Platform.environment['USERPROFILE'];
      return userProfile == null ? null : '$userProfile\\Downloads';
    }
    if (Platform.isLinux || Platform.isMacOS) {
      final String? home = Platform.environment['HOME'];
      return home == null ? null : '$home/Downloads';
    }
    return null;
  }

  Future<String> _uniqueDownloadPath({
    required String directory,
    required String fileName,
  }) async {
    final int extensionIndex = fileName.lastIndexOf('.');
    final String baseName = extensionIndex <= 0
        ? fileName
        : fileName.substring(0, extensionIndex);
    final String extension = extensionIndex <= 0
        ? ''
        : fileName.substring(extensionIndex);

    String candidate = '$directory${Platform.pathSeparator}$fileName';
    int suffix = 1;
    while (await File(candidate).exists()) {
      candidate =
          '$directory${Platform.pathSeparator}$baseName ($suffix)$extension';
      suffix += 1;
    }
    return candidate;
  }

  void _openAttachmentViewer(Contact contact) {
    context.push(
      '${AppRoutes.attachmentViewerPath}?entityType=contact&entityId=${Uri.encodeComponent(contact.id)}&label=${Uri.encodeComponent(contact.name)}',
    );
  }

  Future<void> _showEditSheet(Contact contact) {
    return showAppModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _EditContactSheet(contact: contact);
      },
    );
  }

  Future<void> _showContactTimelineSheet(
    BuildContext context, {
    required List<_ContactTimelineEvent> events,
  }) {
    return showAppModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _ContactTimelineSheet(events: events);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final contactState = ref.watch(contactControllerProvider);
    final debtState = ref.watch(debtControllerProvider);
    final attachmentState = ref.watch(attachmentControllerProvider);
    ref.watch(auditControllerProvider);

    final Contact? contact = contactState.contacts.cast<Contact?>().firstWhere(
      (Contact? item) => item?.id == widget.contactId,
      orElse: () => null,
    );

    if (contact == null) {
      return PwScaffold(
        title: context.tr.contacts,
        body: Center(child: Text(context.tr.contactNotFound)),
      );
    }

    final List<DebtSummary> relatedDebts =
        debtState.debts
            .where((DebtSummary item) => item.contact.id == contact.id)
            .toList(growable: false)
          ..sort(
            (DebtSummary left, DebtSummary right) =>
                right.debt.updatedAt.compareTo(left.debt.updatedAt),
          );
    final List<DebtSummary> openDebts = relatedDebts
        .where((DebtSummary item) => !item.isCompleted)
        .toList(growable: false);
    final bool attachmentsReady =
        attachmentState.activeReference == _attachmentReference;
    final List<Attachment> attachments = attachmentsReady
        ? attachmentState.attachments
        : const <Attachment>[];
    final _ContactBalanceSummary balanceSummary =
        _ContactBalanceSummary.fromDebts(relatedDebts);
    final List<_ContactTimelineEvent> timelineEvents = _buildTimeline(
      context,
      debts: relatedDebts,
      attachments: attachments,
    );
    final String? phoneNumber = _normalizedText(contact.phoneNumber);

    return PwScaffold(
      title: context.tr.contactDetailsTitle,
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: <Widget>[
          _ContactHeroCard(contact: contact, balanceSummary: balanceSummary),
          const SizedBox(height: AppSpacing.md),
          _ContactQuickActions(
            hasPhone: phoneNumber != null,
            onEdit: () => _showEditSheet(contact),
            onCreateDebt: () => showCreateDebtSheet(
              context,
              initialContactId: contact.id,
              lockContact: true,
            ),
            onCall: phoneNumber == null
                ? null
                : () => _launchPhone(phoneNumber),
            onWhatsApp: phoneNumber == null
                ? null
                : () => _launchWhatsApp(phoneNumber),
          ),
          const SizedBox(height: AppSpacing.md),
          _ContactFinancialCard(summary: balanceSummary),
          const SizedBox(height: AppSpacing.md),
          if (openDebts.isEmpty)
            DashboardEmptyState(
              icon: Icons.receipt_long_outlined,
              title: context.tr.contactOpenDebtsEmptyTitle,
              message: context.tr.contactOpenDebtsEmptyMessage,
            )
          else
            _ContactOpenDebtsSection(debts: openDebts),
          if (attachments.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            _ContactAttachmentsSection(
              attachments: attachments,
              onPreview: () => _openAttachmentViewer(contact),
              onOpen: () => _openAttachmentViewer(contact),
              onDownload: _downloadAttachment,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          if (timelineEvents.isEmpty)
            DashboardEmptyState(
              icon: Icons.timeline_rounded,
              title: context.tr.contactActivityEmptyTitle,
              message: context.tr.contactActivityEmptyMessage,
            )
          else
            _ContactTimelineSection(
              events: timelineEvents,
              onViewAll: () =>
                  _showContactTimelineSheet(context, events: timelineEvents),
            ),
        ],
      ),
    );
  }
}

class _ContactHeroCard extends StatelessWidget {
  const _ContactHeroCard({required this.contact, required this.balanceSummary});

  final Contact contact;
  final _ContactBalanceSummary balanceSummary;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final String? phoneNumber = _normalizedText(contact.phoneNumber);

    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 24,
            backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
            child: Text(
              _initialsFor(contact.name),
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  contact.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _contactTypeLabel(context, contact),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  balanceSummary.netLabel(context),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (phoneNumber != null) ...<Widget>[
                  const SizedBox(height: 6),
                  _InfoRow(icon: Icons.call_outlined, value: phoneNumber),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactQuickActions extends StatelessWidget {
  const _ContactQuickActions({
    required this.hasPhone,
    required this.onEdit,
    required this.onCreateDebt,
    required this.onCall,
    required this.onWhatsApp,
  });

  final bool hasPhone;
  final VoidCallback onEdit;
  final VoidCallback onCreateDebt;
  final VoidCallback? onCall;
  final VoidCallback? onWhatsApp;

  @override
  Widget build(BuildContext context) {
    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: <Widget>[
          _ActionChip(
            icon: Icons.edit_outlined,
            label: context.tr.editContact,
            onTap: onEdit,
          ),
          _ActionChip(
            icon: Icons.add_card_rounded,
            label: context.tr.createDebt,
            onTap: onCreateDebt,
          ),
          if (hasPhone)
            _ActionChip(
              icon: Icons.call_outlined,
              label: context.tr.callContact,
              onTap: onCall!,
            ),
          if (hasPhone)
            _ActionChip(
              icon: Icons.chat_bubble_outline_rounded,
              label: context.tr.whatsAppContact,
              onTap: onWhatsApp!,
            ),
        ],
      ),
    );
  }
}

class _ContactFinancialCard extends StatelessWidget {
  const _ContactFinancialCard({required this.summary});

  final _ContactBalanceSummary summary;

  @override
  Widget build(BuildContext context) {
    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.tr.contactFinancialSummaryTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          _CompactSummaryRow(
            label: context.tr.owedToMe,
            value: summary.owedToMeLabel(context),
            tone: AppColors.success,
          ),
          const SizedBox(height: 6),
          _CompactSummaryRow(
            label: context.tr.iOwe,
            value: summary.iOweLabel(context),
            tone: AppColors.warning,
          ),
          const SizedBox(height: 6),
          _CompactSummaryRow(
            label: context.tr.contactNetBalanceLabel,
            value: summary.netLabel(context),
            tone: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _ContactOpenDebtsSection extends StatelessWidget {
  const _ContactOpenDebtsSection({required this.debts});

  final List<DebtSummary> debts;

  @override
  Widget build(BuildContext context) {
    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.tr.contactOpenDebtsTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...debts.map(
            (DebtSummary debt) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: _ContactDebtTile(debt: debt),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactDebtTile extends StatelessWidget {
  const _ContactDebtTile({required this.debt});

  final DebtSummary debt;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color tone = debt.debt.isOwedToMe
        ? AppColors.success
        : AppColors.warning;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(AppRoutes.debtDetailsLocation(debt.debt.id)),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.outlineSoft),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      context.tr.remainingAmountLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatMoney(
                        context,
                        debt.remainingAmount,
                        debt.currency,
                      ),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: tone,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _debtReference(context, debt),
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  _MetaChip(
                    label: debt.isCompleted
                        ? context.tr.settledStatus
                        : context.tr.openStatus,
                    icon: debt.isCompleted
                        ? Icons.check_circle_outline_rounded
                        : Icons.schedule_rounded,
                    tone: debt.isCompleted
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.primary,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${context.tr.createdLabel}: ${DateFormatter.short(debt.debt.createdAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactAttachmentsSection extends StatelessWidget {
  const _ContactAttachmentsSection({
    required this.attachments,
    required this.onPreview,
    required this.onOpen,
    required this.onDownload,
  });

  final List<Attachment> attachments;
  final VoidCallback onPreview;
  final VoidCallback onOpen;
  final ValueChanged<Attachment> onDownload;

  @override
  Widget build(BuildContext context) {
    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  context.tr.attachments,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: onOpen,
                child: Text(context.tr.openAttachmentViewer),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: attachments
                .map(
                  (Attachment attachment) => _ContactAttachmentCard(
                    attachment: attachment,
                    onPreview: onPreview,
                    onOpen: onOpen,
                    onDownload: () => onDownload(attachment),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _ContactAttachmentCard extends StatelessWidget {
  const _ContactAttachmentCard({
    required this.attachment,
    required this.onPreview,
    required this.onOpen,
    required this.onDownload,
  });

  final Attachment attachment;
  final VoidCallback onPreview;
  final VoidCallback onOpen;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: InkWell(
        onTap: onPreview,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.outlineSoft),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Center(child: Icon(Icons.attach_file_rounded, size: 28)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                attachment.fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormatter.short(attachment.createdAt),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: <Widget>[
                  _MiniIconButton(
                    icon: Icons.visibility_outlined,
                    onTap: onPreview,
                  ),
                  const SizedBox(width: 4),
                  _MiniIconButton(
                    icon: Icons.open_in_new_rounded,
                    onTap: onOpen,
                  ),
                  const SizedBox(width: 4),
                  _MiniIconButton(
                    icon: Icons.download_rounded,
                    onTap: onDownload,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactTimelineSection extends StatelessWidget {
  const _ContactTimelineSection({
    required this.events,
    required this.onViewAll,
  });

  final List<_ContactTimelineEvent> events;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final List<_ContactTimelineEvent> visibleEvents = events
        .take(5)
        .toList(growable: false);

    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  context.tr.recentActivity,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(onPressed: onViewAll, child: Text(context.tr.seeAll)),
            ],
          ),
          const SizedBox(height: 2),
          ...visibleEvents.asMap().entries.map(
            (MapEntry<int, _ContactTimelineEvent> entry) =>
                _ContactTimelineTile(
                  event: entry.value,
                  isLast: entry.key == visibleEvents.length - 1,
                ),
          ),
        ],
      ),
    );
  }
}

class _ContactTimelineTile extends StatelessWidget {
  const _ContactTimelineTile({required this.event, required this.isLast});

  final _ContactTimelineEvent event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: AppColors.outlineSoft.withValues(alpha: 0.9),
                ),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: event.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(event.icon, size: 18, color: event.color),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  event.title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormatter.short(event.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (event.amountLabel != null) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    event.amountLabel!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: event.color,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactTimelineSheet extends StatelessWidget {
  const _ContactTimelineSheet({required this.events});

  final List<_ContactTimelineEvent> events;

  @override
  Widget build(BuildContext context) {
    final double keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final double maxHeight = MediaQuery.sizeOf(context).height * 0.82;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md + keyboardInset,
        ),
        child: DashboardSurfaceCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text(
                context.tr.recentActivity,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.xs),
              ...events.asMap().entries.map(
                (MapEntry<int, _ContactTimelineEvent> entry) =>
                    _ContactTimelineTile(
                      event: entry.value,
                      isLast: entry.key == events.length - 1,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditContactSheet extends ConsumerStatefulWidget {
  const _EditContactSheet({required this.contact});

  final Contact contact;

  @override
  ConsumerState<_EditContactSheet> createState() => _EditContactSheetState();
}

class _EditContactSheetState extends ConsumerState<_EditContactSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact.name);
    _phoneController = TextEditingController(
      text: widget.contact.phoneNumber ?? '',
    );
    _noteController = TextEditingController(text: widget.contact.note ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final bool success = await ref
        .read(contactControllerProvider.notifier)
        .updateContact(
          contactId: widget.contact.id,
          name: _nameController.text,
          phoneNumber: _phoneController.text,
          note: _noteController.text,
        );

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.of(context).pop();
      return;
    }

    final String message =
        ref.read(contactControllerProvider).errorMessage ??
        context.tr.contactSaveFailed;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(contactControllerProvider).isLoading;
    final double keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + keyboardInset,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              context.tr.editContact,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              context.tr.editContactHelper,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            PwTextField(
              controller: _nameController,
              label: context.tr.fullName,
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return context.tr.fullNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            PwTextField(
              controller: _phoneController,
              label: context.tr.phoneNumber,
            ),
            const SizedBox(height: AppSpacing.sm),
            PwTextField(
              controller: _noteController,
              label: context.tr.note,
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: <Widget>[
                Expanded(
                  child: PwButton.secondary(
                    label: context.tr.cancel,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: PwButton.primary(
                    label: context.tr.saveChanges,
                    isLoading: isLoading,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.icon, this.tone});

  final String label;
  final IconData icon;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final Color resolvedTone = tone ?? Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: resolvedTone.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: resolvedTone),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: resolvedTone,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: <Widget>[
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: AppColors.outlineSoft),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 18, color: colorScheme.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactSummaryRow extends StatelessWidget {
  const _CompactSummaryRow({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          value,
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: tone,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _MiniIconButton extends StatelessWidget {
  const _MiniIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 16, color: colorScheme.primary),
      ),
    );
  }
}

class _ContactBalanceSummary {
  const _ContactBalanceSummary({
    required this.owedUsd,
    required this.owedSyp,
    required this.iOweUsd,
    required this.iOweSyp,
  });

  factory _ContactBalanceSummary.fromDebts(List<DebtSummary> debts) {
    num owedUsd = 0;
    num owedSyp = 0;
    num iOweUsd = 0;
    num iOweSyp = 0;

    for (final DebtSummary debt in debts) {
      final num remaining = num.tryParse(debt.remainingAmount) ?? 0;
      if (debt.currency.name == 'usd') {
        if (debt.debt.isOwedToMe) {
          owedUsd += remaining;
        } else {
          iOweUsd += remaining;
        }
      } else if (debt.debt.isOwedToMe) {
        owedSyp += remaining;
      } else {
        iOweSyp += remaining;
      }
    }

    return _ContactBalanceSummary(
      owedUsd: owedUsd,
      owedSyp: owedSyp,
      iOweUsd: iOweUsd,
      iOweSyp: iOweSyp,
    );
  }

  final num owedUsd;
  final num owedSyp;
  final num iOweUsd;
  final num iOweSyp;

  String owedToMeLabel(BuildContext context) =>
      _formatCurrencyPair(context, usdAmount: owedUsd, sypAmount: owedSyp);

  String iOweLabel(BuildContext context) =>
      _formatCurrencyPair(context, usdAmount: iOweUsd, sypAmount: iOweSyp);

  String netLabel(BuildContext context) {
    final num usdNet = owedUsd - iOweUsd;
    final num sypNet = owedSyp - iOweSyp;
    final List<String> segments = <String>[];

    if (usdNet != 0 || sypNet == 0) {
      segments.add(_signedAmount(context, usdNet, context.tr.usdShort));
    }
    if (sypNet != 0) {
      segments.add(_signedAmount(context, sypNet, context.tr.sypShort));
    }

    return segments.join(' آ· ');
  }

  String _formatCurrencyPair(
    BuildContext context, {
    required num usdAmount,
    required num sypAmount,
  }) {
    final List<String> segments = <String>[];

    if (usdAmount > 0 || (usdAmount == 0 && sypAmount == 0)) {
      segments.add(
        '\u2066${AmountFormatter.format(usdAmount.toString())} ${context.tr.usdShort}\u2069',
      );
    }
    if (sypAmount > 0) {
      segments.add(
        '\u2066${AmountFormatter.format(sypAmount.toString())} ${context.tr.sypShort}\u2069',
      );
    }

    return segments.join(' آ· ');
  }

  String _signedAmount(BuildContext context, num value, String currencyLabel) {
    final String sign = value > 0
        ? '+'
        : value < 0
        ? '-'
        : '';
    return '\u2066$sign${AmountFormatter.format(value.abs().toString())} $currencyLabel\u2069';
  }
}

class _ContactTimelineEvent {
  const _ContactTimelineEvent({
    required this.title,
    required this.icon,
    required this.color,
    required this.createdAt,
    this.amountLabel,
  });

  final String title;
  final IconData icon;
  final Color color;
  final DateTime createdAt;
  final String? amountLabel;
}

List<_ContactTimelineEvent> _buildTimeline(
  BuildContext context, {
  required List<DebtSummary> debts,
  required List<Attachment> attachments,
}) {
  final List<_ContactTimelineEvent> events = <_ContactTimelineEvent>[];

  for (final DebtSummary debt in debts) {
    events.add(
      _ContactTimelineEvent(
        title: context.tr.debtCreatedEvent,
        icon: Icons.receipt_long_outlined,
        color: Theme.of(context).colorScheme.primary,
        createdAt: debt.debt.createdAt,
        amountLabel: _formatMoney(
          context,
          debt.debt.originalAmount,
          debt.currency,
        ),
      ),
    );

    for (final repayment in debt.repayments) {
      events.add(
        _ContactTimelineEvent(
          title: context.tr.partialPaymentEvent,
          icon: Icons.payments_outlined,
          color: AppColors.success,
          createdAt: repayment.createdAt,
          amountLabel: _formatMoney(context, repayment.amount, debt.currency),
        ),
      );
    }

    for (final settlement in debt.settlements) {
      events.add(
        _ContactTimelineEvent(
          title: context.tr.fullSettlementEvent,
          icon: Icons.check_circle_outline_rounded,
          color: AppColors.success,
          createdAt: settlement.settlement.createdAt,
          amountLabel: _formatMoney(
            context,
            settlement.settlement.amount,
            debt.currency,
          ),
        ),
      );
    }
  }

  for (final Attachment attachment in attachments) {
    events.add(
      _ContactTimelineEvent(
        title: context.tr.attachmentAddedEvent,
        icon: Icons.attach_file_rounded,
        color: Theme.of(context).colorScheme.secondary,
        createdAt: attachment.createdAt,
      ),
    );
  }

  events.sort(
    (_ContactTimelineEvent left, _ContactTimelineEvent right) =>
        right.createdAt.compareTo(left.createdAt),
  );
  return events;
}

String _debtReference(BuildContext context, DebtSummary debt) {
  return context.tr.transactionReferenceLabel(
    context.tr.debt,
    debt.debt.id.replaceAll('_', '-').toUpperCase(),
  );
}

String _formatMoney(BuildContext context, String amount, Currency currency) {
  final String currencyLabel = currency.name == 'usd'
      ? context.tr.usdShort
      : context.tr.sypShort;
  return '\u2066${AmountFormatter.format(amount)} $currencyLabel\u2069';
}

String _contactTypeLabel(BuildContext context, Contact contact) {
  return _isBusinessContact(contact)
      ? context.tr.contactTypeBusiness
      : context.tr.contactTypePerson;
}

bool _isBusinessContact(Contact contact) {
  final String source = '${contact.name} ${contact.note ?? ''}'.toLowerCase();
  const List<String> keywords = <String>[
    'store',
    'shop',
    'market',
    'company',
    'supplier',
    'business',
    'مؤسسة',
    'شركة',
    'متجر',
    'محل',
  ];
  return keywords.any(source.contains);
}

String _initialsFor(String name) {
  final List<String> parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((String item) => item.isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty) {
    return '?';
  }
  if (parts.length == 1) {
    return _firstChar(parts.first).toUpperCase();
  }
  return '${_firstChar(parts.first)}${_firstChar(parts.last)}'.toUpperCase();
}

String? _normalizedText(String? value) {
  if (value == null) {
    return null;
  }
  final String normalized = value.trim();
  return normalized.isEmpty ? null : normalized;
}

String _firstChar(String value) {
  return value.isEmpty ? '?' : String.fromCharCode(value.runes.first);
}
