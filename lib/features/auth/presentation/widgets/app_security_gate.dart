import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/enums/app_lock_status.dart';
import '../../domain/enums/auth_status.dart';
import '../pages/biometric_setup_page.dart';
import '../pages/pin_setup_page.dart';
import '../pages/unlock_page.dart';
import '../providers/auth_providers.dart';

class AppSecurityGate extends ConsumerStatefulWidget {
  const AppSecurityGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AppSecurityGate> createState() => _AppSecurityGateState();
}

class _AppSecurityGateState extends ConsumerState<AppSecurityGate>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = ref.read(authControllerProvider.notifier);
    if (state == AppLifecycleState.paused) {
      controller.handleAppBackgrounded();
    } else if (state == AppLifecycleState.resumed) {
      controller.handleAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    if (authState.status != AuthStatus.authenticated) {
      return widget.child;
    }

    final Widget? securityOverlay = switch (authState.appLockStatus) {
      AppLockStatus.setupRequired => const PinSetupPage(),
      AppLockStatus.biometricSetupRequired => const BiometricSetupPage(),
      AppLockStatus.locked => const UnlockPage(),
      AppLockStatus.unlocked => null,
    };

    if (securityOverlay == null) {
      return widget.child;
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        AbsorbPointer(child: widget.child),
        Positioned.fill(
          child: Navigator(
            key: ValueKey<AppLockStatus>(authState.appLockStatus),
            onDidRemovePage: (Page<dynamic> page) {},
            pages: <Page<void>>[
              MaterialPage<void>(
                key: ValueKey<AppLockStatus>(authState.appLockStatus),
                child: securityOverlay,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
