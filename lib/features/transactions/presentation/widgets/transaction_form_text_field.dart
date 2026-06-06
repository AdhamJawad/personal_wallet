import 'package:flutter/material.dart';

import '../../../../core/design_system/widgets/pw_text_field.dart';

class TransactionFormTextField extends StatelessWidget {
  const TransactionFormTextField({
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.onFieldSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    if (maxLines == 1) {
      return PwTextField(
        controller: controller,
        label: label,
        hint: hint,
        keyboardType: keyboardType,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
      );
    }

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }
}
