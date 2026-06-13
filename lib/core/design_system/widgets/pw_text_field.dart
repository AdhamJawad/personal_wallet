import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PwTextField extends StatefulWidget {
  const PwTextField({
    required this.controller,
    required this.label,
    this.hint,
    this.helper,
    this.prefixIcon,
    this.focusNode,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.validator,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.suffixIcon,
    this.onFieldSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? helper;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int maxLines;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<PwTextField> createState() => _PwTextFieldState();
}

class _PwTextFieldState extends State<PwTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant PwTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      _isObscured = widget.obscureText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool supportsVisibilityToggle = widget.obscureText;

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      obscureText: supportsVisibilityToggle ? _isObscured : widget.obscureText,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      onTap: widget.onTap,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        helperText: widget.helper,
        prefixIcon: widget.prefixIcon,
        suffixIcon: supportsVisibilityToggle
            ? IconButton(
                onPressed: widget.enabled
                    ? () => setState(() => _isObscured = !_isObscured)
                    : null,
                icon: Icon(
                  _isObscured
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                ),
              )
            : widget.suffixIcon,
        counterText: '',
      ),
    );
  }
}
