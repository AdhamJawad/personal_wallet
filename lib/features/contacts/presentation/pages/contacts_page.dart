import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/presentation/widgets/app_modal_bottom_sheet.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/feedback/app_feedback.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/domain/enums/contact_entity_type.dart';
import '../../domain/models/contact.dart';
import '../../../debts/domain/models/debt_summary.dart';
import '../../../debts/presentation/providers/debt_providers.dart';
import '../../../dashboard/presentation/widgets/dashboard_breakpoints.dart';
import '../../../dashboard/presentation/widgets/dashboard_empty_state.dart';
import '../../../dashboard/presentation/widgets/dashboard_skeleton_block.dart';
import '../../../dashboard/presentation/widgets/dashboard_surface_card.dart';
import '../../../transactions/presentation/widgets/transaction_attachment_picker.dart';
import '../providers/contact_providers.dart';

class ContactsPage extends ConsumerStatefulWidget {
  const ContactsPage({super.key});

  @override
  ConsumerState<ContactsPage> createState() => _ContactsPageState();
}

enum _ContactFilter { all, people, businesses }

extension on _ContactFilter {
  ContactEntityType? get entityType {
    return switch (this) {
      _ContactFilter.all => null,
      _ContactFilter.people => ContactEntityType.person,
      _ContactFilter.businesses => ContactEntityType.business,
    };
  }
}

