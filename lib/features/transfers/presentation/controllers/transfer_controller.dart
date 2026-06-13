import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/domain/enums/currency.dart';
import '../../../auth/domain/models/auth_session.dart';
import '../../../debts/domain/models/settlement_summary.dart';
import '../../domain/models/transfer_summary.dart';
import '../../domain/repositories/transfer_repository.dart';
import 'transfer_state.dart';

class TransferController extends StateNotifier<TransferState> {
  TransferController({
    required TransferRepository transferRepository,
    required AuthSession? session,
  }) : _transferRepository = transferRepository,
       _session = session,
       super(const TransferState()) {
    if (session != null) {
      initialize();
    }
  }

  final TransferRepository _transferRepository;
  final AuthSession? _session;

  String get _resolvedOwnerUserId {
    final String? ownerUserId = _session?.user.id;
    if (ownerUserId == null) {
      throw const TransferControllerException('No authenticated user found.');
    }
    return ownerUserId;
  }

  String get _resolvedSenderName {
    final String? senderName = _session?.user.displayName;
    if (senderName == null) {
      throw const TransferControllerException('No authenticated user found.');
    }
    return senderName;
  }

  Future<void> _reload({
    String? selectedTransferId,
    TransferSummary? lastTransfer,
    SettlementSummary? lastSettlement,
  }) async {
    final List<TransferSummary> transfers = await _transferRepository
        .fetchTransfers(_resolvedOwnerUserId);
    final TransferSummary? selectedTransfer = selectedTransferId == null
        ? state.selectedTransfer
        : transfers.cast<TransferSummary?>().firstWhere(
            (TransferSummary? item) => item?.transfer.id == selectedTransferId,
            orElse: () => null,
          );

    state = state.copyWith(
      transfers: transfers,
      selectedTransfer: selectedTransfer,
      lastCompletedTransfer: lastTransfer ?? state.lastCompletedTransfer,
      lastCompletedSettlement: lastSettlement ?? state.lastCompletedSettlement,
      isLoading: false,
      errorMessage: null,
    );
  }

  Future<bool> createTransfer({
    required String senderWalletId,
    required String recipientUserId,
    required String recipientDisplayName,
    required Currency currency,
    required String amount,
    String? note,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final TransferSummary transfer = await _transferRepository.createTransfer(
        ownerUserId: _resolvedOwnerUserId,
        senderDisplayName: _resolvedSenderName,
        senderWalletId: senderWalletId,
        recipientUserId: recipientUserId,
        recipientDisplayName: recipientDisplayName,
        currency: currency,
        amount: amount,
        note: note,
      );
      await _reload(
        selectedTransferId: transfer.transfer.id,
        lastTransfer: transfer,
      );
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<bool> createDebtSettlement({
    required String debtId,
    required String senderWalletId,
    required String recipientUserId,
    required String recipientDisplayName,
    required Currency currency,
    required String amount,
    String? note,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final SettlementSummary settlement = await _transferRepository
          .createDebtSettlement(
            ownerUserId: _resolvedOwnerUserId,
            senderDisplayName: _resolvedSenderName,
            debtId: debtId,
            senderWalletId: senderWalletId,
            recipientUserId: recipientUserId,
            recipientDisplayName: recipientDisplayName,
            currency: currency,
            amount: amount,
            note: note,
          );
      final TransferSummary? transfer = await _transferRepository
          .getTransferById(
            ownerUserId: _resolvedOwnerUserId,
            transferId: settlement.settlement.transferId,
          );
      await _reload(
        selectedTransferId: transfer?.transfer.id,
        lastTransfer: transfer,
        lastSettlement: settlement,
      );
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _reload();
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> loadTransfer(String transferId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final TransferSummary? transfer = await _transferRepository
          .getTransferById(
            ownerUserId: _resolvedOwnerUserId,
            transferId: transferId,
          );
      await _reload(selectedTransferId: transfer?.transfer.id);
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  void clearCompletionState() {
    state = state.copyWith(
      lastCompletedTransfer: null,
      lastCompletedSettlement: null,
    );
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }
}

class TransferControllerException implements Exception {
  const TransferControllerException(this.message);

  final String message;

  @override
  String toString() => message;
}
