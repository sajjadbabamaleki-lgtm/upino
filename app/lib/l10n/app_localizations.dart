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
  /// **'Your savings today'**
  String get onboardingBalanceLabel;

  /// No description provided for @onboardingBalanceHint.
  ///
  /// In en, this message translates to:
  /// **'Money you could actually spend from, not what you mean to keep untouched.'**
  String get onboardingBalanceHint;

  /// No description provided for @onboardingIncomeLabel.
  ///
  /// In en, this message translates to:
  /// **'What do you earn in a month?'**
  String get onboardingIncomeLabel;

  /// No description provided for @onboardingIncomeHint.
  ///
  /// In en, this message translates to:
  /// **'If it varies, give the range. Your plan is built on the lower end.'**
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
  /// **'Build my plan'**
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

  /// No description provided for @currencyChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Switch to {currency}?'**
  String currencyChangeTitle(String currency);

  /// No description provided for @currencyChangeBlurb.
  ///
  /// In en, this message translates to:
  /// **'Every amount in your plan keeps its number and is shown in {currency} from now on. Nothing is converted at an exchange rate, so use this to correct the currency, not to convert your money.'**
  String currencyChangeBlurb(String currency);

  /// No description provided for @currencyChangeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get currencyChangeConfirm;

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

  /// No description provided for @receipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt;

  /// No description provided for @receiptAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a receipt'**
  String get receiptAdd;

  /// No description provided for @receiptCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get receiptCamera;

  /// No description provided for @receiptGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo'**
  String get receiptGallery;

  /// No description provided for @receiptAttached.
  ///
  /// In en, this message translates to:
  /// **'Receipt attached'**
  String get receiptAttached;

  /// No description provided for @receiptRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove the photo'**
  String get receiptRemove;

  /// No description provided for @onboardingIncomeFrom.
  ///
  /// In en, this message translates to:
  /// **'At least'**
  String get onboardingIncomeFrom;

  /// No description provided for @onboardingIncomeTo.
  ///
  /// In en, this message translates to:
  /// **'Up to'**
  String get onboardingIncomeTo;

  /// No description provided for @onboardingIncomeToOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get onboardingIncomeToOptional;

  /// No description provided for @incomeRange.
  ///
  /// In en, this message translates to:
  /// **'{low} to {high}'**
  String incomeRange(String low, String high);

  /// No description provided for @incomeRangeNote.
  ///
  /// In en, this message translates to:
  /// **'Your plan is built on {low}. Anything above it is yours when it arrives.'**
  String incomeRangeNote(String low);

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get categoryFood;

  /// No description provided for @categoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get categoryTransport;

  /// No description provided for @categoryBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get categoryBills;

  /// No description provided for @categoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get categoryShopping;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryFun.
  ///
  /// In en, this message translates to:
  /// **'Going out'**
  String get categoryFun;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @categoryUnsorted.
  ///
  /// In en, this message translates to:
  /// **'Not sorted'**
  String get categoryUnsorted;

  /// No description provided for @categoryPrompt.
  ///
  /// In en, this message translates to:
  /// **'What was it for?'**
  String get categoryPrompt;

  /// No description provided for @spendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Where it went'**
  String get spendingTitle;

  /// No description provided for @spendingWindow.
  ///
  /// In en, this message translates to:
  /// **'Spends recorded in the last 30 days'**
  String get spendingWindow;

  /// No description provided for @backupSection.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backupSection;

  /// No description provided for @backupSave.
  ///
  /// In en, this message translates to:
  /// **'Save a backup'**
  String get backupSave;

  /// No description provided for @backupSaveSub.
  ///
  /// In en, this message translates to:
  /// **'Locked with a password. Send it somewhere safe, like your cloud drive.'**
  String get backupSaveSub;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore from a backup'**
  String get backupRestore;

  /// No description provided for @backupRestoreSub.
  ///
  /// In en, this message translates to:
  /// **'Replaces the plan on this phone'**
  String get backupRestoreSub;

  /// No description provided for @backupPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get backupPassword;

  /// No description provided for @backupPasswordRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat the password'**
  String get backupPasswordRepeat;

  /// No description provided for @backupPasswordSaveBlurb.
  ///
  /// In en, this message translates to:
  /// **'You will need this password to restore the backup. It cannot be recovered if you forget it. Receipt photos are not included.'**
  String get backupPasswordSaveBlurb;

  /// No description provided for @backupPasswordOpenBlurb.
  ///
  /// In en, this message translates to:
  /// **'The password this backup was saved with.'**
  String get backupPasswordOpenBlurb;

  /// No description provided for @backupPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get backupPasswordShort;

  /// No description provided for @backupPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'The two do not match'**
  String get backupPasswordMismatch;

  /// No description provided for @backupOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get backupOpen;

  /// No description provided for @backupReplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace this plan?'**
  String get backupReplaceTitle;

  /// No description provided for @backupReplaceBlurb.
  ///
  /// In en, this message translates to:
  /// **'Everything on this phone is replaced by what is in the backup. This cannot be undone.'**
  String get backupReplaceBlurb;

  /// No description provided for @backupReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get backupReplace;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get backupRestored;

  /// No description provided for @backupWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'That password does not open this backup.'**
  String get backupWrongPassword;

  /// No description provided for @backupNotABackup.
  ///
  /// In en, this message translates to:
  /// **'That file is not an Upino backup.'**
  String get backupNotABackup;

  /// No description provided for @backupUnreadable.
  ///
  /// In en, this message translates to:
  /// **'This backup was made by a newer version of Upino. Update the app and try again.'**
  String get backupUnreadable;

  /// No description provided for @inflationTitle.
  ///
  /// In en, this message translates to:
  /// **'Inflation'**
  String get inflationTitle;

  /// No description provided for @inflationNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set. Add the yearly rate where you live to see what goals will really cost.'**
  String get inflationNotSet;

  /// No description provided for @inflationRate.
  ///
  /// In en, this message translates to:
  /// **'{rate}% a year'**
  String inflationRate(String rate);

  /// No description provided for @inflationDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Yearly inflation'**
  String get inflationDialogTitle;

  /// No description provided for @inflationDialogBlurb.
  ///
  /// In en, this message translates to:
  /// **'Prices rise, so a goal set in today\'s money costs more on its date. Enter the rate you expect. Leave it empty to turn this off.'**
  String get inflationDialogBlurb;

  /// No description provided for @goalsInflated.
  ///
  /// In en, this message translates to:
  /// **'At {rate}% a year, this will cost about {amount} by then.'**
  String goalsInflated(String rate, String amount);

  /// No description provided for @holdingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Other holdings'**
  String get holdingsTitle;

  /// No description provided for @holdingsBlurb.
  ///
  /// In en, this message translates to:
  /// **'Dollars, gold, coins. Shown beside your plan and never counted in what you can spend.'**
  String get holdingsBlurb;

  /// No description provided for @holdingsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a holding'**
  String get holdingsAdd;

  /// No description provided for @holdingsAddSub.
  ///
  /// In en, this message translates to:
  /// **'Not counted in what you can spend'**
  String get holdingsAddSub;

  /// No description provided for @holdingsTotal.
  ///
  /// In en, this message translates to:
  /// **'Together'**
  String get holdingsTotal;

  /// No description provided for @holdingSummary.
  ///
  /// In en, this message translates to:
  /// **'{quantity} × {price} · priced {date}'**
  String holdingSummary(String quantity, String price, String date);

  /// No description provided for @holdingEditNew.
  ///
  /// In en, this message translates to:
  /// **'New holding'**
  String get holdingEditNew;

  /// No description provided for @holdingEditExisting.
  ///
  /// In en, this message translates to:
  /// **'Change holding'**
  String get holdingEditExisting;

  /// No description provided for @holdingName.
  ///
  /// In en, this message translates to:
  /// **'What is it?'**
  String get holdingName;

  /// No description provided for @holdingNameHint.
  ///
  /// In en, this message translates to:
  /// **'US dollar, gold…'**
  String get holdingNameHint;

  /// No description provided for @holdingUsd.
  ///
  /// In en, this message translates to:
  /// **'US dollar'**
  String get holdingUsd;

  /// No description provided for @holdingEur.
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get holdingEur;

  /// No description provided for @holdingGold.
  ///
  /// In en, this message translates to:
  /// **'Gold (gram)'**
  String get holdingGold;

  /// No description provided for @holdingCoin.
  ///
  /// In en, this message translates to:
  /// **'Gold coin'**
  String get holdingCoin;

  /// No description provided for @holdingQuantity.
  ///
  /// In en, this message translates to:
  /// **'How many'**
  String get holdingQuantity;

  /// No description provided for @holdingUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'What one is worth today'**
  String get holdingUnitPrice;

  /// No description provided for @holdingWorth.
  ///
  /// In en, this message translates to:
  /// **'Worth {amount} together'**
  String holdingWorth(String amount);

  /// No description provided for @holdingDelete.
  ///
  /// In en, this message translates to:
  /// **'Remove this holding'**
  String get holdingDelete;

  /// No description provided for @fasterTitle.
  ///
  /// In en, this message translates to:
  /// **'Faster entry'**
  String get fasterTitle;

  /// No description provided for @smsTitle.
  ///
  /// In en, this message translates to:
  /// **'Read bank messages'**
  String get smsTitle;

  /// No description provided for @smsDetail.
  ///
  /// In en, this message translates to:
  /// **'Spends your bank texts you about are offered to record with one tap. Messages are read on this phone only and never sent anywhere.'**
  String get smsDetail;

  /// No description provided for @smsDenied.
  ///
  /// In en, this message translates to:
  /// **'Upino was not allowed to read messages. You can allow it in the phone\'s settings.'**
  String get smsDenied;

  /// No description provided for @smsWaiting.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 bank message to review} other{{count} bank messages to review}}'**
  String smsWaiting(int count);

  /// No description provided for @smsWaitingSub.
  ///
  /// In en, this message translates to:
  /// **'Record each with one tap, or skip it'**
  String get smsWaitingSub;

  /// No description provided for @smsReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'From your bank'**
  String get smsReviewTitle;

  /// No description provided for @smsReviewBlurb.
  ///
  /// In en, this message translates to:
  /// **'Nothing is recorded until you tap Record. Check the amount against the message.'**
  String get smsReviewBlurb;

  /// No description provided for @smsReviewDone.
  ///
  /// In en, this message translates to:
  /// **'All caught up.'**
  String get smsReviewDone;

  /// No description provided for @smsRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get smsRecord;

  /// No description provided for @smsSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get smsSkip;

  /// No description provided for @reminderTitleSetting.
  ///
  /// In en, this message translates to:
  /// **'Evening reminder'**
  String get reminderTitleSetting;

  /// No description provided for @reminderDetail.
  ///
  /// In en, this message translates to:
  /// **'At 9 in the evening, only on days nothing was recorded.'**
  String get reminderDetail;

  /// No description provided for @reminderDenied.
  ///
  /// In en, this message translates to:
  /// **'Upino was not allowed to show notifications. You can allow it in the phone\'s settings.'**
  String get reminderDenied;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Anything spent today?'**
  String get reminderTitle;

  /// No description provided for @reminderBody.
  ///
  /// In en, this message translates to:
  /// **'Record it in a few seconds, so tomorrow\'s figure is right.'**
  String get reminderBody;

  /// No description provided for @reminderChannel.
  ///
  /// In en, this message translates to:
  /// **'Evening reminder'**
  String get reminderChannel;

  /// No description provided for @widgetSpend.
  ///
  /// In en, this message translates to:
  /// **'+ Spend'**
  String get widgetSpend;

  /// No description provided for @widgetAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to home screen'**
  String get widgetAdd;

  /// No description provided for @widgetAddSub.
  ///
  /// In en, this message translates to:
  /// **'What you can spend, and a button to record a spend, without opening the app'**
  String get widgetAddSub;

  /// No description provided for @voiceListening.
  ///
  /// In en, this message translates to:
  /// **'Listening… say the amount and what it was for.'**
  String get voiceListening;

  /// No description provided for @voiceHeard.
  ///
  /// In en, this message translates to:
  /// **'Heard: “{text}”. Check the amount, then save.'**
  String voiceHeard(String text);

  /// No description provided for @voiceNothing.
  ///
  /// In en, this message translates to:
  /// **'No amount heard. Try again, or type it.'**
  String get voiceNothing;

  /// No description provided for @voicePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Your phone turns speech into text. On phones without offline speech, that goes through the phone\'s speech service.'**
  String get voicePrivacy;

  /// No description provided for @voiceButton.
  ///
  /// In en, this message translates to:
  /// **'Say it'**
  String get voiceButton;

  /// No description provided for @voiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This phone has no speech recognition the app can use. Type the amount instead.'**
  String get voiceUnavailable;

  /// No description provided for @voiceNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Upino was not allowed to use the microphone. You can allow it in the phone\'s settings.'**
  String get voiceNoPermission;

  /// No description provided for @voiceNetwork.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition on this phone needs the internet and could not reach it.'**
  String get voiceNetwork;

  /// No description provided for @voiceNoAmount.
  ///
  /// In en, this message translates to:
  /// **'Heard “{text}”, but no amount in it. Try again, or type it.'**
  String voiceNoAmount(String text);

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @navAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask'**
  String get navAsk;

  /// No description provided for @alertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Needs you'**
  String get alertsTitle;

  /// No description provided for @alertsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing needs you right now. The plan is up to date.'**
  String get alertsEmpty;

  /// No description provided for @alertUnfunded.
  ///
  /// In en, this message translates to:
  /// **'{label} is {amount} short'**
  String alertUnfunded(String label, String amount);

  /// No description provided for @alertUnfundedDetail.
  ///
  /// In en, this message translates to:
  /// **'Something you must pay is not covered by what you have.'**
  String get alertUnfundedDetail;

  /// No description provided for @alertIncomeLate.
  ///
  /// In en, this message translates to:
  /// **'Your pay was expected on {date}'**
  String alertIncomeLate(String date);

  /// No description provided for @alertIncomeLateDetail.
  ///
  /// In en, this message translates to:
  /// **'It is not counted until it arrives. Change the date on Plan if it moved.'**
  String get alertIncomeLateDetail;

  /// No description provided for @alertGoalBehind.
  ///
  /// In en, this message translates to:
  /// **'{name} is {amount} behind this period'**
  String alertGoalBehind(String name, String amount);

  /// No description provided for @alertGoalBehindDetail.
  ///
  /// In en, this message translates to:
  /// **'What you have does not reach this period\'s share of the goal.'**
  String get alertGoalBehindDetail;

  /// No description provided for @chatHint.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything, or type a price'**
  String get chatHint;

  /// No description provided for @chatSuggestSafe.
  ///
  /// In en, this message translates to:
  /// **'How much can I spend?'**
  String get chatSuggestSafe;

  /// No description provided for @chatSuggestPay.
  ///
  /// In en, this message translates to:
  /// **'When is my next pay?'**
  String get chatSuggestPay;

  /// No description provided for @chatSuggestWhere.
  ///
  /// In en, this message translates to:
  /// **'Where did my money go?'**
  String get chatSuggestWhere;

  /// No description provided for @chatSuggestAside.
  ///
  /// In en, this message translates to:
  /// **'What is set aside?'**
  String get chatSuggestAside;

  /// No description provided for @chatSafe.
  ///
  /// In en, this message translates to:
  /// **'You can spend {amount} until {date}.'**
  String chatSafe(String amount, String date);

  /// No description provided for @chatSafeStale.
  ///
  /// In en, this message translates to:
  /// **'One thing: your balance needs confirming, so treat this as an estimate.'**
  String get chatSafeStale;

  /// No description provided for @chatPay.
  ///
  /// In en, this message translates to:
  /// **'Your next pay is {amount}, expected on {date}.'**
  String chatPay(String amount, String date);

  /// No description provided for @chatPayNone.
  ///
  /// In en, this message translates to:
  /// **'I don\'t know your next pay yet. Add it on Plan and I\'ll keep an eye on it.'**
  String get chatPayNone;

  /// No description provided for @chatWhere.
  ///
  /// In en, this message translates to:
  /// **'Here\'s where it went in the last 30 days:'**
  String get chatWhere;

  /// No description provided for @chatWhereNone.
  ///
  /// In en, this message translates to:
  /// **'No spends in the last 30 days. Either it\'s been a quiet month or they haven\'t been recorded.'**
  String get chatWhereNone;

  /// No description provided for @chatAside.
  ///
  /// In en, this message translates to:
  /// **'{amount} is set aside before anything counts as spendable:'**
  String chatAside(String amount);

  /// No description provided for @chatPurchase.
  ///
  /// In en, this message translates to:
  /// **'Let\'s see what {amount} would do.'**
  String chatPurchase(String amount);

  /// No description provided for @chatHelp.
  ///
  /// In en, this message translates to:
  /// **'Hmm, I didn\'t quite get that. I can tell you how much you can spend, when your pay comes, where your money went, what\'s set aside, or how to spend less. Or type a price, like “a phone for 20 million”, and I\'ll show you what buying it would do.'**
  String get chatHelp;

  /// No description provided for @chatHelloNew.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m Upino. You\'re new here, so I only know the basics so far: your balance, your pay and what you set aside. That\'s already enough to tell you what you can spend and what a purchase would do. Keep recording your spends and after about a season I\'ll know your habits well enough to be your own money adviser.'**
  String get chatHelloNew;

  /// No description provided for @chatHelloLearning.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! I\'ve been learning from {days, plural, =1{1 day} other{{days} days}} and {spends, plural, =1{1 spend} other{{spends} spends}} so far. About {remaining} more days and I\'ll have a full season to go on.'**
  String chatHelloLearning(int days, int spends, int remaining);

  /// No description provided for @chatHelloFamiliar.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! I\'ve seen {days} days of your money now, so ask me anything, including how to spend less.'**
  String chatHelloFamiliar(int days);

  /// No description provided for @chatHelloAlerts.
  ///
  /// In en, this message translates to:
  /// **'By the way, {count, plural, =1{one thing needs you} other{{count} things need you}}: it\'s under the bell.'**
  String chatHelloAlerts(int count);

  /// No description provided for @chatPurchaseFits.
  ///
  /// In en, this message translates to:
  /// **'Buying it today keeps everything you must pay covered, with {left} still spare.'**
  String chatPurchaseFits(String left);

  /// No description provided for @chatPurchaseWait.
  ///
  /// In en, this message translates to:
  /// **'Buying it today would leave something you must pay short. If you wait until {date}, everything is covered.'**
  String chatPurchaseWait(String date);

  /// No description provided for @chatPurchaseStillShort.
  ///
  /// In en, this message translates to:
  /// **'Heads up: even after your pay on {date}, this would leave something you must pay short.'**
  String chatPurchaseStillShort(String date);

  /// No description provided for @chatPurchaseShort.
  ///
  /// In en, this message translates to:
  /// **'Buying it today would leave something you must pay short.'**
  String get chatPurchaseShort;

  /// No description provided for @chatSafeNothing.
  ///
  /// In en, this message translates to:
  /// **'Right now there\'s nothing spare until {date}: everything you have is already promised to something you must pay.'**
  String chatSafeNothing(String date);

  /// No description provided for @chatPayIn.
  ///
  /// In en, this message translates to:
  /// **'That\'s {days, plural, =1{in a day} other{in {days} days}}.'**
  String chatPayIn(int days);

  /// No description provided for @chatPayLate.
  ///
  /// In en, this message translates to:
  /// **'It\'s late, so it isn\'t counted until you confirm it has arrived.'**
  String get chatPayLate;

  /// No description provided for @chatPayRange.
  ///
  /// In en, this message translates to:
  /// **'Your plan counts on the lower end, so a good month is a bonus, not a hole.'**
  String get chatPayRange;

  /// No description provided for @chatWhereSoFar.
  ///
  /// In en, this message translates to:
  /// **'I\'ve only seen {days, plural, =1{1 day} other{{days} days}} so far, so this is a first look:'**
  String chatWhereSoFar(int days);

  /// No description provided for @chatWhereTop.
  ///
  /// In en, this message translates to:
  /// **'{category} is the biggest: {share}% of it.'**
  String chatWhereTop(String category, int share);

  /// No description provided for @chatWhereTooSoon.
  ///
  /// In en, this message translates to:
  /// **'It\'s a bit early for that: I\'ve barely seen any spending yet. Record a few and ask me again next week.'**
  String get chatWhereTooSoon;

  /// No description provided for @chatAdviceTooSoon.
  ///
  /// In en, this message translates to:
  /// **'I\'d love to help with that, but honestly I don\'t know your spending well enough yet, and advice without it would just be a guess. Record your spends (sorting them helps a lot) and ask me again in a few weeks.'**
  String get chatAdviceTooSoon;

  /// No description provided for @chatAdviceBiggest.
  ///
  /// In en, this message translates to:
  /// **'Your biggest spend in the last 30 days was {category}, at {amount}. Trimming it by a tenth would free about {tenth} a month.'**
  String chatAdviceBiggest(String category, String amount, String tenth);

  /// No description provided for @chatAdviceSort.
  ///
  /// In en, this message translates to:
  /// **'I can see what you spend but not what it\'s on. Give your spends a category when you record them and I can tell you where to trim.'**
  String get chatAdviceSort;

  /// No description provided for @chatAdviceMore.
  ///
  /// In en, this message translates to:
  /// **'You spent {amount} more than the month before.'**
  String chatAdviceMore(String amount);

  /// No description provided for @chatAdviceLess.
  ///
  /// In en, this message translates to:
  /// **'Nice: that\'s {amount} less than the month before.'**
  String chatAdviceLess(String amount);

  /// No description provided for @chatAdviceLearning.
  ///
  /// In en, this message translates to:
  /// **'I\'m still learning your habits, so take this as a first hint rather than the full picture.'**
  String get chatAdviceLearning;

  /// No description provided for @chatSmallHello.
  ///
  /// In en, this message translates to:
  /// **'Hi! What would you like to know about your money?'**
  String get chatSmallHello;

  /// No description provided for @chatSmallThanks.
  ///
  /// In en, this message translates to:
  /// **'Any time! I\'m here whenever you\'re about to spend.'**
  String get chatSmallThanks;

  /// No description provided for @chatSmallWho.
  ///
  /// In en, this message translates to:
  /// **'I\'m Upino\'s assistant. I only know what\'s in your plan, and every number I give comes straight from it; nothing you tell me leaves this phone. I won\'t tell you yes or no, but I\'ll show you what each choice would leave you.'**
  String get chatSmallWho;

  /// No description provided for @chatSuggestAdvice.
  ///
  /// In en, this message translates to:
  /// **'How can I spend less?'**
  String get chatSuggestAdvice;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Upino'**
  String get chatTitle;

  /// No description provided for @chatNew.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get chatNew;

  /// No description provided for @chatResumed.
  ///
  /// In en, this message translates to:
  /// **'Answers here are worked out from your plan as it is today.'**
  String get chatResumed;

  /// No description provided for @chatWhy.
  ///
  /// In en, this message translates to:
  /// **'Here\'s how the figure comes about:'**
  String get chatWhy;

  /// No description provided for @chatWhyHave.
  ///
  /// In en, this message translates to:
  /// **'What you have'**
  String get chatWhyHave;

  /// No description provided for @chatWhySetAside.
  ///
  /// In en, this message translates to:
  /// **'Set aside first'**
  String get chatWhySetAside;

  /// No description provided for @chatWhyLeft.
  ///
  /// In en, this message translates to:
  /// **'Safe to spend'**
  String get chatWhyLeft;

  /// No description provided for @chatSmallHowAreYou.
  ///
  /// In en, this message translates to:
  /// **'I\'m good, thanks for asking! Your money\'s where I left it. What would you like to know?'**
  String get chatSmallHowAreYou;

  /// No description provided for @chatSmallBye.
  ///
  /// In en, this message translates to:
  /// **'Bye! Come back before your next big spend.'**
  String get chatSmallBye;

  /// No description provided for @chatSmallOkay.
  ///
  /// In en, this message translates to:
  /// **'Anything else you\'d like to check?'**
  String get chatSmallOkay;

  /// No description provided for @askHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Talk to Upino'**
  String get askHubTitle;

  /// No description provided for @askHubNew.
  ///
  /// In en, this message translates to:
  /// **'Ask what you can spend, what a purchase would do, or when your pay comes. I\'m still getting to know you, so I\'ll get more useful as you record.'**
  String get askHubNew;

  /// No description provided for @askHubLearning.
  ///
  /// In en, this message translates to:
  /// **'I\'m learning your habits: about {days} more days and I\'ll have a full season to advise from.'**
  String askHubLearning(int days);

  /// No description provided for @askHubFamiliar.
  ///
  /// In en, this message translates to:
  /// **'I know your money well now. Ask me anything, including how to spend less.'**
  String get askHubFamiliar;

  /// No description provided for @askHubStart.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation'**
  String get askHubStart;

  /// No description provided for @askHubCommon.
  ///
  /// In en, this message translates to:
  /// **'Common questions'**
  String get askHubCommon;

  /// No description provided for @askHubHistory.
  ///
  /// In en, this message translates to:
  /// **'Your conversations'**
  String get askHubHistory;

  /// No description provided for @askHubTurns.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 question} other{{count} questions}}'**
  String askHubTurns(int count);

  /// No description provided for @askHubAsidePreview.
  ///
  /// In en, this message translates to:
  /// **'{amount} set aside across {count} commitments'**
  String askHubAsidePreview(String amount, int count);

  /// No description provided for @askHubDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this conversation?'**
  String get askHubDeleteTitle;

  /// No description provided for @askHubDeleteBlurb.
  ///
  /// In en, this message translates to:
  /// **'Only the conversation goes. Nothing in your plan changes.'**
  String get askHubDeleteBlurb;

  /// No description provided for @chatSmallHi.
  ///
  /// In en, this message translates to:
  /// **'Hi!'**
  String get chatSmallHi;

  /// No description provided for @chatSmallHiFine.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m good, thanks.'**
  String get chatSmallHiFine;

  /// No description provided for @chatSafeLasts.
  ///
  /// In en, this message translates to:
  /// **'That has to last {days} days, until your pay.'**
  String chatSafeLasts(int days);

  /// No description provided for @homeSpokenFor.
  ///
  /// In en, this message translates to:
  /// **'{amount} of your money is already spoken for until {date}.'**
  String homeSpokenFor(String amount, String date);

  /// No description provided for @askGoalLater.
  ///
  /// In en, this message translates to:
  /// **'{goal} · about {days, plural, =1{a day} other{{days} days}} later'**
  String askGoalLater(String goal, int days);

  /// No description provided for @askGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Goals move later'**
  String get askGoalsTitle;

  /// No description provided for @askGoalsNote.
  ///
  /// In en, this message translates to:
  /// **'Roughly, at the pace each goal is being saved for.'**
  String get askGoalsNote;

  /// No description provided for @chatPurchaseGoal.
  ///
  /// In en, this message translates to:
  /// **'It would push {goal} back by about {days, plural, =1{a day} other{{days} days}}.'**
  String chatPurchaseGoal(String goal, int days);

  /// No description provided for @monthTitle.
  ///
  /// In en, this message translates to:
  /// **'Your month'**
  String get monthTitle;

  /// No description provided for @monthWindow.
  ///
  /// In en, this message translates to:
  /// **'The last 30 days, against the 30 before'**
  String get monthWindow;

  /// No description provided for @monthTooSoon.
  ///
  /// In en, this message translates to:
  /// **'A month review needs a month of spending. Yours is ready in {days, plural, =1{a day} other{{days} days}}.'**
  String monthTooSoon(int days);

  /// No description provided for @monthSpent.
  ///
  /// In en, this message translates to:
  /// **'In the last 30 days, {amount} went out.'**
  String monthSpent(String amount);

  /// No description provided for @monthNothing.
  ///
  /// In en, this message translates to:
  /// **'Nothing was recorded in the last 30 days.'**
  String get monthNothing;

  /// No description provided for @monthMore.
  ///
  /// In en, this message translates to:
  /// **'That is {amount} more than the 30 days before.'**
  String monthMore(String amount);

  /// No description provided for @monthLess.
  ///
  /// In en, this message translates to:
  /// **'That is {amount} less than the 30 days before.'**
  String monthLess(String amount);

  /// No description provided for @monthSame.
  ///
  /// In en, this message translates to:
  /// **'About the same as the 30 days before.'**
  String get monthSame;

  /// No description provided for @monthUp.
  ///
  /// In en, this message translates to:
  /// **'Up the most: {category}, by {amount}.'**
  String monthUp(String category, String amount);

  /// No description provided for @monthDown.
  ///
  /// In en, this message translates to:
  /// **'Down the most: {category}, by {amount}.'**
  String monthDown(String category, String amount);

  /// No description provided for @monthGoals.
  ///
  /// In en, this message translates to:
  /// **'Goals on track: {onTrack} of {total}.'**
  String monthGoals(int onTrack, int total);

  /// No description provided for @chatSuggestMonth.
  ///
  /// In en, this message translates to:
  /// **'How was my month?'**
  String get chatSuggestMonth;

  /// No description provided for @timelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Your money ahead'**
  String get timelineTitle;

  /// No description provided for @timelineToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get timelineToday;

  /// No description provided for @timelineNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get timelineNow;

  /// No description provided for @timelineProjected.
  ///
  /// In en, this message translates to:
  /// **'Projected'**
  String get timelineProjected;

  /// No description provided for @timelineRecorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get timelineRecorded;

  /// No description provided for @timelineFree.
  ///
  /// In en, this message translates to:
  /// **'Free to spend'**
  String get timelineFree;

  /// No description provided for @timelineHad.
  ///
  /// In en, this message translates to:
  /// **'You had'**
  String get timelineHad;

  /// No description provided for @timelineBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance {amount}'**
  String timelineBalance(String amount);

  /// No description provided for @timelineSetAside.
  ///
  /// In en, this message translates to:
  /// **'Set aside {amount}'**
  String timelineSetAside(String amount);

  /// No description provided for @timelinePayMark.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String timelinePayMark(String amount);

  /// No description provided for @timelineShort.
  ///
  /// In en, this message translates to:
  /// **'{amount} short for something that must be paid'**
  String timelineShort(String amount);

  /// No description provided for @timelineWithout.
  ///
  /// In en, this message translates to:
  /// **'Without it: {amount}'**
  String timelineWithout(String amount);

  /// No description provided for @timelineBuyAfterPay.
  ///
  /// In en, this message translates to:
  /// **'Buy after pay'**
  String get timelineBuyAfterPay;

  /// No description provided for @timelineBalanceLegend.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get timelineBalanceLegend;

  /// No description provided for @timelineWithPurchase.
  ///
  /// In en, this message translates to:
  /// **'With the purchase'**
  String get timelineWithPurchase;

  /// No description provided for @timelinePay.
  ///
  /// In en, this message translates to:
  /// **'Pay day'**
  String get timelinePay;

  /// No description provided for @timelineAssumptions.
  ///
  /// In en, this message translates to:
  /// **'Ahead is a projection: your pay on its date, bills on theirs, what is set aside for living spent evenly, and nothing else. Drag across the chart to see any day.'**
  String get timelineAssumptions;

  /// No description provided for @timelineSemantics.
  ///
  /// In en, this message translates to:
  /// **'Chart of your balance and what is free to spend, day by day'**
  String get timelineSemantics;

  /// No description provided for @goalChartSemantics.
  ///
  /// In en, this message translates to:
  /// **'Chart of how {goal} gets to its target'**
  String goalChartSemantics(String goal);

  /// No description provided for @goalChartTarget.
  ///
  /// In en, this message translates to:
  /// **'Target {amount} by {date}'**
  String goalChartTarget(String amount, String date);

  /// No description provided for @goalPaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Put aside each pay period: {amount}'**
  String goalPaceLabel(String amount);

  /// No description provided for @goalOnTrack.
  ///
  /// In en, this message translates to:
  /// **'On track: reached by {date}.'**
  String goalOnTrack(String date);

  /// No description provided for @goalLate.
  ///
  /// In en, this message translates to:
  /// **'At this pace it is reached on {date}, {days, plural, =1{a day} other{{days} days}} after its date.'**
  String goalLate(String date, int days);

  /// No description provided for @goalNotMoving.
  ///
  /// In en, this message translates to:
  /// **'Nothing is going to it right now, so it is not getting closer.'**
  String get goalNotMoving;

  /// No description provided for @goalUsePace.
  ///
  /// In en, this message translates to:
  /// **'Move the target date to {date}'**
  String goalUsePace(String date);

  /// No description provided for @goalPaceNote.
  ///
  /// In en, this message translates to:
  /// **'Only a what-if: nothing changes until you choose.'**
  String get goalPaceNote;

  /// No description provided for @goalShowPath.
  ///
  /// In en, this message translates to:
  /// **'See how it gets there'**
  String get goalShowPath;

  /// No description provided for @goalHidePath.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get goalHidePath;
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
