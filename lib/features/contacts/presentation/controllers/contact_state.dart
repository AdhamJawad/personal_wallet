import 'package:freezed_annotation/freezed_annotation.dart';

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
    final String normalizedQuery = searchQuery.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return contacts;
    }

    return contacts
        .where((Contact contact) {
          return contact.name.toLowerCase().contains(normalizedQuery) ||
              (contact.phoneNumber ?? '').toLowerCase().contains(
                normalizedQuery,
              );
        })
        .toList(growable: false);
  }
}
