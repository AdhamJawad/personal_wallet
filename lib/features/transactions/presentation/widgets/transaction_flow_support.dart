import 'package:flutter/material.dart';

import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class TransactionFlowLayout extends StatelessWidget {
  const TransactionFlowLayout({
    required this.content,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    this.secondaryLabel,
    this.onSecondaryPressed,
    this.isPrimaryLoading = false,
    this.compact = false,
    this.extraScrollBottomSpacing = 0,
    super.key,
  });

  final Widget content;
  final String primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;
  final bool isPrimaryLoading;
  final bool compact;
  final double extraScrollBottomSpacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final EdgeInsets contentPadding = EdgeInsets.only(
          bottom:
              (compact ? AppSpacing.xs : AppSpacing.lg) +
              extraScrollBottomSpacing,
        );
        final Widget scrollableContent = SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: contentPadding,
          child: content,
        );
        final Widget actionBar = _StickyActionBar(
          primaryLabel: primaryLabel,
          onPrimaryPressed: onPrimaryPressed,
          secondaryLabel: secondaryLabel,
          onSecondaryPressed: onSecondaryPressed,
          isPrimaryLoading: isPrimaryLoading,
        );
        final bool canUseFlex = constraints.hasBoundedHeight && !compact;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: canUseFlex ? MainAxisSize.max : MainAxisSize.min,
            children: <Widget>[
              if (canUseFlex)
                Expanded(child: scrollableContent)
              else
                scrollableContent,
              SizedBox(height: compact ? AppSpacing.xs : AppSpacing.md),
              actionBar,
            ],
          ),
        );
      },
    );
  }
}

class TransactionFormSection extends StatelessWidget {
  const TransactionFormSection({
    required this.child,
    this.title,
    this.subtitle,
    this.compact = false,
    super.key,
  });

  final String? title;
  final String? subtitle;
  final Widget child;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return PwSectionCard(
      child: Padding(
        padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (title != null) ...<Widget>[
              Text(title!, style: Theme.of(context).textTheme.titleMedium),
              if (subtitle != null) ...<Widget>[
                const SizedBox(height: 2),
                Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
              ],
              SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

class TransactionPickerField extends StatelessWidget {
  const TransactionPickerField({
    required this.label,
    required this.value,
    required this.hint,
    required this.onTap,
    this.errorText,
    this.enabled = true,
    this.trailing,
    this.leading,
    this.subtitle,
    super.key,
  });

  final String label;
  final String? value;
  final String hint;
  final String? errorText;
  final VoidCallback onTap;
  final bool enabled;
  final Widget? trailing;
  final Widget? leading;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color borderColor = errorText == null
        ? AppColors.outlineSoft
        : theme.colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  leading!,
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        value == null || value!.isEmpty ? hint : value!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: value == null || value!.isEmpty
                            ? theme.textTheme.bodyMedium?.copyWith(
                                color: theme.hintColor,
                              )
                            : theme.textTheme.bodyLarge,
                      ),
                      if (subtitle != null) ...<Widget>[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                trailing ??
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: enabled
                          ? theme.colorScheme.primary
                          : theme.hintColor,
                    ),
              ],
            ),
          ),
        ),
        if (errorText != null) ...<Widget>[
          const SizedBox(height: AppSpacing.xs),
          Text(
            errorText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}

class TransactionSummaryRow extends StatelessWidget {
  const TransactionSummaryRow({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child: Text(label)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionEmptyState extends StatelessWidget {
  const TransactionEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineSoft.withValues(alpha: 0.8)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (action != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            action!,
          ],
        ],
      ),
    );
  }
}

class TransactionSkeletonBlock extends StatelessWidget {
  const TransactionSkeletonBlock({
    required this.height,
    this.width = double.infinity,
    this.radius = 16,
    super.key,
  });

  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final Color base = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.08);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class TransactionFormSkeleton extends StatelessWidget {
  const TransactionFormSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionFlowLayout(
      primaryLabel: '',
      onPrimaryPressed: null,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TransactionSkeletonBlock(height: 56),
          SizedBox(height: AppSpacing.md),
          TransactionSkeletonBlock(height: 56),
          SizedBox(height: AppSpacing.md),
          TransactionSkeletonBlock(height: 92),
          SizedBox(height: AppSpacing.md),
          TransactionSkeletonBlock(height: 60),
        ],
      ),
    );
  }
}

