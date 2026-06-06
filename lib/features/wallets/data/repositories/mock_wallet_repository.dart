import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/local_store.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../../shared/domain/models/money.dart';
import '../../domain/models/wallet.dart';
import '../../domain/models/wallet_activity_item.dart';
import '../../domain/models/wallet_balance_snapshot.dart';
import '../../domain/models/wallet_dashboard_snapshot.dart';
import '../../domain/models/wallet_overview.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../models/mock_wallet_record.dart';

class MockWalletRepository implements WalletRepository {
  MockWalletRepository(this._localStore);

  final LocalStore _localStore;

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

  List<WalletActivityItem> _mockActivities(List<MockWalletRecord> records) {
    return records
        .take(3)
        .map((MockWalletRecord record) {
          return WalletActivityItem(
            id: 'activity_${record.wallet.id}',
            title: 'Balance snapshot refreshed',
            subtitle:
                'Mock wallet summary prepared for ${record.wallet.name}. Transaction history will be connected later.',
            walletId: record.wallet.id,
            walletName: record.wallet.name,
            occurredAt: record.wallet.updatedAt,
          );
        })
        .toList(growable: false);
  }

  WalletOverview _toOverview(MockWalletRecord record) {
    return WalletOverview(
      wallet: record.wallet,
      balance: WalletBalanceSnapshot(
        walletId: record.wallet.id,
        usdBalance: Money(currency: Currency.usd, amount: record.usdBalance),
        sypBalance: Money(currency: Currency.syp, amount: record.sypBalance),
        asOf: record.wallet.updatedAt,
      ),
    );
  }

  List<WalletOverview> _toOverviews(List<MockWalletRecord> records) {
    return records.map(_toOverview).toList(growable: false);
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
        usdBalance: '1250',
        sypBalance: '12500000',
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
        usdBalance: '500',
        sypBalance: '5000000',
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
        usdBalance: '300',
        sypBalance: '1500000',
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
        usdBalance: '2200',
        sypBalance: '9000000',
      ),
    ];
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
    return _toOverview(updatedRecord);
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
      usdBalance: '0',
      sypBalance: '0',
    );

    final List<MockWalletRecord> updatedRecords = List<MockWalletRecord>.from(
      records,
    )..add(record);

    await _saveRecords(ownerUserId, updatedRecords);
    return _toOverview(record);
  }

  @override
  Future<WalletDashboardSnapshot> fetchDashboardSnapshot(
    String ownerUserId,
  ) async {
    final List<MockWalletRecord> records = await _loadRecords(ownerUserId);
    final List<WalletOverview> overviews = _toOverviews(records);
    final Iterable<MockWalletRecord> activeRecords = records.where(
      (MockWalletRecord record) => !record.wallet.isArchived,
    );

    final num totalUsd = activeRecords.fold<num>(
      0,
      (num total, MockWalletRecord record) =>
          total + (num.tryParse(record.usdBalance) ?? 0),
    );
    final num totalSyp = activeRecords.fold<num>(
      0,
      (num total, MockWalletRecord record) =>
          total + (num.tryParse(record.sypBalance) ?? 0),
    );

    return WalletDashboardSnapshot(
      ownerUserId: ownerUserId,
      totalUsd: totalUsd.toString(),
      totalSyp: totalSyp.toString(),
      walletSummaries: overviews,
      recentActivities: _mockActivities(records),
    );
  }

  @override
  Future<List<WalletOverview>> fetchWallets(String ownerUserId) async {
    return _toOverviews(await _loadRecords(ownerUserId));
  }

  @override
  Future<WalletOverview?> getWalletById({
    required String ownerUserId,
    required String walletId,
  }) async {
    final List<MockWalletRecord> records = await _loadRecords(ownerUserId);
    final MockWalletRecord? record = records
        .cast<MockWalletRecord?>()
        .firstWhere(
          (MockWalletRecord? item) => item?.wallet.id == walletId,
          orElse: () => null,
        );

    return record == null ? null : _toOverview(record);
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
    return _toOverview(updatedRecord);
  }
}

class WalletRepositoryException implements Exception {
  const WalletRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
