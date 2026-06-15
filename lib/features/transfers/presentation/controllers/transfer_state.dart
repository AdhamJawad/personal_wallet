import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../debts/domain/models/settlement_summary.dart';
import '../../domain/models/transfer_summary.dart';

part 'transfer_state.freezed.dart';

@freezed
abstract class TransferState with _$TransferState {
  const TransferState._();

  const factory TransferState({
    @Default(false) bool isLoading,
    @Default(<TransferSummary>[]) List<TransferSummary> transfers,
    TransferSummary? selectedTransfer,
    TransferSummary? lastCompletedTransfer,
    SettlementSummary? lastCompletedSettlement,
    @Default('') String searchQuery,
    String? errorMessage,
  }) = _TransferState;

  List<TransferSummary> get visibleTransfers {
    final String normalizedQuery = searchQuery.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return transfers;
    }

    return transfers
        .where((TransferSummary item) {
          return item.reference.value.toLowerCase().contains(normalizedQuery) ||
              item.counterpartyDisplayName.toLowerCase().contains(
                normalizedQuery,
              ) ||
              (item.transfer.note ?? '').toLowerCase().contains(
                normalizedQuery,
              );
        })
        .toList(growable: false);
  }
}
