import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class PinCodeField extends StatefulWidget {
  const PinCodeField({
    required this.controller,
    this.length = 6,
    this.autofocus = false,
    this.focusNode,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.onCompleted,
    super.key,
  });

  final TextEditingController controller;
  final int length;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onCompleted;

  @override
  State<PinCodeField> createState() => _PinCodeFieldState();
}

class _PinCodeFieldState extends State<PinCodeField> {
  late final FocusNode _internalFocusNode;
  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode();
    widget.controller.addListener(_handleControllerChanged);

    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _focusNode.requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    _internalFocusNode.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    final String value = widget.controller.text;
    if (value.length == widget.length) {
      widget.onCompleted?.call(value);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final String value = widget.controller.text;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _focusNode.requestFocus,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Opacity(
            opacity: 0.01,
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              keyboardType: TextInputType.number,
              textInputAction: widget.textInputAction,
              maxLength: widget.length,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onSubmitted: widget.onSubmitted,
              decoration: const InputDecoration(counterText: ''),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(widget.length, (int index) {
              final bool filled = index < value.length;
              final bool active =
                  value.length == index || (value.isEmpty && index == 0);
              return Container(
                width: 44,
                height: 54,
                margin: EdgeInsetsDirectional.only(
                  end: index == widget.length - 1 ? 0 : AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: filled
                      ? colorScheme.primary.withValues(alpha: 0.12)
                      : theme.cardColor,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: active
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.18),
                    width: active ? 1.4 : 1,
                  ),
                ),
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  width: filled ? 12 : 6,
                  height: filled ? 12 : 6,
                  decoration: BoxDecoration(
                    color: filled
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
