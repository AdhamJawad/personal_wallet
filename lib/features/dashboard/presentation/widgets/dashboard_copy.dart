import 'package:flutter/material.dart';

final class DashboardCopy {
  DashboardCopy._(this.locale);

  final Locale locale;

  static DashboardCopy of(BuildContext context) {
    return DashboardCopy._(Localizations.localeOf(context));
  }

  bool get isArabic => locale.languageCode.toLowerCase().startsWith('ar');

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  String get appName => isArabic
      ? '\u0627\u0644\u0645\u062d\u0641\u0638\u0629'
      : 'Personal Wallet';
  String get home =>
      isArabic ? '\u0627\u0644\u0631\u0626\u064a\u0633\u064a\u0629' : 'Home';
  String get wallets =>
      isArabic ? '\u0627\u0644\u0645\u062d\u0627\u0641\u0638' : 'Wallets';
  String get activity =>
      isArabic ? '\u0627\u0644\u062d\u0631\u0643\u0629' : 'Activity';
  String get action => isArabic ? '\u0625\u062c\u0631\u0627\u0621' : 'Action';
  String get debts =>
      isArabic ? '\u0627\u0644\u062f\u064a\u0648\u0646' : 'Debts';
  String get profile => isArabic ? '\u0627\u0644\u0645\u0644\u0641' : 'Profile';
  String get quickActionsTitle => isArabic
      ? '\u0625\u062c\u0631\u0627\u0621 \u0633\u0631\u064a\u0639'
      : 'Quick Actions';
  String get goodMorning => isArabic
      ? '\u0635\u0628\u0627\u062d \u0627\u0644\u062e\u064a\u0631'
      : 'Good Morning';
  String get goodAfternoon => isArabic
      ? '\u0645\u0633\u0627\u0621 \u0627\u0644\u062e\u064a\u0631'
      : 'Good Afternoon';
  String get goodEvening => isArabic
      ? '\u0645\u0633\u0627\u0621 \u0627\u0644\u062e\u064a\u0631'
      : 'Good Evening';
  String get personalAccount => isArabic
      ? '\u062d\u0633\u0627\u0628 \u0634\u062e\u0635\u064a'
      : 'Personal account';
  String get totalAssets => isArabic
      ? '\u0625\u062c\u0645\u0627\u0644\u064a \u0627\u0644\u0623\u0635\u0648\u0644'
      : 'Total Assets';
  String get quickActions => isArabic
      ? '\u0625\u062c\u0631\u0627\u0621 \u0633\u0631\u064a\u0639'
      : 'Quick Actions';
  String get myWallets =>
      isArabic ? '\u0645\u062d\u0627\u0641\u0638\u064a' : 'My Wallets';
  String get recentActivity => isArabic
      ? '\u0622\u062e\u0631 \u0627\u0644\u0639\u0645\u0644\u064a\u0627\u062a'
      : 'Recent Activity';
  String get debtOverview => isArabic
      ? '\u0646\u0638\u0631\u0629 \u0639\u0627\u0645\u0629 \u0639\u0644\u0649 \u0627\u0644\u062f\u064a\u0648\u0646'
      : 'Debt Overview';
  String get seeAll =>
      isArabic ? '\u0639\u0631\u0636 \u0627\u0644\u0643\u0644' : 'See All';
  String get hideBalances => isArabic
      ? '\u0625\u062e\u0641\u0627\u0621 \u0627\u0644\u0623\u0631\u0635\u062f\u0629'
      : 'Hide balances';
  String get showBalances => isArabic
      ? '\u0625\u0638\u0647\u0627\u0631 \u0627\u0644\u0623\u0631\u0635\u062f\u0629'
      : 'Show balances';
  String get updatedNow => isArabic
      ? '\u062a\u0645 \u0627\u0644\u062a\u062d\u062f\u064a\u062b \u0627\u0644\u0622\u0646'
      : 'Updated just now';
  String get activeWalletsHint => isArabic
      ? '\u0625\u062c\u0645\u0627\u0644\u064a \u0627\u0644\u0623\u0635\u0648\u0644 \u0639\u0628\u0631 \u0627\u0644\u0645\u062d\u0627\u0641\u0638 \u0627\u0644\u0646\u0634\u0637\u0629'
      : 'Combined value across active wallets';
  String get deposit => isArabic ? '\u0625\u064a\u062f\u0627\u0639' : 'Deposit';
  String get withdraw => isArabic ? '\u0633\u062d\u0628' : 'Withdraw';
  String get transfer =>
      isArabic ? '\u062a\u062d\u0648\u064a\u0644' : 'Transfer';
  String get exchange => isArabic ? '\u0635\u0631\u0641' : 'Exchange';
  String get debt => isArabic ? '\u062f\u064a\u0646' : 'Debt';
  String get active => isArabic ? '\u0646\u0634\u0637\u0629' : 'Active';
  String get archived =>
      isArabic ? '\u0645\u0624\u0631\u0634\u0641\u0629' : 'Archived';
  String get usdShort => 'USD';
  String get sypShort => 'SYP';
  String get noWalletsTitle => isArabic
      ? '\u0644\u0627 \u062a\u0648\u062c\u062f \u0645\u062d\u0627\u0641\u0638'
      : 'No Wallets Yet';
  String get noWalletsMessage => isArabic
      ? '\u0623\u0646\u0634\u0626 \u0645\u062d\u0641\u0638\u062a\u0643 \u0627\u0644\u0623\u0648\u0644\u0649 \u0644\u0628\u062f\u0621 \u062a\u062a\u0628\u0639 \u0627\u0644\u0623\u0631\u0635\u062f\u0629 \u0648\u0627\u0644\u062d\u0631\u0643\u0629 \u0627\u0644\u0645\u0627\u0644\u064a\u0629.'
      : 'Create your first wallet to start tracking balances and activity.';
  String get createWallet => isArabic
      ? '\u0625\u0646\u0634\u0627\u0621 \u0645\u062d\u0641\u0638\u0629'
      : 'Create Wallet';
  String get walletsPageSubtitle => isArabic
      ? '\u0646\u0638\u0631\u0629 \u0633\u0631\u064a\u0639\u0629 \u0639\u0644\u0649 \u0627\u0644\u0623\u0631\u0635\u062f\u0629 \u0648\u0627\u0644\u062d\u0631\u0643\u0629 \u0628\u0643\u0644 \u0645\u062d\u0641\u0638\u0629.'
      : 'A compact view of balances and activity across every wallet.';
  String get walletCount => isArabic
      ? '\u0639\u062f\u062f \u0627\u0644\u0645\u062d\u0627\u0641\u0638'
      : 'Wallet Count';
  String get walletSummary => isArabic
      ? '\u0645\u0644\u062e\u0635 \u0627\u0644\u0645\u062d\u0627\u0641\u0638'
      : 'Wallet Summary';
  String get totalWallets => isArabic
      ? '\u0625\u062c\u0645\u0627\u0644\u064a \u0627\u0644\u0645\u062d\u0627\u0641\u0638'
      : 'Total Wallets';
  String get usdTotal =>
      isArabic ? '\u0625\u062c\u0645\u0627\u0644\u064a USD' : 'USD Total';
  String get sypTotal =>
      isArabic ? '\u0625\u062c\u0645\u0627\u0644\u064a SYP' : 'SYP Total';
  String get searchWallets => isArabic
      ? '\u0627\u0628\u062d\u062b \u0639\u0646 \u0645\u062d\u0641\u0638\u0629'
      : 'Search wallets';
  String get searchWalletsHint => isArabic
      ? '\u0627\u0633\u0645 \u0627\u0644\u0645\u062d\u0641\u0638\u0629'
      : 'Wallet name';
  String get sortWallets => isArabic
      ? '\u062a\u0631\u062a\u064a\u0628 \u0627\u0644\u0645\u062d\u0627\u0641\u0638'
      : 'Sort wallets';
  String get allWallets => isArabic
      ? '\u0643\u0644 \u0627\u0644\u0645\u062d\u0627\u0641\u0638'
      : 'All Wallets';
  String get combinedUsd =>
      isArabic ? '\u0625\u062c\u0645\u0627\u0644\u064a USD' : 'Combined USD';
  String get combinedSyp =>
      isArabic ? '\u0625\u062c\u0645\u0627\u0644\u064a SYP' : 'Combined SYP';
  String get currentView => isArabic
      ? '\u0627\u0644\u0639\u0631\u0636 \u0627\u0644\u062d\u0627\u0644\u064a'
      : 'Current view';
  String get walletStatus => isArabic
      ? '\u062d\u0627\u0644\u0629 \u0627\u0644\u0645\u062d\u0641\u0638\u0629'
      : 'Wallet status';
  String get transactionCount => isArabic
      ? '\u0639\u062f\u062f \u0627\u0644\u0639\u0645\u0644\u064a\u0627\u062a'
      : 'Transactions';
  String get lastActivity => isArabic
      ? '\u0622\u062e\u0631 \u062d\u0631\u0643\u0629'
      : 'Last activity';
  String get createdLabel => isArabic
      ? '\u062a\u0627\u0631\u064a\u062e \u0627\u0644\u0625\u0646\u0634\u0627\u0621'
      : 'Created';
  String get updatedLabel => isArabic
      ? '\u0622\u062e\u0631 \u062a\u062d\u062f\u064a\u062b'
      : 'Updated';
  String get noWalletSearchResultsTitle => isArabic
      ? '\u0644\u0627 \u062a\u0648\u062c\u062f \u0646\u062a\u0627\u0626\u062c'
      : 'No Matching Wallets';
  String get noWalletSearchResultsMessage => isArabic
      ? '\u062d\u0627\u0648\u0644 \u0627\u0633\u0645\u0627\u064b \u0622\u062e\u0631 \u0623\u0648 \u0627\u0645\u0633\u062d \u0627\u0644\u0628\u062d\u062b \u0644\u0631\u0624\u064a\u0629 \u0643\u0644 \u0627\u0644\u0645\u062d\u0627\u0641\u0638.'
      : 'Try another name or clear search to see every wallet again.';
  String get clearSearch => isArabic
      ? '\u0645\u0633\u062d \u0627\u0644\u0628\u062d\u062b'
      : 'Clear Search';
  String get noActivityYet => isArabic
      ? '\u0644\u0627 \u062d\u0631\u0643\u0629 \u0628\u0639\u062f'
      : 'No activity yet';
  String get updatedJustNow => isArabic
      ? '\u062a\u0645 \u0627\u0644\u062a\u062d\u062f\u064a\u062b \u0627\u0644\u0622\u0646'
      : 'Updated just now';
  String updatedMinutesAgo(int minutes) => isArabic
      ? '\u062a\u0645 \u0627\u0644\u062a\u062d\u062f\u064a\u062b \u0645\u0646\u0630 $minutes \u062f\u0642\u064a\u0642\u0629'
      : 'Updated $minutes min ago';
  String updatedHoursAgo(int hours) => isArabic
      ? '\u062a\u0645 \u0627\u0644\u062a\u062d\u062f\u064a\u062b \u0645\u0646\u0630 $hours \u0633\u0627\u0639\u0629'
      : 'Updated $hours hours ago';
  String get updatedToday => isArabic
      ? '\u062a\u0645 \u0627\u0644\u062a\u062d\u062f\u064a\u062b \u0627\u0644\u064a\u0648\u0645'
      : 'Updated today';
  String get updatedYesterday => isArabic
      ? '\u062a\u0645 \u0627\u0644\u062a\u062d\u062f\u064a\u062b \u0623\u0645\u0633'
      : 'Updated yesterday';
  String updatedDaysAgo(int days) => isArabic
      ? '\u062a\u0645 \u0627\u0644\u062a\u062d\u062f\u064a\u062b \u0645\u0646\u0630 $days \u0623\u064a\u0627\u0645'
      : 'Updated $days days ago';
  String get newest =>
      isArabic ? '\u0627\u0644\u0623\u062d\u062f\u062b' : 'Newest';
  String get oldest =>
      isArabic ? '\u0627\u0644\u0623\u0642\u062f\u0645' : 'Oldest';
  String get nameAscending =>
      isArabic ? '\u0627\u0644\u0627\u0633\u0645 A-Z' : 'Name A-Z';
  String get nameDescending =>
      isArabic ? '\u0627\u0644\u0627\u0633\u0645 Z-A' : 'Name Z-A';
  String get highestUsd =>
      isArabic ? '\u0623\u0639\u0644\u0649 USD' : 'Highest USD';
  String get highestSyp =>
      isArabic ? '\u0623\u0639\u0644\u0649 SYP' : 'Highest SYP';
  String get noActivityTitle => isArabic
      ? '\u0644\u0627 \u062a\u0648\u062c\u062f \u0639\u0645\u0644\u064a\u0627\u062a \u0628\u0639\u062f'
      : 'No Activity Yet';
  String get noActivityMessage => isArabic
      ? '\u0633\u062a\u0638\u0647\u0631 \u0647\u0646\u0627 \u0622\u062e\u0631 \u0627\u0644\u0625\u064a\u062f\u0627\u0639\u0627\u062a \u0648\u0627\u0644\u062a\u062d\u0648\u064a\u0644\u0627\u062a \u0648\u0627\u0644\u0633\u062d\u0648\u0628\u0627\u062a \u0648\u0639\u0645\u0644\u064a\u0627\u062a \u0627\u0644\u0635\u0631\u0641.'
      : 'New deposits, transfers, withdrawals, and exchanges will appear here.';
  String get noDebtsTitle => isArabic
      ? '\u0644\u0627 \u062a\u0648\u062c\u062f \u062f\u064a\u0648\u0646 \u0628\u0639\u062f'
      : 'No Debts Yet';
  String get noDebtsMessage => isArabic
      ? '\u062a\u0627\u0628\u0639 \u0645\u0627 \u0644\u0643 \u0648\u0645\u0627 \u0639\u0644\u064a\u0643 \u0641\u064a \u0645\u0643\u0627\u0646 \u0648\u0627\u062d\u062f.'
      : 'Track money you owe and money owed to you in one place.';
  String get createDebt => isArabic
      ? '\u0625\u0646\u0634\u0627\u0621 \u062f\u064a\u0646'
      : 'Create Debt';
  String get owedToMe => isArabic
      ? '\u0644\u064a \u0639\u0644\u0649 \u0627\u0644\u0622\u062e\u0631\u064a\u0646'
      : 'Owed To Me';
  String get iOwe => isArabic
      ? '\u0639\u0644\u064a \u0644\u0644\u0622\u062e\u0631\u064a\u0646'
      : 'I Owe';
  String get outstandingDebts => isArabic
      ? '\u0627\u0644\u062f\u064a\u0648\u0646 \u0627\u0644\u0642\u0627\u0626\u0645\u0629'
      : 'Outstanding Debts';
  String get outstandingDebtCaption => isArabic
      ? '\u0633\u062c\u0644\u0627\u062a \u0645\u0641\u062a\u0648\u062d\u0629 \u0628\u0627\u0646\u062a\u0638\u0627\u0631 \u0627\u0644\u0625\u063a\u0644\u0627\u0642'
      : 'Open records pending completion';
  String get walletFallback =>
      isArabic ? '\u0645\u062d\u0641\u0638\u0629' : 'Wallet';
  String get hiddenValue => isArabic ? '\u0645\u062e\u0641\u064a' : 'Hidden';
  String get depositActivity =>
      isArabic ? '\u0625\u064a\u062f\u0627\u0639' : 'Deposit';
  String get withdrawActivity => isArabic ? '\u0633\u062d\u0628' : 'Withdraw';
  String get transferActivity =>
      isArabic ? '\u062a\u062d\u0648\u064a\u0644' : 'Transfer';
  String get exchangeActivity => isArabic ? '\u0635\u0631\u0641' : 'Exchange';
  String get debtSettlementActivity => isArabic
      ? '\u062a\u0633\u0648\u064a\u0629 \u062f\u064a\u0646'
      : 'Debt Settlement';
  String get reversalActivity => isArabic
      ? '\u0639\u0643\u0633 \u0627\u0644\u0639\u0645\u0644\u064a\u0629'
      : 'Reversal';
  String get correctionActivity =>
      isArabic ? '\u062a\u0635\u062d\u064a\u062d' : 'Correction';
  String get profileTitle => isArabic
      ? '\u0627\u0644\u0645\u0644\u0641 \u0648\u0627\u0644\u0625\u0639\u062f\u0627\u062f\u0627\u062a'
      : 'Profile & Settings';
  String get accountSection =>
      isArabic ? '\u0627\u0644\u062d\u0633\u0627\u0628' : 'Account';
  String get securitySection =>
      isArabic ? '\u0627\u0644\u0623\u0645\u0627\u0646' : 'Security';
  String get preferencesSection => isArabic
      ? '\u0627\u0644\u062a\u0641\u0636\u064a\u0644\u0627\u062a'
      : 'Preferences';
  String get applicationSection =>
      isArabic ? '\u0627\u0644\u062a\u0637\u0628\u064a\u0642' : 'Application';
  String get displayName => isArabic
      ? '\u0627\u0633\u0645 \u0627\u0644\u0639\u0631\u0636'
      : 'Display Name';
  String get userIdentifier => isArabic
      ? '\u0645\u0639\u0631\u0641 \u0627\u0644\u0645\u0633\u062a\u062e\u062f\u0645'
      : 'User Identifier';
  String get biometricLogin => isArabic
      ? '\u062a\u0633\u062c\u064a\u0644 \u0627\u0644\u062f\u062e\u0648\u0644 \u0627\u0644\u0628\u064a\u0648\u0645\u062a\u0631\u064a'
      : 'Biometric Login';
  String get faceId => isArabic
      ? '\u0627\u0644\u062a\u0639\u0631\u0641 \u0628\u0627\u0644\u0648\u062c\u0647'
      : 'Face ID';
  String get fingerprint => isArabic
      ? '\u0628\u0635\u0645\u0629 \u0627\u0644\u0625\u0635\u0628\u0639'
      : 'Fingerprint';
  String get notAvailable => isArabic
      ? '\u063a\u064a\u0631 \u0645\u062a\u0627\u062d'
      : 'Not available';
  String get available => isArabic ? '\u0645\u062a\u0627\u062d' : 'Available';
  String get changePassword => isArabic
      ? '\u062a\u063a\u064a\u064a\u0631 \u0643\u0644\u0645\u0629 \u0627\u0644\u0645\u0631\u0648\u0631'
      : 'Change Password';
  String get comingSoon =>
      isArabic ? '\u0642\u0631\u064a\u0628\u0627\u064b' : 'Coming soon';
  String get language =>
      isArabic ? '\u0627\u0644\u0644\u063a\u0629' : 'Language';
  String get theme =>
      isArabic ? '\u0627\u0644\u0645\u0638\u0647\u0631' : 'Theme';
  String get english => isArabic
      ? '\u0627\u0644\u0625\u0646\u062c\u0644\u064a\u0632\u064a\u0629'
      : 'English';
  String get arabic =>
      isArabic ? '\u0627\u0644\u0639\u0631\u0628\u064a\u0629' : 'Arabic';
  String get light => isArabic ? '\u0641\u0627\u062a\u062d' : 'Light';
  String get dark => isArabic ? '\u062f\u0627\u0643\u0646' : 'Dark';
  String get system =>
      isArabic ? '\u062a\u0644\u0642\u0627\u0626\u064a' : 'System';
  String get version =>
      isArabic ? '\u0627\u0644\u0625\u0635\u062f\u0627\u0631' : 'Version';
  String get logout => isArabic
      ? '\u062a\u0633\u062c\u064a\u0644 \u0627\u0644\u062e\u0631\u0648\u062c'
      : 'Logout';
  String get logoutMessage => isArabic
      ? '\u062a\u0645 \u062a\u0633\u062c\u064a\u0644 \u0627\u0644\u062e\u0631\u0648\u062c.'
      : 'You have been logged out.';
  String get openActions => isArabic
      ? '\u0641\u062a\u062d \u0627\u0644\u0625\u062c\u0631\u0627\u0621\u0627\u062a'
      : 'Open actions';
  String get actionsSheetTitle => isArabic
      ? '\u0627\u062e\u062a\u0631 \u0625\u062c\u0631\u0627\u0621\u064b'
      : 'Choose an action';
  String get actionsSheetSubtitle => isArabic
      ? '\u0627\u0644\u0648\u0635\u0648\u0644 \u0627\u0644\u0633\u0631\u064a\u0639 \u0644\u0623\u0647\u0645 \u0627\u0644\u0639\u0645\u0644\u064a\u0627\u062a \u0627\u0644\u0645\u0627\u0644\u064a\u0629.'
      : 'Quick access to primary financial actions.';
  String get homeDescription => isArabic
      ? '\u0646\u0638\u0631\u0629 \u0639\u0627\u0645\u0629 \u0639\u0644\u0649 \u0627\u0644\u0623\u0631\u0635\u062f\u0629'
      : 'Overview of balances';
  String get walletsDescription => isArabic
      ? '\u0625\u062f\u0627\u0631\u0629 \u0627\u0644\u0645\u062d\u0627\u0641\u0638'
      : 'Manage wallets';
  String get activityDescription => isArabic
      ? '\u0645\u062a\u0627\u0628\u0639\u0629 \u0627\u0644\u0639\u0645\u0644\u064a\u0627\u062a'
      : 'Track transactions';
  String get debtsDescription => isArabic
      ? '\u0645\u062a\u0627\u0628\u0639\u0629 \u0627\u0644\u062f\u064a\u0648\u0646'
      : 'Track debts';
  String get profileDescription => isArabic
      ? '\u0627\u0644\u0644\u063a\u0629 \u0648\u0627\u0644\u0645\u0638\u0647\u0631 \u0648\u0627\u0644\u0623\u0645\u0627\u0646'
      : 'Language, theme, and security';
}