class _ContactsPageState extends ConsumerState<ContactsPage> {
  late final TextEditingController _searchController;
  late final VoidCallback _searchListener;
  _ContactFilter _selectedFilter = _ContactFilter.all;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchListener = () {
      ref
          .read(contactControllerProvider.notifier)
          .setSearchQuery(_searchController.text);
    };
    _searchController.addListener(_searchListener);
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchListener);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showContactSheet({Contact? contact}) {
    return showAppModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _ContactEditorSheet(contact: contact);
      },
    );
  }

  Future<void> _confirmDelete(Contact contact) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.tr.deleteContactTitle),
          content: Text(context.tr.deleteContactMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.tr.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.tr.deleteAction),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final bool success = await ref
        .read(contactControllerProvider.notifier)
        .deleteContact(contactId: contact.id);
    if (!mounted) {
      return;
    }

    if (success) {
      showAppSuccessSnackBar(context, context.tr.contactDeletedSuccessfully);
      return;
    }

    final String message =
        ref.read(contactControllerProvider).errorMessage ??
        context.tr.contactDeleteFailed;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final contactState = ref.watch(contactControllerProvider);
    final debtState = ref.watch(debtControllerProvider);
    final List<Contact> contacts = contactState.filteredContacts(
      entityType: _selectedFilter.entityType,
    );
    final _ContactsSummary summary = _ContactsSummary.fromContacts(
      contactState.contacts,
    );
    final bool isInitialLoading =
        contactState.isLoading && contactState.contacts.isEmpty;
    final bool hasLoadError =
        contactState.errorMessage != null && contactState.contacts.isEmpty;
    final bool hasSearchQuery = _searchController.text.trim().isNotEmpty;
    final bool hasActiveFilter = _selectedFilter != _ContactFilter.all;

    return PwScaffold(
      title: context.tr.contacts,
      actions: <Widget>[
        IconButton(
          onPressed: _showContactSheet,
          icon: const Icon(Icons.add_rounded),
          tooltip: context.tr.addContact,
        ),
      ],
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final DashboardBreakpoint breakpoint = resolveDashboardBreakpoint(
              constraints.biggest,
            );
            final double horizontalPadding = resolveDashboardHorizontalPadding(
              breakpoint,
            );
            final int columns = usesTabletLayout(breakpoint) ? 2 : 1;

            return SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: dashboardPageMaxWidth,
                  ),
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      AppSpacing.md,
                      horizontalPadding,
                      AppSpacing.xxl,
                    ),
                    children: <Widget>[
                      if (isInitialLoading)
                        _ContactsLoadingState(columns: columns)
                      else ...<Widget>[
                        _ContactsSummaryCard(summary: summary),
                        const SizedBox(height: AppSpacing.md),
                        _ContactsSearchField(controller: _searchController),
                        const SizedBox(height: AppSpacing.md),
                        _ContactsFilterRow(
                          selectedFilter: _selectedFilter,
                          onSelected: (_ContactFilter value) {
                            setState(() => _selectedFilter = value);
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (hasLoadError)
                          DashboardEmptyState.error(
                            title: context.tr.somethingWentWrong,
                            message: context.tr.contactsLoadFailedMessage,
                            actionLabel: context.tr.tryAgain,
                            onActionPressed: () {
                              ref
                                  .read(contactControllerProvider.notifier)
                                  .initialize();
                            },
                          )
                        else if (contactState.contacts.isEmpty)
                          DashboardEmptyState(
                            icon: Icons.people_outline_rounded,
                            title: context.tr.contactsEmptyTitle,
                            message: context.tr.contactsEmptyMessage,
                            actionLabel: context.tr.addContact,
                            onActionPressed: () => _showContactSheet(),
                          )
                        else if (contacts.isEmpty && hasSearchQuery)
                          DashboardEmptyState.search(
                            title: context.tr.noContactsSearchResultsTitle,
                            message: context.tr.noContactsSearchResultsMessage,
                            actionLabel: context.tr.clearSearch,
                            onActionPressed: () => _searchController.clear(),
                            secondaryActionLabel: hasActiveFilter
                                ? context.tr.clearFilters
                                : null,
                            onSecondaryActionPressed: hasActiveFilter
                                ? () => setState(
                                    () => _selectedFilter = _ContactFilter.all,
                                  )
                                : null,
                          )
                        else if (contacts.isEmpty && hasActiveFilter)
                          DashboardEmptyState.filter(
                            title: context.tr.noContactsFilterResultsTitle,
                            message: context.tr.noContactsFilterResultsMessage,
                            actionLabel: context.tr.clearFilters,
                            onActionPressed: () {
                              setState(
                                () => _selectedFilter = _ContactFilter.all,
                              );
                            },
                          )
                        else
                          _ContactsCardGrid(
                            columns: columns,
                            children: contacts
                                .map(
                                  (Contact contact) => _ContactListCard(
                                    contact: contact,
                                    position: _ContactBalancePosition.fromData(
                                      contact: contact,
                                      debts: debtState.debts,
                                      context: context,
                                    ),
                                    onTap: () => context.push(
                                      AppRoutes.contactDetailsLocation(
                                        contact.id,
                                      ),
                                    ),
                                    onEdit: () =>
                                        _showContactSheet(contact: contact),
                                    onDelete: () => _confirmDelete(contact),
                                  ),
                                )
                                .toList(growable: false),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ContactsLoadingState extends StatelessWidget {
  const _ContactsLoadingState({required this.columns});

  final int columns;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _ContactsSummarySkeleton(),
        const SizedBox(height: AppSpacing.md),
        _ContactsSearchSkeleton(),
        const SizedBox(height: AppSpacing.md),
        _ContactsFilterSkeleton(),
        const SizedBox(height: AppSpacing.md),
        _ContactsListSkeleton(columns: columns),
      ],
    );
  }
}

class _ContactsSummarySkeleton extends StatelessWidget {
  const _ContactsSummarySkeleton();

  @override
  Widget build(BuildContext context) {
    return const DashboardSurfaceCard(
      padding: EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: <Widget>[
          Expanded(child: _ContactsMetricSkeleton()),
          SizedBox(width: AppSpacing.sm),
          Expanded(child: _ContactsMetricSkeleton()),
          SizedBox(width: AppSpacing.sm),
          Expanded(child: _ContactsMetricSkeleton()),
        ],
      ),
    );
  }
}

class _ContactsMetricSkeleton extends StatelessWidget {
  const _ContactsMetricSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DashboardSkeletonBlock(height: 12, width: 78),
        SizedBox(height: 6),
        DashboardSkeletonBlock(height: 20, width: 32),
      ],
    );
  }
}

class _ContactsSearchSkeleton extends StatelessWidget {
  const _ContactsSearchSkeleton();

