enum LockTimeoutOption {
  immediate('immediate', Duration.zero),
  seconds30('30s', Duration(seconds: 30)),
  minute1('1m', Duration(minutes: 1)),
  minutes5('5m', Duration(minutes: 5));

  const LockTimeoutOption(this.storageValue, this.duration);

  final String storageValue;
  final Duration duration;

  static LockTimeoutOption fromStorageValue(String? value) {
    return LockTimeoutOption.values.firstWhere(
      (LockTimeoutOption option) => option.storageValue == value,
      orElse: () => LockTimeoutOption.immediate,
    );
  }
}