class TransactionReviewSkeleton extends StatelessWidget {
  const TransactionReviewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionFlowLayout(
      primaryLabel: '',
      onPrimaryPressed: null,
      secondaryLabel: '',
      content: Column(
        children: <Widget>[
          TransactionSkeletonBlock(height: 18),
          SizedBox(height: AppSpacing.md),
          TransactionSkeletonBlock(height: 18),
          SizedBox(height: AppSpacing.md),
          TransactionSkeletonBlock(height: 18),
          SizedBox(height: AppSpacing.md),
          TransactionSkeletonBlock(height: 18),
        ],
      ),
    );
  }
}

class TransactionSuccessState extends StatelessWidget {
  const TransactionSuccessState({
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
    this.summary,
    this.compact = false,
    super.key,
  });

  final String title;
  final String message;
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;
  final Widget? summary;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return TransactionFlowLayout(
      compact: compact,
      primaryLabel: primaryLabel,
      onPrimaryPressed: onPrimaryPressed,
      secondaryLabel: secondaryLabel,
      onSecondaryPressed: onSecondaryPressed,
      content: Column(
        children: <Widget>[
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 36,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (summary != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            TransactionFormSection(compact: true, child: summary!),
          ],
        ],
      ),
    );
  }
}

class AttachmentCompactField extends StatelessWidget {
  const AttachmentCompactField({
    required this.label,
    required this.value,
    required this.onTap,
    this.thumbnails = const <Widget>[],
    this.subtitle,
    super.key,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final List<Widget> thumbnails;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.outlineSoft.withValues(alpha: 0.8),
          ),
        ),
        child: Row(
          children: <Widget>[
            const Icon(Icons.attach_file_rounded),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(label, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(value, style: Theme.of(context).textTheme.bodySmall),
                  if (subtitle != null) ...<Widget>[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (thumbnails.isNotEmpty) ...<Widget>[
              const SizedBox(width: AppSpacing.sm),
              ...thumbnails,
            ],
          ],
        ),
      ),
    );
  }
}

class SelectionChipOption<T> {
  const SelectionChipOption({required this.value, required this.label});

  final T value;
  final String label;
}

class CurrencyChip<T> extends StatelessWidget {
  const CurrencyChip({
    required this.value,
    required this.label,
    required this.options,
    required this.onSelected,
    this.icon,
    super.key,
  });

  final T value;
  final String label;
  final List<SelectionChipOption<T>> options;
  final ValueChanged<T> onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return PopupMenuButton<T>(
      initialValue: value,
      onSelected: onSelected,
      color: theme.colorScheme.surface,
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (BuildContext context) {
        return options
            .map(
              (SelectionChipOption<T> option) => PopupMenuItem<T>(
                value: option.value,
                child: Text(option.label),
              ),
            )
            .toList(growable: false);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.outlineSoft.withValues(alpha: 0.8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(icon, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(label, style: theme.textTheme.titleSmall),
            const SizedBox(width: AppSpacing.xs),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}

class _StickyActionBar extends StatelessWidget {
  const _StickyActionBar({
    required this.primaryLabel,
    required this.onPrimaryPressed,
    this.secondaryLabel,
    this.onSecondaryPressed,
    this.isPrimaryLoading = false,
  });

  final String primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;
  final bool isPrimaryLoading;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.outlineSoft.withValues(alpha: 0.8)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: <Widget>[
            if (secondaryLabel != null) ...<Widget>[
              Expanded(
                child: PwButton.secondary(
                  label: secondaryLabel!,
                  onPressed: onSecondaryPressed,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: PwButton.primary(
                label: primaryLabel,
                onPressed: onPrimaryPressed,
                isLoading: isPrimaryLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String transactionAttachmentSummary(
  BuildContext context,
  int count, {
  String? fileName,
}) {
  if (count == 0) {
    return context.tr.addAttachment;
  }
  if (count == 1 && fileName != null && fileName.isNotEmpty) {
    return fileName;
  }
  return context.tr.attachmentsSelected(count);
}
