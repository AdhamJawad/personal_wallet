import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mock_contact_repository.dart';
import '../../domain/repositories/contact_repository.dart';

final contactRepositoryProvider = Provider<ContactRepository>((Ref ref) {
  return const MockContactRepository();
});
