import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/local_store.dart';
import '../../../../core/sync/enums/sync_operation_type.dart';
import '../../../../core/sync/repositories/sync_queue_repository.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../audit/domain/enums/audit_event_type.dart';
import '../../../audit/domain/services/audit_logger.dart';
import '../../../notifications/domain/services/notification_publisher.dart';
import '../../../../shared/domain/enums/transaction_type.dart';
import '../../../transactions/data/services/mock_ledger_store.dart';
import '../../../transactions/domain/models/ledger_transaction.dart';
import '../../../transactions/domain/services/balance_calculator_service.dart';
import '../../domain/models/wallet.dart';
import '../../domain/models/wallet_activity_item.dart';
import '../../domain/models/wallet_balance_snapshot.dart';
import '../../domain/models/wallet_dashboard_snapshot.dart';
import '../../domain/models/wallet_overview.dart';
import 'local_wallet_repository.dart';
import '../models/mock_wallet_record.dart';

class MockWalletRepository implements LocalWalletRepository {
  MockWalletRepository({
    required LocalStore localStore,
    required MockLedgerStore ledgerStore,
    required BalanceCalculatorService balanceCalculatorService,
    required SyncQueueRepository syncQueueRepository,
    required NotificationPublisher notificationPublisher,
    required AuditLogger auditLogger,
  }) : _localStore = localStore,
       _ledgerStore = ledgerStore,
       _balanceCalculatorService = balanceCalculatorService,
       _syncQueueRepository = syncQueueRepository,
       _notificationPublisher = notificationPublisher,
       _auditLogger = auditLogger;

  final LocalStore _localStore;
  final MockLedgerStore _ledgerStore;
  final BalanceCalculatorService _balanceCalculatorService;
  final SyncQueueRepository _syncQueueRepository;
  final NotificationPublisher _notificationPublisher;
  final AuditLogger _auditLogger;

  Future<List<MockWalletRecord>> _loadRecords(String ownerUserId) async {
    final String? rawValue = await _localStore.read(
      boxName: AppConstants.walletsBox,
      key: ownerUserId,
    );

    if (rawValue == null || rawValue.isEmpty) {
      final List<MockWalletRecord> seededRecords = _seedRecords(ownerUserId);
      await _saveRecords(ownerUserId, seededRecords);
      return seededRecords;
    }

    final List<dynamic> decoded = jsonDecode(rawValue) as List<dynamic>;
    return decoded
        .map(
          (dynamic item) =>
              MockWalletRecord.fromJson(item as Map<String, dynamic>),
        )
        .toList(growable: false);
  }

  Future<void> _saveRecords(
    String ownerUserId,
    List<MockWalletRecord> records,
  ) async {
    await _localStore.write(
      boxName: AppConstants.walletsBox,
      key: ownerUserId,
      value: jsonEncode(
        records.map((MockWalletRecord record) => record.toJson()).toList(),
      ),
    );
  }

  List<MockWalletRecord> _seedRecords(String ownerUserId) {
    final DateTime now = DateTime.now().toUtc();

    return <MockWalletRecord>[
      MockWalletRecord(
        wallet: Wallet(
          id: 'wallet_main',
          ownerUserId: ownerUserId,
          name: 'Main Wallet',
          isArchived: false,
          createdAt: now.subtract(const Duration(days: 50)),
          updatedAt: now.subtract(const Duration(hours: 3)),
        ),
      ),
      MockWalletRecord(
        wallet: Wallet(
          id: 'wallet_business',
          ownerUserId: ownerUserId,
          name: 'Business Wallet',
          isArchived: false,
          createdAt: now.subtract(const Duration(days: 30)),
          updatedAt: now.subtract(const Duration(days: 1)),
        ),
      ),
      MockWalletRecord(
        wallet: Wallet(
          id: 'wallet_travel',
          ownerUserId: ownerUserId,
          name: 'Travel Wallet',
          isArchived: false,
          createdAt: now.subtract(const Duration(days: 10)),
          updatedAt: now.subtract(const Duration(days: 2)),
        ),
      ),
      MockWalletRecord(
        wallet: Wallet(
          id: 'wallet_savings',
          ownerUserId: ownerUserId,
          name: 'Savings Wallet',
          isArchived: false,
          createdAt: now.subtract(const Duration(days: 5)),
          updatedAt: now.subtract(const Duration(hours: 10)),
        ),
      ),
    ];
  }

