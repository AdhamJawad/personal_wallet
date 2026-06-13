// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Personal Wallet';

  @override
  String get home => 'Home';

  @override
  String get wallets => 'Wallets';

  @override
  String get activity => 'Activity';

  @override
  String get action => 'Action';

  @override
  String get debts => 'Debts';

  @override
  String get profile => 'Profile';

  @override
  String get quickActionsTitle => 'Quick Actions';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String get personalAccount => 'Personal account';

  @override
  String get totalAssets => 'Total Assets';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get myWallets => 'My Wallets';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get debtOverview => 'Debt Overview';

  @override
  String get seeAll => 'See All';

  @override
  String get hideBalances => 'Hide balances';

  @override
  String get showBalances => 'Show balances';

  @override
  String get updatedNow => 'Updated just now';

  @override
  String get activeWalletsHint => 'Combined value across active wallets';

  @override
  String get deposit => 'Deposit';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get transfer => 'Transfer';

  @override
  String get exchange => 'Exchange';

  @override
  String get debt => 'Debt';

  @override
  String get active => 'Active';

  @override
  String get archived => 'Archived';

  @override
  String get usdShort => 'USD';

  @override
  String get sypShort => 'SYP';

  @override
  String get noWalletsTitle => 'No Wallets Yet';

  @override
  String get noWalletsMessage =>
      'Create your first wallet to start tracking balances and activity.';

  @override
  String get createWallet => 'Create Wallet';

  @override
  String get createWalletHelper =>
      'Create a new wallet for organizing your funds.';

  @override
  String get walletNameLabel => 'Wallet Name';

  @override
  String get walletNameHint => 'Travel Wallet';

  @override
  String get walletColor => 'Wallet Color';

  @override
  String get walletPreview => 'Preview';

  @override
  String get walletDetails => 'Wallet Details';

  @override
  String get createWalletConfirm => 'Create Wallet';

  @override
  String get walletCreatedSuccess => 'Wallet created successfully';

  @override
  String get walletCreateFailure => 'Failed to create wallet.';

  @override
  String get walletNameRequired => 'Wallet name is required.';

  @override
  String get walletNameTooShort => 'Wallet name must be at least 3 characters.';

  @override
  String get walletsPageSubtitle =>
      'A compact view of balances and activity across every wallet.';

  @override
  String get walletCount => 'Wallet Count';

  @override
  String get walletSummary => 'Wallet Summary';

  @override
  String get totalWallets => 'Total Wallets';

  @override
  String get usdTotal => 'USD Total';

  @override
  String get sypTotal => 'SYP Total';

  @override
  String get searchWallets => 'Search wallets';

  @override
  String get searchWalletsHint => 'Wallet name';

  @override
  String get sortWallets => 'Sort wallets';

  @override
  String get allWallets => 'All Wallets';

  @override
  String get combinedUsd => 'Combined USD';

  @override
  String get combinedSyp => 'Combined SYP';

  @override
  String get currentView => 'Current view';

  @override
  String get walletStatus => 'Wallet status';

  @override
  String get transactionCount => 'Transactions';

  @override
  String get lastActivity => 'Last activity';

  @override
  String get createdLabel => 'Created';

  @override
  String get updatedLabel => 'Updated';

  @override
  String get noWalletSearchResultsTitle => 'No Matching Wallets';

  @override
  String get noWalletSearchResultsMessage =>
      'Try another name or clear search to see every wallet again.';

  @override
  String get clearSearch => 'Clear Search';

  @override
  String get noActivityYet => 'No activity yet';

  @override
  String get updatedJustNow => 'Updated just now';

  @override
  String updatedMinutesAgo(int minutes) {
    return 'Updated $minutes min ago';
  }

  @override
  String updatedHoursAgo(int hours) {
    return 'Updated $hours hours ago';
  }

  @override
  String get updatedToday => 'Updated today';

  @override
  String get updatedYesterday => 'Updated yesterday';

  @override
  String updatedDaysAgo(int days) {
    return 'Updated $days days ago';
  }

  @override
  String get all => 'All';

  @override
  String get deposits => 'Deposits';

  @override
  String get withdrawals => 'Withdrawals';

  @override
  String get transfers => 'Transfers';

  @override
  String get exchanges => 'Exchanges';

  @override
  String get noWalletActivityTitle => 'No activity yet';

  @override
  String get noWalletActivityMessage =>
      'The first financial activity for this wallet will appear here.';

  @override
  String get walletNotFound => 'Wallet not found.';

  @override
  String get lastUpdated => 'Last updated';

  @override
  String get balanceUsd => 'USD Balance';

  @override
  String get balanceSyp => 'SYP Balance';

  @override
  String get openTransaction => 'Open transaction';

  @override
  String get reference => 'Reference';

  @override
  String get amount => 'Amount';

  @override
  String get date => 'Date';

  @override
  String get newest => 'Newest';

  @override
  String get oldest => 'Oldest';

  @override
  String get nameAscending => 'Name A-Z';

  @override
  String get nameDescending => 'Name Z-A';

  @override
  String get highestUsd => 'Highest USD';

  @override
  String get highestSyp => 'Highest SYP';

  @override
  String get noActivityTitle => 'No Activity Yet';

  @override
  String get noActivityMessage =>
      'New deposits, transfers, withdrawals, and exchanges will appear here.';

  @override
  String get noDebtsTitle => 'No Debts Yet';

  @override
  String get noDebtsMessage =>
      'Track money you owe and money owed to you in one place.';

  @override
  String get createDebt => 'Create Debt';

  @override
  String get owedToMe => 'Owed To Me';

  @override
  String get iOwe => 'I Owe';

  @override
  String get openStatus => 'Open';

  @override
  String get settledStatus => 'Settled';

  @override
  String get remainingAmountLabel => 'Remaining';

  @override
  String get openRecords => 'Open Records';

  @override
  String get searchDebts => 'Search debts';

  @override
  String get searchDebtsHint => 'Contact, note, or reference';

  @override
  String get noDebtRecordsYetTitle => 'No Debt Records Yet';

  @override
  String get noDebtRecordsYetMessage =>
      'Create your first debt record to track money owed to you and money you owe.';

  @override
  String get noDebtSearchResultsTitle => 'No Matching Debts';

  @override
  String get noDebtSearchResultsMessage =>
      'Try another contact, note, or reference.';

  @override
  String get noDebtFilterResultsTitle => 'No Debts In This View';

  @override
  String get noDebtFilterResultsMessage =>
      'Choose another filter to view more debt records.';

  @override
  String get outstandingDebts => 'Outstanding Debts';

  @override
  String get outstandingDebtCaption => 'Open records pending completion';

  @override
  String get walletFallback => 'Wallet';

  @override
  String get hiddenValue => 'Hidden';

  @override
  String get depositActivity => 'Deposit';

  @override
  String get withdrawActivity => 'Withdraw';

  @override
  String get transferActivity => 'Transfer';

  @override
  String get exchangeActivity => 'Exchange';

  @override
  String get debtSettlementActivity => 'Debt Settlement';

  @override
  String get reversalActivity => 'Reversal';

  @override
  String get correctionActivity => 'Correction';

  @override
  String get profileTitle => 'Profile & Settings';

  @override
  String get accountSection => 'Account';

  @override
  String get securitySection => 'Security';

  @override
  String get preferencesSection => 'Preferences';

  @override
  String get applicationSection => 'Application';

  @override
  String get displayName => 'Display Name';

  @override
  String get userIdentifier => 'User Identifier';

  @override
  String get biometricLogin => 'Biometric Login';

  @override
  String get faceId => 'Face ID';

  @override
  String get fingerprint => 'Fingerprint';

  @override
  String get notAvailable => 'Not available';

  @override
  String get available => 'Available';

  @override
  String get changePassword => 'Change Password';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get version => 'Version';

  @override
  String get logout => 'Logout';

  @override
  String get logoutMessage => 'You have been logged out.';

  @override
  String get openActions => 'Open actions';

  @override
  String get actionsSheetTitle => 'Choose an action';

  @override
  String get actionsSheetSubtitle =>
      'Quick access to primary financial actions.';

  @override
  String get homeDescription => 'Overview of balances';

  @override
  String get walletsDescription => 'Manage wallets';

  @override
  String get activityDescription => 'Track transactions';

  @override
  String get debtsDescription => 'Track debts';

  @override
  String get profileDescription => 'Language, theme, and security';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get loginSubtitle =>
      'Sign in with your phone number and password. Secure biometric access is available after setup.';

  @override
  String get createNewAccount => 'Create a new account';

  @override
  String get mockLoginCredentials => 'Mock login: +963999999999 / 123456';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get phoneNumberRequired => 'Phone number is required.';

  @override
  String get password => 'Password';

  @override
  String get passwordRequired => 'Password is required.';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign in';

  @override
  String get useBiometricLogin => 'Use Face ID / Fingerprint';

  @override
  String get resetAccess => 'Reset access';

  @override
  String get resetAccessSubtitle =>
      'Enter your phone number and we will simulate the secure password reset flow.';

  @override
  String get sendInstructions => 'Send instructions';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String verifyOtpSubtitle(Object phoneNumber) {
    return 'Enter the 6-digit code sent to $phoneNumber.';
  }

  @override
  String get yourPhone => 'your phone';

  @override
  String get mockOtp => 'Mock OTP: 123456';

  @override
  String get otpCode => 'OTP code';

  @override
  String get otpCodeRequired => 'OTP code is required.';

  @override
  String get otpMustBeSixDigits => 'OTP must be 6 digits.';

  @override
  String get verifyAndContinue => 'Verify and continue';

  @override
  String get createAccount => 'Create account';

  @override
  String get registerSubtitle =>
      'Register for secure wallet access. Your account will be verified with a one-time OTP code.';

  @override
  String get fullName => 'Full name';

  @override
  String get fullNameRequired => 'Full name is required.';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get confirmPasswordRequired => 'Confirm password is required.';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get continueToOtp => 'Continue to OTP';

  @override
  String get preparingSecureSession => 'Preparing your secure session.';

  @override
  String get transactions => 'Transactions';

  @override
  String get unknownWallet => 'Unknown wallet';

  @override
  String get searchTransactions => 'Search transactions';

  @override
  String get transactionsSearchHint => 'Reference, wallet, contact, or note';

  @override
  String get transactionReferenceHint => 'TX-2026-000001';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get allTypes => 'All types';

  @override
  String get highestAmount => 'Highest amount';

  @override
  String get lowestAmount => 'Lowest amount';

  @override
  String get noTransactionsForFilters =>
      'No transactions match the current filters.';

  @override
  String get transactionsNoResultsMessage =>
      'Try another search term or change the active filters.';

  @override
  String get transactionsEmptyStateTitle => 'No transactions yet';

  @override
  String get transactionsEmptyStateMessage =>
      'Your financial activity feed will appear here once you create the first operation.';

  @override
  String get transactionsCreateFirst => 'Create first transaction';

  @override
  String get transactionsTodaySummary => 'Today';

  @override
  String get transactionsMonthSummary => 'This Month';

  @override
  String get transactionsTotalSummary => 'Total Transactions';

  @override
  String get transactionsFilterSheetTitle => 'Feed Filters';

  @override
  String get transactionsDateRange => 'Date Range';

  @override
  String get transactionsDateRangeAll => 'All Dates';

  @override
  String get transactionsDateRangeToday => 'Today';

  @override
  String get transactionsDateRangeThisWeek => 'This Week';

  @override
  String get transactionsDateRangeThisMonth => 'This Month';

  @override
  String get transactionsDateRangeLast30Days => 'Last 30 Days';

  @override
  String get transactionsTodayGroup => 'Today';

  @override
  String get transactionsYesterdayGroup => 'Yesterday';

  @override
  String get transactionsThisWeekGroup => 'This Week';

  @override
  String get transactionsThisMonthGroup => 'This Month';

  @override
  String get transactionsDebtRepaymentChip => 'Debt Repayment';

  @override
  String get transactionsCurrencyExchangeChip => 'Currency Exchange';

  @override
  String get transactionsReferenceLabel => 'Reference';

  @override
  String get transactionsStatusLabel => 'Status';

  @override
  String get transactionsDetailContact => 'Contact';

  @override
  String get transactionsFromLabel => 'From';

  @override
  String get transactionsToLabel => 'To';

  @override
  String transactionsFromLabelValue(Object value) {
    return 'From: $value';
  }

  @override
  String transactionsToLabelValue(Object value) {
    return 'To: $value';
  }

  @override
  String get transactionsSelectAction => 'Choose an action';

  @override
  String get internalTransfer => 'Internal Transfer';

  @override
  String get userTransfer => 'User Transfer';

  @override
  String get debtSettlementTransfer => 'Debt Settlement Transfer';

  @override
  String toWallet(Object walletName) {
    return 'To $walletName';
  }

  @override
  String fromWallet(Object walletName) {
    return 'From $walletName';
  }

  @override
  String walletToUser(Object walletName, Object userName) {
    return '$walletName -> $userName';
  }

  @override
  String userToWallet(Object userName, Object walletName) {
    return 'From $userName to $walletName';
  }

  @override
  String walletToWallet(Object sourceWallet, Object destinationWallet) {
    return '$sourceWallet -> $destinationWallet';
  }

  @override
  String exchangeInWallet(Object walletName) {
    return 'Exchange in $walletName';
  }

  @override
  String get ledgerCorrection => 'Ledger correction';

  @override
  String get userFallback => 'User';

  @override
  String get amountRequired => 'Amount is required.';

  @override
  String get enterValidAmount => 'Enter a valid amount.';

  @override
  String get createDepositTitle => 'Create Deposit';

  @override
  String get createWithdrawTitle => 'Create Withdraw';

  @override
  String get createExchangeTitle => 'Create Exchange';

  @override
  String get createInternalTransferTitle => 'Create Internal Transfer';

  @override
  String get recordDepositHelper =>
      'Record a new deposit directly into this wallet.';

  @override
  String get recordWithdrawHelper => 'Record a withdrawal from this wallet.';

  @override
  String get recordExchangeHelper => 'Exchange balances within this wallet.';

  @override
  String get wallet => 'Wallet';

  @override
  String get walletRequired => 'Wallet is required.';

  @override
  String get sourceWallet => 'Source wallet';

  @override
  String get sourceWalletRequired => 'Source wallet is required.';

  @override
  String get destinationWallet => 'Destination wallet';

  @override
  String get destinationWalletRequired => 'Destination wallet is required.';

  @override
  String get sourceCurrency => 'Source currency';

  @override
  String get destinationCurrency => 'Destination currency';

  @override
  String get currency => 'Currency';

  @override
  String get amountGiven => 'Amount given';

  @override
  String get exchangeRate => 'Exchange rate';

  @override
  String get amountReceived => 'Amount received';

  @override
  String get note => 'Note';

  @override
  String get attachmentLabel => 'Attachment label';

  @override
  String get receiptFileHint => 'receipt.jpg';

  @override
  String get saving => 'Saving...';

  @override
  String get saveDeposit => 'Save deposit';

  @override
  String get saveWithdrawal => 'Save withdrawal';

  @override
  String get saveExchange => 'Save exchange';

  @override
  String get saveTransfer => 'Save transfer';

  @override
  String get sourceDestinationDifferent =>
      'Source and destination currencies must be different.';

  @override
  String get failedCreateDeposit => 'Failed to create deposit.';

  @override
  String get failedCreateWithdrawal => 'Failed to create withdrawal.';

  @override
  String get failedCreateExchange => 'Failed to create exchange.';

  @override
  String get failedCreateTransfer => 'Failed to create transfer.';

  @override
  String get sourceDestinationWalletsDifferent =>
      'Source and destination wallets must be different.';

  @override
  String get editWallet => 'Edit Wallet';

  @override
  String get editWalletHelper =>
      'Update the wallet name or archive it when needed.';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get failedSaveWallet => 'Failed to save wallet.';

  @override
  String get walletArchivedLabel => 'Wallet archived';

  @override
  String get archiveWallet => 'Archive wallet';

  @override
  String get failedArchiveWallet => 'Failed to archive wallet.';

  @override
  String get moveMoney => 'Move Money';

  @override
  String get noTransactionsTitle => 'No transactions found';

  @override
  String get selectWallet => 'Select wallet';

  @override
  String walletBalanceSummary(Object usdAmount, Object sypAmount) {
    return '$usdAmount USD · $sypAmount SYP';
  }

  @override
  String get selectCurrency => 'Select currency';

  @override
  String get selectSourceCurrency => 'Select source currency';

  @override
  String get selectDestinationCurrency => 'Select destination currency';

  @override
  String get walletPickerHint => 'Main Wallet';

  @override
  String get enterAmountHint => 'Enter amount';

  @override
  String get enterExchangeRateHint => 'Enter exchange rate';

  @override
  String get transactionNoteHint =>
      'Salary payment, travel expenses, loan repayment';

  @override
  String get addAttachment => 'Add Attachment';

  @override
  String get attachments => 'Attachments';

  @override
  String attachmentsSelected(int count) {
    return '$count attachments selected';
  }

  @override
  String get removeAttachment => 'Remove attachment';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get takePhotoSubtitle => 'Capture a photo with the device camera.';

  @override
  String get chooseFromGallery => 'Choose From Gallery';

  @override
  String get chooseFromGallerySubtitle =>
      'Select an image from the device gallery.';

  @override
  String get preparingPicker => 'Preparing picker...';

  @override
  String get cancel => 'Cancel';

  @override
  String get continueReview => 'Continue Review';

  @override
  String get confirmDeposit => 'Confirm Deposit';

  @override
  String get confirmWithdrawal => 'Confirm Withdrawal';

  @override
  String get confirmExchange => 'Confirm Exchange';

  @override
  String get confirmTransfer => 'Confirm Transfer';

  @override
  String get review => 'Review';

  @override
  String get back => 'Back';

  @override
  String get success => 'Success';

  @override
  String get done => 'Done';

  @override
  String get returnAction => 'Return';

  @override
  String get depositSuccessMessage => 'Deposit recorded successfully.';

  @override
  String get withdrawSuccessMessage => 'Withdrawal recorded successfully.';

  @override
  String get exchangeSuccessMessage => 'Exchange recorded successfully.';

  @override
  String get transferSuccessMessage => 'Transfer recorded successfully.';

  @override
  String get transactionSubmitFailed => 'Unable to complete this transaction.';

  @override
  String get transactionAttachmentSaveFailed =>
      'The transaction was recorded, but one or more attachments could not be saved.';

  @override
  String get transferAttachmentSaveFailed =>
      'The transfer was created, but one or more attachments could not be saved.';

  @override
  String transactionReferenceLabel(Object operation, Object reference) {
    return '$operation $reference';
  }

  @override
  String get noTransactionWalletsTitle => 'No wallets available';

  @override
  String get noTransactionWalletsMessage =>
      'Create a wallet before starting a new transaction.';

  @override
  String get noTransferWalletsMessage =>
      'Create a wallet before sending money.';

  @override
  String get noDescriptionAdded => 'No description added';

  @override
  String get noAttachments => 'No attachments';

  @override
  String get transferRecipientTitle => 'Recipient';

  @override
  String get transferRecipientDescription =>
      'Choose how you want to identify the recipient, then confirm their details.';

  @override
  String get transferRecipientRequired => 'Recipient is required.';

  @override
  String get recipient => 'Recipient';

  @override
  String get recipientUserId => 'Recipient user ID';

  @override
  String get recipientName => 'Recipient name';

  @override
  String get enterRecipientUserIdHint => 'Enter user ID';

  @override
  String get enterRecipientNameHint => 'Enter recipient name';

  @override
  String get recipientMethodHint =>
      'Pick the fastest way to find the right person.';

  @override
  String get qrScan => 'QR Scan';

  @override
  String get scanQrRecipient => 'Scan QR recipient';

  @override
  String get scanRecipientHint => 'Scan or select a recipient profile';

  @override
  String get contacts => 'Contacts';

  @override
  String get manualEntry => 'Manual Entry';

  @override
  String get transferRouteTitle => 'Transfer Route';

  @override
  String get transferRouteDescription =>
      'Review where the money leaves from and who will receive it.';

  @override
  String get transferRouteSourceHint => 'Choose the wallet to send from';

  @override
  String get transferRouteDestinationHint => 'Recipient details appear here';

  @override
  String get transferRouteSwap => 'Swap View';

  @override
  String get transferRouteSourceLabel => 'Source Wallet';

  @override
  String get transferRouteDestinationLabel => 'Recipient';

  @override
  String get transferDetailsTitle => 'Transfer Details';

  @override
  String get transferDetailsDescription =>
      'Enter the transfer amount, currency, note, and any supporting attachment.';

  @override
  String get transferRecipientPreviewHint => 'Select a recipient to continue';

  @override
  String get selectContact => 'Select contact';

  @override
  String get selectSavedContactHint => 'Select a saved contact';

  @override
  String get noQrRecipientsTitle => 'No QR recipients available';

  @override
  String get noQrRecipientsMessage => 'Try contacts or manual entry.';

  @override
  String get noTransferContactsTitle => 'No contacts available';

  @override
  String get noTransferContactsMessage =>
      'Add a registered contact first, or use manual entry.';

  @override
  String get debtFormDescription =>
      'Create a debt record with clear direction, contact details, amount, and optional evidence.';

  @override
  String get debtDirectionTitle => 'Direction';

  @override
  String get debtDirectionDescription =>
      'Choose whether the money is owed to you or owed by you.';

  @override
  String get debtContactTitle => 'Contact';

  @override
  String get debtContactDescription =>
      'Select the person related to this debt record.';

  @override
  String get debtContactRequired => 'Contact is required.';

  @override
  String get debtContactHint => 'Select a contact';

  @override
  String get debtDetailsTitle => 'Debt Details';

  @override
  String get debtDetailsDescription =>
      'Capture the amount, currency, note, and any supporting attachment.';

  @override
  String get debtRepaymentTitle => 'Record Repayment';

  @override
  String get debtRepaymentDescription =>
      'Record a repayment amount and keep a supporting note or attachment if needed.';

  @override
  String get saveDebtRecord => 'Save Debt';

  @override
  String get saveRepayment => 'Save Repayment';

  @override
  String get failedCreateDebt => 'Failed to create debt.';

  @override
  String get failedCreateRepayment => 'Failed to record repayment.';

  @override
  String get debtNotFound => 'Debt not found.';

  @override
  String get debtFinancialSummaryTitle => 'Financial Summary';

  @override
  String get ofAmountPrefix => 'of';

  @override
  String get originalAmountLabel => 'Original Amount';

  @override
  String get paidAmountLabel => 'Paid';

  @override
  String get debtProgressTitle => 'Progress';

  @override
  String remainingPercentLabel(int percent) {
    return '$percent% Remaining';
  }

  @override
  String get recordPayment => 'Record Payment';

  @override
  String get openAction => 'Open';

  @override
  String get editDebt => 'Edit Debt';

  @override
  String get editDebtHelper =>
      'Adjust the debt details, note, and any supporting attachment.';

  @override
  String get closeDebt => 'Close Debt';

  @override
  String get closeDebtConfirmation =>
      'Are you sure you want to mark this debt as settled?';

  @override
  String get markAsSettled => 'Mark as Settled';

  @override
  String get reopenDebt => 'Reopen Debt';

  @override
  String get reopenDebtConfirmation =>
      'Are you sure you want to reopen this debt record?';

  @override
  String get viewHistory => 'View History';

  @override
  String get currentRemainingAmount => 'Current Remaining Amount';

  @override
  String get debtEditUnavailable =>
      'Editing debt records is not available yet.';

  @override
  String get debtCloseUnavailable =>
      'Closing debt records is not available yet.';

  @override
  String get debtReopenUnavailable =>
      'Reopening debt records is not available yet.';

  @override
  String get previewAttachment => 'Preview';

  @override
  String get downloadAttachment => 'Download';

  @override
  String get openAttachmentViewer => 'Open Attachments';

  @override
  String get attachmentPreviewUnavailable =>
      'Preview is not available for this file.';

  @override
  String attachmentDownloaded(Object fileName) {
    return '$fileName was downloaded.';
  }

  @override
  String attachmentSaved(Object fileName) {
    return '$fileName was saved to your device.';
  }

  @override
  String get attachmentDownloadFailed =>
      'The attachment could not be downloaded.';

  @override
  String get attachmentDownloadUnsupported =>
      'Downloading attachments is not supported on this device yet.';

  @override
  String get attachmentShareUnsupported =>
      'Sharing attachments is not supported on this device yet.';

  @override
  String get attachmentShareFailed => 'The attachment could not be shared.';

  @override
  String get attachmentsAddAction => 'Add attachment';

  @override
  String get attachmentsRelatedTransaction => 'Related transaction:';

  @override
  String get attachmentsRelatedRecord => 'Related record:';

  @override
  String get attachmentsEmptyTitle => 'No attachments for this record';

  @override
  String get attachmentsEmptyMessage =>
      'You can add receipts, images, or supporting files here.';

  @override
  String get attachmentsShareAction => 'Share';

  @override
  String get attachmentsSaveToDeviceAction => 'Save to device';

  @override
  String get attachmentsTypeImage => 'Image';

  @override
  String get attachmentsTypeReceipt => 'Receipt';

  @override
  String get attachmentsTypeProofOfPayment => 'Proof of payment';

  @override
  String get attachmentsTypeDocument => 'Document';

  @override
  String get timeline => 'Timeline';

  @override
  String get debtCreatedEvent => 'Debt Created';

  @override
  String get partialPaymentEvent => 'Partial Payment';

  @override
  String get fullSettlementEvent => 'Full Settlement';

  @override
  String get attachmentAddedEvent => 'Attachment Added';

  @override
  String get debtAttachmentSaveFailed =>
      'The debt was saved, but one or more attachments could not be stored.';

  @override
  String get repaymentAttachmentSaveFailed =>
      'The repayment was saved, but one or more attachments could not be stored.';

  @override
  String get debtAttachmentHint =>
      'Add receipts, agreements, or proof of repayment.';

  @override
  String get debtDirectionOwedToMeShort => 'Owed to me';

  @override
  String get debtDirectionIOweShort => 'I owe';

  @override
  String get completed => 'Completed';

  @override
  String get noDebtRecordsFound => 'No debt records found.';

  @override
  String get transactionDetailsTitle => 'Transaction Details';

  @override
  String get transactionNotFound => 'Transaction not found.';

  @override
  String get attachmentsButton => 'Attachments';

  @override
  String get detailDate => 'Date';

  @override
  String get detailType => 'Type';

  @override
  String get detailDestinationWallet => 'Destination wallet';

  @override
  String get detailSender => 'Sender';

  @override
  String get detailReceived => 'Received';

  @override
  String get detailTransferId => 'Transfer ID';

  @override
  String get detailSettlementId => 'Settlement ID';

  @override
  String get detailNotes => 'Notes';

  @override
  String get detailAttachment => 'Attachment';

  @override
  String get none => 'None';

  @override
  String get contactDetailsTitle => 'Contact Details';

  @override
  String get contactNotFound => 'Contact not found.';

  @override
  String get searchContacts => 'Search contacts';

  @override
  String get searchContactsHint => 'Ahmad Kareem';

  @override
  String get addExternalContact => 'Add External Contact';

  @override
  String get registeredContactsSection => 'Registered Users';

  @override
  String get externalContactsSection => 'External Contacts';

  @override
  String get noContactsAvailable => 'No contacts available.';

  @override
  String get contactLinkReady => 'Link-ready';

  @override
  String get createExternalContact => 'Create External Contact';

  @override
  String get saveContact => 'Save Contact';

  @override
  String get contactCreateFailed => 'Failed to create contact.';

  @override
  String get editContact => 'Edit Contact';

  @override
  String get editContactHelper =>
      'Update the contact name, phone number, or note.';

  @override
  String get contactSaveFailed => 'Failed to save contact.';

  @override
  String get openContactProfile => 'Open Contact Profile';

  @override
  String get contactTypePerson => 'Person';

  @override
  String get contactTypeBusiness => 'Business';

  @override
  String get callContact => 'Call Contact';

  @override
  String get whatsAppContact => 'WhatsApp Contact';

  @override
  String get contactFinancialSummaryTitle => 'Financial Summary';

  @override
  String get contactNetBalanceLabel => 'Net Balance';

  @override
  String get contactOpenDebtsTitle => 'Open Debts';

  @override
  String get contactOpenDebtsEmptyTitle => 'No active debts';

  @override
  String get contactOpenDebtsEmptyMessage =>
      'No debts associated with this contact.';

  @override
  String get contactActivityEmptyTitle => 'No recent activity';

  @override
  String get contactActivityEmptyMessage =>
      'Debt activity for this contact will appear here.';

  @override
  String get contactCallUnavailable =>
      'Calling is not available on this device.';

  @override
  String get contactWhatsAppUnavailable =>
      'WhatsApp could not be opened on this device.';

  @override
  String get addContact => 'Add Contact';

  @override
  String get totalContacts => 'Total Contacts';

  @override
  String get peopleLabel => 'People';

  @override
  String get businessesLabel => 'Businesses';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get profileImageLabel => 'Profile Image';

  @override
  String get deleteAction => 'Delete';

  @override
  String get deleteContactTitle => 'Delete Contact?';

  @override
  String get deleteContactMessage => 'This action cannot be undone.';

  @override
  String get contactDeleteFailed => 'Failed to delete contact.';

  @override
  String get contactsEmptyTitle => 'No contacts yet';

  @override
  String get contactsEmptyMessage =>
      'Create your first contact to start tracking debts and financial relationships.';

  @override
  String get noContactsSearchResultsTitle => 'No matching contacts';

  @override
  String get noContactsSearchResultsMessage =>
      'Try another name, phone number, or email.';

  @override
  String get contactNeutralBalance => 'No balance';

  @override
  String get transactionsStatusCompleted => 'Completed';

  @override
  String get transactionsStatusPending => 'Pending';

  @override
  String get transactionsStatusFailed => 'Failed';

  @override
  String get transactionsStatusCancelled => 'Cancelled';
}
