import 'package:hive_flutter/hive_flutter.dart';

import '../../constants/app_constants.dart';

sealed class HiveInitializer {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    await Future.wait(<Future<Box<String>>>[
      Hive.openBox<String>(AppConstants.preferencesBox),
      Hive.openBox<String>(AppConstants.usersBox),
      Hive.openBox<String>(AppConstants.sessionsBox),
      Hive.openBox<String>(AppConstants.walletsBox),
      Hive.openBox<String>(AppConstants.transactionsBox),
      Hive.openBox<String>(AppConstants.debtsBox),
      Hive.openBox<String>(AppConstants.contactsBox),
      Hive.openBox<String>(AppConstants.qrProfilesBox),
      Hive.openBox<String>(AppConstants.attachmentsBox),
      Hive.openBox<String>(AppConstants.notificationsBox),
      Hive.openBox<String>(AppConstants.auditBox),
      Hive.openBox<String>(AppConstants.syncQueueBox),
    ]);
  }
}