  Future<List<WalletOverview>> _toOverviews(
    String ownerUserId,
    List<MockWalletRecord> records,
  ) async {
    final List<LedgerTransaction> transactions = await _ledgerStore
        .loadTransactions(ownerUserId);
    final balances = _balanceCalculatorService.calculateBalances(
      records.map((MockWalletRecord record) => record.wallet.id).toList(),
      transactions,
    );

    return records
        .map(
          (MockWalletRecord record) => WalletOverview(
            wallet: record.wallet,
            balance: WalletBalanceSnapshot(
              walletId: record.wallet.id,
              usdBalance: balances[record.wallet.id]!.usdBalance,
              sypBalance: balances[record.wallet.id]!.sypBalance,
              asOf: record.wallet.updatedAt,
            ),
          ),
        )
        .toList(growable: false);
  }

  List<WalletActivityItem> _toActivities(
    List<MockWalletRecord> records,
    List<LedgerTransaction> transactions,
  ) {
    if (transactions.isEmpty) {
      return records
          .take(3)
          .map((MockWalletRecord record) {
            return WalletActivityItem(
              id: 'activity_${record.wallet.id}',
              title: 'Wallet ready',
              subtitle: '${record.wallet.name} is ready for ledger activity.',
              walletId: record.wallet.id,
              walletName: record.wallet.name,
              occurredAt: record.wallet.updatedAt,
            );
          })
          .toList(growable: false);
    }

    final Map<String, String> walletNames = <String, String>{
      for (final MockWalletRecord record in records)
        record.wallet.id: record.wallet.name,
    };

    final List<LedgerTransaction> orderedTransactions =
        List<LedgerTransaction>.from(transactions)
          ..sort((LedgerTransaction left, LedgerTransaction right) {
            return right.createdAt.compareTo(left.createdAt);
          });

    return orderedTransactions
        .take(4)
        .map((LedgerTransaction transaction) {
          final String walletId =
              transaction.destinationWalletId ??
              transaction.sourceWalletId ??
              '';

          return WalletActivityItem(
            id: transaction.id,
            title: switch (transaction.type) {
              TransactionType.deposit => 'Deposit recorded',
              TransactionType.withdraw => 'Withdrawal recorded',
              TransactionType.transfer => transaction.recipientUserId == null
                  ? 'Internal transfer recorded'
                  : transaction.debtSettlementId == null
                  ? 'User transfer recorded'
                  : 'Debt settlement recorded',
              TransactionType.exchange => 'Exchange recorded',
              TransactionType.reversal => 'Reversal recorded',
              TransactionType.correction => 'Correction recorded',
            },
            subtitle: transaction.note ?? transaction.reference.value,
            walletId: walletId,
            walletName: walletNames[walletId] ?? 'Unknown wallet',
            occurredAt: transaction.createdAt,
          );
        })
        .toList(growable: false);
  }

  @override
  Future<WalletOverview> archiveWallet({
    required String ownerUserId,
    required String walletId,
  }) async {
    final List<MockWalletRecord> records = await _loadRecords(ownerUserId);
    final int recordIndex = records.indexWhere(
      (MockWalletRecord record) => record.wallet.id == walletId,
    );

    if (recordIndex < 0) {
      throw const WalletRepositoryException('Wallet was not found.');
    }

    final MockWalletRecord updatedRecord = records[recordIndex].copyWith(
      wallet: records[recordIndex].wallet.copyWith(
        isArchived: true,
        updatedAt: DateTime.now().toUtc(),
      ),
    );

    final List<MockWalletRecord> updatedRecords = List<MockWalletRecord>.from(
      records,
    )..[recordIndex] = updatedRecord;

    await _saveRecords(ownerUserId, updatedRecords);
    await _syncQueueRepository.addOperation(
      ownerUserId: ownerUserId,
      entityId: walletId,
      type: SyncOperationType.walletArchive,
      payload: <String, dynamic>{'walletId': walletId},
    );
    await _auditLogger.log(
      ownerUserId: ownerUserId,
      type: AuditEventType.walletArchived,
      entityId: walletId,
      relatedEntityType: 'wallet',
    );
    final List<WalletOverview> overviews = await _toOverviews(
      ownerUserId,
      updatedRecords,
    );

    return overviews.firstWhere(
      (WalletOverview item) => item.wallet.id == updatedRecord.wallet.id,
    );
  }

