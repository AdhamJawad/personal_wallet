import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Personal Wallet'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @wallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get wallets;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @action.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action;

  /// No description provided for @debts.
  ///
  /// In en, this message translates to:
  /// **'Debts'**
  String get debts;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @quickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActionsTitle;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @personalAccount.
  ///
  /// In en, this message translates to:
  /// **'Personal account'**
  String get personalAccount;

  /// No description provided for @totalAssets.
  ///
  /// In en, this message translates to:
  /// **'Total Assets'**
  String get totalAssets;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @myWallets.
  ///
  /// In en, this message translates to:
  /// **'My Wallets'**
  String get myWallets;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @debtOverview.
  ///
  /// In en, this message translates to:
  /// **'Debt Overview'**
  String get debtOverview;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @hideBalances.
  ///
  /// In en, this message translates to:
  /// **'Hide balances'**
  String get hideBalances;

  /// No description provided for @showBalances.
  ///
  /// In en, this message translates to:
  /// **'Show balances'**
  String get showBalances;

  /// No description provided for @updatedNow.
  ///
  /// In en, this message translates to:
  /// **'Updated just now'**
  String get updatedNow;

  /// No description provided for @activeWalletsHint.
  ///
  /// In en, this message translates to:
  /// **'Combined value across active wallets'**
  String get activeWalletsHint;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @exchange.
  ///
  /// In en, this message translates to:
  /// **'Exchange'**
  String get exchange;

  /// No description provided for @debt.
  ///
  /// In en, this message translates to:
  /// **'Debt'**
  String get debt;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @usdShort.
  ///
  /// In en, this message translates to:
  /// **'USD'**
  String get usdShort;

  /// No description provided for @sypShort.
  ///
  /// In en, this message translates to:
  /// **'SYP'**
  String get sypShort;

  /// No description provided for @noWalletsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Wallets Yet'**
  String get noWalletsTitle;

  /// No description provided for @noWalletsMessage.
  ///
  /// In en, this message translates to:
  /// **'Create your first wallet to start tracking balances and activity.'**
  String get noWalletsMessage;

  /// No description provided for @createWallet.
  ///
  /// In en, this message translates to:
  /// **'Create Wallet'**
  String get createWallet;

  /// No description provided for @createWalletHelper.
  ///
  /// In en, this message translates to:
  /// **'Create a new wallet for organizing your funds.'**
  String get createWalletHelper;

  /// No description provided for @walletNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Wallet Name'**
  String get walletNameLabel;

  /// No description provided for @walletNameHint.
  ///
  /// In en, this message translates to:
  /// **'Travel Wallet'**
  String get walletNameHint;

  /// No description provided for @walletColor.
  ///
  /// In en, this message translates to:
  /// **'Wallet Color'**
  String get walletColor;

  /// No description provided for @walletPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get walletPreview;

  /// No description provided for @walletDetails.
  ///
  /// In en, this message translates to:
  /// **'Wallet Details'**
  String get walletDetails;

  /// No description provided for @createWalletConfirm.
  ///
  /// In en, this message translates to:
  /// **'Create Wallet'**
  String get createWalletConfirm;

  /// No description provided for @walletCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Wallet created successfully'**
  String get walletCreatedSuccess;

  /// No description provided for @walletCreateFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to create wallet.'**
  String get walletCreateFailure;

  /// No description provided for @walletNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Wallet name is required.'**
  String get walletNameRequired;

  /// No description provided for @walletNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Wallet name must be at least 3 characters.'**
  String get walletNameTooShort;

  /// No description provided for @walletsPageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A compact view of balances and activity across every wallet.'**
  String get walletsPageSubtitle;

  /// No description provided for @walletCount.
  ///
  /// In en, this message translates to:
  /// **'Wallet Count'**
  String get walletCount;

  /// No description provided for @walletSummary.
  ///
  /// In en, this message translates to:
  /// **'Wallet Summary'**
  String get walletSummary;

  /// No description provided for @totalWallets.
  ///
  /// In en, this message translates to:
  /// **'Total Wallets'**
  String get totalWallets;

  /// No description provided for @usdTotal.
  ///
  /// In en, this message translates to:
  /// **'USD Total'**
  String get usdTotal;

  /// No description provided for @sypTotal.
  ///
  /// In en, this message translates to:
  /// **'SYP Total'**
  String get sypTotal;

  /// No description provided for @searchWallets.
  ///
  /// In en, this message translates to:
  /// **'Search wallets'**
  String get searchWallets;

  /// No description provided for @searchWalletsHint.
  ///
  /// In en, this message translates to:
  /// **'Wallet name'**
  String get searchWalletsHint;

  /// No description provided for @sortWallets.
  ///
  /// In en, this message translates to:
  /// **'Sort wallets'**
  String get sortWallets;

  /// No description provided for @allWallets.
  ///
  /// In en, this message translates to:
  /// **'All Wallets'**
  String get allWallets;

  /// No description provided for @combinedUsd.
  ///
  /// In en, this message translates to:
  /// **'Combined USD'**
  String get combinedUsd;

  /// No description provided for @combinedSyp.
  ///
  /// In en, this message translates to:
  /// **'Combined SYP'**
  String get combinedSyp;

  /// No description provided for @currentView.
  ///
  /// In en, this message translates to:
  /// **'Current view'**
  String get currentView;

  /// No description provided for @walletStatus.
  ///
  /// In en, this message translates to:
  /// **'Wallet status'**
  String get walletStatus;

  /// No description provided for @transactionCount.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionCount;

  /// No description provided for @lastActivity.
  ///
  /// In en, this message translates to:
  /// **'Last activity'**
  String get lastActivity;

  /// No description provided for @createdLabel.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get createdLabel;

  /// No description provided for @updatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updatedLabel;

  /// No description provided for @noWalletSearchResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Matching Wallets'**
  String get noWalletSearchResultsTitle;

  /// No description provided for @noWalletSearchResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'Try another name or clear search to see every wallet again.'**
  String get noWalletSearchResultsMessage;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get clearSearch;

  /// No description provided for @noActivityYet.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get noActivityYet;

  /// No description provided for @updatedJustNow.
  ///
  /// In en, this message translates to:
  /// **'Updated just now'**
  String get updatedJustNow;

  /// No description provided for @updatedMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'Updated {minutes} min ago'**
  String updatedMinutesAgo(int minutes);

  /// No description provided for @updatedHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'Updated {hours} hours ago'**
  String updatedHoursAgo(int hours);

  /// No description provided for @updatedToday.
  ///
  /// In en, this message translates to:
  /// **'Updated today'**
  String get updatedToday;

  /// No description provided for @updatedYesterday.
  ///
  /// In en, this message translates to:
  /// **'Updated yesterday'**
  String get updatedYesterday;

  /// No description provided for @updatedDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Updated {days} days ago'**
  String updatedDaysAgo(int days);

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @deposits.
  ///
  /// In en, this message translates to:
  /// **'Deposits'**
  String get deposits;

  /// No description provided for @withdrawals.
  ///
  /// In en, this message translates to:
  /// **'Withdrawals'**
  String get withdrawals;

  /// No description provided for @transfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get transfers;

  /// No description provided for @exchanges.
  ///
  /// In en, this message translates to:
  /// **'Exchanges'**
  String get exchanges;

  /// No description provided for @noWalletActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get noWalletActivityTitle;

  /// No description provided for @noWalletActivityMessage.
  ///
  /// In en, this message translates to:
  /// **'The first financial activity for this wallet will appear here.'**
  String get noWalletActivityMessage;

  /// No description provided for @walletNotFound.
  ///
  /// In en, this message translates to:
  /// **'Wallet not found.'**
  String get walletNotFound;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get lastUpdated;

  /// No description provided for @balanceUsd.
  ///
  /// In en, this message translates to:
  /// **'USD Balance'**
  String get balanceUsd;

  /// No description provided for @balanceSyp.
  ///
  /// In en, this message translates to:
  /// **'SYP Balance'**
  String get balanceSyp;

  /// No description provided for @openTransaction.
  ///
  /// In en, this message translates to:
  /// **'Open transaction'**
  String get openTransaction;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get reference;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// No description provided for @oldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get oldest;

  /// No description provided for @nameAscending.
  ///
  /// In en, this message translates to:
  /// **'Name A-Z'**
  String get nameAscending;

  /// No description provided for @nameDescending.
  ///
  /// In en, this message translates to:
  /// **'Name Z-A'**
  String get nameDescending;

  /// No description provided for @highestUsd.
  ///
  /// In en, this message translates to:
  /// **'Highest USD'**
  String get highestUsd;

  /// No description provided for @highestSyp.
  ///
  /// In en, this message translates to:
  /// **'Highest SYP'**
  String get highestSyp;

  /// No description provided for @noActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'No Activity Yet'**
  String get noActivityTitle;

  /// No description provided for @noActivityMessage.
  ///
  /// In en, this message translates to:
  /// **'New deposits, transfers, withdrawals, and exchanges will appear here.'**
  String get noActivityMessage;

  /// No description provided for @noDebtsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Debts Yet'**
  String get noDebtsTitle;

  /// No description provided for @noDebtsMessage.
  ///
  /// In en, this message translates to:
  /// **'Track money you owe and money owed to you in one place.'**
  String get noDebtsMessage;

  /// No description provided for @createDebt.
  ///
  /// In en, this message translates to:
  /// **'Create Debt'**
  String get createDebt;

  /// No description provided for @owedToMe.
  ///
  /// In en, this message translates to:
  /// **'Owed To Me'**
  String get owedToMe;

  /// No description provided for @iOwe.
  ///
  /// In en, this message translates to:
  /// **'I Owe'**
  String get iOwe;

  /// No description provided for @openStatus.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openStatus;

  /// No description provided for @settledStatus.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get settledStatus;

  /// No description provided for @remainingAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remainingAmountLabel;

  /// No description provided for @openRecords.
  ///
  /// In en, this message translates to:
  /// **'Open Records'**
  String get openRecords;

  /// No description provided for @searchDebts.
  ///
  /// In en, this message translates to:
  /// **'Search debts'**
  String get searchDebts;

  /// No description provided for @searchDebtsHint.
  ///
  /// In en, this message translates to:
  /// **'Contact, note, or reference'**
  String get searchDebtsHint;

  /// No description provided for @noDebtRecordsYetTitle.
  ///
  /// In en, this message translates to:
  /// **'No Debt Records Yet'**
  String get noDebtRecordsYetTitle;

  /// No description provided for @noDebtRecordsYetMessage.
  ///
  /// In en, this message translates to:
  /// **'Create your first debt record to track money owed to you and money you owe.'**
  String get noDebtRecordsYetMessage;

  /// No description provided for @noDebtSearchResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Matching Debts'**
  String get noDebtSearchResultsTitle;

  /// No description provided for @noDebtSearchResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'Try another contact, note, or reference.'**
  String get noDebtSearchResultsMessage;

  /// No description provided for @noDebtFilterResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Debts In This View'**
  String get noDebtFilterResultsTitle;

  /// No description provided for @noDebtFilterResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose another filter to view more debt records.'**
  String get noDebtFilterResultsMessage;

  /// No description provided for @outstandingDebts.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Debts'**
  String get outstandingDebts;

  /// No description provided for @outstandingDebtCaption.
  ///
  /// In en, this message translates to:
  /// **'Open records pending completion'**
  String get outstandingDebtCaption;

  /// No description provided for @walletFallback.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletFallback;

  /// No description provided for @hiddenValue.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get hiddenValue;

  /// No description provided for @depositActivity.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get depositActivity;

  /// No description provided for @withdrawActivity.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdrawActivity;

  /// No description provided for @transferActivity.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transferActivity;

  /// No description provided for @exchangeActivity.
  ///
  /// In en, this message translates to:
  /// **'Exchange'**
  String get exchangeActivity;

  /// No description provided for @debtSettlementActivity.
  ///
  /// In en, this message translates to:
  /// **'Debt Settlement'**
  String get debtSettlementActivity;

  /// No description provided for @reversalActivity.
  ///
  /// In en, this message translates to:
  /// **'Reversal'**
  String get reversalActivity;

  /// No description provided for @correctionActivity.
  ///
  /// In en, this message translates to:
  /// **'Correction'**
  String get correctionActivity;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile & Settings'**
  String get profileTitle;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @securitySection.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securitySection;

  /// No description provided for @preferencesSection.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesSection;

  /// No description provided for @applicationSection.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get applicationSection;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// No description provided for @userIdentifier.
  ///
  /// In en, this message translates to:
  /// **'User Identifier'**
  String get userIdentifier;

  /// No description provided for @biometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get biometricLogin;

  /// No description provided for @faceId.
  ///
  /// In en, this message translates to:
  /// **'Face ID'**
  String get faceId;

  /// No description provided for @fingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get fingerprint;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'You have been logged out.'**
  String get logoutMessage;

  /// No description provided for @openActions.
  ///
  /// In en, this message translates to:
  /// **'Open actions'**
  String get openActions;

  /// No description provided for @actionsSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose an action'**
  String get actionsSheetTitle;

  /// No description provided for @actionsSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick access to primary financial actions.'**
  String get actionsSheetSubtitle;

  /// No description provided for @homeDescription.
  ///
  /// In en, this message translates to:
  /// **'Overview of balances'**
  String get homeDescription;

  /// No description provided for @walletsDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage wallets'**
  String get walletsDescription;

  /// No description provided for @activityDescription.
  ///
  /// In en, this message translates to:
  /// **'Track transactions'**
  String get activityDescription;

  /// No description provided for @debtsDescription.
  ///
  /// In en, this message translates to:
  /// **'Track debts'**
  String get debtsDescription;

  /// No description provided for @profileDescription.
  ///
  /// In en, this message translates to:
  /// **'Language, theme, and security'**
  String get profileDescription;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your phone number and password. Secure biometric access is available after setup.'**
  String get loginSubtitle;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create a new account'**
  String get createNewAccount;

  /// No description provided for @mockLoginCredentials.
  ///
  /// In en, this message translates to:
  /// **'Mock login: +963999999999 / 123456'**
  String get mockLoginCredentials;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required.'**
  String get phoneNumberRequired;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required.'**
  String get passwordRequired;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @useBiometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Use Face ID / Fingerprint'**
  String get useBiometricLogin;

  /// No description provided for @resetAccess.
  ///
  /// In en, this message translates to:
  /// **'Reset access'**
  String get resetAccess;

  /// No description provided for @resetAccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number and we will simulate the secure password reset flow.'**
  String get resetAccessSubtitle;

  /// No description provided for @sendInstructions.
  ///
  /// In en, this message translates to:
  /// **'Send instructions'**
  String get sendInstructions;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @verifyOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to {phoneNumber}.'**
  String verifyOtpSubtitle(Object phoneNumber);

  /// No description provided for @yourPhone.
  ///
  /// In en, this message translates to:
  /// **'your phone'**
  String get yourPhone;

  /// No description provided for @mockOtp.
  ///
  /// In en, this message translates to:
  /// **'Mock OTP: 123456'**
  String get mockOtp;

  /// No description provided for @otpCode.
  ///
  /// In en, this message translates to:
  /// **'OTP code'**
  String get otpCode;

  /// No description provided for @otpCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'OTP code is required.'**
  String get otpCodeRequired;

  /// No description provided for @otpMustBeSixDigits.
  ///
  /// In en, this message translates to:
  /// **'OTP must be 6 digits.'**
  String get otpMustBeSixDigits;

  /// No description provided for @verifyAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify and continue'**
  String get verifyAndContinue;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register for secure wallet access. Your account will be verified with a one-time OTP code.'**
  String get registerSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required.'**
  String get fullNameRequired;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required.'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @continueToOtp.
  ///
  /// In en, this message translates to:
  /// **'Continue to OTP'**
  String get continueToOtp;

  /// No description provided for @preparingSecureSession.
  ///
  /// In en, this message translates to:
  /// **'Preparing your secure session.'**
  String get preparingSecureSession;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @unknownWallet.
  ///
  /// In en, this message translates to:
  /// **'Unknown wallet'**
  String get unknownWallet;

  /// No description provided for @searchTransactions.
  ///
  /// In en, this message translates to:
  /// **'Search transactions'**
  String get searchTransactions;

  /// No description provided for @transactionReferenceHint.
  ///
  /// In en, this message translates to:
  /// **'TX-2026-000001'**
  String get transactionReferenceHint;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get allTypes;

  /// No description provided for @highestAmount.
  ///
  /// In en, this message translates to:
  /// **'Highest amount'**
  String get highestAmount;

  /// No description provided for @lowestAmount.
  ///
  /// In en, this message translates to:
  /// **'Lowest amount'**
  String get lowestAmount;

  /// No description provided for @noTransactionsForFilters.
  ///
  /// In en, this message translates to:
  /// **'No transactions match the current filters.'**
  String get noTransactionsForFilters;

  /// No description provided for @internalTransfer.
  ///
  /// In en, this message translates to:
  /// **'Internal Transfer'**
  String get internalTransfer;

  /// No description provided for @userTransfer.
  ///
  /// In en, this message translates to:
  /// **'User Transfer'**
  String get userTransfer;

  /// No description provided for @debtSettlementTransfer.
  ///
  /// In en, this message translates to:
  /// **'Debt Settlement Transfer'**
  String get debtSettlementTransfer;

  /// No description provided for @toWallet.
  ///
  /// In en, this message translates to:
  /// **'To {walletName}'**
  String toWallet(Object walletName);

  /// No description provided for @fromWallet.
  ///
  /// In en, this message translates to:
  /// **'From {walletName}'**
  String fromWallet(Object walletName);

  /// No description provided for @walletToUser.
  ///
  /// In en, this message translates to:
  /// **'{walletName} -> {userName}'**
  String walletToUser(Object walletName, Object userName);

  /// No description provided for @userToWallet.
  ///
  /// In en, this message translates to:
  /// **'From {userName} to {walletName}'**
  String userToWallet(Object userName, Object walletName);

  /// No description provided for @walletToWallet.
  ///
  /// In en, this message translates to:
  /// **'{sourceWallet} -> {destinationWallet}'**
  String walletToWallet(Object sourceWallet, Object destinationWallet);

  /// No description provided for @exchangeInWallet.
  ///
  /// In en, this message translates to:
  /// **'Exchange in {walletName}'**
  String exchangeInWallet(Object walletName);

  /// No description provided for @ledgerCorrection.
  ///
  /// In en, this message translates to:
  /// **'Ledger correction'**
  String get ledgerCorrection;

  /// No description provided for @userFallback.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userFallback;

  /// No description provided for @amountRequired.
  ///
  /// In en, this message translates to:
  /// **'Amount is required.'**
  String get amountRequired;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount.'**
  String get enterValidAmount;

  /// No description provided for @createDepositTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Deposit'**
  String get createDepositTitle;

  /// No description provided for @createWithdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Withdraw'**
  String get createWithdrawTitle;

  /// No description provided for @createExchangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Exchange'**
  String get createExchangeTitle;

  /// No description provided for @createInternalTransferTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Internal Transfer'**
  String get createInternalTransferTitle;

  /// No description provided for @recordDepositHelper.
  ///
  /// In en, this message translates to:
  /// **'Record a new deposit directly into this wallet.'**
  String get recordDepositHelper;

  /// No description provided for @recordWithdrawHelper.
  ///
  /// In en, this message translates to:
  /// **'Record a withdrawal from this wallet.'**
  String get recordWithdrawHelper;

  /// No description provided for @recordExchangeHelper.
  ///
  /// In en, this message translates to:
  /// **'Exchange balances within this wallet.'**
  String get recordExchangeHelper;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @walletRequired.
  ///
  /// In en, this message translates to:
  /// **'Wallet is required.'**
  String get walletRequired;

  /// No description provided for @sourceWallet.
  ///
  /// In en, this message translates to:
  /// **'Source wallet'**
  String get sourceWallet;

  /// No description provided for @sourceWalletRequired.
  ///
  /// In en, this message translates to:
  /// **'Source wallet is required.'**
  String get sourceWalletRequired;

  /// No description provided for @destinationWallet.
  ///
  /// In en, this message translates to:
  /// **'Destination wallet'**
  String get destinationWallet;

  /// No description provided for @destinationWalletRequired.
  ///
  /// In en, this message translates to:
  /// **'Destination wallet is required.'**
  String get destinationWalletRequired;

  /// No description provided for @sourceCurrency.
  ///
  /// In en, this message translates to:
  /// **'Source currency'**
  String get sourceCurrency;

  /// No description provided for @destinationCurrency.
  ///
  /// In en, this message translates to:
  /// **'Destination currency'**
  String get destinationCurrency;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @amountGiven.
  ///
  /// In en, this message translates to:
  /// **'Amount given'**
  String get amountGiven;

  /// No description provided for @exchangeRate.
  ///
  /// In en, this message translates to:
  /// **'Exchange rate'**
  String get exchangeRate;

  /// No description provided for @amountReceived.
  ///
  /// In en, this message translates to:
  /// **'Amount received'**
  String get amountReceived;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @attachmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Attachment label'**
  String get attachmentLabel;

  /// No description provided for @receiptFileHint.
  ///
  /// In en, this message translates to:
  /// **'receipt.jpg'**
  String get receiptFileHint;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @saveDeposit.
  ///
  /// In en, this message translates to:
  /// **'Save deposit'**
  String get saveDeposit;

  /// No description provided for @saveWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Save withdrawal'**
  String get saveWithdrawal;

  /// No description provided for @saveExchange.
  ///
  /// In en, this message translates to:
  /// **'Save exchange'**
  String get saveExchange;

  /// No description provided for @saveTransfer.
  ///
  /// In en, this message translates to:
  /// **'Save transfer'**
  String get saveTransfer;

  /// No description provided for @sourceDestinationDifferent.
  ///
  /// In en, this message translates to:
  /// **'Source and destination currencies must be different.'**
  String get sourceDestinationDifferent;

  /// No description provided for @failedCreateDeposit.
  ///
  /// In en, this message translates to:
  /// **'Failed to create deposit.'**
  String get failedCreateDeposit;

  /// No description provided for @failedCreateWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Failed to create withdrawal.'**
  String get failedCreateWithdrawal;

  /// No description provided for @failedCreateExchange.
  ///
  /// In en, this message translates to:
  /// **'Failed to create exchange.'**
  String get failedCreateExchange;

  /// No description provided for @failedCreateTransfer.
  ///
  /// In en, this message translates to:
  /// **'Failed to create transfer.'**
  String get failedCreateTransfer;

  /// No description provided for @sourceDestinationWalletsDifferent.
  ///
  /// In en, this message translates to:
  /// **'Source and destination wallets must be different.'**
  String get sourceDestinationWalletsDifferent;

  /// No description provided for @editWallet.
  ///
  /// In en, this message translates to:
  /// **'Edit Wallet'**
  String get editWallet;

  /// No description provided for @editWalletHelper.
  ///
  /// In en, this message translates to:
  /// **'Update the wallet name or archive it when needed.'**
  String get editWalletHelper;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @failedSaveWallet.
  ///
  /// In en, this message translates to:
  /// **'Failed to save wallet.'**
  String get failedSaveWallet;

  /// No description provided for @walletArchivedLabel.
  ///
  /// In en, this message translates to:
  /// **'Wallet archived'**
  String get walletArchivedLabel;

  /// No description provided for @archiveWallet.
  ///
  /// In en, this message translates to:
  /// **'Archive wallet'**
  String get archiveWallet;

  /// No description provided for @failedArchiveWallet.
  ///
  /// In en, this message translates to:
  /// **'Failed to archive wallet.'**
  String get failedArchiveWallet;

  /// No description provided for @moveMoney.
  ///
  /// In en, this message translates to:
  /// **'Move Money'**
  String get moveMoney;

  /// No description provided for @noTransactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get noTransactionsTitle;

  /// No description provided for @selectWallet.
  ///
  /// In en, this message translates to:
  /// **'Select wallet'**
  String get selectWallet;

  /// No description provided for @walletBalanceSummary.
  ///
  /// In en, this message translates to:
  /// **'{usdAmount} USD · {sypAmount} SYP'**
  String walletBalanceSummary(Object usdAmount, Object sypAmount);

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select currency'**
  String get selectCurrency;

  /// No description provided for @selectSourceCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select source currency'**
  String get selectSourceCurrency;

  /// No description provided for @selectDestinationCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select destination currency'**
  String get selectDestinationCurrency;

  /// No description provided for @walletPickerHint.
  ///
  /// In en, this message translates to:
  /// **'Main Wallet'**
  String get walletPickerHint;

  /// No description provided for @enterAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmountHint;

  /// No description provided for @enterExchangeRateHint.
  ///
  /// In en, this message translates to:
  /// **'Enter exchange rate'**
  String get enterExchangeRateHint;

  /// No description provided for @transactionNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Salary payment, travel expenses, loan repayment'**
  String get transactionNoteHint;

  /// No description provided for @addAttachment.
  ///
  /// In en, this message translates to:
  /// **'Add Attachment'**
  String get addAttachment;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @attachmentsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} attachments selected'**
  String attachmentsSelected(int count);

  /// No description provided for @removeAttachment.
  ///
  /// In en, this message translates to:
  /// **'Remove attachment'**
  String get removeAttachment;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @takePhotoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Capture a photo with the device camera.'**
  String get takePhotoSubtitle;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose From Gallery'**
  String get chooseFromGallery;

  /// No description provided for @chooseFromGallerySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select an image from the device gallery.'**
  String get chooseFromGallerySubtitle;

  /// No description provided for @preparingPicker.
  ///
  /// In en, this message translates to:
  /// **'Preparing picker...'**
  String get preparingPicker;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @continueReview.
  ///
  /// In en, this message translates to:
  /// **'Continue Review'**
  String get continueReview;

  /// No description provided for @confirmDeposit.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deposit'**
  String get confirmDeposit;

  /// No description provided for @confirmWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Confirm Withdrawal'**
  String get confirmWithdrawal;

  /// No description provided for @confirmExchange.
  ///
  /// In en, this message translates to:
  /// **'Confirm Exchange'**
  String get confirmExchange;

  /// No description provided for @confirmTransfer.
  ///
  /// In en, this message translates to:
  /// **'Confirm Transfer'**
  String get confirmTransfer;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @returnAction.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnAction;

  /// No description provided for @depositSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Deposit recorded successfully.'**
  String get depositSuccessMessage;

  /// No description provided for @withdrawSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal recorded successfully.'**
  String get withdrawSuccessMessage;

  /// No description provided for @exchangeSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Exchange recorded successfully.'**
  String get exchangeSuccessMessage;

  /// No description provided for @transferSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Transfer recorded successfully.'**
  String get transferSuccessMessage;

  /// No description provided for @transactionSubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to complete this transaction.'**
  String get transactionSubmitFailed;

  /// No description provided for @transactionAttachmentSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'The transaction was recorded, but one or more attachments could not be saved.'**
  String get transactionAttachmentSaveFailed;

  /// No description provided for @transferAttachmentSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'The transfer was created, but one or more attachments could not be saved.'**
  String get transferAttachmentSaveFailed;

  /// No description provided for @transactionReferenceLabel.
  ///
  /// In en, this message translates to:
  /// **'{operation} {reference}'**
  String transactionReferenceLabel(Object operation, Object reference);

  /// No description provided for @noTransactionWalletsTitle.
  ///
  /// In en, this message translates to:
  /// **'No wallets available'**
  String get noTransactionWalletsTitle;

  /// No description provided for @noTransactionWalletsMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a wallet before starting a new transaction.'**
  String get noTransactionWalletsMessage;

  /// No description provided for @noTransferWalletsMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a wallet before sending money.'**
  String get noTransferWalletsMessage;

  /// No description provided for @noDescriptionAdded.
  ///
  /// In en, this message translates to:
  /// **'No description added'**
  String get noDescriptionAdded;

  /// No description provided for @noAttachments.
  ///
  /// In en, this message translates to:
  /// **'No attachments'**
  String get noAttachments;

  /// No description provided for @transferRecipientTitle.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get transferRecipientTitle;

  /// No description provided for @transferRecipientDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to identify the recipient, then confirm their details.'**
  String get transferRecipientDescription;

  /// No description provided for @transferRecipientRequired.
  ///
  /// In en, this message translates to:
  /// **'Recipient is required.'**
  String get transferRecipientRequired;

  /// No description provided for @recipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// No description provided for @recipientUserId.
  ///
  /// In en, this message translates to:
  /// **'Recipient user ID'**
  String get recipientUserId;

  /// No description provided for @recipientName.
  ///
  /// In en, this message translates to:
  /// **'Recipient name'**
  String get recipientName;

  /// No description provided for @enterRecipientUserIdHint.
  ///
  /// In en, this message translates to:
  /// **'Enter user ID'**
  String get enterRecipientUserIdHint;

  /// No description provided for @enterRecipientNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter recipient name'**
  String get enterRecipientNameHint;

  /// No description provided for @recipientMethodHint.
  ///
  /// In en, this message translates to:
  /// **'Pick the fastest way to find the right person.'**
  String get recipientMethodHint;

  /// No description provided for @qrScan.
  ///
  /// In en, this message translates to:
  /// **'QR Scan'**
  String get qrScan;

  /// No description provided for @scanQrRecipient.
  ///
  /// In en, this message translates to:
  /// **'Scan QR recipient'**
  String get scanQrRecipient;

  /// No description provided for @scanRecipientHint.
  ///
  /// In en, this message translates to:
  /// **'Scan or select a recipient profile'**
  String get scanRecipientHint;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @manualEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manualEntry;

  /// No description provided for @transferRouteTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer Route'**
  String get transferRouteTitle;

  /// No description provided for @transferRouteDescription.
  ///
  /// In en, this message translates to:
  /// **'Review where the money leaves from and who will receive it.'**
  String get transferRouteDescription;

  /// No description provided for @transferRouteSourceHint.
  ///
  /// In en, this message translates to:
  /// **'Choose the wallet to send from'**
  String get transferRouteSourceHint;

  /// No description provided for @transferRouteDestinationHint.
  ///
  /// In en, this message translates to:
  /// **'Recipient details appear here'**
  String get transferRouteDestinationHint;

  /// No description provided for @transferRouteSwap.
  ///
  /// In en, this message translates to:
  /// **'Swap View'**
  String get transferRouteSwap;

  /// No description provided for @transferRouteSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source Wallet'**
  String get transferRouteSourceLabel;

  /// No description provided for @transferRouteDestinationLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get transferRouteDestinationLabel;

  /// No description provided for @transferDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transfer Details'**
  String get transferDetailsTitle;

  /// No description provided for @transferDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the transfer amount, currency, note, and any supporting attachment.'**
  String get transferDetailsDescription;

  /// No description provided for @transferRecipientPreviewHint.
  ///
  /// In en, this message translates to:
  /// **'Select a recipient to continue'**
  String get transferRecipientPreviewHint;

  /// No description provided for @selectContact.
  ///
  /// In en, this message translates to:
  /// **'Select contact'**
  String get selectContact;

  /// No description provided for @selectSavedContactHint.
  ///
  /// In en, this message translates to:
  /// **'Select a saved contact'**
  String get selectSavedContactHint;

  /// No description provided for @noQrRecipientsTitle.
  ///
  /// In en, this message translates to:
  /// **'No QR recipients available'**
  String get noQrRecipientsTitle;

  /// No description provided for @noQrRecipientsMessage.
  ///
  /// In en, this message translates to:
  /// **'Try contacts or manual entry.'**
  String get noQrRecipientsMessage;

  /// No description provided for @noTransferContactsTitle.
  ///
  /// In en, this message translates to:
  /// **'No contacts available'**
  String get noTransferContactsTitle;

  /// No description provided for @noTransferContactsMessage.
  ///
  /// In en, this message translates to:
  /// **'Add a registered contact first, or use manual entry.'**
  String get noTransferContactsMessage;

  /// No description provided for @debtFormDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a debt record with clear direction, contact details, amount, and optional evidence.'**
  String get debtFormDescription;

  /// No description provided for @debtDirectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get debtDirectionTitle;

  /// No description provided for @debtDirectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose whether the money is owed to you or owed by you.'**
  String get debtDirectionDescription;

  /// No description provided for @debtContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get debtContactTitle;

  /// No description provided for @debtContactDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the person related to this debt record.'**
  String get debtContactDescription;

  /// No description provided for @debtContactRequired.
  ///
  /// In en, this message translates to:
  /// **'Contact is required.'**
  String get debtContactRequired;

  /// No description provided for @debtContactHint.
  ///
  /// In en, this message translates to:
  /// **'Select a contact'**
  String get debtContactHint;

  /// No description provided for @debtDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Debt Details'**
  String get debtDetailsTitle;

  /// No description provided for @debtDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Capture the amount, currency, note, and any supporting attachment.'**
  String get debtDetailsDescription;

  /// No description provided for @debtRepaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Record Repayment'**
  String get debtRepaymentTitle;

  /// No description provided for @debtRepaymentDescription.
  ///
  /// In en, this message translates to:
  /// **'Record a repayment amount and keep a supporting note or attachment if needed.'**
  String get debtRepaymentDescription;

  /// No description provided for @saveDebtRecord.
  ///
  /// In en, this message translates to:
  /// **'Save Debt'**
  String get saveDebtRecord;

  /// No description provided for @saveRepayment.
  ///
  /// In en, this message translates to:
  /// **'Save Repayment'**
  String get saveRepayment;

  /// No description provided for @failedCreateDebt.
  ///
  /// In en, this message translates to:
  /// **'Failed to create debt.'**
  String get failedCreateDebt;

  /// No description provided for @failedCreateRepayment.
  ///
  /// In en, this message translates to:
  /// **'Failed to record repayment.'**
  String get failedCreateRepayment;

  /// No description provided for @debtNotFound.
  ///
  /// In en, this message translates to:
  /// **'Debt not found.'**
  String get debtNotFound;

  /// No description provided for @debtFinancialSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial Summary'**
  String get debtFinancialSummaryTitle;

  /// No description provided for @ofAmountPrefix.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofAmountPrefix;

  /// No description provided for @originalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Original Amount'**
  String get originalAmountLabel;

  /// No description provided for @paidAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paidAmountLabel;

  /// No description provided for @debtProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get debtProgressTitle;

  /// No description provided for @remainingPercentLabel.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Remaining'**
  String remainingPercentLabel(int percent);

  /// No description provided for @recordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get recordPayment;

  /// No description provided for @openAction.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openAction;

  /// No description provided for @editDebt.
  ///
  /// In en, this message translates to:
  /// **'Edit Debt'**
  String get editDebt;

  /// No description provided for @editDebtHelper.
  ///
  /// In en, this message translates to:
  /// **'Adjust the debt details, note, and any supporting attachment.'**
  String get editDebtHelper;

  /// No description provided for @closeDebt.
  ///
  /// In en, this message translates to:
  /// **'Close Debt'**
  String get closeDebt;

  /// No description provided for @closeDebtConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to mark this debt as settled?'**
  String get closeDebtConfirmation;

  /// No description provided for @markAsSettled.
  ///
  /// In en, this message translates to:
  /// **'Mark as Settled'**
  String get markAsSettled;

  /// No description provided for @reopenDebt.
  ///
  /// In en, this message translates to:
  /// **'Reopen Debt'**
  String get reopenDebt;

  /// No description provided for @reopenDebtConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reopen this debt record?'**
  String get reopenDebtConfirmation;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @currentRemainingAmount.
  ///
  /// In en, this message translates to:
  /// **'Current Remaining Amount'**
  String get currentRemainingAmount;

  /// No description provided for @debtEditUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Editing debt records is not available yet.'**
  String get debtEditUnavailable;

  /// No description provided for @debtCloseUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Closing debt records is not available yet.'**
  String get debtCloseUnavailable;

  /// No description provided for @debtReopenUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Reopening debt records is not available yet.'**
  String get debtReopenUnavailable;

  /// No description provided for @previewAttachment.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewAttachment;

  /// No description provided for @downloadAttachment.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get downloadAttachment;

  /// No description provided for @openAttachmentViewer.
  ///
  /// In en, this message translates to:
  /// **'Open Attachments'**
  String get openAttachmentViewer;

  /// No description provided for @attachmentPreviewUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Preview is not available for this file.'**
  String get attachmentPreviewUnavailable;

  /// No description provided for @attachmentDownloaded.
  ///
  /// In en, this message translates to:
  /// **'{fileName} was downloaded.'**
  String attachmentDownloaded(Object fileName);

  /// No description provided for @attachmentDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'The attachment could not be downloaded.'**
  String get attachmentDownloadFailed;

  /// No description provided for @attachmentDownloadUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Downloading attachments is not supported on this device yet.'**
  String get attachmentDownloadUnsupported;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @debtCreatedEvent.
  ///
  /// In en, this message translates to:
  /// **'Debt Created'**
  String get debtCreatedEvent;

  /// No description provided for @partialPaymentEvent.
  ///
  /// In en, this message translates to:
  /// **'Partial Payment'**
  String get partialPaymentEvent;

  /// No description provided for @fullSettlementEvent.
  ///
  /// In en, this message translates to:
  /// **'Full Settlement'**
  String get fullSettlementEvent;

  /// No description provided for @attachmentAddedEvent.
  ///
  /// In en, this message translates to:
  /// **'Attachment Added'**
  String get attachmentAddedEvent;

  /// No description provided for @debtAttachmentSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'The debt was saved, but one or more attachments could not be stored.'**
  String get debtAttachmentSaveFailed;

  /// No description provided for @repaymentAttachmentSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'The repayment was saved, but one or more attachments could not be stored.'**
  String get repaymentAttachmentSaveFailed;

  /// No description provided for @debtAttachmentHint.
  ///
  /// In en, this message translates to:
  /// **'Add receipts, agreements, or proof of repayment.'**
  String get debtAttachmentHint;

  /// No description provided for @debtDirectionOwedToMeShort.
  ///
  /// In en, this message translates to:
  /// **'Owed to me'**
  String get debtDirectionOwedToMeShort;

  /// No description provided for @debtDirectionIOweShort.
  ///
  /// In en, this message translates to:
  /// **'I owe'**
  String get debtDirectionIOweShort;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @noDebtRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No debt records found.'**
  String get noDebtRecordsFound;

  /// No description provided for @transactionDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transactionDetailsTitle;

  /// No description provided for @transactionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Transaction not found.'**
  String get transactionNotFound;

  /// No description provided for @attachmentsButton.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachmentsButton;

  /// No description provided for @detailDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get detailDate;

  /// No description provided for @detailType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get detailType;

  /// No description provided for @detailDestinationWallet.
  ///
  /// In en, this message translates to:
  /// **'Destination wallet'**
  String get detailDestinationWallet;

  /// No description provided for @detailSender.
  ///
  /// In en, this message translates to:
  /// **'Sender'**
  String get detailSender;

  /// No description provided for @detailReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get detailReceived;

  /// No description provided for @detailTransferId.
  ///
  /// In en, this message translates to:
  /// **'Transfer ID'**
  String get detailTransferId;

  /// No description provided for @detailSettlementId.
  ///
  /// In en, this message translates to:
  /// **'Settlement ID'**
  String get detailSettlementId;

  /// No description provided for @detailNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get detailNotes;

  /// No description provided for @detailAttachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get detailAttachment;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @contactDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactDetailsTitle;

  /// No description provided for @contactNotFound.
  ///
  /// In en, this message translates to:
  /// **'Contact not found.'**
  String get contactNotFound;

  /// No description provided for @searchContacts.
  ///
  /// In en, this message translates to:
  /// **'Search contacts'**
  String get searchContacts;

  /// No description provided for @searchContactsHint.
  ///
  /// In en, this message translates to:
  /// **'Ahmad Kareem'**
  String get searchContactsHint;

  /// No description provided for @addExternalContact.
  ///
  /// In en, this message translates to:
  /// **'Add External Contact'**
  String get addExternalContact;

  /// No description provided for @registeredContactsSection.
  ///
  /// In en, this message translates to:
  /// **'Registered Users'**
  String get registeredContactsSection;

  /// No description provided for @externalContactsSection.
  ///
  /// In en, this message translates to:
  /// **'External Contacts'**
  String get externalContactsSection;

  /// No description provided for @noContactsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No contacts available.'**
  String get noContactsAvailable;

  /// No description provided for @contactLinkReady.
  ///
  /// In en, this message translates to:
  /// **'Link-ready'**
  String get contactLinkReady;

  /// No description provided for @createExternalContact.
  ///
  /// In en, this message translates to:
  /// **'Create External Contact'**
  String get createExternalContact;

  /// No description provided for @saveContact.
  ///
  /// In en, this message translates to:
  /// **'Save Contact'**
  String get saveContact;

  /// No description provided for @contactCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create contact.'**
  String get contactCreateFailed;

  /// No description provided for @editContact.
  ///
  /// In en, this message translates to:
  /// **'Edit Contact'**
  String get editContact;

  /// No description provided for @editContactHelper.
  ///
  /// In en, this message translates to:
  /// **'Update the contact name, phone number, or note.'**
  String get editContactHelper;

  /// No description provided for @contactSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save contact.'**
  String get contactSaveFailed;

  /// No description provided for @openContactProfile.
  ///
  /// In en, this message translates to:
  /// **'Open Contact Profile'**
  String get openContactProfile;

  /// No description provided for @contactTypePerson.
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get contactTypePerson;

  /// No description provided for @contactTypeBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get contactTypeBusiness;

  /// No description provided for @callContact.
  ///
  /// In en, this message translates to:
  /// **'Call Contact'**
  String get callContact;

  /// No description provided for @whatsAppContact.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Contact'**
  String get whatsAppContact;

  /// No description provided for @contactFinancialSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial Summary'**
  String get contactFinancialSummaryTitle;

  /// No description provided for @contactNetBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get contactNetBalanceLabel;

  /// No description provided for @contactOpenDebtsTitle.
  ///
  /// In en, this message translates to:
  /// **'Open Debts'**
  String get contactOpenDebtsTitle;

  /// No description provided for @contactOpenDebtsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No active debts'**
  String get contactOpenDebtsEmptyTitle;

  /// No description provided for @contactOpenDebtsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No debts associated with this contact.'**
  String get contactOpenDebtsEmptyMessage;

  /// No description provided for @contactActivityEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get contactActivityEmptyTitle;

  /// No description provided for @contactActivityEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Debt activity for this contact will appear here.'**
  String get contactActivityEmptyMessage;

  /// No description provided for @contactCallUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Calling is not available on this device.'**
  String get contactCallUnavailable;

  /// No description provided for @contactWhatsAppUnavailable.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp could not be opened on this device.'**
  String get contactWhatsAppUnavailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
