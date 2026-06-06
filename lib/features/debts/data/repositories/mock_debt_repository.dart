import '../../../../core/utils/id_generator.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../../shared/domain/enums/debt_status.dart';
import '../../domain/models/debt_record.dart';
import '../../domain/repositories/debt_repository.dart';

class MockDebtRepository implements DebtRepository {
  const MockDebtRepository();

  @override
  Future<List<DebtRecord>> fetchDebts(String ownerUserId) async {
    final DateTime now = DateTime.now().toUtc();

    return <DebtRecord>[
      DebtRecord(
        id: IdGenerator.next(),
        lenderPartyId: ownerUserId,
        borrowerPartyId: 'user_demo_2',
        currency: Currency.usd,
        principalAmount: '250.00',
        repaidAmount: '100.00',
        status: DebtStatus.open,
        note: 'Short-term business advance',
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