  @override
  Future<WalletOverview> createWallet({
    required String ownerUserId,
    required String name,
  }) async {
    final DateTime now = DateTime.now().toUtc();
    final List<MockWalletRecord> records = await _loadRecords(ownerUserId);
    final MockWalletRecord record = MockWalletRecord(
      wallet: Wallet(
        id: IdGenerator.next(),
        ownerUserId: ownerUserId,
        name: name,
        isArchived: false,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final List<MockWalletRecord> updatedRecords = List<MockWalletRecord>.from(
      records,
    )..add(record);

    await _saveRecords(ownerUserId, updatedRecords);
    await _syncQueueRepository.addOperation(
      ownerUserId: ownerUserId,
      entityId: record.wallet.id,
      type: SyncOperationType.walletCreate,
      payload: <String, dynamic>{'walletId': record.wallet.id, 'name': name},
    );
    await _notificationPublisher.publish(
      ownerUserId: ownerUserId,
      type: 'walletCreated',
      title: 'Wallet created',
      message: '${record.wallet.name} was created locally.',
      relatedEntityId: record.wallet.id,
      relatedEntityType: 'wallet',
    );
    await _auditLogger.log(
      ownerUserId: ownerUserId,
      type: AuditEventType.walletCreated,
      entityId: record.wallet.id,
      relatedEntityType: 'wallet',
      metadata: <String, dynamic>{'name': record.wallet.name},
    );
    final List<WalletOverview> overviews = await _toOverviews(
      ownerUserId,
      updatedRecords,
    );

    return overviews.firstWhere(
      (WalletOverview item) => item.wallet.id == record.wallet.id,
    );
  }

  @override
  Future<WalletDashboardSnapshot> fetchDashboardSnapshot(
    String ownerUserId,
  ) async {
    final List<MockWalletRecord> records = await _loadRecords(ownerUserId);
    final List<LedgerTransaction> transactions = await _ledgerStore
        .loadTransactions(ownerUserId);
    final List<WalletOverview> overviews = await _toOverviews(
      ownerUserId,
      records,
    );
    final Iterable<WalletOverview> activeOverviews = overviews.where(
      (WalletOverview item) => !item.wallet.isArchived,
    );

    final num totalUsd = activeOverviews.fold<num>(
      0,
      (num total, WalletOverview item) =>
          total + (num.tryParse(item.balance.usdBalance.amount) ?? 0),
    );
    final num totalSyp = activeOverviews.fold<num>(
      0,
      (num total, WalletOverview item) =>
          total + (num.tryParse(item.balance.sypBalance.amount) ?? 0),
    );

    return WalletDashboardSnapshot(
      ownerUserId: ownerUserId,
      totalUsd: totalUsd.toString(),
      totalSyp: totalSyp.toString(),
      walletSummaries: overviews,
      recentActivities: _toActivities(records, transactions),
    );
  }

  @override
  Future<List<WalletOverview>> fetchWallets(String ownerUserId) async {
    return _toOverviews(ownerUserId, await _loadRecords(ownerUserId));
  }

  @override
  Future<WalletOverview?> getWalletById({
    required String ownerUserId,
    required String walletId,
  }) async {
    final List<WalletOverview> overviews = await _toOverviews(
      ownerUserId,
      await _loadRecords(ownerUserId),
    );

    return overviews.cast<WalletOverview?>().firstWhere(
      (WalletOverview? item) => item?.wallet.id == walletId,
      orElse: () => null,
    );
  }

  @override
  Future<WalletOverview> renameWallet({
    required String ownerUserId,
    required String walletId,
    required String name,
  }) async {
    final List<MockWalletRecord> records = await _loadRecords(ownerUserId);
    final int recordIndex = records.indexWhere(
      (MockWalletRecord record) => record.wallet.id == walletId,
    );

    if (recordIndex < 0) {
      throw const WalletRepositoryException('Wallet was not found.');
    }

    final MockWalletRecord updatedRecord = records[recordIndex].copyWith(
      wallet: records[recordIndex].wallet.copyWith(
        name: name,
        updatedAt: DateTime.now().toUtc(),
      ),
    );

    final List<MockWalletRecord> updatedRecords = List<MockWalletRecord>.from(
      records,
    )..[recordIndex] = updatedRecord;

    await _saveRecords(ownerUserId, updatedRecords);
    await _syncQueueRepository.addOperation(
      ownerUserId: ownerUserId,
      entityId: walletId,
      type: SyncOperationType.walletRename,
      payload: <String, dynamic>{'walletId': walletId, 'name': name},
    );
    await _auditLogger.log(
      ownerUserId: ownerUserId,
      type: AuditEventType.walletRenamed,
      entityId: walletId,
      relatedEntityType: 'wallet',
      metadata: <String, dynamic>{'name': name},
    );
    final List<WalletOverview> overviews = await _toOverviews(
      ownerUserId,
      updatedRecords,
    );

    return overviews.firstWhere(
      (WalletOverview item) => item.wallet.id == updatedRecord.wallet.id,
    );
  }
}

class WalletRepositoryException implements Exception {
  const WalletRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
