enum Currency { usd, syp }

extension CurrencyCodeX on Currency {
  String get code => name.toUpperCase();
}

Currency currencyFromCode(String code) {
  return Currency.values.firstWhere(
    (Currency currency) => currency.code == code.toUpperCase(),
    orElse: () => Currency.usd,
  );
}
