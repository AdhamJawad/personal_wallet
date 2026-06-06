import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/contact.dart';
import '../../domain/repositories/contact_repository.dart';
import 'contact_state.dart';

class ContactController extends StateNotifier<ContactState> {
  ContactController({
    required ContactRepository contactRepository,
    required String? ownerUserId,
  }) : _contactRepository = contactRepository,
       _ownerUserId = ownerUserId,
       super(const ContactState()) {
    if (ownerUserId != null) {
      initialize();
    }
  }

  final ContactRepository _contactRepository;
  final String? _ownerUserId;

  String get _resolvedOwnerUserId {
    final String? ownerUserId = _ownerUserId;
    if (ownerUserId == null) {
      throw const ContactControllerException('No authenticated user found.');
    }
    return ownerUserId;
  }

  Future<bool> createExternalContact({
    required String name,
    String? phoneNumber,
    String? note,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      await _contactRepository.createExternalContact(
        ownerUserId: _resolvedOwnerUserId,
        name: name.trim(),
        phoneNumber: phoneNumber?.trim().isEmpty == true
            ? null
            : phoneNumber?.trim(),
        note: note?.trim().isEmpty == true ? null : note?.trim(),
      );
      await initialize();
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<bool> createRegisteredContact({
    required String linkedUserId,
    required String name,
    String? phoneNumber,
    String? note,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      await _contactRepository.createRegisteredContact(
        ownerUserId: _resolvedOwnerUserId,
        linkedUserId: linkedUserId,
        name: name.trim(),
        phoneNumber: phoneNumber?.trim().isEmpty == true
            ? null
            : phoneNumber?.trim(),
        note: note?.trim().isEmpty == true ? null : note?.trim(),
      );
      await initialize();
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);

    try {
      final List<Contact> contacts = await _contactRepository.fetchContacts(
        _resolvedOwnerUserId,
      );
      state = state.copyWith(
        contacts: contacts,
        isLoading: false,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }
}

class ContactControllerException implements Exception {
  const ContactControllerException(this.message);

  final String message;

  @override
  String toString() => message;
}
