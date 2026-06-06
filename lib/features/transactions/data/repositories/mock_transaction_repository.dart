import '../../../../core/utils/id_generator.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../../shared/domain/enums/transaction_type.dart';
import '../../domain/models/transaction_record.dart';
import '../../domain/repositories/transaction_repository.dart';

class MockTransactionRepository implements TransactionRepository {
  const MockTransactionRepository();

  @override
  Future<List<TransactionRecord>> fetchTransactions(String ownerUserId) async {
    final DateTime now = DateTime.now().toUtc();

    return <TransactionRecord>[
      TransactionRecord(
        id: IdGenerator.next(),
        type: TransactionType.deposit,
        initiatedByUserId: ownerUserId,
        destinationWalletId: 'wallet_main',
        sourceAmount: '300.00',
        sourceCurrency: Currency.usd,
        note: 'Seed balance for demo architecture',
        createdAt: now,
      ),
      TransactionRecord(
        id: IdGenerator.next(),
        type: TransactionType.exchange,
        initiatedByUserId: ownerUserId,
        sourceWalletId: 'wallet_main',
        destinationWalletId: 'wallet_travel',
        sourceAmount: '50.00',
        sourceCurrency: Currency.usd,
        destinationAmount: '650000.00',
        destinationCurrency: Currency.syp,
        createdAt: now,
      ),
    ];
  }
}
