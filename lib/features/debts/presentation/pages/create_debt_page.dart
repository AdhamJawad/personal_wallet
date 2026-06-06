import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../contacts/presentation/providers/contact_providers.dart';
import '../providers/debt_providers.dart';

class CreateDebtPage extends ConsumerStatefulWidget {
  const CreateDebtPage({super.key});

  @override
  ConsumerState<CreateDebtPage> createState() => _CreateDebtPageState();
}

class _CreateDebtPageState extends ConsumerState<CreateDebtPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _contactId;
  Currency _currency = Currency.usd;
  bool _isOwedToMe = true;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _contactId == null) {
      return;
    }

    final bool success = await ref
        .read(debtControllerProvider.notifier)
        .createDebt(
          contactId: _contactId!,
          isOwedToMe: _isOwedToMe,
          currencyCode: _currency.name,
          amount: _amountController.text.trim(),
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
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
          ref.read(debtControllerProvider).errorMessage ??
              'Failed to create debt.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final debtState = ref.watch(debtControllerProvider);
    final contacts = ref.watch(contactControllerProvider).contacts;

    return PwScaffold(
      title: 'Create Debt',
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: PwSectionCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SegmentedButton<bool>(
                      segments: const <ButtonSegment<bool>>[
                        ButtonSegment<bool>(
                          value: true,
                          label: Text('Owed To Me'),
                        ),
                        ButtonSegment<bool>(value: false, label: Text('I Owe')),
                      ],
                      selected: <bool>{_isOwedToMe},
                      onSelectionChanged: (Set<bool> selection) {
                        setState(() => _isOwedToMe = selection.first);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<String>(
                      initialValue: _contactId,
                      decoration: const InputDecoration(labelText: 'Contact'),
                      items: contacts
                          .map(
                            (contact) => DropdownMenuItem(
                              value: contact.id,
                              child: Text(contact.name),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (String? value) {
                        setState(() => _contactId = value);
                      },
                      validator: (String? value) =>
                          value == null ? 'Contact is required.' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<Currency>(
                      initialValue: _currency,
                      decoration: const InputDecoration(labelText: 'Currency'),
                      items: Currency.values
                          .map(
                            (Currency currency) => DropdownMenuItem(
                              value: currency,
                              child: Text(currency.name.toUpperCase()),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (Currency? value) {
                        if (value != null) {
                          setState(() => _currency = value);
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PwTextField(
                      controller: _amountController,
                      label: 'Amount',
                      keyboardType: TextInputType.number,
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Amount is required.';
                        }
                        final num? parsed = num.tryParse(value.trim());
                        if (parsed == null || parsed <= 0) {
                          return 'Enter a valid amount.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Note'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    PwButton.primary(
                      label: 'Save debt',
                      isLoading: debtState.isLoading,
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
