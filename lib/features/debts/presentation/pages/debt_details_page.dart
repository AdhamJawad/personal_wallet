import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/presentation/widgets/app_modal_bottom_sheet.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/feedback/app_feedback.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../features/attachments/domain/enums/attachment_reference_type.dart';
import '../../../../features/attachments/domain/models/attachment.dart';
import '../../../../features/attachments/domain/models/attachment_draft.dart';
import '../../../../features/attachments/domain/models/attachment_reference.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../attachments/presentation/providers/attachment_providers.dart';
import '../../../dashboard/presentation/widgets/dashboard_empty_state.dart';
import '../../../dashboard/presentation/widgets/dashboard_skeleton_block.dart';
import '../../../dashboard/presentation/widgets/dashboard_surface_card.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../../transactions/presentation/widgets/transaction_attachment_picker.dart';
import '../../../transactions/presentation/widgets/transaction_flow_support.dart';
import '../../../transactions/presentation/widgets/transaction_form_validators.dart';
import '../../../wallets/domain/models/wallet_overview.dart';
import '../../../wallets/presentation/providers/wallet_providers.dart';
import '../../domain/models/debt_summary.dart';
import '../../domain/models/settlement_summary.dart';
import 'create_debt_repayment_page.dart';
import '../providers/debt_providers.dart';

class DebtDetailsPage extends ConsumerStatefulWidget {
  const DebtDetailsPage({required this.debtId, super.key});

  final String debtId;

  @override
  ConsumerState<DebtDetailsPage> createState() => _DebtDetailsPageState();
}

