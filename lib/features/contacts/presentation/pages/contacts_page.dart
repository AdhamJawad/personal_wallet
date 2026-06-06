import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/domain/enums/contact_kind.dart';
import '../../domain/models/contact.dart';
import '../providers/contact_providers.dart';

class ContactsPage extends ConsumerStatefulWidget {
  const ContactsPage({super.key});

  @override
  ConsumerState<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsPage> {
  late final TextEditingController _searchController;
  late final VoidCallback _searchListener;

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

  @override
  Widget build(BuildContext context) {
    final contactState = ref.watch(contactControllerProvider);
    final List<Contact> contacts = contactState.visibleContacts;
    final List<Contact> registered = contacts
        .where((Contact item) => item.kind == ContactKind.registered)
        .toList(growable: false);
    final List<Contact> external = contacts
        .where((Contact item) => item.kind == ContactKind.external)
        .toList(growable: false);

    return PwScaffold(
      title: 'Contacts',
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: PwTextField(
                  controller: _searchController,
                  label: 'Search contacts',
                  hint: 'Ali',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              PwButton.primary(
                label: 'Add external contact',
                onPressed: () => context.push(AppRoutes.contactCreatePath),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _ContactSection(title: 'Registered Users', contacts: registered),
          const SizedBox(height: AppSpacing.xl),
          _ContactSection(title: 'External Contacts', contacts: external),
        ],
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({required this.title, required this.contacts});

  final String title;
  final List<Contact> contacts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        if (contacts.isEmpty)
          const PwSectionCard(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text('No contacts available.'),
            ),
          )
        else
          ...contacts.map((Contact contact) {
            final List<String> subtitleParts = <String>[
              if ((contact.phoneNumber ?? '').isNotEmpty) contact.phoneNumber!,
              if ((contact.note ?? '').isNotEmpty) contact.note!,
            ];

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: PwSectionCard(
                child: ListTile(
                  title: Text(contact.name),
                  subtitle: Text(subtitleParts.join(' | ')),
                  trailing: Wrap(
                    spacing: AppSpacing.sm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      if (contact.kind == ContactKind.registered)
                        TextButton(
                          onPressed: () => context.push(
                            '${AppRoutes.userTransferCreatePath}?recipientUserId=${Uri.encodeComponent(contact.linkedUserId!)}&recipientName=${Uri.encodeComponent(contact.name)}',
                          ),
                          child: const Text('Transfer'),
                        ),
                      TextButton(
                        onPressed: () => context.push(
                          '${AppRoutes.attachmentViewerPath}?entityType=contact&entityId=${Uri.encodeComponent(contact.id)}&label=${Uri.encodeComponent(contact.name)}',
                        ),
                        child: const Text('Files'),
                      ),
                      if (contact.kind == ContactKind.external &&
                          contact.futureLinkCandidate != null)
                        const Chip(label: Text('Link-ready')),
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
