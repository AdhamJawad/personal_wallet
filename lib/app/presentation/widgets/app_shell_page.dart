import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_modal_bottom_sheet.dart';
import '../../../features/dashboard/presentation/widgets/dashboard_copy.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

class AppShellPage extends StatelessWidget {
  const AppShellPage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final DashboardCopy copy = DashboardCopy.of(context);
    void goBranch(int index) {
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }

    return Directionality(
      textDirection: copy.textDirection,
      child: Scaffold(
        extendBody: true,
        body: navigationShell,
        bottomNavigationBar: _ShellNavigationBar(
          currentIndex: navigationShell.currentIndex,
          items: <_ShellNavItem>[
            _ShellNavItem(
              label: copy.home,
              icon: Icons.home_rounded,
              onTap: () => goBranch(0),
            ),
            _ShellNavItem(
              label: copy.wallets,
              icon: Icons.account_balance_wallet_rounded,
              onTap: () => goBranch(1),
            ),
            _ShellNavItem(
              label: copy.action,
              icon: Icons.add_rounded,
              onTap: () => _showQuickActions(context, copy),
              isPrimaryAction: true,
            ),
            _ShellNavItem(
              label: copy.debts,
              icon: Icons.request_quote_rounded,
              onTap: () => goBranch(2),
            ),
            _ShellNavItem(
              label: copy.profile,
              icon: Icons.person_rounded,
              onTap: () => goBranch(3),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showQuickActions(
    BuildContext context,
    DashboardCopy copy,
  ) async {
    await showAppModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      builder: (BuildContext modalContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.md,
              AppSpacing.xl,
              AppSpacing.xxl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  copy.actionsSheetTitle,
                  textAlign: TextAlign.right,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  copy.actionsSheetSubtitle,
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: <Widget>[
                    _ActionSheetItem(
                      label: copy.deposit,
                      icon: Icons.south_west_rounded,
                      onTap: () =>
                          _pushAction(context, '/transactions/deposit'),
                    ),
                    _ActionSheetItem(
                      label: copy.withdraw,
                      icon: Icons.north_east_rounded,
                      onTap: () =>
                          _pushAction(context, '/transactions/withdraw'),
                    ),
                    _ActionSheetItem(
                      label: copy.transfer,
                      icon: Icons.swap_horiz_rounded,
                      onTap: () =>
                          _pushAction(context, '/transactions/transfer'),
                    ),
                    _ActionSheetItem(
                      label: copy.exchange,
                      icon: Icons.currency_exchange_rounded,
                      onTap: () =>
                          _pushAction(context, '/transactions/exchange'),
                    ),
                    _ActionSheetItem(
                      label: copy.createDebt,
                      icon: Icons.receipt_long_rounded,
                      onTap: () => _pushAction(context, '/debts/create'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _pushAction(BuildContext context, String location) {
    Navigator.of(context).pop();
    context.push(location);
  }
}

class _ShellNavigationBar extends StatelessWidget {
  const _ShellNavigationBar({required this.currentIndex, required this.items});

  final int currentIndex;
  final List<_ShellNavItem> items;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isDark
                ? theme.cardColor.withValues(alpha: 0.96)
                : Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.12),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SizedBox(
            height: 72,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List<Widget>.generate(items.length, (int index) {
                final _ShellNavItem item = items[index];
                return Expanded(
                  child: _ShellNavigationButton(
                    item: item,
                    isSelected:
                        !item.isPrimaryAction &&
                        currentIndex == _branchIndexFor(index),
                    isCenter: index == 2,
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShellNavigationButton extends StatelessWidget {
  const _ShellNavigationButton({
    required this.item,
    required this.isSelected,
    required this.isCenter,
  });

  final _ShellNavItem item;
  final bool isSelected;
  final bool isCenter;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isPrimaryAction = item.isPrimaryAction;
    final bool isDark = theme.brightness == Brightness.dark;
    final double iconSize = isPrimaryAction ? 20 : 21;
    final Color foregroundColor = isPrimaryAction
        ? colorScheme.onPrimary
        : isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;
    final Color chipColor = isPrimaryAction
        ? colorScheme.primary
        : isSelected
        ? colorScheme.primary.withValues(alpha: 0.08)
        : Colors.transparent;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: EdgeInsets.only(
          left: 2,
          right: 2,
          top: AppSpacing.sm,
          bottom: AppSpacing.sm,
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              horizontal: isPrimaryAction ? AppSpacing.md : AppSpacing.sm,
              vertical: isPrimaryAction ? AppSpacing.sm : 6,
            ),
            decoration: BoxDecoration(
              color: chipColor,
              borderRadius: BorderRadius.circular(isPrimaryAction ? 16 : 18),
              border: isPrimaryAction
                  ? Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.12)
                          : colorScheme.primary.withValues(alpha: 0.22),
                    )
                  : null,
              boxShadow: isPrimaryAction
                  ? <BoxShadow>[
                      BoxShadow(
                        color: colorScheme.primary.withValues(
                          alpha: isDark ? 0.28 : 0.22,
                        ),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(item.icon, size: iconSize, color: foregroundColor),
                const SizedBox(height: 3),
                SizedBox(
                  height: 13,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: foregroundColor,
                        fontWeight: isPrimaryAction || isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        height: 1,
                        letterSpacing: isPrimaryAction ? 0.1 : 0,
                      ),
                    ),
                  ),
                ),
                if (!isPrimaryAction) ...<Widget>[
                  const SizedBox(height: 3),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: isSelected ? 16 : 0,
                    height: 2,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ] else
                  const SizedBox(height: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionSheetItem extends StatelessWidget {
  const _ActionSheetItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final double width = (MediaQuery.sizeOf(context).width - 64) / 2;

    return SizedBox(
      width: width.clamp(120, 240),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Ink(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 18, color: colorScheme.primary),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.right,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShellNavItem {
  const _ShellNavItem({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimaryAction = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimaryAction;
}

int _branchIndexFor(int itemIndex) {
  if (itemIndex <= 1) {
    return itemIndex;
  }
  return itemIndex - 1;
}
