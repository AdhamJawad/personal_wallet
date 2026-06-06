import '../models/transaction_record.dart';

abstract interface class TransactionRepository {
  Future<List<TransactionRecord>> fetchTransactions(String ownerUserId);
}
