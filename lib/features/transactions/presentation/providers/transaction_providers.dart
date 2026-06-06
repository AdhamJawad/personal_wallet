import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../audit/presentation/providers/audit_providers.dart';
import '../../../../core/sync/providers/sync_providers.dart';
import '../../data/repositories/mock_transaction_repository.dart';
import '../../data/services/mock_ledger_store.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/services/balance_calculator_service.dart';
import '../controllers/transaction_controller.dart';
import '../controllers/transaction_state.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((
  Ref ref,
) {
  return MockTransactionRepository(
    ref.watch(mockLedgerStoreProvider),
    ref.watch(syncQueueRepositoryProvider),
    ref.watch(auditLoggerProvider),
  );
});

final mockLedgerStoreProvider = Provider<MockLedgerStore>((Ref ref) {
  return MockLedgerStore(ref.watch(localStoreProvider));
});

final balanceCalculatorServiceProvider = Provider<BalanceCalculatorService>((
  Ref ref,
) {
  return const BalanceCalculatorService();
});

final transactionControllerProvider =
    StateNotifierProvider<TransactionController, TransactionState>((Ref ref) {
      final authState = ref.watch(authControllerProvider);

      return TransactionController(
        transactionRepository: ref.watch(transactionRepositoryProvider),
        ownerUserId: authState.session?.user.id,
      );
    });
