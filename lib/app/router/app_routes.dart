sealed class AppRoutes {
  static const dashboard = 'dashboard';
  static const auth = 'auth';
  static const splash = 'splash';
  static const login = 'login';
  static const register = 'register';
  static const otpVerification = 'otpVerification';
  static const forgotPassword = 'forgotPassword';
  static const wallets = 'wallets';
  static const walletDetails = 'walletDetails';
  static const walletEdit = 'walletEdit';
  static const transactions = 'transactions';
  static const transferCreate = 'transferCreate';
  static const transactionDetails = 'transactionDetails';
  static const debts = 'debts';
  static const debtDetails = 'debtDetails';
  static const debtRepayment = 'debtRepayment';
  static const debtSettlement = 'debtSettlement';
  static const debtSettlementSuccess = 'debtSettlementSuccess';
  static const contacts = 'contacts';
  static const contactDetails = 'contactDetails';
  static const qr = 'qr';
  static const qrScanner = 'qrScanner';
  static const qrPreview = 'qrPreview';
  static const userTransferCreate = 'userTransferCreate';
  static const userTransferConfirmation = 'userTransferConfirmation';
  static const userTransferSuccess = 'userTransferSuccess';
  static const syncDashboard = 'syncDashboard';
  static const notificationCenter = 'notificationCenter';
  static const auditHistory = 'auditHistory';
  static const attachmentViewer = 'attachmentViewer';
  static const profile = 'profile';
  static const profileAccount = 'profileAccount';
  static const security = 'security';

  static const dashboardPath = '/';
  static const authPath = '/auth';
  static const splashPath = '/auth/splash';
  static const loginPath = '/auth/login';
  static const registerPath = '/auth/register';
  static const otpVerificationPath = '/auth/otp';
  static const forgotPasswordPath = '/auth/forgot-password';
  static const walletsPath = '/wallets';
  static const transactionsPath = '/transactions';
  static const transferCreatePath = '/transactions/transfer';
  static const debtsPath = '/debts';
  static const contactsPath = '/contacts';
  static const qrPath = '/qr';
  static const qrScannerPath = '/qr/scan';
  static const qrPreviewPath = '/qr/preview';
  static const userTransferCreatePath = '/transfers/create';
  static const userTransferConfirmationPath = '/transfers/confirm';
  static const userTransferSuccessPath = '/transfers/success';
  static const syncDashboardPath = '/developer/sync';
  static const notificationCenterPath = '/notifications';
  static const auditHistoryPath = '/developer/audit';
  static const attachmentViewerPath = '/attachments/viewer';
  static const profilePath = '/profile';
  static const profileAccountPath = '/profile/account';
  static const securityPath = '/profile/security';

  static String walletDetailsLocation(String walletId) => '/wallets/$walletId';
  static String walletEditLocation(String walletId) =>
      '/wallets/$walletId/edit';
  static String transactionDetailsLocation(String transactionId) =>
      '/transactions/$transactionId';
  static String debtDetailsLocation(String debtId) => '/debts/$debtId';
  static String debtRepaymentLocation(String debtId) =>
      '/debts/$debtId/repayment';
  static String debtSettlementLocation(String debtId) =>
      '/debts/$debtId/settlement';
  static String debtSettlementSuccessLocation(String debtId) =>
      '/debts/$debtId/settlement-success';
  static String contactDetailsLocation(String contactId) =>
      '/contacts/$contactId';
}
