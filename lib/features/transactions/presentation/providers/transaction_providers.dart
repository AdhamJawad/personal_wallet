import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mock_transaction_repository.dart';
import '../../domain/repositories/transaction_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((
  Ref ref,
) {
  return const MockTransactionRepository();
});
