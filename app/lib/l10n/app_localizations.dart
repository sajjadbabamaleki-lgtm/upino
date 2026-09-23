import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('es'),
    Locale('fa'),
    Locale('fr'),
    Locale('hi'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh')
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get navPlan;

  /// No description provided for @navGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get navGoals;

  /// No description provided for @navActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get navActivity;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @currencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Which currency?'**
  String get currencyTitle;

  /// No description provided for @currencyBlurb.
  ///
  /// In en, this message translates to:
  /// **'Everything in your plan is kept in this one. Pick the currency you are actually paid in.'**
  String get currencyBlurb;

  /// No description provided for @currencySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search country, currency or code'**
  String get currencySearchHint;

  /// No description provided for @currencyNoMatch.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches “{query}”. Try the country, or the three-letter code.'**
  String currencyNoMatch(String query);

  /// No description provided for @onboardingBadge.
  ///
  /// In en, this message translates to:
  /// **'Takes about a minute'**
  String get onboardingBadge;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your plan'**
  String get onboardingTitle;

  /// No description provided for @onboardingBlurb.
  ///
  /// In en, this message translates to:
  /// **'Two answers are enough to start. Everything else can wait.'**
  String get onboardingBlurb;

  /// No description provided for @onboardingBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'How much do you have right now?'**
  String get onboardingBalanceLabel;

  /// No description provided for @onboardingBalanceHint.
  ///
  /// In en, this message translates to:
  /// **'Across the accounts you spend from'**
  String get onboardingBalanceHint;

  /// No description provided for @onboardingIncomeLabel.
  ///
  /// In en, this message translates to:
  /// **'How much is your next pay?'**
  String get onboardingIncomeLabel;

  /// No description provided for @onboardingIncomeHint.
  ///
  /// In en, this message translates to:
  /// **'Your usual amount is fine'**
  String get onboardingIncomeHint;

  /// No description provided for @onboardingPayDay.
  ///
  /// In en, this message translates to:
  /// **'When is your next pay?'**
  String get onboardingPayDay;

  /// No description provided for @onboardingDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String onboardingDays(int count);

  /// No description provided for @onboardingCommitments.
  ///
  /// In en, this message translates to:
  /// **'Add your commitments'**
  String get onboardingCommitments;

  /// No description provided for @onboardingCommitmentsOpen.
  ///
  /// In en, this message translates to:
  /// **'Rent, essentials and a goal'**
  String get onboardingCommitmentsOpen;

  /// No description provided for @onboardingCommitmentsShut.
  ///
  /// In en, this message translates to:
  /// **'Optional, and you can do it later'**
  String get onboardingCommitmentsShut;

  /// No description provided for @onboardingRentLabel.
  ///
  /// In en, this message translates to:
  /// **'Rent and fixed bills'**
  String get onboardingRentLabel;

  /// No description provided for @onboardingRentHint.
  ///
  /// In en, this message translates to:
  /// **'Due before your next pay'**
  String get onboardingRentHint;

  /// No description provided for @onboardingEssentialsLabel.
  ///
  /// In en, this message translates to:
  /// **'Food and transport'**
  String get onboardingEssentialsLabel;

  /// No description provided for @onboardingEssentialsHint.
  ///
  /// In en, this message translates to:
  /// **'What you need to get through the period'**
  String get onboardingEssentialsHint;

  /// No description provided for @onboardingGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Saving toward a goal'**
  String get onboardingGoalLabel;

  /// No description provided for @onboardingGoalHint.
  ///
  /// In en, this message translates to:
  /// **'What you want to put aside this period'**
  String get onboardingGoalHint;

  /// No description provided for @onboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'See what I can spend'**
  String get onboardingFinish;

  /// No description provided for @onboardingIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Fill in the first two answers to continue'**
  String get onboardingIncomplete;

  /// No description provided for @tapToType.
  ///
  /// In en, this message translates to:
  /// **'Tap to type'**
  String get tapToType;

  /// No description provided for @heroSafeToSpend.
  ///
  /// In en, this message translates to:
  /// **'Safe to spend now'**
  String get heroSafeToSpend;

  /// No description provided for @heroNotUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Not up to date'**
  String get heroNotUpToDate;

  /// No description provided for @heroRecordSpend.
  ///
  /// In en, this message translates to:
  /// **'Record a spend'**
  String get heroRecordSpend;

  /// No description provided for @heroSeeShort.
  ///
  /// In en, this message translates to:
  /// **'See what is short'**
  String get heroSeeShort;

  /// No description provided for @heroConfirmBalance.
  ///
  /// In en, this message translates to:
  /// **'Confirm balance'**
  String get heroConfirmBalance;

  /// No description provided for @heroReviewBlurb.
  ///
  /// In en, this message translates to:
  /// **'Check your balance so this number can be trusted again.'**
  String get heroReviewBlurb;

  /// No description provided for @heroUntilSetAside.
  ///
  /// In en, this message translates to:
  /// **'Until {date} · {amount} set aside'**
  String heroUntilSetAside(String date, String amount);

  /// No description provided for @heroShort.
  ///
  /// In en, this message translates to:
  /// **'{amount} short'**
  String heroShort(String amount);

  /// No description provided for @heroUnfunded.
  ///
  /// In en, this message translates to:
  /// **'{label} · {amount} unfunded'**
  String heroUnfunded(String label, String amount);

  /// No description provided for @heroBalanceNever.
  ///
  /// In en, this message translates to:
  /// **'Balance not confirmed yet'**
  String get heroBalanceNever;

  /// No description provided for @heroBalanceToday.
  ///
  /// In en, this message translates to:
  /// **'Balance confirmed today'**
  String get heroBalanceToday;

  /// No description provided for @heroBalanceYesterday.
  ///
  /// In en, this message translates to:
  /// **'Balance confirmed yesterday'**
  String get heroBalanceYesterday;

  /// No description provided for @heroBalanceDays.
  ///
  /// In en, this message translates to:
  /// **'Balance confirmed {count} days ago'**
  String heroBalanceDays(int count);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your plan'**
  String get homeTitle;

  /// No description provided for @homeUntilTotal.
  ///
  /// In en, this message translates to:
  /// **'Until {date} · {amount} in total'**
  String homeUntilTotal(String date, String amount);

  /// No description provided for @homeRecorded.
  ///
  /// In en, this message translates to:
  /// **'{amount} recorded'**
  String homeRecorded(String amount);

  /// No description provided for @homeAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs your attention'**
  String get homeAttention;

  /// No description provided for @homeNotCovered.
  ///
  /// In en, this message translates to:
  /// **'{amount} not covered'**
  String homeNotCovered(String amount);

  /// No description provided for @homeAfterNextPay.
  ///
  /// In en, this message translates to:
  /// **'After your next pay'**
  String get homeAfterNextPay;

  /// No description provided for @homeOncePayArrives.
  ///
  /// In en, this message translates to:
  /// **'Once your pay arrives on {date}'**
  String homeOncePayArrives(String date);

  /// No description provided for @homeSetAsideFirst.
  ///
  /// In en, this message translates to:
  /// **'Set aside first'**
  String get homeSetAsideFirst;

  /// No description provided for @homeProtectedBlurb.
  ///
  /// In en, this message translates to:
  /// **'Protected before anything is spendable.'**
  String get homeProtectedBlurb;

  /// No description provided for @homeNothingSetAside.
  ///
  /// In en, this message translates to:
  /// **'Nothing is set aside yet. Everything you have is spendable.'**
  String get homeNothingSetAside;

  /// No description provided for @homeWhyThisNumber.
  ///
  /// In en, this message translates to:
  /// **'Why this number'**
  String get homeWhyThisNumber;

  /// No description provided for @homeWhatIsShort.
  ///
  /// In en, this message translates to:
  /// **'What is short'**
  String get homeWhatIsShort;

  /// No description provided for @homeShortBlurb.
  ///
  /// In en, this message translates to:
  /// **'Nothing here is moved or delayed for you. These are the commitments your current money does not cover.'**
  String get homeShortBlurb;

  /// No description provided for @askSpendTitle.
  ///
  /// In en, this message translates to:
  /// **'How much did you spend?'**
  String get askSpendTitle;

  /// No description provided for @askBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your balance now?'**
  String get askBalanceTitle;

  /// No description provided for @askBalanceBlurb.
  ///
  /// In en, this message translates to:
  /// **'Any difference is recorded as a correction, never as spending.'**
  String get askBalanceBlurb;

  /// No description provided for @whyNoChange.
  ///
  /// In en, this message translates to:
  /// **'Nothing has changed since your last plan.'**
  String get whyNoChange;

  /// No description provided for @whyPayArrived.
  ///
  /// In en, this message translates to:
  /// **'Your pay arrived, so the plan was refreshed.'**
  String get whyPayArrived;

  /// No description provided for @whyBillPaid.
  ///
  /// In en, this message translates to:
  /// **'A bill you had set money aside for was paid.'**
  String get whyBillPaid;

  /// No description provided for @whyHeldForBill.
  ///
  /// In en, this message translates to:
  /// **'Money is held back for a bill due just after your next pay.'**
  String get whyHeldForBill;

  /// No description provided for @whyOvercommitted.
  ///
  /// In en, this message translates to:
  /// **'You have committed to more than you currently have.'**
  String get whyOvercommitted;

  /// No description provided for @whyStale.
  ///
  /// In en, this message translates to:
  /// **'Your balance has not been confirmed recently.'**
  String get whyStale;

  /// No description provided for @whyCardLarger.
  ///
  /// In en, this message translates to:
  /// **'Your card balance is larger than the money you have.'**
  String get whyCardLarger;

  /// No description provided for @whyPayLate.
  ///
  /// In en, this message translates to:
  /// **'Your expected pay has not arrived yet.'**
  String get whyPayLate;

  /// No description provided for @whyOverdue.
  ///
  /// In en, this message translates to:
  /// **'Something is past its due date.'**
  String get whyOverdue;

  /// No description provided for @whyBufferShort.
  ///
  /// In en, this message translates to:
  /// **'Your savings buffer is not fully topped up.'**
  String get whyBufferShort;

  /// No description provided for @whyGoalShort.
  ///
  /// In en, this message translates to:
  /// **'Your savings goal cannot be fully funded right now.'**
  String get whyGoalShort;

  /// No description provided for @whyFlexibleLess.
  ///
  /// In en, this message translates to:
  /// **'A flexible goal received less than planned.'**
  String get whyFlexibleLess;

  /// No description provided for @whyDuplicate.
  ///
  /// In en, this message translates to:
  /// **'A repeated transaction was counted only once.'**
  String get whyDuplicate;

  /// No description provided for @planTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get planTitle;

  /// No description provided for @planBlurb.
  ///
  /// In en, this message translates to:
  /// **'What your money is promised to, before anything is spendable.'**
  String get planBlurb;

  /// No description provided for @planMoneyAndIncome.
  ///
  /// In en, this message translates to:
  /// **'Money and income'**
  String get planMoneyAndIncome;

  /// No description provided for @planMoneyYouHave.
  ///
  /// In en, this message translates to:
  /// **'Money you have'**
  String get planMoneyYouHave;

  /// No description provided for @planNextPay.
  ///
  /// In en, this message translates to:
  /// **'Next pay'**
  String get planNextPay;

  /// No description provided for @planYourNextPay.
  ///
  /// In en, this message translates to:
  /// **'Your next pay'**
  String get planYourNextPay;

  /// No description provided for @planNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get planNotSet;

  /// No description provided for @planExpectedBlurb.
  ///
  /// In en, this message translates to:
  /// **'This is only expected, so it stays out of what you can spend now.'**
  String get planExpectedBlurb;

  /// No description provided for @planSetAsideFirst.
  ///
  /// In en, this message translates to:
  /// **'Set aside first'**
  String get planSetAsideFirst;

  /// No description provided for @planNothingSetAside.
  ///
  /// In en, this message translates to:
  /// **'Nothing is set aside, so everything you have is spendable.'**
  String get planNothingSetAside;

  /// No description provided for @planAddToPlan.
  ///
  /// In en, this message translates to:
  /// **'Add to your plan'**
  String get planAddToPlan;

  /// No description provided for @planGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get planGoals;

  /// No description provided for @planSaveToward.
  ///
  /// In en, this message translates to:
  /// **'Save toward something'**
  String get planSaveToward;

  /// No description provided for @planSaveTowardSub.
  ///
  /// In en, this message translates to:
  /// **'A trip, a deposit, a replacement laptop'**
  String get planSaveTowardSub;

  /// No description provided for @planAllGoals.
  ///
  /// In en, this message translates to:
  /// **'All goals'**
  String get planAllGoals;

  /// No description provided for @planAllGoalsSub.
  ///
  /// In en, this message translates to:
  /// **'Add, edit or put money aside'**
  String get planAllGoalsSub;

  /// No description provided for @planHowMuchSetAside.
  ///
  /// In en, this message translates to:
  /// **'How much do you need to set aside for this?'**
  String get planHowMuchSetAside;

  /// No description provided for @planChangeOrRemove.
  ///
  /// In en, this message translates to:
  /// **'Change the amount, or remove it from your plan.'**
  String get planChangeOrRemove;

  /// No description provided for @planRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from plan'**
  String get planRemove;

  /// No description provided for @planDue.
  ///
  /// In en, this message translates to:
  /// **' · due {date}'**
  String planDue(String date);

  /// No description provided for @priorityMandatory.
  ///
  /// In en, this message translates to:
  /// **'Must be paid — comes first'**
  String get priorityMandatory;

  /// No description provided for @priorityEssential.
  ///
  /// In en, this message translates to:
  /// **'Day-to-day needs'**
  String get priorityEssential;

  /// No description provided for @priorityBuffer.
  ///
  /// In en, this message translates to:
  /// **'Kept back for emergencies'**
  String get priorityBuffer;

  /// No description provided for @priorityCard.
  ///
  /// In en, this message translates to:
  /// **'Already spent on a card'**
  String get priorityCard;

  /// No description provided for @prioritySinkingFund.
  ///
  /// In en, this message translates to:
  /// **'Saving for a known bill'**
  String get prioritySinkingFund;

  /// No description provided for @priorityGoal.
  ///
  /// In en, this message translates to:
  /// **'A goal you have committed to'**
  String get priorityGoal;

  /// No description provided for @priorityDiscretionary.
  ///
  /// In en, this message translates to:
  /// **'Nice to have — yields first'**
  String get priorityDiscretionary;

  /// No description provided for @goalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goalsTitle;

  /// No description provided for @goalsBlurbEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved toward yet.'**
  String get goalsBlurbEmpty;

  /// No description provided for @goalsBlurb.
  ///
  /// In en, this message translates to:
  /// **'What each goal needs from this pay period.'**
  String get goalsBlurb;

  /// No description provided for @goalsEmptyCard.
  ///
  /// In en, this message translates to:
  /// **'Add something you are saving for — a trip, a deposit, a replacement laptop. Upino works out what to hold back each pay period so it arrives on time.'**
  String get goalsEmptyCard;

  /// No description provided for @goalsNew.
  ///
  /// In en, this message translates to:
  /// **'New goal'**
  String get goalsNew;

  /// No description provided for @goalsNewSub.
  ///
  /// In en, this message translates to:
  /// **'Something you are putting money aside for'**
  String get goalsNewSub;

  /// No description provided for @goalsAddMoney.
  ///
  /// In en, this message translates to:
  /// **'Add money'**
  String get goalsAddMoney;

  /// No description provided for @goalsAddTo.
  ///
  /// In en, this message translates to:
  /// **'Add to {name}'**
  String goalsAddTo(String name);

  /// No description provided for @goalsAddBlurb.
  ///
  /// In en, this message translates to:
  /// **'This records what you have put aside. It does not spend anything — it lowers what has to be held back from here on.'**
  String get goalsAddBlurb;

  /// No description provided for @goalsEachPeriod.
  ///
  /// In en, this message translates to:
  /// **'Each pay period'**
  String get goalsEachPeriod;

  /// No description provided for @goalsTargetDate.
  ///
  /// In en, this message translates to:
  /// **'Target date'**
  String get goalsTargetDate;

  /// No description provided for @goalsOf.
  ///
  /// In en, this message translates to:
  /// **'of {amount}'**
  String goalsOf(String amount);

  /// No description provided for @goalsPeriodsToGo.
  ///
  /// In en, this message translates to:
  /// **'{count} pay periods to go'**
  String goalsPeriodsToGo(int count);

  /// No description provided for @goalsDone.
  ///
  /// In en, this message translates to:
  /// **'Saved in full'**
  String get goalsDone;

  /// No description provided for @goalsPausedStatus.
  ///
  /// In en, this message translates to:
  /// **'Paused — nothing held back'**
  String get goalsPausedStatus;

  /// No description provided for @goalsFlexibleStatus.
  ///
  /// In en, this message translates to:
  /// **'Flexible — gives way to anything you must pay'**
  String get goalsFlexibleStatus;

  /// No description provided for @goalEditNew.
  ///
  /// In en, this message translates to:
  /// **'What are you saving for?'**
  String get goalEditNew;

  /// No description provided for @goalEditExisting.
  ///
  /// In en, this message translates to:
  /// **'Edit goal'**
  String get goalEditExisting;

  /// No description provided for @goalName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get goalName;

  /// No description provided for @goalNameHint.
  ///
  /// In en, this message translates to:
  /// **'A trip, a deposit, a laptop'**
  String get goalNameHint;

  /// No description provided for @goalTotal.
  ///
  /// In en, this message translates to:
  /// **'How much in total'**
  String get goalTotal;

  /// No description provided for @goalByWhen.
  ///
  /// In en, this message translates to:
  /// **'By when'**
  String get goalByWhen;

  /// No description provided for @goalMonths.
  ///
  /// In en, this message translates to:
  /// **'{count} mo'**
  String goalMonths(int count);

  /// No description provided for @goalOneYear.
  ///
  /// In en, this message translates to:
  /// **'1 year'**
  String get goalOneYear;

  /// No description provided for @goalTwoYears.
  ///
  /// In en, this message translates to:
  /// **'2 years'**
  String get goalTwoYears;

  /// No description provided for @goalFirmness.
  ///
  /// In en, this message translates to:
  /// **'How firm is it?'**
  String get goalFirmness;

  /// No description provided for @goalKindHard.
  ///
  /// In en, this message translates to:
  /// **'Committed'**
  String get goalKindHard;

  /// No description provided for @goalKindHardSub.
  ///
  /// In en, this message translates to:
  /// **'Held back before anything is spendable'**
  String get goalKindHardSub;

  /// No description provided for @goalKindFlexible.
  ///
  /// In en, this message translates to:
  /// **'Flexible'**
  String get goalKindFlexible;

  /// No description provided for @goalKindFlexibleSub.
  ///
  /// In en, this message translates to:
  /// **'Gives way to anything you must pay'**
  String get goalKindFlexibleSub;

  /// No description provided for @goalKindPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get goalKindPaused;

  /// No description provided for @goalKindPausedSub.
  ///
  /// In en, this message translates to:
  /// **'Stays visible, nothing held back'**
  String get goalKindPausedSub;

  /// No description provided for @goalSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get goalSaveChanges;

  /// No description provided for @goalAddThis.
  ///
  /// In en, this message translates to:
  /// **'Add this goal'**
  String get goalAddThis;

  /// No description provided for @goalDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete this goal'**
  String get goalDelete;

  /// No description provided for @activityTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityTitle;

  /// No description provided for @activityBlurb.
  ///
  /// In en, this message translates to:
  /// **'Everything you have recorded, newest first.'**
  String get activityBlurb;

  /// No description provided for @activityEmpty.
  ///
  /// In en, this message translates to:
  /// **'When you record a spend it will appear here, and you can remove it if you got it wrong.'**
  String get activityEmpty;

  /// No description provided for @activityRemoveIt.
  ///
  /// In en, this message translates to:
  /// **'Remove it'**
  String get activityRemoveIt;

  /// No description provided for @activityKeepIt.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get activityKeepIt;

  /// No description provided for @activitySpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get activitySpent;

  /// No description provided for @activityIncome.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get activityIncome;

  /// No description provided for @activityCorrection.
  ///
  /// In en, this message translates to:
  /// **'Correction'**
  String get activityCorrection;

  /// No description provided for @activityRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get activityRemoved;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileConfirmBalance.
  ///
  /// In en, this message translates to:
  /// **'Confirm your balance'**
  String get profileConfirmBalance;

  /// No description provided for @profileTrustTitle.
  ///
  /// In en, this message translates to:
  /// **'How trustworthy is the figure?'**
  String get profileTrustTitle;

  /// No description provided for @profileTrustFresh.
  ///
  /// In en, this message translates to:
  /// **'Up to date. Nothing needs your attention.'**
  String get profileTrustFresh;

  /// No description provided for @profileTrustDegraded.
  ///
  /// In en, this message translates to:
  /// **'Your balance has not been confirmed for a while. The figure is still shown, just less certain.'**
  String get profileTrustDegraded;

  /// No description provided for @profileTrustReview.
  ///
  /// In en, this message translates to:
  /// **'Too old or too uncertain to rely on. Confirm your balance to fix it.'**
  String get profileTrustReview;

  /// No description provided for @profileConfirmedNever.
  ///
  /// In en, this message translates to:
  /// **'Not confirmed yet'**
  String get profileConfirmedNever;

  /// No description provided for @profileConfirmedToday.
  ///
  /// In en, this message translates to:
  /// **'Confirmed today'**
  String get profileConfirmedToday;

  /// No description provided for @profileConfirmedYesterday.
  ///
  /// In en, this message translates to:
  /// **'Confirmed yesterday'**
  String get profileConfirmedYesterday;

  /// No description provided for @profileConfirmedDays.
  ///
  /// In en, this message translates to:
  /// **'Confirmed {count} days ago'**
  String profileConfirmedDays(int count);

  /// No description provided for @profileAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileAppearance;

  /// No description provided for @profileTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get profileTheme;

  /// No description provided for @profileThemeBlurb.
  ///
  /// In en, this message translates to:
  /// **'Following your phone is the default, so nothing is imposed.'**
  String get profileThemeBlurb;

  /// No description provided for @themePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get themePhone;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileLanguageBlurb.
  ///
  /// In en, this message translates to:
  /// **'Following your phone is the default, so nothing is imposed.'**
  String get profileLanguageBlurb;

  /// No description provided for @languagePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get languagePhone;

  /// No description provided for @profileCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get profileCurrency;

  /// No description provided for @profileYourData.
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get profileYourData;

  /// No description provided for @profileDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete my plan'**
  String get profileDelete;

  /// No description provided for @profileDeleteSub.
  ///
  /// In en, this message translates to:
  /// **'Clears everything and returns to setup'**
  String get profileDeleteSub;

  /// No description provided for @profileStartOver.
  ///
  /// In en, this message translates to:
  /// **'Start over?'**
  String get profileStartOver;

  /// No description provided for @profileStartOverBlurb.
  ///
  /// In en, this message translates to:
  /// **'Your plan and everything you recorded are deleted. This cannot be undone.'**
  String get profileStartOverBlurb;

  /// No description provided for @profileDeleteEverything.
  ///
  /// In en, this message translates to:
  /// **'Delete everything'**
  String get profileDeleteEverything;

  /// No description provided for @profileKeepPlan.
  ///
  /// In en, this message translates to:
  /// **'Keep my plan'**
  String get profileKeepPlan;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @activityRemoveAmount.
  ///
  /// In en, this message translates to:
  /// **'Remove {amount}?'**
  String activityRemoveAmount(String amount);

  /// No description provided for @activityRemoveDetail.
  ///
  /// In en, this message translates to:
  /// **'It stops counting toward your plan straight away. The entry stays on this list marked as removed, so your record is still complete.'**
  String get activityRemoveDetail;

  /// No description provided for @activityCardPurchase.
  ///
  /// In en, this message translates to:
  /// **'Card purchase'**
  String get activityCardPurchase;

  /// No description provided for @activityCardPayment.
  ///
  /// In en, this message translates to:
  /// **'Card payment'**
  String get activityCardPayment;

  /// No description provided for @activityRefund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get activityRefund;

  /// No description provided for @activityTransfer.
  ///
  /// In en, this message translates to:
  /// **'Moved between accounts'**
  String get activityTransfer;

  /// No description provided for @activityLoan.
  ///
  /// In en, this message translates to:
  /// **'Loan received'**
  String get activityLoan;

  /// No description provided for @activityDebtPayment.
  ///
  /// In en, this message translates to:
  /// **'Debt payment'**
  String get activityDebtPayment;

  /// No description provided for @activityBalanceCorrected.
  ///
  /// In en, this message translates to:
  /// **'Balance corrected'**
  String get activityBalanceCorrected;

  /// No description provided for @activityBlurbEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded yet.'**
  String get activityBlurbEmpty;

  /// No description provided for @profileStartAgain.
  ///
  /// In en, this message translates to:
  /// **'Start again'**
  String get profileStartAgain;

  /// No description provided for @claimRent.
  ///
  /// In en, this message translates to:
  /// **'Rent and bills'**
  String get claimRent;

  /// No description provided for @claimCardMinimum.
  ///
  /// In en, this message translates to:
  /// **'Card minimum due'**
  String get claimCardMinimum;

  /// No description provided for @claimEssentials.
  ///
  /// In en, this message translates to:
  /// **'Food and transport'**
  String get claimEssentials;

  /// No description provided for @claimBuffer.
  ///
  /// In en, this message translates to:
  /// **'Emergency buffer'**
  String get claimBuffer;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Which language?'**
  String get languageTitle;

  /// No description provided for @languageBlurb.
  ///
  /// In en, this message translates to:
  /// **'You can change this later in Profile.'**
  String get languageBlurb;

  /// No description provided for @profileLedgerTitle.
  ///
  /// In en, this message translates to:
  /// **'Is the record complete?'**
  String get profileLedgerTitle;

  /// No description provided for @ledgerComplete.
  ///
  /// In en, this message translates to:
  /// **'Everything you have spent is recorded.'**
  String get ledgerComplete;

  /// No description provided for @ledgerPartial.
  ///
  /// In en, this message translates to:
  /// **'Some spending was found only when you confirmed your balance.'**
  String get ledgerPartial;

  /// No description provided for @ledgerUnknown.
  ///
  /// In en, this message translates to:
  /// **'Upino cannot tell how much is missing. Confirm your balance to find out.'**
  String get ledgerUnknown;

  /// No description provided for @askTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask before you spend'**
  String get askTitle;

  /// No description provided for @askBlurb.
  ///
  /// In en, this message translates to:
  /// **'Try a purchase against your plan. Nothing is recorded and nothing changes.'**
  String get askBlurb;

  /// No description provided for @askAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'How much would it be?'**
  String get askAmountLabel;

  /// No description provided for @askRun.
  ///
  /// In en, this message translates to:
  /// **'See what it would do'**
  String get askRun;

  /// No description provided for @askDoNotBuy.
  ///
  /// In en, this message translates to:
  /// **'Do not buy'**
  String get askDoNotBuy;

  /// No description provided for @askBuyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy it today'**
  String get askBuyNow;

  /// No description provided for @askBuyAfter.
  ///
  /// In en, this message translates to:
  /// **'Buy it after {date}'**
  String askBuyAfter(String date);

  /// No description provided for @askUnchanged.
  ///
  /// In en, this message translates to:
  /// **'Your plan stays as it is.'**
  String get askUnchanged;

  /// No description provided for @askStsAfter.
  ///
  /// In en, this message translates to:
  /// **'Safe to spend afterwards'**
  String get askStsAfter;

  /// No description provided for @askBreaks.
  ///
  /// In en, this message translates to:
  /// **'This leaves something you must pay unfunded.'**
  String get askBreaks;

  /// No description provided for @askSafe.
  ///
  /// In en, this message translates to:
  /// **'Nothing you must pay is left unfunded.'**
  String get askSafe;

  /// No description provided for @askCosts.
  ///
  /// In en, this message translates to:
  /// **'What gets less'**
  String get askCosts;

  /// No description provided for @askCostLine.
  ///
  /// In en, this message translates to:
  /// **'{label} · {amount} less'**
  String askCostLine(String label, String amount);

  /// No description provided for @askWaitingHelps.
  ///
  /// In en, this message translates to:
  /// **'Waiting until your pay arrives covers everything.'**
  String get askWaitingHelps;

  /// No description provided for @askNoIncome.
  ///
  /// In en, this message translates to:
  /// **'No pay is expected yet, so there is nothing later to compare against.'**
  String get askNoIncome;

  /// No description provided for @askAssumption.
  ///
  /// In en, this message translates to:
  /// **'Assumes your pay arrives as expected on {date}.'**
  String askAssumption(String date);

  /// No description provided for @askNoVerdict.
  ///
  /// In en, this message translates to:
  /// **'Upino does not say yes or no. The trade-off is yours.'**
  String get askNoVerdict;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'en',
        'es',
        'fa',
        'fr',
        'hi',
        'pt',
        'ru',
        'tr',
        'zh'
      ].contains(locale.languageCode);

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
    case 'es':
      return AppLocalizationsEs();
    case 'fa':
      return AppLocalizationsFa();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
