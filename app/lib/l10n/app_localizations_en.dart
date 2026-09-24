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

  @override
  String get voiceButton => 'Say it';

  @override
  String get voiceUnavailable =>
      'This phone has no speech recognition the app can use. Type the amount instead.';

  @override
  String get voiceNoPermission =>
      'Upino was not allowed to use the microphone. You can allow it in the phone\'s settings.';

  @override
  String get voiceNetwork =>
      'Speech recognition on this phone needs the internet and could not reach it.';

  @override
  String voiceNoAmount(String text) {
    return 'Heard “$text”, but no amount in it. Try again, or type it.';
  }

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get navAsk => 'Ask';

  @override
  String get alertsTitle => 'Needs you';

  @override
  String get alertsEmpty =>
      'Nothing needs you right now. The plan is up to date.';

  @override
  String alertUnfunded(String label, String amount) {
    return '$label is $amount short';
  }

  @override
  String get alertUnfundedDetail =>
      'Something you must pay is not covered by what you have.';

  @override
  String alertIncomeLate(String date) {
    return 'Your pay was expected on $date';
  }

  @override
  String get alertIncomeLateDetail =>
      'It is not counted until it arrives. Change the date on Plan if it moved.';

  @override
  String alertGoalBehind(String name, String amount) {
    return '$name is $amount behind this period';
  }

  @override
  String get alertGoalBehindDetail =>
      'What you have does not reach this period\'s share of the goal.';

  @override
  String get chatHint => 'Ask me anything, or type a price';

  @override
  String get chatSuggestSafe => 'How much can I spend?';

  @override
  String get chatSuggestPay => 'When is my next pay?';

  @override
  String get chatSuggestWhere => 'Where did my money go?';

  @override
  String get chatSuggestAside => 'What is set aside?';

  @override
  String chatSafe(String amount, String date) {
    return 'You can spend $amount until $date.';
  }

  @override
  String get chatSafeStale =>
      'One thing: your balance needs confirming, so treat this as an estimate.';

  @override
  String chatPay(String amount, String date) {
    return 'Your next pay is $amount, expected on $date.';
  }

  @override
  String get chatPayNone =>
      'I don\'t know your next pay yet. Add it on Plan and I\'ll keep an eye on it.';

  @override
  String get chatWhere => 'Here\'s where it went in the last 30 days:';

  @override
  String get chatWhereNone =>
      'No spends in the last 30 days. Either it\'s been a quiet month or they haven\'t been recorded.';

  @override
  String chatAside(String amount) {
    return '$amount is set aside before anything counts as spendable:';
  }

  @override
  String chatPurchase(String amount) {
    return 'Let\'s see what $amount would do.';
  }

  @override
  String get chatHelp =>
      'Hmm, I didn\'t quite get that. I can tell you how much you can spend, when your pay comes, where your money went, what\'s set aside, or how to spend less. Or type a price, like “a phone for 20 million”, and I\'ll show you what buying it would do.';

  @override
  String get chatHelloNew =>
      'Hi! I\'m Upino. You\'re new here, so I only know the basics so far: your balance, your pay and what you set aside. That\'s already enough to tell you what you can spend and what a purchase would do. Keep recording your spends and after about a season I\'ll know your habits well enough to be your own money adviser.';

  @override
  String chatHelloLearning(int days, int spends, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    String _temp1 = intl.Intl.pluralLogic(
      spends,
      locale: localeName,
      other: '$spends spends',
      one: '1 spend',
    );
    return 'Welcome back! I\'ve been learning from $_temp0 and $_temp1 so far. About $remaining more days and I\'ll have a full season to go on.';
  }

  @override
  String chatHelloFamiliar(int days) {
    return 'Welcome back! I\'ve seen $days days of your money now, so ask me anything, including how to spend less.';
  }

  @override
  String chatHelloAlerts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count things need you',
      one: 'one thing needs you',
    );
    return 'By the way, $_temp0: it\'s under the bell.';
  }

  @override
  String chatPurchaseFits(String left) {
    return 'Buying it today keeps everything you must pay covered, with $left still spare.';
  }

  @override
  String chatPurchaseWait(String date) {
    return 'Buying it today would leave something you must pay short. If you wait until $date, everything is covered.';
  }

  @override
  String chatPurchaseStillShort(String date) {
    return 'Heads up: even after your pay on $date, this would leave something you must pay short.';
  }

  @override
  String get chatPurchaseShort =>
      'Buying it today would leave something you must pay short.';

  @override
  String chatSafeNothing(String date) {
    return 'Right now there\'s nothing spare until $date: everything you have is already promised to something you must pay.';
  }

  @override
  String chatPayIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'in $days days',
      one: 'in a day',
    );
    return 'That\'s $_temp0.';
  }

  @override
  String get chatPayLate =>
      'It\'s late, so it isn\'t counted until you confirm it has arrived.';

  @override
  String get chatPayRange =>
      'Your plan counts on the lower end, so a good month is a bonus, not a hole.';

  @override
  String chatWhereSoFar(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return 'I\'ve only seen $_temp0 so far, so this is a first look:';
  }

  @override
  String chatWhereTop(String category, int share) {
    return '$category is the biggest: $share% of it.';
  }

  @override
  String get chatWhereTooSoon =>
      'It\'s a bit early for that: I\'ve barely seen any spending yet. Record a few and ask me again next week.';

  @override
  String get chatAdviceTooSoon =>
      'I\'d love to help with that, but honestly I don\'t know your spending well enough yet, and advice without it would just be a guess. Record your spends (sorting them helps a lot) and ask me again in a few weeks.';

  @override
  String chatAdviceBiggest(String category, String amount, String tenth) {
    return 'Your biggest spend in the last 30 days was $category, at $amount. Trimming it by a tenth would free about $tenth a month.';
  }

  @override
  String get chatAdviceSort =>
      'I can see what you spend but not what it\'s on. Give your spends a category when you record them and I can tell you where to trim.';

  @override
  String chatAdviceMore(String amount) {
    return 'You spent $amount more than the month before.';
  }

  @override
  String chatAdviceLess(String amount) {
    return 'Nice: that\'s $amount less than the month before.';
  }

  @override
  String get chatAdviceLearning =>
      'I\'m still learning your habits, so take this as a first hint rather than the full picture.';

  @override
  String get chatSmallHello =>
      'Hi! What would you like to know about your money?';

  @override
  String get chatSmallThanks =>
      'Any time! I\'m here whenever you\'re about to spend.';

  @override
  String get chatSmallWho =>
      'I\'m Upino\'s assistant. I only know what\'s in your plan, and every number I give comes straight from it; nothing you tell me leaves this phone. I won\'t tell you yes or no, but I\'ll show you what each choice would leave you.';

  @override
  String get chatSuggestAdvice => 'How can I spend less?';

  @override
  String get chatTitle => 'Upino';

  @override
  String get chatNew => 'New chat';

  @override
  String get chatResumed =>
      'Answers here are worked out from your plan as it is today.';

  @override
  String get chatWhy => 'Here\'s how the figure comes about:';

  @override
  String get chatWhyHave => 'What you have';

  @override
  String get chatWhySetAside => 'Set aside first';

  @override
  String get chatWhyLeft => 'Safe to spend';

  @override
  String get chatSmallHowAreYou =>
      'I\'m good, thanks for asking! Your money\'s where I left it. What would you like to know?';

  @override
  String get chatSmallBye => 'Bye! Come back before your next big spend.';

  @override
  String get chatSmallOkay => 'Anything else you\'d like to check?';

  @override
  String get askHubTitle => 'Talk to Upino';

  @override
  String get askHubNew =>
      'Ask what you can spend, what a purchase would do, or when your pay comes. I\'m still getting to know you, so I\'ll get more useful as you record.';

  @override
  String askHubLearning(int days) {
    return 'I\'m learning your habits: about $days more days and I\'ll have a full season to advise from.';
  }

  @override
  String get askHubFamiliar =>
      'I know your money well now. Ask me anything, including how to spend less.';

  @override
  String get askHubStart => 'Start a conversation';

  @override
  String get askHubCommon => 'Common questions';

  @override
  String get askHubHistory => 'Your conversations';

  @override
  String askHubTurns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
    );
    return '$_temp0';
  }

  @override
  String askHubAsidePreview(String amount, int count) {
    return '$amount set aside across $count commitments';
  }

  @override
  String get askHubDeleteTitle => 'Delete this conversation?';

  @override
  String get askHubDeleteBlurb =>
      'Only the conversation goes. Nothing in your plan changes.';

  @override
  String get chatSmallHi => 'Hi!';

  @override
  String get chatSmallHiFine => 'Hi! I\'m good, thanks.';

  @override
  String chatSafeLasts(int days) {
    return 'That has to last $days days, until your pay.';
  }

  @override
  String homeSpokenFor(String amount, String date) {
    return '$amount of your money is already spoken for until $date.';
  }

  @override
  String askGoalLater(String goal, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: 'a day',
    );
    return '$goal · about $_temp0 later';
  }

  @override
  String get askGoalsTitle => 'Goals move later';

  @override
  String get askGoalsNote =>
      'Roughly, at the pace each goal is being saved for.';

  @override
  String chatPurchaseGoal(String goal, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: 'a day',
    );
    return 'It would push $goal back by about $_temp0.';
  }

  @override
  String get monthTitle => 'Your month';

  @override
  String get monthWindow => 'The last 30 days, against the 30 before';

  @override
  String monthTooSoon(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: 'a day',
    );
    return 'A month review needs a month of spending. Yours is ready in $_temp0.';
  }

  @override
  String monthSpent(String amount) {
    return 'In the last 30 days, $amount went out.';
  }

  @override
  String get monthNothing => 'Nothing was recorded in the last 30 days.';

  @override
  String monthMore(String amount) {
    return 'That is $amount more than the 30 days before.';
  }

  @override
  String monthLess(String amount) {
    return 'That is $amount less than the 30 days before.';
  }

  @override
  String get monthSame => 'About the same as the 30 days before.';

  @override
  String monthUp(String category, String amount) {
    return 'Up the most: $category, by $amount.';
  }

  @override
  String monthDown(String category, String amount) {
    return 'Down the most: $category, by $amount.';
  }

  @override
  String monthGoals(int onTrack, int total) {
    return 'Goals on track: $onTrack of $total.';
  }

  @override
  String get chatSuggestMonth => 'How was my month?';

  @override
  String get timelineTitle => 'Your money ahead';

  @override
  String get timelineToday => 'Today';

  @override
  String get timelineNow => 'Now';

  @override
  String get timelineProjected => 'Projected';

  @override
  String get timelineRecorded => 'Recorded';

  @override
  String get timelineFree => 'Free to spend';

  @override
  String get timelineHad => 'You had';

  @override
  String timelineBalance(String amount) {
    return 'Balance $amount';
  }

  @override
  String timelineSetAside(String amount) {
    return 'Set aside $amount';
  }

  @override
  String timelinePayMark(String amount) {
    return 'Pay $amount';
  }

  @override
  String timelineShort(String amount) {
    return '$amount short for something that must be paid';
  }

  @override
  String timelineWithout(String amount) {
    return 'Without it: $amount';
  }

  @override
  String get timelineBuyAfterPay => 'Buy after pay';

  @override
  String get timelineBalanceLegend => 'Balance';

  @override
  String get timelineWithPurchase => 'With the purchase';

  @override
  String get timelinePay => 'Pay day';

  @override
  String get timelineAssumptions =>
      'Ahead is a projection: your pay on its date, bills on theirs, what is set aside for living spent evenly, and nothing else. Drag across the chart to see any day.';

  @override
  String get timelineSemantics =>
      'Chart of your balance and what is free to spend, day by day';

  @override
  String goalChartSemantics(String goal) {
    return 'Chart of how $goal gets to its target';
  }

  @override
  String goalChartTarget(String amount, String date) {
    return 'Target $amount by $date';
  }

  @override
  String goalPaceLabel(String amount) {
    return 'Put aside each pay period: $amount';
  }

  @override
  String goalOnTrack(String date) {
    return 'On track: reached by $date.';
  }

  @override
  String goalLate(String date, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: 'a day',
    );
    return 'At this pace it is reached on $date, $_temp0 after its date.';
  }

  @override
  String get goalNotMoving =>
      'Nothing is going to it right now, so it is not getting closer.';

  @override
  String goalUsePace(String date) {
    return 'Move the target date to $date';
  }

  @override
  String get goalPaceNote =>
      'Only a what-if: nothing changes until you choose.';

  @override
  String get goalShowPath => 'See how it gets there';

  @override
  String get goalHidePath => 'Hide';

  @override
  String get billsTitle => 'Bills and subscriptions';

  @override
  String get billAdd => 'Add a bill or subscription';

  @override
  String get billAddSub =>
      'Phone, internet, insurance, streaming… each is set aside before its date.';

  @override
  String get billEditNew => 'New bill';

  @override
  String get billEditExisting => 'Change this bill';

  @override
  String get billName => 'What is it?';

  @override
  String get billNameHint => 'e.g. Internet';

  @override
  String get billAmount => 'Each payment';

  @override
  String get billEvery => 'How often';

  @override
  String get billEveryWeek => 'Weekly';

  @override
  String get billEveryMonth => 'Monthly';

  @override
  String get billEveryQuarter => 'Quarterly';

  @override
  String get billEveryYear => 'Yearly';

  @override
  String get billNext => 'Next payment';

  @override
  String get billKind => 'It is a';

  @override
  String get billKindBill => 'Bill';

  @override
  String get billKindSubscription => 'Subscription';

  @override
  String get billRepays => 'Repays';

  @override
  String get billRepaysNothing => 'Nothing, it is a cost';

  @override
  String get billAddThis => 'Add this bill';

  @override
  String get billDelete => 'Delete this bill';

  @override
  String billRow(String every, String date) {
    return '$every · next $date';
  }

  @override
  String billOverdue(String date) {
    return 'Was due $date';
  }

  @override
  String get billPay => 'Mark as paid';

  @override
  String get billEdit => 'Change it';

  @override
  String get dayToday => 'Today';

  @override
  String dayIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'In $days days',
      one: 'In a day',
    );
    return '$_temp0';
  }

  @override
  String dayAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days ago',
      one: 'A day ago',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'Coming up';

  @override
  String homeComingUpTotal(String amount) {
    return '$amount in bills due in the next 30 days.';
  }

  @override
  String payDueTitle(String date) {
    return 'Your pay was due $date. Has it come?';
  }

  @override
  String get payDueSub =>
      'Say what arrived, and the next pay is expected a period later.';

  @override
  String get payArrived => 'It came';

  @override
  String get payArrivedTitle => 'How much arrived?';

  @override
  String get planRecordPay => 'Pay arrived';

  @override
  String get planRecordPaySub =>
      'Record it, and the next one moves a period on';

  @override
  String get accountsTitle => 'Accounts';

  @override
  String get accountMain => 'Main account';

  @override
  String get accountKindBank => 'Bank account';

  @override
  String get accountKindCash => 'Cash';

  @override
  String get accountKindSavings => 'Savings';

  @override
  String get accountKindCard => 'Credit card';

  @override
  String get accountKindLoan => 'Loan';

  @override
  String get accountAdd => 'Add an account';

  @override
  String get accountAddSub =>
      'Cash, savings, a card or a loan. No bank connection needed.';

  @override
  String get accountEditNew => 'New account';

  @override
  String get accountNameHint => 'e.g. Wallet';

  @override
  String get accountHolds => 'What it holds now';

  @override
  String get accountOwes => 'What is owed now';

  @override
  String get accountCounted => 'Count it in the plan';

  @override
  String get accountCountedSub => 'Money here can be spent this month.';

  @override
  String accountOwed(String amount) {
    return 'Owed $amount';
  }

  @override
  String get accountNotCounted => 'Not counted in the plan';

  @override
  String get accountConfirm => 'Say what it really holds';

  @override
  String get accountMove => 'Move money';

  @override
  String accountMoveTo(String name) {
    return 'Move to $name';
  }

  @override
  String get accountMoveBlurb =>
      'Moving money between your own accounts is neither spending nor income.';

  @override
  String get accountPayCard => 'Pay off some of it';

  @override
  String get accountPayBlurb =>
      'Paid from the main account. It settles what is owed; it is not a second spend.';

  @override
  String get accountRemove => 'Remove this account';

  @override
  String get accountInUse =>
      'It has history, so it stays. You can stop counting it instead.';

  @override
  String get paidFrom => 'Paid from';

  @override
  String get categorySuggested =>
      'Suggested from your past spends. Tap another to change it.';

  @override
  String get recoverTitle => 'Money coming back';

  @override
  String recoverTotal(String amount) {
    return '$amount may come back. It is not counted until it arrives.';
  }

  @override
  String get recoverReturnable => 'Can be returned';

  @override
  String get recoverExpect => 'Returned, refund expected';

  @override
  String get recoverArrived => 'Refund arrived';

  @override
  String get recoverKept => 'Kept it';

  @override
  String get recoverPending => 'Refund on its way';

  @override
  String get recoverRefunded => 'Refunded';

  @override
  String get recoverPrompt => 'Getting money back';

  @override
  String recoverWhere(String amount) {
    return '$amount came back. Where should it go?';
  }

  @override
  String recoverToGoal(String goal) {
    return 'Toward $goal';
  }

  @override
  String get recoverToBuffer => 'Into the emergency buffer';

  @override
  String get recoverLeave => 'Leave it free to spend';

  @override
  String get accountStopCounting => 'Stop counting it in the plan';

  @override
  String get moveTitle => 'Best move';

  @override
  String get moveTagMove => 'Move';

  @override
  String get moveTagWait => 'Wait';

  @override
  String get moveTagSave => 'Save';

  @override
  String get moveTagSpend => 'Spend';

  @override
  String moveMove(String amount, String account) {
    return 'Move $amount from $account to cover what must be paid.';
  }

  @override
  String moveMoveWhy(String claim) {
    return '$claim is short, and this money is sitting outside the plan.';
  }

  @override
  String get moveDoIt => 'Move it';

  @override
  String moveWaitGap(String date, String amount) {
    return 'Hold back on extras: on $date, something that must be paid would be $amount short.';
  }

  @override
  String get moveWaitGapWhy =>
      'The projection counts your pay, bills and living costs up to that day.';

  @override
  String moveWaitPay(int days, String now, String later) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: 'a day',
    );
    return 'Your pay is $_temp0 away. Waiting for it turns $now of room into $later.';
  }

  @override
  String get moveWaitPayWhy =>
      'Only if what you have in mind can wait. Nothing is at risk either way.';

  @override
  String moveSave(String amount, String account, String goal) {
    return 'Move $amount to $account for $goal.';
  }

  @override
  String moveSaveWhy(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: 'a day',
    );
    return 'It gets there about $_temp0 sooner, and what stays free is still twice your usual month.';
  }

  @override
  String moveSpend(String amount, String date) {
    return 'You\'re covered until $date: $amount is free to use.';
  }

  @override
  String get moveSpendWhy =>
      'Bills and goals are already set aside, nothing ahead comes up short, and this is well above your usual spending.';

  @override
  String get moveNotNow => 'Not now';

  @override
  String get moveNone =>
      'There is no move worth suggesting right now. Your plan stands as it is.';

  @override
  String monthIncome(String amount) {
    return 'Pay that came in: $amount.';
  }

  @override
  String monthToGoals(String amount) {
    return 'Put toward goals: $amount.';
  }

  @override
  String monthNow(String free, String aside) {
    return 'Now: $free free to spend, $aside set aside.';
  }

  @override
  String get monthAheadTitle => 'The next 30 days';

  @override
  String monthAheadBills(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bills come to $amount.',
      one: 'One bill comes to $amount.',
    );
    return '$_temp0';
  }

  @override
  String monthAheadPay(String date) {
    return 'Your next pay is expected $date.';
  }

  @override
  String monthAheadTightest(String date, String amount) {
    return 'The tightest day is $date, with $amount free.';
  }

  @override
  String monthAheadShort(String date, String amount) {
    return 'On $date, something that must be paid would be $amount short.';
  }

  @override
  String get monthWorthKnowing => 'Worth knowing';

  @override
  String insightUp(String category, String amount) {
    return '$category is up $amount on the month before.';
  }

  @override
  String insightGoal(int days, String goal) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: 'a day',
    );
    return 'Kept up, that is about $_temp0 of $goal every month.';
  }

  @override
  String get chatSuggestMove => 'What should I do next?';

  @override
  String get chatSuggestComing => 'What bills are coming up?';

  @override
  String get chatComingNone =>
      'No bills are due in the next 30 days. Add the ones you pay on Plan and I\'ll keep track of them.';

  @override
  String get quickAsk => 'Ask';

  @override
  String get quickPay => 'Pay came';

  @override
  String get quickBills => 'Bills';

  @override
  String get quickMonth => 'My month';

  @override
  String get quickPayDue => 'Your pay is due. Say whether it came.';

  @override
  String get chartAvg => 'Avg';

  @override
  String get flowsTitle => 'Money in and out';

  @override
  String get flowsBlurb =>
      'Week by week: pay and refunds above the line, spending and repayments below.';

  @override
  String flowsWeek(String date) {
    return 'Week of $date';
  }

  @override
  String flowsInOut(String moneyIn, String moneyOut) {
    return 'In $moneyIn · Out $moneyOut';
  }

  @override
  String get balanceHistoryTitle => 'Your balance over time';

  @override
  String rangeMonths(int count) {
    return '${count}M';
  }

  @override
  String get rangeYear => '1Y';

  @override
  String get weekSpentTitle => 'Last 7 days';

  @override
  String weekSpentTotal(String amount) {
    return '$amount spent';
  }

  @override
  String get payGaugeTitle => 'Until your next pay';

  @override
  String payGaugeDaysLabel(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'days to go',
      one: 'day to go',
    );
    return '$_temp0';
  }

  @override
  String payGaugeAfter(String date, String amount) {
    return 'After your pay on $date: $amount free';
  }

  @override
  String payGaugeLasts(String amount) {
    return '$amount has to last until then.';
  }

  @override
  String get goalsOverall => 'of all your goals';

  @override
  String goalsThisMonth(String amount) {
    return '+$amount this month';
  }

  @override
  String get goalsNothingThisMonth => 'Nothing added this month';

  @override
  String get goalsAllOnTrack => 'All on track';

  @override
  String goalsOnTrackCount(int onTrack, int total) {
    return '$onTrack of $total on track';
  }

  @override
  String goalsNextUp(String goal, String date) {
    return 'Next: $goal, $date';
  }

  @override
  String get goalsTips => 'Ways to get there sooner';

  @override
  String get goalsTipsSub => 'Ask Upino, from your own spending';

  @override
  String get goalsDetailTitle => 'Each goal';

  @override
  String get demoTry => 'Try it with sample data';

  @override
  String get demoTrySub =>
      'Four goals, bills and three months of history, in a copy that is not yours and is not saved.';

  @override
  String get demoBanner => 'Sample data: nothing here is yours or saved.';

  @override
  String get demoExit => 'Exit';

  @override
  String get demoGoalTrip => 'Trip';

  @override
  String get demoGoalLaptop => 'Laptop';

  @override
  String get demoGoalEmergency => 'Emergency';

  @override
  String get demoGoalCar => 'Car';

  @override
  String get demoBillPhone => 'Phone';

  @override
  String get demoBillInternet => 'Internet';

  @override
  String get demoBillGym => 'Gym';

  @override
  String get voiceExample => 'For example: “twelve fifty, lunch”';

  @override
  String get voiceTitleListening => 'Listening';

  @override
  String get voiceTitleHeard => 'Heard you';

  @override
  String get voiceTitleFailed => 'Didn\'t catch that';

  @override
  String get voiceStop => 'Stop';

  @override
  String get voiceRetry => 'Again';
}
