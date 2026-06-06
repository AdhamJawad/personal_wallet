sealed class AppRoutes {
  static const dashboard = 'dashboard';
  static const auth = 'auth';
  static const splash = 'splash';
  static const login = 'login';
  static const register = 'register';
  static const otpVerification = 'otpVerification';
  static const forgotPassword = 'forgotPassword';
  static const wallets = 'wallets';
  static const walletCreate = 'walletCreate';
  static const walletDetails = 'walletDetails';
  static const walletEdit = 'walletEdit';
  static const transactions = 'transactions';
  static const debts = 'debts';
  static const contacts = 'contacts';
  static const qr = 'qr';

  static const dashboardPath = '/';
  static const authPath = '/auth';
  static const splashPath = '/auth/splash';
  static const loginPath = '/auth/login';
  static const registerPath = '/auth/register';
  static const otpVerificationPath = '/auth/otp';
  static const forgotPasswordPath = '/auth/forgot-password';
  static const walletsPath = '/wallets';
  static const walletCreatePath = '/wallets/create';
  static const transactionsPath = '/transactions';
  static const debtsPath = '/debts';
  static const contactsPath = '/contacts';
  static const qrPath = '/qr';

  static String walletDetailsLocation(String walletId) => '/wallets/$walletId';
  static String walletEditLocation(String walletId) =>
      '/wallets/$walletId/edit';
}
