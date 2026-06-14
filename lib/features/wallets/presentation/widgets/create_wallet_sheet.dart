import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/presentation/widgets/app_modal_bottom_sheet.dart';
import '../../../../core/feedback/app_feedback.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../dashboard/presentation/widgets/dashboard_surface_card.dart';
import '../../presentation/providers/wallet_providers.dart';

Future<void> showCreateWalletSheet(BuildContext context) {
  return showAppModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return const _CreateWalletSheet();
    },
  );
}

class _CreateWalletSheet extends ConsumerStatefulWidget {
  const _CreateWalletSheet();

  @override
  ConsumerState<_CreateWalletSheet> createState() => _CreateWalletSheetState();
}

class _CreateWalletSheetState extends ConsumerState<_CreateWalletSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _nameFieldKey = GlobalKey();
  late final TextEditingController _nameController;
  late final FocusNode _nameFocusNode;
  Color _selectedColor = _walletSheetColors.first.color;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameFocusNode = FocusNode();
    _nameFocusNode.addListener(_handleNameFocusChange);
    _nameController.addListener(_handleNameChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_handleNameChanged);
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _handleNameChanged() {
    setState(() {});
  }

  void _handleNameFocusChange() {
    if (!_nameFocusNode.hasFocus) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? fieldContext = _nameFieldKey.currentContext;
      if (!mounted || fieldContext == null) {
        return;
      }
      Scrollable.ensureVisible(
        fieldContext,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        alignment: 0.22,
      );
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final bool success = await ref
        .read(walletControllerProvider.notifier)
        .createWallet(_nameController.text);

    if (!mounted) {
      return;
    }

    if (success) {
      final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
      final SnackBar successSnackBar = buildAppSuccessSnackBar(
        context,
        context.tr.walletCreatedSuccess,
      );
      Navigator.of(context).pop();
      messenger.showSnackBar(successSnackBar);
      return;
    }

    final String errorMessage =
        ref.read(walletControllerProvider).errorMessage ??
        context.tr.walletCreateFailure;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(errorMessage)));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isLoading = ref.watch(walletControllerProvider).isLoading;
    final String walletName = _nameController.text.trim().isEmpty
        ? context.tr.walletNameHint
        : _nameController.text.trim();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.sm,
        ),
        child: DashboardSurfaceCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    context.tr.createWallet,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    context.tr.createWalletHelper,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  KeyedSubtree(
                    key: _nameFieldKey,
                    child: TextFormField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: context.tr.walletNameLabel,
                        hintText: context.tr.walletNameHint,
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.tr.walletNameRequired;
                        }
                        if (value.trim().length < 3) {
                          return context.tr.walletNameTooShort;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    context.tr.walletColor,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.sm,
                    children: _walletSheetColors
                        .map((WalletSheetColorOption option) {
                          final bool selected = option.color == _selectedColor;

                          return InkWell(
                            onTap: isLoading
                                ? null
                                : () => setState(
                                    () => _selectedColor = option.color,
                                  ),
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: option.color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selected
                                      ? colorScheme.onSurface
                                      : option.color.withValues(alpha: 0.22),
                                  width: selected ? 2.4 : 1.2,
                                ),
                                boxShadow: selected
                                    ? <BoxShadow>[
                                        BoxShadow(
                                          color: option.color.withValues(
                                            alpha: 0.28,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : const <BoxShadow>[],
                              ),
                              child: selected
                                  ? Icon(
                                      Icons.check_rounded,
                                      size: 18,
                                      color: option.foreground,
                                    )
                                  : null,
                            ),
                          );
                        })
                        .toList(growable: false),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    context.tr.walletPreview,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _WalletPreviewCard(
                    walletName: walletName,
                    statusLabel: context.tr.active,
                    selectedColor: _selectedColor,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.filledButtonTheme.style?.foregroundColor
                                          ?.resolve(const <WidgetState>{}) ??
                                      colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : Text(context.tr.createWalletConfirm),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WalletPreviewCard extends StatelessWidget {
  const _WalletPreviewCard({
    required this.walletName,
    required this.statusLabel,
    required this.selectedColor,
  });

  final String walletName;
  final String statusLabel;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: selectedColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  walletName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  statusLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'USD 0',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'SYP 0',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class WalletSheetColorOption {
  const WalletSheetColorOption({required this.color, required this.foreground});

  final Color color;
  final Color foreground;
}

const List<WalletSheetColorOption>
_walletSheetColors = <WalletSheetColorOption>[
  WalletSheetColorOption(color: Color(0xFF0E5A8A), foreground: Colors.white),
  WalletSheetColorOption(color: Color(0xFF1E8E5A), foreground: Colors.white),
  WalletSheetColorOption(color: Color(0xFF7A52C7), foreground: Colors.white),
  WalletSheetColorOption(color: Color(0xFFCC7A00), foreground: Colors.white),
  WalletSheetColorOption(color: Color(0xFFBE3A34), foreground: Colors.white),
  WalletSheetColorOption(color: Color(0xFF0097A7), foreground: Colors.white),
];
