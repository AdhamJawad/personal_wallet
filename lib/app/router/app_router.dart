import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/enums/auth_status.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/contacts/presentation/pages/contacts_placeholder_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_placeholder_page.dart';
import '../../features/debts/presentation/pages/debts_placeholder_page.dart';
import '../../features/qr/presentation/pages/qr_placeholder_page.dart';
import '../../features/transactions/presentation/pages/transactions_placeholder_page.dart';
import '../../features/wallets/presentation/pages/create_wallet_page.dart';
import '../../features/wallets/presentation/pages/edit_wallet_page.dart';
import '../../features/wallets/presentation/pages/wallet_details_page.dart';
import '../../features/wallets/presentation/pages/wallets_page.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((Ref ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: AppRoutes.splashPath,
    redirect: (BuildContext context, GoRouterState state) {
      final String location = state.matchedLocation;
      final bool isSplash = location == AppRoutes.splashPath;
      final bool isAuthRoute =
          location == AppRoutes.authPath ||
          location == AppRoutes.loginPath ||
          location == AppRoutes.registerPath ||
          location == AppRoutes.otpVerificationPath ||
          location == AppRoutes.forgotPasswordPath;

      if (authState.status == AuthStatus.initializing) {
        return isSplash ? null : AppRoutes.splashPath;
      }

      if (authState.status == AuthStatus.authenticated) {
        if (isSplash || isAuthRoute) {
          return AppRoutes.dashboardPath;
        }
        return null;
      }

      if (authState.status == AuthStatus.awaitingOtp) {
        return location == AppRoutes.otpVerificationPath
            ? null
            : AppRoutes.otpVerificationPath;
      }

      if (location == AppRoutes.otpVerificationPath) {
        return AppRoutes.loginPath;
      }

      if (isSplash) {
        return AppRoutes.loginPath;
      }

      if (isAuthRoute) {
        return null;
      }

      return AppRoutes.loginPath;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.dashboardPath,
        name: AppRoutes.dashboard,
        builder: (BuildContext context, GoRouterState state) {
          return const DashboardPlaceholderPage();
        },
      ),
      GoRoute(
        path: AppRoutes.authPath,
        name: AppRoutes.auth,
        redirect: (_, _) => AppRoutes.loginPath,
      ),
      GoRoute(
        path: AppRoutes.splashPath,
        name: AppRoutes.splash,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: AppRoutes.registerPath,
        name: AppRoutes.register,
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterPage();
        },
      ),
      GoRoute(
        path: AppRoutes.otpVerificationPath,
        name: AppRoutes.otpVerification,
        builder: (BuildContext context, GoRouterState state) {
          return const OtpVerificationPage();
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPasswordPath,
        name: AppRoutes.forgotPassword,
        builder: (BuildContext context, GoRouterState state) {
          return const ForgotPasswordPage();
        },
      ),
      GoRoute(
        path: AppRoutes.walletsPath,
        name: AppRoutes.wallets,
        builder: (BuildContext context, GoRouterState state) {
          return const WalletsPage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'create',
            name: AppRoutes.walletCreate,
            builder: (BuildContext context, GoRouterState state) {
              return const CreateWalletPage();
            },
          ),
          GoRoute(
            path: ':walletId',
            name: AppRoutes.walletDetails,
            builder: (BuildContext context, GoRouterState state) {
              return WalletDetailsPage(
                walletId: state.pathParameters['walletId']!,
              );
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'edit',
                name: AppRoutes.walletEdit,
                builder: (BuildContext context, GoRouterState state) {
                  return EditWalletPage(
                    walletId: state.pathParameters['walletId']!,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.transactionsPath,
        name: AppRoutes.transactions,
        builder: (BuildContext context, GoRouterState state) {
          return const TransactionsPlaceholderPage();
        },
      ),
      GoRoute(
        path: AppRoutes.debtsPath,
        name: AppRoutes.debts,
        builder: (BuildContext context, GoRouterState state) {
          return const DebtsPlaceholderPage();
        },
      ),
      GoRoute(
        path: AppRoutes.contactsPath,
        name: AppRoutes.contacts,
        builder: (BuildContext context, GoRouterState state) {
          return const ContactsPlaceholderPage();
        },
      ),
      GoRoute(
        path: AppRoutes.qrPath,
        name: AppRoutes.qr,
        builder: (BuildContext context, GoRouterState state) {
          return const QrPlaceholderPage();
        },
      ),
    ],
  );
});
