import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/attachments/presentation/pages/attachment_picker_page.dart';
import '../../features/attachments/presentation/pages/attachment_viewer_page.dart';
import '../../features/auth/domain/enums/auth_status.dart';
import '../../features/audit/presentation/pages/audit_history_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verification_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/contacts/presentation/pages/contacts_page.dart';
import '../../features/contacts/presentation/pages/contact_details_page.dart';
import '../../features/contacts/presentation/pages/create_external_contact_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_placeholder_page.dart';
import '../../features/debts/presentation/pages/create_debt_page.dart';
import '../../features/debts/presentation/pages/create_debt_repayment_page.dart';
import '../../features/debts/presentation/pages/debt_details_page.dart';
import '../../features/debts/presentation/pages/debts_page.dart';
import '../../features/notifications/presentation/pages/notification_center_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/qr/presentation/pages/my_qr_page.dart';
import '../../features/qr/presentation/pages/qr_scanner_page.dart';
import '../../features/qr/presentation/pages/user_preview_page.dart';
import '../../features/sync/presentation/pages/sync_dashboard_page.dart';
import '../../features/transfers/domain/models/transfer_draft.dart';
import '../../features/transfers/presentation/pages/debt_settlement_page.dart';
import '../../features/transfers/presentation/pages/debt_settlement_success_page.dart';
import '../../features/transfers/presentation/pages/transfer_confirmation_page.dart';
import '../../features/transfers/presentation/pages/transfer_page.dart';
import '../../features/transfers/presentation/pages/transfer_success_page.dart';
import '../../features/transactions/presentation/pages/create_transfer_page.dart';
import '../../features/transactions/presentation/pages/transaction_details_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../features/wallets/presentation/pages/create_wallet_page.dart';
import '../../features/wallets/presentation/pages/edit_wallet_page.dart';
import '../../features/wallets/presentation/pages/wallet_details_page.dart';
import '../../features/wallets/presentation/pages/wallets_page.dart';
import '../presentation/widgets/app_shell_page.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _homeBranchNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _walletsBranchNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _debtsBranchNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _profileBranchNavigatorKey =
    GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((Ref ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
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
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) {
              return AppShellPage(navigationShell: navigationShell);
            },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _homeBranchNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.dashboardPath,
                name: AppRoutes.dashboard,
                builder: (BuildContext context, GoRouterState state) {
                  return const DashboardPlaceholderPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _walletsBranchNavigatorKey,
            routes: <RouteBase>[
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
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (BuildContext context, GoRouterState state) {
                      return const CreateWalletPage();
                    },
                  ),
                  GoRoute(
                    path: ':walletId',
                    name: AppRoutes.walletDetails,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (BuildContext context, GoRouterState state) {
                      return WalletDetailsPage(
                        walletId: state.pathParameters['walletId']!,
                      );
                    },
                    routes: <RouteBase>[
                      GoRoute(
                        path: 'edit',
                        name: AppRoutes.walletEdit,
                        parentNavigatorKey: _rootNavigatorKey,
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
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _debtsBranchNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.debtsPath,
                name: AppRoutes.debts,
                builder: (BuildContext context, GoRouterState state) {
                  return const DebtsPage();
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: 'create',
                    name: AppRoutes.debtCreate,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (BuildContext context, GoRouterState state) {
                      return CreateDebtPage(
                        initialContactId:
                            state.uri.queryParameters['contactId'],
                      );
                    },
                  ),
                  GoRoute(
                    path: ':debtId',
                    name: AppRoutes.debtDetails,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (BuildContext context, GoRouterState state) {
                      return DebtDetailsPage(
                        debtId: state.pathParameters['debtId']!,
                      );
                    },
                    routes: <RouteBase>[
                      GoRoute(
                        path: 'repayment',
                        name: AppRoutes.debtRepayment,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (BuildContext context, GoRouterState state) {
                          return CreateDebtRepaymentPage(
                            debtId: state.pathParameters['debtId']!,
                          );
                        },
                      ),
                      GoRoute(
                        path: 'settlement',
                        name: AppRoutes.debtSettlement,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (BuildContext context, GoRouterState state) {
                          return DebtSettlementPage(
                            debtId: state.pathParameters['debtId']!,
                          );
                        },
                      ),
                      GoRoute(
                        path: 'settlement-success',
                        name: AppRoutes.debtSettlementSuccess,
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (BuildContext context, GoRouterState state) {
                          return DebtSettlementSuccessPage(
                            debtId: state.pathParameters['debtId']!,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileBranchNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.profilePath,
                name: AppRoutes.profile,
                builder: (BuildContext context, GoRouterState state) {
                  return const ProfilePage();
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
          return const TransactionsPage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'transfer',
            name: AppRoutes.transferCreate,
            builder: (BuildContext context, GoRouterState state) {
              return const CreateTransferPage();
            },
          ),
          GoRoute(
            path: ':transactionId',
            name: AppRoutes.transactionDetails,
            builder: (BuildContext context, GoRouterState state) {
              return TransactionDetailsPage(
                transactionId: state.pathParameters['transactionId']!,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.contactsPath,
        name: AppRoutes.contacts,
        builder: (BuildContext context, GoRouterState state) {
          return const ContactsPage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'create',
            name: AppRoutes.contactCreate,
            builder: (BuildContext context, GoRouterState state) {
              return const CreateExternalContactPage();
            },
          ),
          GoRoute(
            path: ':contactId',
            name: AppRoutes.contactDetails,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (BuildContext context, GoRouterState state) {
              return ContactDetailsPage(
                contactId: state.pathParameters['contactId']!,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.qrPath,
        name: AppRoutes.qr,
        builder: (BuildContext context, GoRouterState state) {
          return const MyQrPage();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'scan',
            name: AppRoutes.qrScanner,
            builder: (BuildContext context, GoRouterState state) {
              return const QrScannerPage();
            },
          ),
          GoRoute(
            path: 'preview',
            name: AppRoutes.qrPreview,
            builder: (BuildContext context, GoRouterState state) {
              return const UserPreviewPage();
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.userTransferCreatePath,
        name: AppRoutes.userTransferCreate,
        builder: (BuildContext context, GoRouterState state) {
          return TransferPage(
            preselectedRecipientUserId:
                state.uri.queryParameters['recipientUserId'],
            preselectedRecipientName:
                state.uri.queryParameters['recipientName'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.userTransferConfirmationPath,
        name: AppRoutes.userTransferConfirmation,
        builder: (BuildContext context, GoRouterState state) {
          return TransferConfirmationPage(draft: state.extra as TransferDraft?);
        },
      ),
      GoRoute(
        path: AppRoutes.userTransferSuccessPath,
        name: AppRoutes.userTransferSuccess,
        builder: (BuildContext context, GoRouterState state) {
          return const TransferSuccessPage();
        },
      ),
      GoRoute(
        path: AppRoutes.notificationCenterPath,
        name: AppRoutes.notificationCenter,
        builder: (BuildContext context, GoRouterState state) {
          return const NotificationCenterPage();
        },
      ),
      GoRoute(
        path: AppRoutes.syncDashboardPath,
        name: AppRoutes.syncDashboard,
        builder: (BuildContext context, GoRouterState state) {
          return const SyncDashboardPage();
        },
      ),
      GoRoute(
        path: AppRoutes.auditHistoryPath,
        name: AppRoutes.auditHistory,
        builder: (BuildContext context, GoRouterState state) {
          return const AuditHistoryPage();
        },
      ),
      GoRoute(
        path: AppRoutes.attachmentViewerPath,
        name: AppRoutes.attachmentViewer,
        builder: (BuildContext context, GoRouterState state) {
          return AttachmentViewerPage(
            entityType:
                state.uri.queryParameters['entityType'] ?? 'transaction',
            entityId: state.uri.queryParameters['entityId'] ?? '',
            label: state.uri.queryParameters['label'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.attachmentPickerPath,
        name: AppRoutes.attachmentPicker,
        builder: (BuildContext context, GoRouterState state) {
          return AttachmentPickerPage(
            entityType:
                state.uri.queryParameters['entityType'] ?? 'transaction',
            entityId: state.uri.queryParameters['entityId'] ?? '',
            label: state.uri.queryParameters['label'],
          );
        },
      ),
    ],
  );
});
