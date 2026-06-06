import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/local_store.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../../shared/domain/enums/transaction_type.dart';
import '../../domain/models/ledger_transaction.dart';
import '../../domain/models/transaction_reference.dart';

class MockLedgerStore {
  MockLedgerStore(this._localStore);

  final LocalStore _localStore;

  static String _transactionsKey(String ownerUserId) =>
      'ledger.transactions.$ownerUserId';
  static String _sequenceKey(String ownerUserId) =>
      'ledger.sequence.$ownerUserId';

  Future<TransactionReference> nextReference(String ownerUserId) async {
    final DateTime now = DateTime.now().toUtc();
    final String key = _sequenceKey(ownerUserId);
    final String? currentValue = await _localStore.read(
      boxName: AppConstants.transactionsBox,
      key: key,
    );
    final int nextSequence = (int.tryParse(currentValue ?? '0') ?? 0) + 1;

    await _localStore.write(
      boxName: AppConstants.transactionsBox,
      key: key,
      value: nextSequence.toString(),
    );

    return TransactionReference(
      value: 'TX-${now.year}-${nextSequence.toString().padLeft(6, '0')}',
      year: now.year,
      sequence: nextSequence,
    );
  }

  Future<List<LedgerTransaction>> loadTransactions(String ownerUserId) async {
    final String key = _transactionsKey(ownerUserId);
    final String? rawValue = await _localStore.read(
      boxName: AppConstants.transactionsBox,
      key: key,
    );

    if (rawValue == null || rawValue.isEmpty) {
      final List<LedgerTransaction> seededTransactions = _seedTransactions(
        ownerUserId,
      );
      await saveTransactions(ownerUserId, seededTransactions);
      await _localStore.write(
        boxName: AppConstants.transactionsBox,
        key: _sequenceKey(ownerUserId),
        value: seededTransactions.length.toString(),
      );
      return seededTransactions;
    }

    final List<dynamic> decoded = jsonDecode(rawValue) as List<dynamic>;
    return decoded
        .map(
          (dynamic item) =>
              LedgerTransaction.fromJson(item as Map<String, dynamic>),
        )
        .toList(growable: false);
  }

  Future<void> saveTransactions(
    String ownerUserId,
    List<LedgerTransaction> transactions,
  ) async {
    await _localStore.write(
      boxName: AppConstants.transactionsBox,
      key: _transactionsKey(ownerUserId),
      value: jsonEncode(
        transactions
            .map((LedgerTransaction transaction) => transaction.toJson())
            .toList(),
      ),
    );
  }

  List<LedgerTransaction> _seedTransactions(String ownerUserId) {
    final DateTime now = DateTime.now().toUtc();

    LedgerTransaction seed({
      required int sequence,
      required TransactionType type,
      String? sourceWalletId,
      String? destinationWalletId,
      required Currency sourceCurrency,
      Currency? destinationCurrency,
      required String sourceAmount,
      String? destinationAmount,
      String? exchangeRate,
      String? note,
    }) {
      return LedgerTransaction(
        id: IdGenerator.next(),
        reference: TransactionReference(
          value: 'TX-${now.year}-${sequence.toString().padLeft(6, '0')}',
          year: now.year,
          sequence: sequence,
        ),
        type: type,
        initiatedByUserId: ownerUserId,
        sourceWalletId: sourceWalletId,
        destinationWalletId: destinationWalletId,
        sourceCurrency: sourceCurrency,
        destinationCurrency: destinationCurrency,
        sourceAmount: sourceAmount,
        destinationAmount: destinationAmount,
        exchangeRate: exchangeRate,
        note: note,
        createdAt: now.subtract(Duration(days: 30 - sequence)),
      );
    }

    return <LedgerTransaction>[
      seed(
        sequence: 1,
        type: TransactionType.deposit,
        destinationWalletId: 'wallet_main',
        sourceCurrency: Currency.usd,
        sourceAmount: '1250',
        note: 'Initial USD funding',
      ),
      seed(
        sequence: 2,
        type: TransactionType.deposit,
        destinationWalletId: 'wallet_main',
        sourceCurrency: Currency.syp,
        sourceAmount: '12500000',
        note: 'Initial SYP funding',
      ),
      seed(
        sequence: 3,
        type: TransactionType.deposit,
        destinationWalletId: 'wallet_business',
        sourceCurrency: Currency.usd,
        sourceAmount: '500',
        note: 'Business reserve',
      ),
      seed(
        sequence: 4,
        type: TransactionType.deposit,
        destinationWalletId: 'wallet_business',
        sourceCurrency: Currency.syp,
        sourceAmount: '5000000',
        note: 'Business reserve in SYP',
      ),
      seed(
        sequence: 5,
        type: TransactionType.deposit,
        destinationWalletId: 'wallet_travel',
        sourceCurrency: Currency.usd,
        sourceAmount: '300',
        note: 'Travel budget',
      ),
      seed(
        sequence: 6,
        type: TransactionType.deposit,
        destinationWalletId: 'wallet_travel',
        sourceCurrency: Currency.syp,
        sourceAmount: '1500000',
        note: 'Travel reserve in SYP',
      ),
      seed(
        sequence: 7,
        type: TransactionType.deposit,
        destinationWalletId: 'wallet_savings',
        sourceCurrency: Currency.usd,
        sourceAmount: '2200',
        note: 'Savings funding',
      ),
      seed(
        sequence: 8,
        type: TransactionType.deposit,
        destinationWalletId: 'wallet_savings',
        sourceCurrency: Currency.syp,
        sourceAmount: '9000000',
        note: 'Savings reserve in SYP',
      ),
    ];
  }
}
