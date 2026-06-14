import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/feedback/app_feedback.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/wallet_providers.dart';

class EditWalletPage extends ConsumerStatefulWidget {
  const EditWalletPage({required this.walletId, super.key});

  final String walletId;

  @override
  ConsumerState<EditWalletPage> createState() => _EditWalletPageState();
}

class _EditWalletPageState extends ConsumerState<EditWalletPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() async {
      await ref
          .read(walletControllerProvider.notifier)
          .loadWallet(widget.walletId);
      final wallet = ref.read(selectedWalletProvider);
      if (wallet != null) {
        _nameController.text = wallet.wallet.name;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _archive() async {
    final bool success = await ref
        .read(walletControllerProvider.notifier)
        .archiveSelectedWallet();

    if (!mounted) {
      return;
    }

    if (success) {
      showAppSuccessSnackBar(context, context.tr.walletArchivedSuccessfully);
      context.pop();
      return;
    }

    final errorMessage = ref.read(walletControllerProvider).errorMessage;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage ?? context.tr.failedArchiveWallet)),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final bool success = await ref
        .read(walletControllerProvider.notifier)
        .renameSelectedWallet(_nameController.text);

    if (!mounted) {
      return;
    }

    if (success) {
      showAppSuccessSnackBar(context, context.tr.walletRenamedSuccessfully);
      context.pop();
      return;
    }

    final errorMessage = ref.read(walletControllerProvider).errorMessage;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage ?? context.tr.failedSaveWallet)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final walletOverview = walletState.selectedWallet;

    return PwScaffold(
      title: context.tr.editWallet,
      body: walletState.isLoading && walletOverview == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: PwSectionCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          PwTextField(
                            controller: _nameController,
                            label: context.tr.walletNameLabel,
                            validator: (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return context.tr.walletNameRequired;
                              }
                              if (value.trim().length < 3) {
                                return context.tr.walletNameTooShort;
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => _save(),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          PwButton.primary(
                            label: context.tr.saveChanges,
                            isLoading: walletState.isLoading,
                            onPressed: _save,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          PwButton.secondary(
                            label: walletOverview?.wallet.isArchived == true
                                ? context.tr.walletArchivedLabel
                                : context.tr.archiveWallet,
                            onPressed: walletOverview?.wallet.isArchived == true
                                ? null
                                : _archive,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
