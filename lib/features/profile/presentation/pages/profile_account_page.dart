import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class ProfileAccountPage extends ConsumerStatefulWidget {
  const ProfileAccountPage({super.key});

  @override
  ConsumerState<ProfileAccountPage> createState() => _ProfileAccountPageState();
}

class _ProfileAccountPageState extends ConsumerState<ProfileAccountPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _userIdController;
  String? _profileImageUri;
  bool _didInitialize = false;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _userIdController = TextEditingController();
    _syncFromSession();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  void _syncFromSession() {
    if (_didInitialize) {
      return;
    }
    final user = ref.read(authControllerProvider).session?.user;
    if (user == null) {
      return;
    }
    _nameController.text = user.displayName;
    _emailController.text = user.emailAddress ?? '';
    _phoneController.text = user.phoneNumber;
    _userIdController.text = user.id;
    _profileImageUri = user.profileImageUri;
    _didInitialize = true;
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_isPickingImage) {
      return;
    }

    setState(() => _isPickingImage = true);
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 88,
      );
      if (!mounted || file == null) {
        return;
      }
      setState(() => _profileImageUri = file.path);
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  Future<void> _showPhotoActions() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: Text(context.tr.takePhoto),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: Text(context.tr.chooseFromGallery),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if ((_profileImageUri ?? '').trim().isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.delete_outline_rounded),
                    title: Text(context.tr.removeProfilePhoto),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() => _profileImageUri = null);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final result = await ref
        .read(authControllerProvider.notifier)
        .updateProfile(
          displayName: _nameController.text,
          emailAddress: _emailController.text,
          profileImageUri: _profileImageUri,
        );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message)));

    if (result.isSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && GoRouter.of(context).canPop()) {
          context.pop();
        }
      });
    }
  }

  String? _validateName(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return context.tr.fullNameRequired;
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final String normalized = (value ?? '').trim();
    if (normalized.isEmpty) {
      return null;
    }
    final RegExp emailPattern = RegExp(
      r'^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$',
      caseSensitive: false,
    );
    if (!emailPattern.hasMatch(normalized)) {
      return context.tr.invalidEmailAddress;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.session?.user;

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.accountInformation)),
      body: user == null
          ? const SizedBox.shrink()
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              behavior: HitTestBehavior.translucent,
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.xxl + MediaQuery.paddingOf(context).bottom,
                ),
                children: <Widget>[
                  _EditableProfileHeader(
                    name: _nameController.text.trim().isEmpty
                        ? context.tr.notAdded
                        : _nameController.text.trim(),
                    email: _emailController.text.trim(),
                    profileImageUri: _profileImageUri,
                    onTapPhoto: _showPhotoActions,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            PwTextField(
                              controller: _nameController,
                              label: context.tr.fullName,
                              textInputAction: TextInputAction.next,
                              validator: _validateName,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            PwTextField(
                              controller: _emailController,
                              label: context.tr.emailAddress,
                              hint: context.tr.optionalField,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: _validateEmail,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            PwTextField(
                              controller: _phoneController,
                              label: context.tr.phoneNumber,
                              readOnly: true,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            PwTextField(
                              controller: _userIdController,
                              label: context.tr.userIdentifier,
                              readOnly: true,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            SizedBox(
                              width: double.infinity,
                              child: PwButton.primary(
                                label: context.tr.saveChanges,
                                isLoading: authState.isBusy,
                                onPressed: _save,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _EditableProfileHeader extends StatelessWidget {
  const _EditableProfileHeader({
    required this.name,
    required this.email,
    required this.profileImageUri,
    required this.onTapPhoto,
  });

  final String name;
  final String email;
  final String? profileImageUri;
  final VoidCallback onTapPhoto;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: <Widget>[
            Stack(
              children: <Widget>[
                _ProfileAvatar(
                  name: name,
                  profileImageUri: profileImageUri,
                  radius: 30,
                ),
                PositionedDirectional(
                  end: 0,
                  bottom: 0,
                  child: Material(
                    color: theme.colorScheme.primary,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onTapPhoto,
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email.trim().isEmpty ? context.tr.notAdded : email.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.name,
    required this.profileImageUri,
    this.radius = 24,
  });

  final String name;
  final String? profileImageUri;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final File? imageFile = _resolvedImageFile(profileImageUri);

    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
      backgroundImage: imageFile == null ? null : FileImage(imageFile),
      child: imageFile != null
          ? null
          : Text(
              _initialsFromName(name),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }
}

File? _resolvedImageFile(String? path) {
  final String normalized = (path ?? '').trim();
  if (normalized.isEmpty) {
    return null;
  }
  final File file = File(normalized);
  if (!file.existsSync()) {
    return null;
  }
  return file;
}

String _initialsFromName(String value) {
  final List<String> parts = value
      .trim()
      .split(RegExp(r'\s+'))
      .where((String item) => item.isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty || value == '--') {
    return '--';
  }
  if (parts.length == 1) {
    return parts.first
        .substring(0, parts.first.length >= 2 ? 2 : 1)
        .toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}
