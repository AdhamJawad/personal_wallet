String? amountValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Amount is required.';
  }

  final num? parsedValue = num.tryParse(value.trim());
  if (parsedValue == null || parsedValue <= 0) {
    return 'Enter a valid amount.';
  }

  return null;
}
