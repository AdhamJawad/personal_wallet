import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mock_debt_repository.dart';
import '../../domain/repositories/debt_repository.dart';

final debtRepositoryProvider = Provider<DebtRepository>((Ref ref) {
  return const MockDebtRepository();
});
