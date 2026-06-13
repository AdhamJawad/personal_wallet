import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/enums/contact_entity_type.dart';
import '../../domain/models/contact.dart';

part 'contact_state.freezed.dart';

@freezed
abstract class ContactState with _$ContactState {
  const ContactState._();

  const factory ContactState({
    @Default(false) bool isLoading,
    @Default(<Contact>[]) List<Contact> contacts,
    @Default('') String searchQuery,
    String? errorMessage,
  }) = _ContactState;

  List<Contact> get visibleContacts {
    return filteredContacts();
  }

  List<Contact> filteredContacts({ContactEntityType? entityType}) {
    final String normalizedQuery = _normalizeSearchValue(searchQuery);

    return contacts
        .where((Contact contact) {
          if (entityType != null && contact.entityType != entityType) {
            return false;
          }
          if (normalizedQuery.isEmpty) {
            return true;
          }
          return _contactSearchTokens(
            contact,
          ).any((String token) => token.contains(normalizedQuery));
        })
        .toList(growable: false);
  }

  Iterable<String> _contactSearchTokens(Contact contact) sync* {
    yield _normalizeSearchValue(contact.name);
    yield _normalizeSearchValue(contact.emailAddress);
    yield _normalizeSearchValue(contact.phoneNumber);
    yield _normalizeSearchValue(contact.note);
  }

  String _normalizeSearchValue(String? value) {
    if (value == null) {
      return '';
    }
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '');
  }
}
