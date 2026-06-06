import 'package:hive/hive.dart';

import '../local_store.dart';

class HiveLocalStore implements LocalStore {
  const HiveLocalStore();

  @override
  Future<void> clearBox({required String boxName}) async {
    await Hive.box<String>(boxName).clear();
  }

  @override
  Future<void> delete({required String boxName, required String key}) async {
    await Hive.box<String>(boxName).delete(key);
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> read({required String boxName, required String key}) async {
    return Hive.box<String>(boxName).get(key);
  }

  @override
  Future<List<String>> readAll({required String boxName}) async {
    return Hive.box<String>(boxName).values.toList(growable: false);
  }

  @override
  Future<void> write({
    required String boxName,
    required String key,
    required String value,
  }) async {
    await Hive.box<String>(boxName).put(key, value);
  }
}
