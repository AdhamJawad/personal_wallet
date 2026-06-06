import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/debt.dart';
import '../../domain/models/debt_repayment.dart';
import '../../domain/models/debt_settlement.dart';

part 'mock_debt_record.freezed.dart';
part 'mock_debt_record.g.dart';

@freezed
abstract class MockDebtRecord with _$MockDebtRecord {
  const factory MockDebtRecord({
    required Debt debt,
    required List<DebtRepayment> repayments,
    @Default(<DebtSettlement>[]) List<DebtSettlement> settlements,
  }) = _MockDebtRecord;

  factory MockDebtRecord.fromJson(Map<String, dynamic> json) =>
      _$MockDebtRecordFromJson(json);
}