  @override
  Widget build(BuildContext context) {
    return const DashboardSurfaceCard(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: DashboardSkeletonBlock(height: 24, width: double.infinity),
    );
  }
}

class _ContactsFilterSkeleton extends StatelessWidget {
  const _ContactsFilterSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        Expanded(
          child: DashboardSkeletonBlock(
            height: 34,
            width: 96,
            radius: AppRadius.pill,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: DashboardSkeletonBlock(
            height: 34,
            width: 96,
            radius: AppRadius.pill,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: DashboardSkeletonBlock(
            height: 34,
            width: 96,
            radius: AppRadius.pill,
          ),
        ),
      ],
    );
  }
}

class _ContactsListSkeleton extends StatelessWidget {
  const _ContactsListSkeleton({required this.columns});

  final int columns;

  @override
  Widget build(BuildContext context) {
    return _ContactsCardGrid(
      columns: columns,
      children: const <Widget>[
        _ContactCardSkeleton(),
        _ContactCardSkeleton(),
        _ContactCardSkeleton(),
      ],
    );
  }
}

class _ContactsCardGrid extends StatelessWidget {
  const _ContactsCardGrid({required this.columns, required this.children});

  final int columns;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (columns <= 1) {
      return Column(
        children: children
            .map(
              (Widget child) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: child,
              ),
            )
            .toList(growable: false),
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double spacing = AppSpacing.sm;
        final double itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map((Widget child) => SizedBox(width: itemWidth, child: child))
              .toList(growable: false),
        );
      },
    );
  }
}

class _ContactCardSkeleton extends StatelessWidget {
  const _ContactCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const DashboardSurfaceCard(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: <Widget>[
          DashboardSkeletonBlock(height: 48, width: 48, radius: 999),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DashboardSkeletonBlock(height: 18, width: 132),
                SizedBox(height: AppSpacing.xs),
                DashboardSkeletonBlock(height: 14, width: 88),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md),
          DashboardSkeletonBlock(height: 30, width: 68, radius: AppRadius.pill),
        ],
      ),
    );
  }
}

class _ContactsSummaryCard extends StatelessWidget {
  const _ContactsSummaryCard({required this.summary});

  final _ContactsSummary summary;

