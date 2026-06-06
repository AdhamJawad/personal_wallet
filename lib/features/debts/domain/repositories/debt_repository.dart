import '../models/debt_record.dart';

abstract interface class DebtRepository {
  Future<List<DebtRecord>> fetchDebts(String ownerUserId);
}