class _DebtDetailsPageState extends ConsumerState<DebtDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _timelineKey = GlobalKey();

  AttachmentReference get _attachmentReference => AttachmentReference(
    type: AttachmentReferenceType.debt,
    entityId: widget.debtId,
  );

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_loadData);
  }

  @override
  void didUpdateWidget(covariant DebtDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.debtId != widget.debtId) {
      Future<void>.microtask(_loadData);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await ref.read(debtControllerProvider.notifier).loadDebt(widget.debtId);
    if (!mounted) {
      return;
    }
    await ref
        .read(attachmentControllerProvider.notifier)
        .loadReference(_attachmentReference);
  }

  Future<void> _retryLoadData() async {
    await _loadData();
  }

  Future<void> _scrollToTimeline() async {
    final BuildContext? timelineContext = _timelineKey.currentContext;
    if (timelineContext == null) {
      return;
    }
    await Scrollable.ensureVisible(
      timelineContext,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      alignment: 0.08,
    );
  }

  void _showUnavailableMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _downloadAttachment(Attachment attachment) async {
    final File source = File(attachment.localUri);
    if (!await source.exists()) {
      if (!mounted) {
        return;
      }
      _showUnavailableMessage(context.tr.attachmentDownloadFailed);
      return;
    }

    final String? downloadsDirectoryPath = _downloadsDirectoryPath();
    if (downloadsDirectoryPath == null) {
      if (!mounted) {
        return;
      }
      _showUnavailableMessage(context.tr.attachmentDownloadUnsupported);
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

      if (!mounted) {
        return;
      }
      _showUnavailableMessage(
        context.tr.attachmentDownloaded(attachment.fileName),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showUnavailableMessage(context.tr.attachmentDownloadFailed);
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
          '$directory${Platform.pathSeparator}$baseName-$suffix$extension';
      suffix += 1;
    }

    return candidate;
  }

  void _openAttachmentViewer(DebtSummary summary) {
    context.push(
      '${AppRoutes.attachmentViewerPath}?entityType=debt&entityId=${Uri.encodeComponent(summary.debt.id)}&label=${Uri.encodeComponent(summary.contact.name)}',
    );
  }

  Future<void> _showEditDebtSheet(DebtSummary summary) {
    return showAppModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _EditDebtSheet(summary: summary);
      },
    );
  }

  Future<void> _showCloseDebtSheet(DebtSummary summary) {
    return showAppModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return _CloseDebtSettlementSheet(
          summary: summary,
          onCompleted: _loadData,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final debtState = ref.watch(debtControllerProvider);
    final attachmentState = ref.watch(attachmentControllerProvider);
    final DebtSummary? summary = debtState.selectedDebt;
    final bool isAttachmentReferenceActive =
        attachmentState.activeReference?.type == _attachmentReference.type &&
        attachmentState.activeReference?.entityId ==
            _attachmentReference.entityId;
    final List<Attachment> attachments = isAttachmentReferenceActive
        ? attachmentState.attachments
        : const <Attachment>[];
    final List<_DebtTimelineEvent> timelineEvents = summary == null
        ? const <_DebtTimelineEvent>[]
        : _buildTimelineEvents(context, summary, attachments: attachments);

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.debtDetailsTitle, style: context.titleMedium),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? <Color>[AppColors.brandDark, AppColors.surfaceDark]
                : <Color>[AppColors.canvasTop, AppColors.canvasBottom],
          ),
        ),
        child: debtState.isLoading && summary == null
            ? const _DebtDetailsSkeleton()
            : debtState.errorMessage != null && summary == null
            ? Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: DashboardEmptyState.error(
                    title: context.tr.somethingWentWrong,
                    message: context.tr.debtsLoadFailedMessage,
                    actionLabel: context.tr.tryAgain,
                    onActionPressed: _retryLoadData,
                    secondaryActionLabel: context.tr.back,
                    onSecondaryActionPressed: () =>
                        context.go(AppRoutes.debtsPath),
                  ),
                ),
              )
            : summary == null
            ? Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: DashboardEmptyState.notFound(
                    title: context.tr.debtNotFound,
                    message: context.tr.debtNotFound,
                    actionLabel: context.tr.tryAgain,
                    onActionPressed: _retryLoadData,
                    secondaryActionLabel: context.tr.back,
                    onSecondaryActionPressed: () =>
                        context.go(AppRoutes.debtsPath),
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadData,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 820),
                    child: ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.lg,
                        AppSpacing.lg,
                      ),
                      children: <Widget>[
                        _DebtHeaderCard(summary: summary),
                        const SizedBox(height: AppSpacing.md),
                        _DebtQuickActionsRow(
                          summary: summary,
                          onRecordPayment: () => showCreateDebtRepaymentSheet(
                            context,
                            debtId: summary.debt.id,
                          ),
                          onEditDebt: () => _showEditDebtSheet(summary),
                          onCloseDebt: () => _showCloseDebtSheet(summary),
                          onViewHistory: _scrollToTimeline,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _DebtFinancialSummaryCard(summary: summary),
                        if ((summary.debt.note ?? '')
                            .trim()
                            .isNotEmpty) ...<Widget>[
                          const SizedBox(height: AppSpacing.md),
                          _DebtNotesCard(note: summary.debt.note!.trim()),
                        ],
                        if (attachmentState.isLoading &&
                            isAttachmentReferenceActive)
                          const Padding(
                            padding: EdgeInsets.only(top: AppSpacing.md),
                            child: _DebtAttachmentsLoadingCard(),
                          )
                        else if (attachmentState.errorMessage != null &&
                            isAttachmentReferenceActive &&
                            attachments.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.md),
                            child: DashboardEmptyState.error(
                              title: context.tr.somethingWentWrong,
                              message: context.tr.attachmentsLoadFailedMessage,
                              actionLabel: context.tr.tryAgain,
                              onActionPressed: () {
                                ref
                                    .read(attachmentControllerProvider.notifier)
                                    .loadReference(_attachmentReference);
                              },
                            ),
                          )
                        else if (attachments.isNotEmpty) ...<Widget>[
                          const SizedBox(height: AppSpacing.md),
                          _DebtAttachmentsCard(
                            attachments: attachments,
                            onPreview: () => _openAttachmentViewer(summary),
                            onOpen: () => _openAttachmentViewer(summary),
                            onDownload: _downloadAttachment,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        _DebtTimelineCard(
                          key: _timelineKey,
                          events: timelineEvents,
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

class _DebtDetailsSkeleton extends StatelessWidget {
  const _DebtDetailsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      children: const <Widget>[
        DashboardSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DashboardSkeletonBlock(height: 22, width: 156),
              SizedBox(height: AppSpacing.sm),
              DashboardSkeletonBlock(height: 14, width: 118),
              SizedBox(height: AppSpacing.sm),
              DashboardSkeletonBlock(height: 30, width: 188),
              SizedBox(height: AppSpacing.sm),
              DashboardSkeletonBlock(height: 8, width: double.infinity),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        DashboardSurfaceCard(
          child: Row(
            children: <Widget>[
              Expanded(
                child: DashboardSkeletonBlock(
                  height: 38,
                  width: 88,
                  radius: AppRadius.pill,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: DashboardSkeletonBlock(
                  height: 38,
                  width: 88,
                  radius: AppRadius.pill,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        DashboardSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DashboardSkeletonBlock(height: 18, width: 132),
              SizedBox(height: AppSpacing.sm),
              DashboardSkeletonBlock(height: 14, width: double.infinity),
              SizedBox(height: AppSpacing.xs),
              DashboardSkeletonBlock(height: 14, width: double.infinity),
              SizedBox(height: AppSpacing.xs),
              DashboardSkeletonBlock(height: 14, width: 220),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        _DebtAttachmentsLoadingCard(),
        SizedBox(height: AppSpacing.md),
        DashboardSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DashboardSkeletonBlock(height: 18, width: 128),
              SizedBox(height: AppSpacing.sm),
              DashboardSkeletonBlock(height: 72, width: double.infinity),
            ],
          ),
        ),
      ],
    );
  }
}

class _DebtAttachmentsLoadingCard extends StatelessWidget {
  const _DebtAttachmentsLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const DashboardSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DashboardSkeletonBlock(height: 18, width: 132),
          SizedBox(height: AppSpacing.sm),
          DashboardSkeletonBlock(height: 56, width: double.infinity),
        ],
      ),
    );
  }
}

class _DebtHeaderCard extends StatelessWidget {
  const _DebtHeaderCard({required this.summary});

  final DebtSummary summary;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color directionColor = summary.debt.isOwedToMe
        ? AppColors.success
        : AppColors.warning;
    final bool isOpen = !summary.isCompleted;
    final Color statusColor = isOpen
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    final num original = num.tryParse(summary.debt.originalAmount) ?? 0;
    final num remaining = num.tryParse(summary.remainingAmount) ?? 0;
    final num paid = num.tryParse(summary.repaidAmount) ?? 0;
    final double progressValue = original <= 0
        ? 0
        : (paid / original).clamp(0, 1).toDouble();
    final int remainingPercent = original <= 0
        ? 0
        : ((remaining / original) * 100).round().clamp(0, 100);

    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextButton(
            onPressed: () => context.push(
              AppRoutes.contactDetailsLocation(summary.contact.id),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: AlignmentDirectional.centerStart,
            ),
            child: Text(
              summary.contact.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.04,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Text(
                summary.debt.isOwedToMe ? context.tr.owedToMe : context.tr.iOwe,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: directionColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '•',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              _DebtInfoChip(
                label: isOpen
                    ? context.tr.openStatus
                    : context.tr.settledStatus,
                backgroundColor: statusColor.withValues(alpha: 0.10),
                foregroundColor: statusColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${_formatMoney(context, summary.remainingAmount, summary.currency)} ${context.tr.remainingAmountLabel}',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${context.tr.ofAmountPrefix} ${_formatMoney(context, summary.debt.originalAmount, summary.currency)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(minHeight: 8, value: progressValue),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.tr.remainingPercentLabel(remainingPercent),
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DebtQuickActionsRow extends StatelessWidget {
  const _DebtQuickActionsRow({
    required this.summary,
    required this.onRecordPayment,
    required this.onEditDebt,
    required this.onCloseDebt,
    required this.onViewHistory,
  });

  final DebtSummary summary;
  final VoidCallback onRecordPayment;
  final VoidCallback onEditDebt;
  final VoidCallback onCloseDebt;
  final VoidCallback onViewHistory;

  @override
  Widget build(BuildContext context) {
    final List<Widget> actions = summary.isCompleted
        ? <Widget>[
            _DebtActionIconButton(
              icon: Icons.history_rounded,
              label: context.tr.viewHistory,
              onTap: onViewHistory,
            ),
          ]
        : <Widget>[
            _DebtActionIconButton(
              icon: Icons.payments_outlined,
              label: context.tr.recordPayment,
              onTap: onRecordPayment,
            ),
            _DebtActionIconButton(
              icon: Icons.edit_outlined,
              label: context.tr.editDebt,
              onTap: onEditDebt,
            ),
            _DebtActionIconButton(
              icon: Icons.task_alt_rounded,
              label: context.tr.closeDebt,
              onTap: onCloseDebt,
            ),
          ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: actions
            .map(
              (Widget action) => Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                child: action,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _DebtFinancialSummaryCard extends StatelessWidget {
  const _DebtFinancialSummaryCard({required this.summary});

  final DebtSummary summary;

  @override
  Widget build(BuildContext context) {
    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final List<Widget> metrics = <Widget>[
            _DebtSummaryMetric(
              label: context.tr.originalAmountLabel,
              value: _formatMoney(
                context,
                summary.debt.originalAmount,
                summary.currency,
              ),
            ),
            _DebtSummaryMetric(
              label: context.tr.paidAmountLabel,
              value: _formatMoney(
                context,
                summary.repaidAmount,
                summary.currency,
              ),
            ),
            _DebtSummaryMetric(
              label: context.tr.remainingAmountLabel,
              value: _formatMoney(
                context,
                summary.remainingAmount,
                summary.currency,
              ),
              emphasized: true,
            ),
          ];

          if (constraints.maxWidth >= 640) {
            return Row(
              children: metrics
                  .map(
                    (Widget item) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: item,
                      ),
                    ),
                  )
                  .toList(growable: false),
            );
          }

          return Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: metrics
                .map(
                  (Widget item) => SizedBox(
                    width: constraints.maxWidth < 420
                        ? constraints.maxWidth
                        : (constraints.maxWidth - AppSpacing.sm) / 2,
                    child: item,
                  ),
                )
                .toList(growable: false),
          );
        },
      ),
    );
  }
}

class _DebtNotesCard extends StatelessWidget {
  const _DebtNotesCard({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.tr.detailNotes,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(note, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _DebtAttachmentsCard extends StatelessWidget {
  const _DebtAttachmentsCard({
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
                  (Attachment attachment) => _DebtAttachmentCard(
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

class _DebtAttachmentCard extends StatelessWidget {
  const _DebtAttachmentCard({
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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return SizedBox(
      width: 160,
      child: InkWell(
        onTap: onPreview,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.outlineSoft),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: _AttachmentThumbnail(attachment: attachment)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                attachment.fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormatter.short(attachment.createdAt),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: <Widget>[
                  _MiniIconAction(
                    icon: Icons.visibility_outlined,
                    onTap: onPreview,
                  ),
                  const SizedBox(width: 4),
                  _MiniIconAction(
                    icon: Icons.open_in_new_rounded,
                    onTap: onOpen,
                  ),
                  const SizedBox(width: 4),
                  _MiniIconAction(
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

class _DebtTimelineCard extends StatelessWidget {
  const _DebtTimelineCard({required this.events, super.key});

  final List<_DebtTimelineEvent> events;

  @override
  Widget build(BuildContext context) {
    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.tr.timeline,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          ...events.asMap().entries.map((
            MapEntry<int, _DebtTimelineEvent> entry,
          ) {
            return _DebtTimelineTile(
              event: entry.value,
              isLast: entry.key == events.length - 1,
            );
          }),
        ],
      ),
    );
  }
}

class _DebtTimelineTile extends StatelessWidget {
  const _DebtTimelineTile({required this.event, required this.isLast});

  final _DebtTimelineEvent event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
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
          Icon(event.icon, size: 16, color: event.color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  DateFormatter.short(event.createdAt),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  event.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (event.amountLabel != null) ...<Widget>[
                  const SizedBox(height: 1),
                  Text(
                    event.amountLabel!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: event.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                if (event.subtitle != null &&
                    event.subtitle!.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 1),
                  Text(
                    event.subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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

class _DebtInfoChip extends StatelessWidget {
  const _DebtInfoChip({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.onTap,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget content = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: content,
    );
  }
}

class _DebtActionIconButton extends StatelessWidget {
  const _DebtActionIconButton({
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Ink(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: AppColors.outlineSoft),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DebtSummaryMetric extends StatelessWidget {
  const _DebtSummaryMetric({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: emphasized
            ? colorScheme.primary.withValues(alpha: 0.08)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: emphasized
              ? colorScheme.primary.withValues(alpha: 0.18)
              : AppColors.outlineSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style:
                (emphasized
                        ? theme.textTheme.titleLarge
                        : theme.textTheme.titleMedium)
                    ?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: emphasized ? colorScheme.primary : null,
                      height: 1.08,
                    ),
          ),
        ],
      ),
    );
  }
}

class _MiniIconAction extends StatelessWidget {
  const _MiniIconAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _AttachmentThumbnail extends StatelessWidget {
  const _AttachmentThumbnail({required this.attachment});

  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    if (_isImageAttachment(attachment)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.file(
          File(attachment.localUri),
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _AttachmentThumbnailFallback(theme: theme),
        ),
      );
    }

    return _AttachmentThumbnailFallback(theme: theme);
  }
}

class _AttachmentThumbnailFallback extends StatelessWidget {
  const _AttachmentThumbnailFallback({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        Icons.insert_drive_file_outlined,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class _CloseDebtSettlementSheet extends ConsumerStatefulWidget {
  const _CloseDebtSettlementSheet({
    required this.summary,
    required this.onCompleted,
  });

  final DebtSummary summary;
  final Future<void> Function() onCompleted;

  @override
  ConsumerState<_CloseDebtSettlementSheet> createState() =>
      _CloseDebtSettlementSheetState();
}

class _CloseDebtSettlementSheetState
    extends ConsumerState<_CloseDebtSettlementSheet> {
  String? _walletId;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(
      () => ref.read(walletControllerProvider.notifier).initialize(),
    );
  }

  Future<void> _submit() async {
    final String? walletId = _walletId;
    if (walletId == null) {
      return;
    }

    final DebtSummary summary = widget.summary;
    final String amount = summary.remainingAmount;
    final bool transactionSaved = summary.debt.isOwedToMe
        ? await ref
              .read(transactionControllerProvider.notifier)
              .createDeposit(
                walletId: walletId,
                currency: summary.currency,
                amount: amount,
              )
        : await ref
              .read(transactionControllerProvider.notifier)
              .createWithdraw(
                walletId: walletId,
                currency: summary.currency,
                amount: amount,
              );

    if (!mounted) {
      return;
    }

    if (!transactionSaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(transactionControllerProvider).errorMessage ??
                (summary.debt.isOwedToMe
                    ? context.tr.failedCreateDeposit
                    : context.tr.failedCreateWithdrawal),
          ),
        ),
      );
      return;
    }

    final bool repaymentSaved = await ref
        .read(debtControllerProvider.notifier)
        .createRepayment(debtId: summary.debt.id, amount: amount);

    if (!mounted) {
      return;
    }

    if (!repaymentSaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(debtControllerProvider).errorMessage ??
                context.tr.failedCreateRepayment,
          ),
        ),
      );
      return;
    }

    await ref.read(walletControllerProvider.notifier).initialize();
    await ref.read(transactionControllerProvider.notifier).initialize();
    await widget.onCompleted();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      buildAppSuccessSnackBar(context, context.tr.debtClosedSuccessfully),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final List<WalletOverview> activeWallets = walletState.wallets
        .where((WalletOverview item) => !item.wallet.isArchived)
        .toList(growable: false);
    final bool isIncomingSettlement = widget.summary.debt.isOwedToMe;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: DashboardSurfaceCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              context.tr.closeDebt,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${context.tr.currentRemainingAmount}: ${_formatMoney(context, widget.summary.remainingAmount, widget.summary.currency)}',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              context.tr.closeDebtConfirmation,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            if (walletState.isLoading && activeWallets.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (activeWallets.isEmpty)
              TransactionEmptyState(
                icon: Icons.account_balance_wallet_outlined,
                title: context.tr.noTransactionWalletsTitle,
                message: context.tr.debtRepaymentNoWalletsMessage,
              )
            else
              DropdownButtonFormField<String>(
                initialValue: _walletId,
                decoration: InputDecoration(
                  labelText: isIncomingSettlement
                      ? context.tr.debtRepaymentDepositWalletLabel
                      : context.tr.debtRepaymentWithdrawWalletLabel,
                  prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                ),
                items: activeWallets
                    .map(
                      (WalletOverview item) => DropdownMenuItem<String>(
                        value: item.wallet.id,
                        child: Text(item.wallet.name),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (String? value) {
                  setState(() => _walletId = value);
                },
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
                    label: context.tr.markAsSettled,
                    onPressed:
                        walletState.isLoading ||
                            activeWallets.isEmpty ||
                            _walletId == null
                        ? null
                        : _submit,
                    isLoading: walletState.isLoading,
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

class _EditDebtSheet extends ConsumerStatefulWidget {
  const _EditDebtSheet({required this.summary});

  final DebtSummary summary;

  @override
  ConsumerState<_EditDebtSheet> createState() => _EditDebtSheetState();
}

class _EditDebtSheetState extends ConsumerState<_EditDebtSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _amountFieldKey = GlobalKey();
  final GlobalKey _noteFieldKey = GlobalKey();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();
  final List<TransactionAttachmentDraft> _attachments =
      <TransactionAttachmentDraft>[];

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.summary.debt.originalAmount;
    _noteController.text = widget.summary.debt.note ?? '';
    _amountFocusNode.addListener(
      () => _handleFieldFocus(_amountFocusNode, _amountFieldKey),
    );
    _noteFocusNode.addListener(
      () => _handleFieldFocus(_noteFocusNode, _noteFieldKey),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _amountFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  void _handleFieldFocus(FocusNode focusNode, GlobalKey fieldKey) {
    if (!focusNode.hasFocus) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? fieldContext = fieldKey.currentContext;
      if (!mounted || fieldContext == null) {
        return;
      }
      Scrollable.ensureVisible(
        fieldContext,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        alignment: 0.22,
      );
    });
  }

  Future<void> _addAttachment() async {
    final TransactionAttachmentDraft? attachment =
        await showTransactionAttachmentSourceSheet(context: context);
    if (attachment != null) {
      setState(() => _attachments.add(attachment));
    }
  }

  Future<String?> _persistAttachments() async {
    if (_attachments.isEmpty) {
      return null;
    }
    final String warningMessage = context.tr.debtAttachmentSaveFailed;

    final bool saved = await ref
        .read(attachmentControllerProvider.notifier)
        .createAttachments(
          reference: AttachmentReference(
            type: AttachmentReferenceType.debt,
            entityId: widget.summary.debt.id,
            label: context.tr.transactionReferenceLabel(
              context.tr.debt,
              widget.summary.contact.name,
            ),
          ),
          drafts: _attachments
              .map(
                (TransactionAttachmentDraft item) => AttachmentDraft(
                  kind: item.kind,
                  fileName: item.fileName,
                  localUri: item.localUri,
                  mimeType: item.mimeType,
                  byteSize: item.byteSize,
                ),
              )
              .toList(growable: false),
        );

    return saved ? null : warningMessage;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(
      context,
    );
    final NavigatorState navigator = Navigator.of(context);
    final bool success = await ref
        .read(debtControllerProvider.notifier)
        .updateDebt(
          debtId: widget.summary.debt.id,
          amount: _amountController.text.trim(),
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    if (!success) {
      messenger?.showSnackBar(
        SnackBar(
          content: Text(
            ref.read(debtControllerProvider).errorMessage ??
                context.tr.debtEditFailed,
          ),
        ),
      );
      return;
    }

    final String? warning = await _persistAttachments();
    if (!mounted) {
      return;
    }

    navigator.pop();
    if (warning != null) {
      messenger?.showSnackBar(SnackBar(content: Text(warning)));
      return;
    }
    messenger?.showSnackBar(
      buildAppSuccessSnackBar(context, context.tr.debtUpdatedSuccessfully),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.sm,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.sm,
      ),
      child: DashboardSurfaceCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.tr.editDebt,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.tr.editDebtHelper,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: <Widget>[
                    _DebtInfoChip(
                      label: widget.summary.contact.name,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      onTap: () => context.push(
                        AppRoutes.contactDetailsLocation(
                          widget.summary.contact.id,
                        ),
                      ),
                    ),
                    _DebtInfoChip(
                      label: widget.summary.debt.isOwedToMe
                          ? context.tr.owedToMe
                          : context.tr.iOwe,
                      backgroundColor:
                          (widget.summary.debt.isOwedToMe
                                  ? AppColors.success
                                  : AppColors.warning)
                              .withValues(alpha: 0.10),
                      foregroundColor: widget.summary.debt.isOwedToMe
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                    _DebtInfoChip(
                      label: _currencyLabel(context, widget.summary.currency),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.10),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                KeyedSubtree(
                  key: _amountFieldKey,
                  child: PwTextField(
                    controller: _amountController,
                    focusNode: _amountFocusNode,
                    label: context.tr.amount,
                    hint: context.tr.enterAmountHint,
                    prefixIcon: const Icon(Icons.payments_outlined),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (String? value) =>
                        amountValidator(context, value),
                    onFieldSubmitted: (_) => _noteFocusNode.requestFocus(),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                KeyedSubtree(
                  key: _noteFieldKey,
                  child: PwTextField(
                    controller: _noteController,
                    focusNode: _noteFocusNode,
                    label: context.tr.note,
                    hint: context.tr.transactionNoteHint,
                    prefixIcon: const Icon(Icons.edit_note_rounded),
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AttachmentCompactField(
                  label: context.tr.addAttachment,
                  value: transactionAttachmentSummary(
                    context,
                    _attachments.length,
                    fileName: _attachments.isEmpty
                        ? null
                        : _attachments.first.fileName,
                  ),
                  onTap: _addAttachment,
                  thumbnails: _attachments
                      .take(3)
                      .map(
                        (TransactionAttachmentDraft attachment) => Padding(
                          padding: const EdgeInsetsDirectional.only(start: 4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              attachment.bytes,
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
                if (_attachments.isNotEmpty) ...<Widget>[
                  const SizedBox(height: AppSpacing.xs),
                  TransactionAttachmentList(
                    attachments: _attachments,
                    onRemove: (TransactionAttachmentDraft item) {
                      setState(() => _attachments.remove(item));
                    },
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
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
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DebtTimelineEvent {
  const _DebtTimelineEvent({
    required this.createdAt,
    required this.title,
    required this.icon,
    required this.color,
    this.amountLabel,
    this.subtitle,
  });

  final DateTime createdAt;
  final String title;
  final IconData icon;
  final Color color;
  final String? amountLabel;
  final String? subtitle;
}

List<_DebtTimelineEvent> _buildTimelineEvents(
  BuildContext context,
  DebtSummary summary, {
  required List<Attachment> attachments,
}) {
  final List<_DebtTimelineEvent> timeline = <_DebtTimelineEvent>[
    _DebtTimelineEvent(
      createdAt: summary.debt.createdAt,
      title: context.tr.debtCreatedEvent,
      subtitle: (summary.debt.note ?? '').trim().isEmpty
          ? null
          : summary.debt.note!.trim(),
      icon: Icons.receipt_long_rounded,
      color: Theme.of(context).colorScheme.primary,
    ),
  ];

  final num originalAmount = num.tryParse(summary.debt.originalAmount) ?? 0;
  num runningRemaining = originalAmount;
  final List<_DebtEventRecord> paymentEvents = <_DebtEventRecord>[
    ...summary.repayments.map(
      (repayment) => _DebtEventRecord(
        createdAt: repayment.createdAt,
        amount: num.tryParse(repayment.amount) ?? 0,
        note: repayment.note,
        isSettlement: false,
      ),
    ),
    ...summary.settlements.map(
      (SettlementSummary settlement) => _DebtEventRecord(
        createdAt: settlement.settlement.createdAt,
        amount: num.tryParse(settlement.settlement.amount) ?? 0,
        note: settlement.settlement.note,
        isSettlement: true,
        transferReference: settlement.transferReference,
        counterpartyDisplayName: settlement.counterpartyDisplayName,
      ),
    ),
  ]..sort((left, right) => left.createdAt.compareTo(right.createdAt));

  for (final _DebtEventRecord event in paymentEvents) {
    runningRemaining -= event.amount;
    final bool completed = runningRemaining <= 0;
    timeline.add(
      _DebtTimelineEvent(
        createdAt: event.createdAt,
        title: completed
            ? context.tr.fullSettlementEvent
            : context.tr.partialPaymentEvent,
        amountLabel: _formatMoney(
          context,
          event.amount.toString(),
          summary.currency,
        ),
        subtitle: _timelineSubtitle(event),
        icon: event.isSettlement
            ? Icons.swap_horiz_rounded
            : Icons.payments_outlined,
        color: completed ? AppColors.success : AppColors.warning,
      ),
    );
  }

  for (final Attachment attachment in attachments) {
    timeline.add(
      _DebtTimelineEvent(
        createdAt: attachment.createdAt,
        title: context.tr.attachmentAddedEvent,
        subtitle: attachment.fileName,
        icon: Icons.attach_file_rounded,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  timeline.sort((left, right) => left.createdAt.compareTo(right.createdAt));
  return timeline;
}

String? _timelineSubtitle(_DebtEventRecord event) {
  final String note = (event.note ?? '').trim();
  final String transferReference = (event.transferReference ?? '').trim();
  final String counterpartyDisplayName = (event.counterpartyDisplayName ?? '')
      .trim();

  final List<String> segments = <String>[
    if (counterpartyDisplayName.isNotEmpty) counterpartyDisplayName,
    if (transferReference.isNotEmpty) transferReference,
    if (note.isNotEmpty) note,
  ];

  return segments.isEmpty ? null : segments.join(' | ');
}

class _DebtEventRecord {
  const _DebtEventRecord({
    required this.createdAt,
    required this.amount,
    required this.isSettlement,
    this.note,
    this.transferReference,
    this.counterpartyDisplayName,
  });

  final DateTime createdAt;
  final num amount;
  final bool isSettlement;
  final String? note;
  final String? transferReference;
  final String? counterpartyDisplayName;
}

bool _isImageAttachment(Attachment attachment) {
  final String mimeType = (attachment.mimeType ?? '').toLowerCase();
  final String lowerPath = attachment.localUri.toLowerCase();
  return mimeType.startsWith('image/') ||
      lowerPath.endsWith('.png') ||
      lowerPath.endsWith('.jpg') ||
      lowerPath.endsWith('.jpeg') ||
      lowerPath.endsWith('.gif') ||
      lowerPath.endsWith('.webp');
}

String _formatMoney(BuildContext context, String amount, Currency currency) {
  return '\u2066${AmountFormatter.format(amount)} ${_currencyLabel(context, currency)}\u2069';
}

String _currencyLabel(BuildContext context, Currency currency) {
  switch (currency) {
    case Currency.usd:
      return context.tr.usdShort;
    case Currency.syp:
      return context.tr.sypShort;
  }
}