  @override
  Widget build(BuildContext context) {
    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _SummaryMetric(
              label: context.tr.totalContacts,
              value: '${summary.total}',
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _SummaryMetric(
              label: context.tr.peopleLabel,
              value: '${summary.people}',
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _SummaryMetric(
              label: context.tr.businessesLabel,
              value: '${summary.businesses}',
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _ContactsSearchField extends StatelessWidget {
  const _ContactsSearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return DashboardSurfaceCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search_rounded,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 52),
              child: Center(
                child: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    hintText: context.tr.searchContacts,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactsFilterRow extends StatelessWidget {
  const _ContactsFilterRow({
    required this.selectedFilter,
    required this.onSelected,
  });

  final _ContactFilter selectedFilter;
  final ValueChanged<_ContactFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: _ContactFilter.values
          .map(
            (_ContactFilter filter) => _FilterChip(
              label: _filterLabel(context, filter),
              selected: filter == selectedFilter,
              onTap: () => onSelected(filter),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary.withValues(alpha: 0.10)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.24)
                : colorScheme.outline.withValues(alpha: 0.16),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ContactListCard extends StatelessWidget {
  const _ContactListCard({
    required this.contact,
    required this.position,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Contact contact;
  final _ContactBalancePosition position;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return DashboardSurfaceCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: <Widget>[
                _ContactAvatar(contact: contact, size: 46),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        contact.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _contactTypeLabel(context, contact.entityType),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (position.lastActivityLabel != null) ...<Widget>[
                        const SizedBox(height: 2),
                        Text(
                          position.lastActivityLabel!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      position.amountLabel,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: position.color,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      position.caption,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<_ContactCardAction>(
                  onSelected: (_ContactCardAction value) {
                    if (value == _ContactCardAction.edit) {
                      onEdit();
                    } else {
                      onDelete();
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<_ContactCardAction>>[
                        PopupMenuItem<_ContactCardAction>(
                          value: _ContactCardAction.edit,
                          child: Text(context.tr.editContact),
                        ),
                        PopupMenuItem<_ContactCardAction>(
                          value: _ContactCardAction.delete,
                          child: Text(context.tr.deleteAction),
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

enum _ContactCardAction { edit, delete }

class _ContactEditorSheet extends ConsumerStatefulWidget {
  const _ContactEditorSheet({this.contact});

  final Contact? contact;

  @override
  ConsumerState<_ContactEditorSheet> createState() =>
      _ContactEditorSheetState();
}

class _ContactEditorSheetState extends ConsumerState<_ContactEditorSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _nameFieldKey = GlobalKey();
  final GlobalKey _phoneFieldKey = GlobalKey();
  final GlobalKey _emailFieldKey = GlobalKey();
  final GlobalKey _noteFieldKey = GlobalKey();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _noteController;
  late final FocusNode _nameFocusNode;
  late final FocusNode _phoneFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _noteFocusNode;
  late ContactEntityType _entityType;
  String? _imageUri;

  bool get _isEditing => widget.contact != null;

  @override
  void initState() {
    super.initState();
    final Contact? contact = widget.contact;
    _nameController = TextEditingController(text: contact?.name ?? '');
    _phoneController = TextEditingController(text: contact?.phoneNumber ?? '');
    _emailController = TextEditingController(text: contact?.emailAddress ?? '');
    _noteController = TextEditingController(text: contact?.note ?? '');
    _nameFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _noteFocusNode = FocusNode();
    _nameFocusNode.addListener(
      () => _handleFieldFocus(_nameFocusNode, _nameFieldKey),
    );
    _phoneFocusNode.addListener(
      () => _handleFieldFocus(_phoneFocusNode, _phoneFieldKey),
    );
    _emailFocusNode.addListener(
      () => _handleFieldFocus(_emailFocusNode, _emailFieldKey),
    );
    _noteFocusNode.addListener(
      () => _handleFieldFocus(_noteFocusNode, _noteFieldKey),
    );
    _entityType = contact?.entityType ?? ContactEntityType.person;
    _imageUri = contact?.imageUri;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _noteController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  void _handleFieldFocus(FocusNode focusNode, GlobalKey fieldKey) {
    if (!focusNode.hasFocus) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? fieldContext = fieldKey.currentContext;
      if (fieldContext == null || !mounted) {
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

  Future<void> _pickProfileImage() async {
    final TransactionAttachmentDraft? image =
        await showTransactionAttachmentSourceSheet(context: context);
    if (image == null) {
      return;
    }
    setState(() => _imageUri = image.localUri);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = ref.read(contactControllerProvider.notifier);

    final bool success = _isEditing
        ? await controller.updateContact(
            contactId: widget.contact!.id,
            entityType: _entityType,
            name: _nameController.text,
            phoneNumber: _phoneController.text,
            emailAddress: _emailController.text,
            note: _noteController.text,
            imageUri: _imageUri,
          )
        : await controller.createExternalContact(
            entityType: _entityType,
            name: _nameController.text,
            phoneNumber: _phoneController.text,
            emailAddress: _emailController.text,
            note: _noteController.text,
            imageUri: _imageUri,
          );

    if (!mounted) {
      return;
    }
    if (success) {
      final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
      final SnackBar successSnackBar = buildAppSuccessSnackBar(
        context,
        _isEditing
            ? context.tr.contactUpdatedSuccessfully
            : context.tr.contactCreatedSuccessfully,
      );
      Navigator.of(context).pop();
      messenger.showSnackBar(successSnackBar);
      return;
    }

    final String message =
        ref.read(contactControllerProvider).errorMessage ??
        (_isEditing
            ? context.tr.contactSaveFailed
            : context.tr.contactCreateFailed);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(contactControllerProvider).isLoading;
    final double keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final ThemeData theme = Theme.of(context);
    final double maxHeight = MediaQuery.sizeOf(context).height * 0.88;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                _isEditing ? context.tr.editContact : context.tr.addContact,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _ImagePickerField(
                imageUri: _imageUri,
                entityType: _entityType,
                onTap: _pickProfileImage,
              ),
              const SizedBox(height: AppSpacing.sm),
              _EntityTypeToggle(
                value: _entityType,
                onChanged: (ContactEntityType value) {
                  setState(() => _entityType = value);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              KeyedSubtree(
                key: _nameFieldKey,
                child: PwTextField(
                  controller: _nameController,
                  label: context.tr.fullName,
                  focusNode: _nameFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _phoneFocusNode.requestFocus(),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.tr.fullNameRequired;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              KeyedSubtree(
                key: _phoneFieldKey,
                child: PwTextField(
                  controller: _phoneController,
                  label: context.tr.phoneNumber,
                  focusNode: _phoneFocusNode,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              KeyedSubtree(
                key: _emailFieldKey,
                child: PwTextField(
                  controller: _emailController,
                  label: context.tr.emailAddress,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _noteFocusNode.requestFocus(),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              KeyedSubtree(
                key: _noteFieldKey,
                child: PwTextField(
                  controller: _noteController,
                  label: context.tr.note,
                  focusNode: _noteFocusNode,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final Widget cancelButton = PwButton.secondary(
                    label: context.tr.cancel,
                    onPressed: () => Navigator.of(context).pop(),
                  );
                  final Widget submitButton = PwButton.primary(
                    label: _isEditing
                        ? context.tr.saveChanges
                        : context.tr.saveContact,
                    isLoading: isLoading,
                    onPressed: _submit,
                  );

                  if (constraints.maxWidth < 360) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        submitButton,
                        const SizedBox(height: AppSpacing.sm),
                        cancelButton,
                      ],
                    );
                  }

                  return Row(
                    children: <Widget>[
                      Expanded(child: cancelButton),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: submitButton),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EntityTypeToggle extends StatelessWidget {
  const _EntityTypeToggle({required this.value, required this.onChanged});

  final ContactEntityType value;
  final ValueChanged<ContactEntityType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: <Widget>[
        _SelectionPill(
          label: context.tr.contactTypePerson,
          selected: value == ContactEntityType.person,
          onTap: () => onChanged(ContactEntityType.person),
        ),
        _SelectionPill(
          label: context.tr.contactTypeBusiness,
          selected: value == ContactEntityType.business,
          onTap: () => onChanged(ContactEntityType.business),
        ),
      ],
    );
  }
}

class _SelectionPill extends StatelessWidget {
  const _SelectionPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary.withValues(alpha: 0.10)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.24)
                : colorScheme.outline.withValues(alpha: 0.16),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ImagePickerField extends StatelessWidget {
  const _ImagePickerField({
    required this.imageUri,
    required this.entityType,
    required this.onTap,
  });

  final String? imageUri;
  final ContactEntityType entityType;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.outlineSoft),
        ),
        child: Row(
          children: <Widget>[
            _ContactAvatar(
              imageUri: imageUri,
              initials: entityType == ContactEntityType.business ? 'B' : 'P',
              size: 44,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                context.tr.profileImageLabel,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const Icon(Icons.photo_camera_back_outlined, size: 18),
          ],
        ),
      ),
    );
  }
}

class _ContactAvatar extends StatelessWidget {
  const _ContactAvatar({
    Contact? contact,
    this.imageUri,
    this.initials,
    this.size = 44,
  }) : _contact = contact;

  final Contact? _contact;
  final String? imageUri;
  final String? initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    final String resolvedInitials =
        initials ?? _contactInitials(_contact?.name ?? '');
    final String? resolvedImageUri = imageUri ?? _contact?.imageUri;
    final File? imageFile = resolvedImageUri == null || resolvedImageUri.isEmpty
        ? null
        : File(resolvedImageUri);

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.12),
      backgroundImage: imageFile != null && imageFile.existsSync()
          ? FileImage(imageFile)
          : null,
      child: imageFile != null && imageFile.existsSync()
          ? null
          : Text(
              resolvedInitials,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }
}

class _ContactsSummary {
  const _ContactsSummary({
    required this.total,
    required this.people,
    required this.businesses,
  });

  factory _ContactsSummary.fromContacts(List<Contact> contacts) {
    final int people = contacts
        .where((Contact item) => item.entityType == ContactEntityType.person)
        .length;
    return _ContactsSummary(
      total: contacts.length,
      people: people,
      businesses: contacts.length - people,
    );
  }

  final int total;
  final int people;
  final int businesses;
}

class _ContactBalancePosition {
  const _ContactBalancePosition({
    required this.amountLabel,
    required this.caption,
    required this.color,
    required this.lastActivityLabel,
  });

  factory _ContactBalancePosition.fromData({
    required Contact contact,
    required List<DebtSummary> debts,
    required BuildContext context,
  }) {
    num usd = 0;
    num syp = 0;
    DateTime? lastActivity;

    for (final DebtSummary debt in debts) {
      if (debt.contact.id != contact.id) {
        continue;
      }
      final num remaining = num.tryParse(debt.remainingAmount) ?? 0;
      final num signed = debt.debt.isOwedToMe ? remaining : -remaining;
      if (debt.currency.name == 'usd') {
        usd += signed;
      } else {
        syp += signed;
      }

      final DateTime candidate = _latestDebtActivity(debt);
      if (lastActivity == null || candidate.isAfter(lastActivity)) {
        lastActivity = candidate;
      }
    }

    final Color color;
    final String caption;
    if (usd > 0 || syp > 0) {
      color = AppColors.success;
      caption = context.tr.owedToMe;
    } else if (usd < 0 || syp < 0) {
      color = AppColors.warning;
      caption = context.tr.iOwe;
    } else {
      color = Theme.of(context).colorScheme.onSurfaceVariant;
      caption = context.tr.contactNeutralBalance;
    }

    return _ContactBalancePosition(
      amountLabel: _formatNetAmount(context, usd: usd, syp: syp),
      caption: caption,
      color: color,
      lastActivityLabel: lastActivity == null
          ? null
          : '${context.tr.lastActivity}: ${DateFormatter.short(lastActivity)}',
    );
  }

  final String amountLabel;
  final String caption;
  final Color color;
  final String? lastActivityLabel;
}

String _filterLabel(BuildContext context, _ContactFilter filter) {
  return switch (filter) {
    _ContactFilter.all => context.tr.all,
    _ContactFilter.people => context.tr.peopleLabel,
    _ContactFilter.businesses => context.tr.businessesLabel,
  };
}

String _contactTypeLabel(BuildContext context, ContactEntityType entityType) {
  return entityType == ContactEntityType.business
      ? context.tr.contactTypeBusiness
      : context.tr.contactTypePerson;
}

String _contactInitials(String name) {
  final List<String> parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((String item) => item.isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty) {
    return '?';
  }
  if (parts.length == 1) {
    return String.fromCharCode(parts.first.runes.first).toUpperCase();
  }
  return '${String.fromCharCode(parts.first.runes.first)}${String.fromCharCode(parts.last.runes.first)}'
      .toUpperCase();
}

DateTime _latestDebtActivity(DebtSummary debt) {
  DateTime latest = debt.debt.updatedAt;
  for (final repayment in debt.repayments) {
    if (repayment.createdAt.isAfter(latest)) {
      latest = repayment.createdAt;
    }
  }
  for (final settlement in debt.settlements) {
    if (settlement.settlement.createdAt.isAfter(latest)) {
      latest = settlement.settlement.createdAt;
    }
  }
  return latest;
}

String _formatNetAmount(
  BuildContext context, {
  required num usd,
  required num syp,
}) {
  final List<String> segments = <String>[];
  if (usd != 0 || syp == 0) {
    segments.add(
      '${usd > 0
          ? '+'
          : usd < 0
          ? '-'
          : ''}${AmountFormatter.format(usd.abs().toString())} ${context.tr.usdShort}',
    );
  }
  if (syp != 0) {
    segments.add(
      '${syp > 0
          ? '+'
          : syp < 0
          ? '-'
          : ''}${AmountFormatter.format(syp.abs().toString())} ${context.tr.sypShort}',
    );
  }
  return segments.join(' • ');
}
