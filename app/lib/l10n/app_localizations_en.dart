// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navPlan => 'Plan';

  @override
  String get navGoals => 'Goals';

  @override
  String get navActivity => 'Activity';

  @override
  String get navProfile => 'Profile';

  @override
  String get currencyTitle => 'Which currency?';

  @override
  String get currencyBlurb =>
      'Everything in your plan is kept in this one. Pick the currency you are actually paid in.';

  @override
  String get currencySearchHint => 'Search country, currency or code';

  @override
  String currencyNoMatch(String query) {
    return 'Nothing matches “$query”. Try the country, or the three-letter code.';
  }

  @override
  String get onboardingBadge => 'Takes about a minute';

  @override
  String get onboardingTitle => 'Set up your plan';

  @override
  String get onboardingBlurb =>
      'Two answers are enough to start. Everything else can wait.';

  @override
  String get onboardingBalanceLabel => 'Your savings today';

  @override
  String get onboardingBalanceHint =>
      'Money you could actually spend from, not what you mean to keep untouched.';

  @override
  String get onboardingIncomeLabel => 'What do you earn in a month?';

  @override
  String get onboardingIncomeHint =>
      'If it varies, give the range. Your plan is built on the lower end.';

  @override
  String get onboardingPayDay => 'When is your next pay?';

  @override
  String onboardingDays(int count) {
    return '$count days';
  }

  @override
  String get onboardingCommitments => 'Add your commitments';

  @override
  String get onboardingCommitmentsOpen => 'Rent, essentials and a goal';

  @override
  String get onboardingCommitmentsShut => 'Optional, and you can do it later';

  @override
  String get onboardingRentLabel => 'Rent and fixed bills';

  @override
  String get onboardingRentHint => 'Due before your next pay';

  @override
  String get onboardingEssentialsLabel => 'Food and transport';

  @override
  String get onboardingEssentialsHint =>
      'What you need to get through the period';

  @override
  String get onboardingGoalLabel => 'Saving toward a goal';

  @override
  String get onboardingGoalHint => 'What you want to put aside this period';

  @override
  String get onboardingFinish => 'Build my plan';

  @override
  String get onboardingIncomplete =>
      'Fill in the first two answers to continue';

  @override
  String get tapToType => 'Tap to type';

  @override
  String get heroSafeToSpend => 'Safe to spend now';

  @override
  String get heroNotUpToDate => 'Not up to date';

  @override
  String get heroRecordSpend => 'Record a spend';

  @override
  String get heroSeeShort => 'See what is short';

  @override
  String get heroConfirmBalance => 'Confirm balance';

  @override
  String get heroReviewBlurb =>
      'Check your balance so this number can be trusted again.';

  @override
  String heroUntilSetAside(String date, String amount) {
    return 'Until $date · $amount set aside';
  }

  @override
  String heroShort(String amount) {
    return '$amount short';
  }

  @override
  String heroUnfunded(String label, String amount) {
    return '$label · $amount unfunded';
  }

  @override
  String get heroBalanceNever => 'Balance not confirmed yet';

  @override
  String get heroBalanceToday => 'Balance confirmed today';

  @override
  String get heroBalanceYesterday => 'Balance confirmed yesterday';

  @override
  String heroBalanceDays(int count) {
    return 'Balance confirmed $count days ago';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get homeTitle => 'Your plan';

  @override
  String homeUntilTotal(String date, String amount) {
    return 'Until $date · $amount in total';
  }

  @override
  String homeRecorded(String amount) {
    return '$amount recorded';
  }

  @override
  String get homeAttention => 'Needs your attention';

  @override
  String homeNotCovered(String amount) {
    return '$amount not covered';
  }

  @override
  String get homeAfterNextPay => 'After your next pay';

  @override
  String homeOncePayArrives(String date) {
    return 'Once your pay arrives on $date';
  }

  @override
  String get homeSetAsideFirst => 'Set aside first';

  @override
  String get homeProtectedBlurb => 'Protected before anything is spendable.';

  @override
  String get homeNothingSetAside =>
      'Nothing is set aside yet. Everything you have is spendable.';

  @override
  String get homeWhyThisNumber => 'Why this number';

  @override
  String get homeWhatIsShort => 'What is short';

  @override
  String get homeShortBlurb =>
      'Nothing here is moved or delayed for you. These are the commitments your current money does not cover.';

  @override
  String get askSpendTitle => 'How much did you spend?';

  @override
  String get askBalanceTitle => 'What is your balance now?';

  @override
  String get askBalanceBlurb =>
      'Any difference is recorded as a correction, never as spending.';

  @override
  String get whyNoChange => 'Nothing has changed since your last plan.';

  @override
  String get whyPayArrived => 'Your pay arrived, so the plan was refreshed.';

  @override
  String get whyBillPaid => 'A bill you had set money aside for was paid.';

  @override
  String get whyHeldForBill =>
      'Money is held back for a bill due just after your next pay.';

  @override
  String get whyOvercommitted =>
      'You have committed to more than you currently have.';

  @override
  String get whyStale => 'Your balance has not been confirmed recently.';

  @override
  String get whyCardLarger =>
      'Your card balance is larger than the money you have.';

  @override
  String get whyPayLate => 'Your expected pay has not arrived yet.';

  @override
  String get whyOverdue => 'Something is past its due date.';

  @override
  String get whyBufferShort => 'Your savings buffer is not fully topped up.';

  @override
  String get whyGoalShort =>
      'Your savings goal cannot be fully funded right now.';

  @override
  String get whyFlexibleLess => 'A flexible goal received less than planned.';

  @override
  String get whyDuplicate => 'A repeated transaction was counted only once.';

  @override
  String get planTitle => 'Plan';

  @override
  String get planBlurb =>
      'What your money is promised to, before anything is spendable.';

  @override
  String get planMoneyAndIncome => 'Money and income';

  @override
  String get planMoneyYouHave => 'Money you have';

  @override
  String get planNextPay => 'Next pay';

  @override
  String get planYourNextPay => 'Your next pay';

  @override
  String get planNotSet => 'Not set';

  @override
  String get planExpectedBlurb =>
      'This is only expected, so it stays out of what you can spend now.';

  @override
  String get planSetAsideFirst => 'Set aside first';

  @override
  String get planNothingSetAside =>
      'Nothing is set aside, so everything you have is spendable.';

  @override
  String get planAddToPlan => 'Add to your plan';

  @override
  String get planGoals => 'Goals';

  @override
  String get planSaveToward => 'Save toward something';

  @override
  String get planSaveTowardSub => 'A trip, a deposit, a replacement laptop';

  @override
  String get planAllGoals => 'All goals';

  @override
  String get planAllGoalsSub => 'Add, edit or put money aside';

  @override
  String get planHowMuchSetAside =>
      'How much do you need to set aside for this?';

  @override
  String get planChangeOrRemove =>
      'Change the amount, or remove it from your plan.';

  @override
  String get planRemove => 'Remove from plan';

  @override
  String planDue(String date) {
    return ' · due $date';
  }

  @override
  String get priorityMandatory => 'Must be paid — comes first';

  @override
  String get priorityEssential => 'Day-to-day needs';

  @override
  String get priorityBuffer => 'Kept back for emergencies';

  @override
  String get priorityCard => 'Already spent on a card';

  @override
  String get prioritySinkingFund => 'Saving for a known bill';

  @override
  String get priorityGoal => 'A goal you have committed to';

  @override
  String get priorityDiscretionary => 'Nice to have — yields first';

  @override
  String get goalsTitle => 'Goals';

  @override
  String get goalsBlurbEmpty => 'Nothing saved toward yet.';

  @override
  String get goalsBlurb => 'What each goal needs from this pay period.';

  @override
  String get goalsEmptyCard =>
      'Add something you are saving for — a trip, a deposit, a replacement laptop. Upino works out what to hold back each pay period so it arrives on time.';

  @override
  String get goalsNew => 'New goal';

  @override
  String get goalsNewSub => 'Something you are putting money aside for';

  @override
  String get goalsAddMoney => 'Add money';

  @override
  String goalsAddTo(String name) {
    return 'Add to $name';
  }

  @override
  String get goalsAddBlurb =>
      'This records what you have put aside. It does not spend anything — it lowers what has to be held back from here on.';

  @override
  String get goalsEachPeriod => 'Each pay period';

  @override
  String get goalsTargetDate => 'Target date';

  @override
  String goalsOf(String amount) {
    return 'of $amount';
  }

  @override
  String goalsPeriodsToGo(int count) {
    return '$count pay periods to go';
  }

  @override
  String get goalsDone => 'Saved in full';

  @override
  String get goalsPausedStatus => 'Paused — nothing held back';

  @override
  String get goalsFlexibleStatus =>
      'Flexible — gives way to anything you must pay';

  @override
  String get goalEditNew => 'What are you saving for?';

  @override
  String get goalEditExisting => 'Edit goal';

  @override
  String get goalName => 'Name';

  @override
  String get goalNameHint => 'A trip, a deposit, a laptop';

  @override
  String get goalTotal => 'How much in total';

  @override
  String get goalByWhen => 'By when';

  @override
  String goalMonths(int count) {
    return '$count mo';
  }

  @override
  String get goalOneYear => '1 year';

  @override
  String get goalTwoYears => '2 years';

  @override
  String get goalFirmness => 'How firm is it?';

  @override
  String get goalKindHard => 'Committed';

  @override
  String get goalKindHardSub => 'Held back before anything is spendable';

  @override
  String get goalKindFlexible => 'Flexible';

  @override
  String get goalKindFlexibleSub => 'Gives way to anything you must pay';

  @override
  String get goalKindPaused => 'Paused';

  @override
  String get goalKindPausedSub => 'Stays visible, nothing held back';

  @override
  String get goalSaveChanges => 'Save changes';

  @override
  String get goalAddThis => 'Add this goal';

  @override
  String get goalDelete => 'Delete this goal';

  @override
  String get activityTitle => 'Activity';

  @override
  String get activityBlurb => 'Everything you have recorded, newest first.';

  @override
  String get activityEmpty =>
      'When you record a spend it will appear here, and you can remove it if you got it wrong.';

  @override
  String get activityRemoveIt => 'Remove it';

  @override
  String get activityKeepIt => 'Keep it';

  @override
  String get activitySpent => 'Spent';

  @override
  String get activityIncome => 'Pay';

  @override
  String get activityCorrection => 'Correction';

  @override
  String get activityRemoved => 'Removed';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileConfirmBalance => 'Confirm your balance';

  @override
  String get profileTrustTitle => 'How trustworthy is the figure?';

  @override
  String get profileTrustFresh => 'Up to date. Nothing needs your attention.';

  @override
  String get profileTrustDegraded =>
      'Your balance has not been confirmed for a while. The figure is still shown, just less certain.';

  @override
  String get profileTrustReview =>
      'Too old or too uncertain to rely on. Confirm your balance to fix it.';

  @override
  String get profileConfirmedNever => 'Not confirmed yet';

  @override
  String get profileConfirmedToday => 'Confirmed today';

  @override
  String get profileConfirmedYesterday => 'Confirmed yesterday';

  @override
  String profileConfirmedDays(int count) {
    return 'Confirmed $count days ago';
  }

  @override
  String get profileAppearance => 'Appearance';

  @override
  String get profileTheme => 'Theme';

  @override
  String get profileThemeBlurb =>
      'Following your phone is the default, so nothing is imposed.';

  @override
  String get themePhone => 'Phone';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileLanguageBlurb =>
      'Following your phone is the default, so nothing is imposed.';

  @override
  String get languagePhone => 'Phone';

  @override
  String get profileCurrency => 'Currency';

  @override
  String currencyChangeTitle(String currency) {
    return 'Switch to $currency?';
  }

  @override
  String currencyChangeBlurb(String currency) {
    return 'Every amount in your plan keeps its number and is shown in $currency from now on. Nothing is converted at an exchange rate, so use this to correct the currency, not to convert your money.';
  }

  @override
  String get currencyChangeConfirm => 'Switch';

  @override
  String get profileYourData => 'Your data';

  @override
  String get profileDelete => 'Delete my plan';

  @override
  String get profileDeleteSub => 'Clears everything and returns to setup';

  @override
  String get profileStartOver => 'Start over?';

  @override
  String get profileStartOverBlurb =>
      'Your plan and everything you recorded are deleted. This cannot be undone.';

  @override
  String get profileDeleteEverything => 'Delete everything';

  @override
  String get profileKeepPlan => 'Keep my plan';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String activityRemoveAmount(String amount) {
    return 'Remove $amount?';
  }

  @override
  String get activityRemoveDetail =>
      'It stops counting toward your plan straight away. The entry stays on this list marked as removed, so your record is still complete.';

  @override
  String get activityCardPurchase => 'Card purchase';

  @override
  String get activityCardPayment => 'Card payment';

  @override
  String get activityRefund => 'Refund';

  @override
  String get activityTransfer => 'Moved between accounts';

  @override
  String get activityLoan => 'Loan received';

  @override
  String get activityDebtPayment => 'Debt payment';

  @override
  String get activityBalanceCorrected => 'Balance corrected';

  @override
  String get activityBlurbEmpty => 'Nothing recorded yet.';

  @override
  String get profileStartAgain => 'Start again';

  @override
  String get claimRent => 'Rent and bills';

  @override
  String get claimCardMinimum => 'Card minimum due';

  @override
  String get claimEssentials => 'Food and transport';

  @override
  String get claimBuffer => 'Emergency buffer';

  @override
  String get languageTitle => 'Which language?';

  @override
  String get languageBlurb => 'You can change this later in Profile.';

  @override
  String get profileLedgerTitle => 'Is the record complete?';

  @override
  String get ledgerComplete => 'Everything you have spent is recorded.';

  @override
  String get ledgerPartial =>
      'Some spending was found only when you confirmed your balance.';

  @override
  String get ledgerUnknown =>
      'Upino cannot tell how much is missing. Confirm your balance to find out.';

  @override
  String get askTitle => 'Ask before you spend';

  @override
  String get askBlurb =>
      'Try a purchase against your plan. Nothing is recorded and nothing changes.';

  @override
  String get askAmountLabel => 'How much would it be?';

  @override
  String get askRun => 'See what it would do';

  @override
  String get askDoNotBuy => 'Do not buy';

  @override
  String get askBuyNow => 'Buy it today';

  @override
  String askBuyAfter(String date) {
    return 'Buy it after $date';
  }

  @override
  String get askUnchanged => 'Your plan stays as it is.';

  @override
  String get askStsAfter => 'Safe to spend afterwards';

  @override
  String get askBreaks => 'This leaves something you must pay unfunded.';

  @override
  String get askSafe => 'Nothing you must pay is left unfunded.';

  @override
  String get askCosts => 'What gets less';

  @override
  String askCostLine(String label, String amount) {
    return '$label · $amount less';
  }

  @override
  String get askWaitingHelps =>
      'Waiting until your pay arrives covers everything.';

  @override
  String get askNoIncome =>
      'No pay is expected yet, so there is nothing later to compare against.';

  @override
  String askAssumption(String date) {
    return 'Assumes your pay arrives as expected on $date.';
  }

  @override
  String get askNoVerdict =>
      'Upino does not say yes or no. The trade-off is yours.';

  @override
  String get receipt => 'Receipt';

  @override
  String get receiptAdd => 'Add a receipt';

  @override
  String get receiptCamera => 'Take a photo';

  @override
  String get receiptGallery => 'Choose a photo';

  @override
  String get receiptAttached => 'Receipt attached';

  @override
  String get receiptRemove => 'Remove the photo';

  @override
  String get onboardingIncomeFrom => 'At least';

  @override
  String get onboardingIncomeTo => 'Up to';

  @override
  String get onboardingIncomeToOptional => 'Optional';

  @override
  String incomeRange(String low, String high) {
    return '$low to $high';
  }

  @override
  String incomeRangeNote(String low) {
    return 'Your plan is built on $low. Anything above it is yours when it arrives.';
  }

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryBills => 'Bills';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryFun => 'Going out';

  @override
  String get categoryOther => 'Other';

  @override
  String get categoryUnsorted => 'Not sorted';

  @override
  String get categoryPrompt => 'What was it for?';

  @override
  String get spendingTitle => 'Where it went';

  @override
  String get spendingWindow => 'Spends recorded in the last 30 days';

  @override
  String get backupSection => 'Backup';

  @override
  String get backupSave => 'Save a backup';

  @override
  String get backupSaveSub =>
      'Locked with a password. Send it somewhere safe, like your cloud drive.';

  @override
  String get backupRestore => 'Restore from a backup';

  @override
  String get backupRestoreSub => 'Replaces the plan on this phone';

  @override
  String get backupPassword => 'Password';

  @override
  String get backupPasswordRepeat => 'Repeat the password';

  @override
  String get backupPasswordSaveBlurb =>
      'You will need this password to restore the backup. It cannot be recovered if you forget it. Receipt photos are not included.';

  @override
  String get backupPasswordOpenBlurb =>
      'The password this backup was saved with.';

  @override
  String get backupPasswordShort => 'At least 6 characters';

  @override
  String get backupPasswordMismatch => 'The two do not match';

  @override
  String get backupOpen => 'Open';

  @override
  String get backupReplaceTitle => 'Replace this plan?';

  @override
  String get backupReplaceBlurb =>
      'Everything on this phone is replaced by what is in the backup. This cannot be undone.';

  @override
  String get backupReplace => 'Replace';

  @override
  String get backupRestored => 'Backup restored';

  @override
  String get backupWrongPassword => 'That password does not open this backup.';

  @override
  String get backupNotABackup => 'That file is not an Upino backup.';

  @override
  String get backupUnreadable =>
      'This backup was made by a newer version of Upino. Update the app and try again.';

  @override
  String get inflationTitle => 'Inflation';

  @override
  String get inflationNotSet =>
      'Not set. Add the yearly rate where you live to see what goals will really cost.';

  @override
  String inflationRate(String rate) {
    return '$rate% a year';
  }

  @override
  String get inflationDialogTitle => 'Yearly inflation';

  @override
  String get inflationDialogBlurb =>
      'Prices rise, so a goal set in today\'s money costs more on its date. Enter the rate you expect. Leave it empty to turn this off.';

  @override
  String goalsInflated(String rate, String amount) {
    return 'At $rate% a year, this will cost about $amount by then.';
  }

  @override
  String get holdingsTitle => 'Other holdings';

  @override
  String get holdingsBlurb =>
      'Dollars, gold, coins. Shown beside your plan and never counted in what you can spend.';

  @override
  String get holdingsAdd => 'Add a holding';

  @override
  String get holdingsAddSub => 'Not counted in what you can spend';

  @override
  String get holdingsTotal => 'Together';

  @override
  String holdingSummary(String quantity, String price, String date) {
    return '$quantity × $price · priced $date';
  }

  @override
  String get holdingEditNew => 'New holding';

  @override
  String get holdingEditExisting => 'Change holding';

  @override
  String get holdingName => 'What is it?';

  @override
  String get holdingNameHint => 'US dollar, gold…';

  @override
  String get holdingUsd => 'US dollar';

  @override
  String get holdingEur => 'Euro';

  @override
  String get holdingGold => 'Gold (gram)';

  @override
  String get holdingCoin => 'Gold coin';

  @override
  String get holdingQuantity => 'How many';

  @override
  String get holdingUnitPrice => 'What one is worth today';

  @override
  String holdingWorth(String amount) {
    return 'Worth $amount together';
  }

  @override
  String get holdingDelete => 'Remove this holding';

  @override
  String get fasterTitle => 'Faster entry';

  @override
  String get smsTitle => 'Read bank messages';

  @override
  String get smsDetail =>
      'Spends your bank texts you about are offered to record with one tap. Messages are read on this phone only and never sent anywhere.';

  @override
  String get smsDenied =>
      'Upino was not allowed to read messages. You can allow it in the phone\'s settings.';

  @override
  String smsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bank messages to review',
      one: '1 bank message to review',
    );
    return '$_temp0';
  }

  @override
  String get smsWaitingSub => 'Record each with one tap, or skip it';

  @override
  String get smsReviewTitle => 'From your bank';

  @override
  String get smsReviewBlurb =>
      'Nothing is recorded until you tap Record. Check the amount against the message.';

  @override
  String get smsReviewDone => 'All caught up.';

  @override
  String get smsRecord => 'Record';

  @override
  String get smsSkip => 'Skip';

  @override
  String get reminderTitleSetting => 'Evening reminder';

  @override
  String get reminderDetail =>
      'At 9 in the evening, only on days nothing was recorded.';

  @override
  String get reminderDenied =>
      'Upino was not allowed to show notifications. You can allow it in the phone\'s settings.';

  @override
  String get reminderTitle => 'Anything spent today?';

  @override
  String get reminderBody =>
      'Record it in a few seconds, so tomorrow\'s figure is right.';

  @override
  String get reminderChannel => 'Evening reminder';

  @override
  String get widgetSpend => '+ Spend';

  @override
  String get widgetAdd => 'Add to home screen';

  @override
  String get widgetAddSub =>
      'What you can spend, and a button to record a spend, without opening the app';

  @override
  String get voiceListening => 'Listening… say the amount and what it was for.';

  @override
  String voiceHeard(String text) {
    return 'Heard: “$text”. Check the amount, then save.';
  }

  @override
  String get voiceNothing => 'No amount heard. Try again, or type it.';

  @override
  String get voicePrivacy =>
      'Your phone turns speech into text. On phones without offline speech, that goes through the phone\'s speech service.';
}
