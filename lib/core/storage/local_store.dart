abstract interface class LocalStore {
  Future<void> initialize();
  Future<void> write({
    required String boxName,
    required String key,
    required String value,
  });
  Future<String?> read({required String boxName, required String key});
  Future<List<String>> readAll({required String boxName});
  Future<void> delete({required String boxName, required String key});
  Future<void> clearBox({required String boxName});
}
