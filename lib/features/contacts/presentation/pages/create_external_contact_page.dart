import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/contact_providers.dart';

class CreateExternalContactPage extends ConsumerStatefulWidget {
  const CreateExternalContactPage({super.key});

  @override
  ConsumerState<CreateExternalContactPage> createState() =>
      _CreateExternalContactPageState();
}

class _CreateExternalContactPageState
    extends ConsumerState<CreateExternalContactPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final bool success = await ref
        .read(contactControllerProvider.notifier)
        .createExternalContact(
          name: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          note: _noteController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.of(context).pop();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ref.read(contactControllerProvider).errorMessage ??
              'Failed to create contact.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contactState = ref.watch(contactControllerProvider);

    return PwScaffold(
      title: 'Create External Contact',
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
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
                      label: 'Name',
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PwTextField(
                      controller: _phoneController,
                      label: 'Phone number',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Note'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    PwButton.primary(
                      label: 'Save contact',
                      isLoading: contactState.isLoading,
                      onPressed: _submit,
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
