// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navPlan => 'الخطة';

  @override
  String get navGoals => 'الأهداف';

  @override
  String get navActivity => 'السجل';

  @override
  String get navProfile => 'الملف';

  @override
  String get currencyTitle => 'أي عملة؟';

  @override
  String get currencyBlurb =>
      'كل ما في خطتك محفوظ بهذه العملة وحدها. اختر العملة التي تتقاضى راتبك بها فعلاً.';

  @override
  String get currencySearchHint => 'ابحث عن بلد أو عملة أو رمز';

  @override
  String currencyNoMatch(String query) {
    return 'لا يوجد ما يطابق «$query». جرّب اسم البلد أو الرمز المكوّن من ثلاثة أحرف.';
  }

  @override
  String get onboardingBadge => 'يستغرق دقيقة تقريباً';

  @override
  String get onboardingTitle => 'أعدّ خطتك';

  @override
  String get onboardingBlurb =>
      'إجابتان تكفيان للبدء. كل ما عداهما يمكن أن ينتظر.';

  @override
  String get onboardingBalanceLabel => 'كم لديك الآن؟';

  @override
  String get onboardingBalanceHint => 'في الحسابات التي تنفق منها';

  @override
  String get onboardingIncomeLabel => 'كم راتبك القادم؟';

  @override
  String get onboardingIncomeHint => 'مبلغك المعتاد يكفي';

  @override
  String get onboardingPayDay => 'متى راتبك القادم؟';

  @override
  String onboardingDays(int count) {
    return '$count يوماً';
  }

  @override
  String get onboardingCommitments => 'أضف التزاماتك';

  @override
  String get onboardingCommitmentsOpen => 'الإيجار والضروريات وهدف';

  @override
  String get onboardingCommitmentsShut => 'اختياري، ويمكنك فعله لاحقاً';

  @override
  String get onboardingRentLabel => 'الإيجار والفواتير الثابتة';

  @override
  String get onboardingRentHint => 'تستحق قبل راتبك القادم';

  @override
  String get onboardingEssentialsLabel => 'الطعام والتنقل';

  @override
  String get onboardingEssentialsHint => 'ما تحتاجه لتمضية هذه الفترة';

  @override
  String get onboardingGoalLabel => 'ادخار لهدف';

  @override
  String get onboardingGoalHint => 'ما تريد تجنيبه هذه الفترة';

  @override
  String get onboardingFinish => 'أنشئ خطتي';

  @override
  String get onboardingIncomplete => 'املأ الإجابتين الأوليين للمتابعة';

  @override
  String get tapToType => 'اضغط واكتب';

  @override
  String get heroSafeToSpend => 'يمكنك إنفاقه الآن';

  @override
  String get heroNotUpToDate => 'غير محدّث';

  @override
  String get heroRecordSpend => 'سجّل مصروفاً';

  @override
  String get heroSeeShort => 'أرني ما ينقص';

  @override
  String get heroConfirmBalance => 'أكّد الرصيد';

  @override
  String get heroReviewBlurb => 'تحقّق من رصيدك ليعود هذا الرقم جديراً بالثقة.';

  @override
  String heroUntilSetAside(String date, String amount) {
    return 'حتى $date · $amount مجنّبة';
  }

  @override
  String heroShort(String amount) {
    return 'ينقص $amount';
  }

  @override
  String heroUnfunded(String label, String amount) {
    return '$label · $amount غير مغطّاة';
  }

  @override
  String get heroBalanceNever => 'لم يُؤكَّد الرصيد بعد';

  @override
  String get heroBalanceToday => 'أُكِّد الرصيد اليوم';

  @override
  String get heroBalanceYesterday => 'أُكِّد الرصيد أمس';

  @override
  String heroBalanceDays(int count) {
    return 'أُكِّد الرصيد قبل $count يوماً';
  }

  @override
  String get confirm => 'تأكيد';

  @override
  String get homeTitle => 'خطتك';

  @override
  String homeUntilTotal(String date, String amount) {
    return 'حتى $date · $amount إجمالاً';
  }

  @override
  String homeRecorded(String amount) {
    return 'سُجِّل $amount';
  }

  @override
  String get homeAttention => 'يحتاج انتباهك';

  @override
  String homeNotCovered(String amount) {
    return '$amount غير مغطّاة';
  }

  @override
  String get homeAfterNextPay => 'بعد راتبك القادم';

  @override
  String homeOncePayArrives(String date) {
    return 'حين يصل راتبك في $date';
  }

  @override
  String get homeSetAsideFirst => 'يُجنَّب أولاً';

  @override
  String get homeProtectedBlurb => 'محميّ قبل أن يصبح أي شيء قابلاً للإنفاق.';

  @override
  String get homeNothingSetAside =>
      'لم يُجنَّب شيء بعد. كل ما لديك قابل للإنفاق.';

  @override
  String get homeWhyThisNumber => 'لماذا هذا الرقم';

  @override
  String get homeWhatIsShort => 'ما الذي ينقص';

  @override
  String get homeShortBlurb =>
      'لا شيء هنا يُنقل أو يؤجَّل نيابةً عنك. هذه التزامات لا تغطيها أموالك الحالية.';

  @override
  String get askSpendTitle => 'كم أنفقت؟';

  @override
  String get askBalanceTitle => 'كم رصيدك الآن؟';

  @override
  String get askBalanceBlurb => 'أي فرق يُسجَّل تصحيحاً، لا إنفاقاً.';

  @override
  String get whyNoChange => 'لم يتغيّر شيء منذ خطتك السابقة.';

  @override
  String get whyPayArrived => 'وصل راتبك، فحُدِّثت الخطة.';

  @override
  String get whyBillPaid => 'دُفعت فاتورة كنت قد جنّبت لها مالاً.';

  @override
  String get whyHeldForBill => 'حُجز مال لفاتورة تستحق بُعيد راتبك القادم.';

  @override
  String get whyOvercommitted => 'التزمت بأكثر مما تملك حالياً.';

  @override
  String get whyStale => 'لم يُؤكَّد رصيدك مؤخراً.';

  @override
  String get whyCardLarger => 'رصيد بطاقتك أكبر من المال الذي تملكه.';

  @override
  String get whyPayLate => 'راتبك المتوقّع لم يصل بعد.';

  @override
  String get whyOverdue => 'شيء تجاوز موعد استحقاقه.';

  @override
  String get whyBufferShort => 'احتياطي الطوارئ لديك غير مكتمل.';

  @override
  String get whyGoalShort => 'لا يمكن تمويل هدف ادخارك بالكامل الآن.';

  @override
  String get whyFlexibleLess => 'هدف مرن تلقّى أقل مما خُطّط له.';

  @override
  String get whyDuplicate => 'عملية مكرّرة حُسبت مرة واحدة فقط.';

  @override
  String get planTitle => 'الخطة';

  @override
  String get planBlurb =>
      'ما وُعدت به أموالك، قبل أن يصبح أي شيء قابلاً للإنفاق.';

  @override
  String get planMoneyAndIncome => 'المال والدخل';

  @override
  String get planMoneyYouHave => 'المال الذي تملكه';

  @override
  String get planNextPay => 'الراتب القادم';

  @override
  String get planYourNextPay => 'راتبك القادم';

  @override
  String get planNotSet => 'غير محدّد';

  @override
  String get planExpectedBlurb =>
      'هذا متوقّع فقط، لذا يبقى خارج ما يمكنك إنفاقه الآن.';

  @override
  String get planSetAsideFirst => 'يُجنَّب أولاً';

  @override
  String get planNothingSetAside => 'لم يُجنَّب شيء، فكل ما لديك قابل للإنفاق.';

  @override
  String get planAddToPlan => 'أضف إلى خطتك';

  @override
  String get planGoals => 'الأهداف';

  @override
  String get planSaveToward => 'ادّخر لشيء ما';

  @override
  String get planSaveTowardSub => 'رحلة، أو دفعة، أو حاسوب جديد';

  @override
  String get planAllGoals => 'كل الأهداف';

  @override
  String get planAllGoalsSub => 'أضف أو عدّل أو جنّب مالاً';

  @override
  String get planHowMuchSetAside => 'كم تحتاج أن تجنّب لهذا؟';

  @override
  String get planChangeOrRemove => 'غيّر المبلغ، أو احذفه من خطتك.';

  @override
  String get planRemove => 'احذف من الخطة';

  @override
  String planDue(String date) {
    return ' · يستحق $date';
  }

  @override
  String get priorityMandatory => 'يجب دفعه — يأتي أولاً';

  @override
  String get priorityEssential => 'احتياجات يومية';

  @override
  String get priorityBuffer => 'محجوز للطوارئ';

  @override
  String get priorityCard => 'أُنفق على بطاقة سلفاً';

  @override
  String get prioritySinkingFund => 'ادخار لفاتورة معلومة';

  @override
  String get priorityGoal => 'هدف التزمت به';

  @override
  String get priorityDiscretionary => 'جميل لو توفّر — يتنازل أولاً';

  @override
  String get goalsTitle => 'الأهداف';

  @override
  String get goalsBlurbEmpty => 'لا ادخار لأي شيء بعد.';

  @override
  String get goalsBlurb => 'ما يحتاجه كل هدف من فترة الراتب هذه.';

  @override
  String get goalsEmptyCard =>
      'أضف شيئاً تدّخر من أجله — رحلة، أو دفعة، أو حاسوباً جديداً. يحسب أوبينو ما يجب حجزه كل فترة راتب ليصل في موعده.';

  @override
  String get goalsNew => 'هدف جديد';

  @override
  String get goalsNewSub => 'شيء تجنّب المال من أجله';

  @override
  String get goalsAddMoney => 'أضف مالاً';

  @override
  String goalsAddTo(String name) {
    return 'أضف إلى $name';
  }

  @override
  String get goalsAddBlurb =>
      'هذا يسجّل ما جنّبته. لا يُنفق شيئاً — بل يقلّل ما يجب حجزه من الآن فصاعداً.';

  @override
  String get goalsEachPeriod => 'كل فترة راتب';

  @override
  String get goalsTargetDate => 'التاريخ المستهدف';

  @override
  String goalsOf(String amount) {
    return 'من $amount';
  }

  @override
  String goalsPeriodsToGo(int count) {
    return 'بقيت $count فترة راتب';
  }

  @override
  String get goalsDone => 'اكتمل الادخار';

  @override
  String get goalsPausedStatus => 'متوقّف — لا يُحجز شيء';

  @override
  String get goalsFlexibleStatus => 'مرن — يتنازل لأي شيء يجب دفعه';

  @override
  String get goalEditNew => 'لأي شيء تدّخر؟';

  @override
  String get goalEditExisting => 'تعديل الهدف';

  @override
  String get goalName => 'الاسم';

  @override
  String get goalNameHint => 'رحلة، أو دفعة، أو حاسوب';

  @override
  String get goalTotal => 'كم إجمالاً';

  @override
  String get goalByWhen => 'بحلول متى';

  @override
  String goalMonths(int count) {
    return '$count شهراً';
  }

  @override
  String get goalOneYear => 'سنة';

  @override
  String get goalTwoYears => 'سنتان';

  @override
  String get goalFirmness => 'ما مدى إلزامه؟';

  @override
  String get goalKindHard => 'ملتزم';

  @override
  String get goalKindHardSub => 'يُحجز قبل أن يصبح أي شيء قابلاً للإنفاق';

  @override
  String get goalKindFlexible => 'مرن';

  @override
  String get goalKindFlexibleSub => 'يتنازل لأي شيء يجب دفعه';

  @override
  String get goalKindPaused => 'متوقّف';

  @override
  String get goalKindPausedSub => 'يبقى ظاهراً، ولا يُحجز شيء';

  @override
  String get goalSaveChanges => 'احفظ التغييرات';

  @override
  String get goalAddThis => 'أضف هذا الهدف';

  @override
  String get goalDelete => 'احذف هذا الهدف';

  @override
  String get activityTitle => 'السجل';

  @override
  String get activityBlurb => 'كل ما سجّلته، الأحدث أولاً.';

  @override
  String get activityEmpty =>
      'حين تسجّل مصروفاً سيظهر هنا، ويمكنك إزالته إن أخطأت.';

  @override
  String get activityRemoveIt => 'احذفه';

  @override
  String get activityKeepIt => 'أبقه';

  @override
  String get activitySpent => 'مصروف';

  @override
  String get activityIncome => 'راتب';

  @override
  String get activityCorrection => 'تصحيح';

  @override
  String get activityRemoved => 'محذوف';

  @override
  String get profileTitle => 'الملف';

  @override
  String get profileConfirmBalance => 'أكّد رصيدك';

  @override
  String get profileTrustTitle => 'ما مدى موثوقية الرقم؟';

  @override
  String get profileTrustFresh => 'محدّث. لا شيء يحتاج انتباهك.';

  @override
  String get profileTrustDegraded =>
      'لم يُؤكَّد رصيدك منذ فترة. الرقم لا يزال معروضاً، لكنه أقل يقيناً.';

  @override
  String get profileTrustReview =>
      'أقدم أو أقل يقيناً من أن يُعتمد عليه. أكّد رصيدك لإصلاحه.';

  @override
  String get profileConfirmedNever => 'لم يُؤكَّد بعد';

  @override
  String get profileConfirmedToday => 'أُكِّد اليوم';

  @override
  String get profileConfirmedYesterday => 'أُكِّد أمس';

  @override
  String profileConfirmedDays(int count) {
    return 'أُكِّد قبل $count يوماً';
  }

  @override
  String get profileAppearance => 'المظهر';

  @override
  String get profileTheme => 'السمة';

  @override
  String get profileThemeBlurb =>
      'اتباع هاتفك هو الوضع الافتراضي، فلا شيء مفروض.';

  @override
  String get themePhone => 'الهاتف';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get profileLanguage => 'اللغة';

  @override
  String get profileLanguageBlurb =>
      'اتباع هاتفك هو الوضع الافتراضي، فلا شيء مفروض.';

  @override
  String get languagePhone => 'الهاتف';

  @override
  String get profileCurrency => 'العملة';

  @override
  String get profileYourData => 'بياناتك';

  @override
  String get profileDelete => 'احذف خطتي';

  @override
  String get profileDeleteSub => 'يمسح كل شيء ويعيدك إلى الإعداد';

  @override
  String get profileStartOver => 'البدء من جديد؟';

  @override
  String get profileStartOverBlurb =>
      'ستُحذف خطتك وكل ما سجّلته. لا يمكن التراجع عن هذا.';

  @override
  String get profileDeleteEverything => 'احذف كل شيء';

  @override
  String get profileKeepPlan => 'أبقِ خطتي';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String activityRemoveAmount(String amount) {
    return 'إزالة $amount؟';
  }

  @override
  String get activityRemoveDetail =>
      'يتوقف احتسابه في خطتك فوراً. يبقى القيد في هذه القائمة موسوماً بأنه مُزال، فيظل سجلك كاملاً.';

  @override
  String get activityCardPurchase => 'شراء بالبطاقة';

  @override
  String get activityCardPayment => 'سداد البطاقة';

  @override
  String get activityRefund => 'استرداد';

  @override
  String get activityTransfer => 'تحويل بين الحسابات';

  @override
  String get activityLoan => 'قرض مستلم';

  @override
  String get activityDebtPayment => 'سداد دين';

  @override
  String get activityBalanceCorrected => 'تصحيح الرصيد';

  @override
  String get activityBlurbEmpty => 'لم يُسجَّل شيء بعد.';

  @override
  String get profileStartAgain => 'البدء من جديد';

  @override
  String get claimRent => 'الإيجار والفواتير';

  @override
  String get claimCardMinimum => 'الحد الأدنى للبطاقة';

  @override
  String get claimEssentials => 'الطعام والتنقل';

  @override
  String get claimBuffer => 'احتياطي الطوارئ';

  @override
  String get languageTitle => 'أي لغة؟';

  @override
  String get languageBlurb => 'يمكنك تغييرها لاحقاً من الملف.';

  @override
  String get profileLedgerTitle => 'هل السجل كامل؟';

  @override
  String get ledgerComplete => 'كل ما أنفقته مسجَّل.';

  @override
  String get ledgerPartial => 'بعض المصروفات ظهرت فقط عند تأكيد رصيدك.';

  @override
  String get ledgerUnknown => 'لا يعرف أوبينو كم ينقص. أكّد رصيدك لتعرف.';

  @override
  String get askTitle => 'اسأل قبل أن تنفق';

  @override
  String get askBlurb =>
      'جرّب عملية شراء على خطتك. لا يُسجَّل شيء ولا يتغيّر شيء.';

  @override
  String get askAmountLabel => 'كم ستكون؟';

  @override
  String get askRun => 'أرني ما ستفعله';

  @override
  String get askDoNotBuy => 'عدم الشراء';

  @override
  String get askBuyNow => 'اشترِها اليوم';

  @override
  String askBuyAfter(String date) {
    return 'اشترِها بعد $date';
  }

  @override
  String get askUnchanged => 'تبقى خطتك كما هي.';

  @override
  String get askStsAfter => 'ما يمكنك إنفاقه بعدها';

  @override
  String get askBreaks => 'هذا يترك شيئاً يجب دفعه دون تغطية.';

  @override
  String get askSafe => 'لا شيء مما يجب دفعه يبقى دون تغطية.';

  @override
  String get askCosts => 'ما الذي ينقص';

  @override
  String askCostLine(String label, String amount) {
    return '$label · $amount أقل';
  }

  @override
  String get askWaitingHelps => 'الانتظار حتى وصول راتبك يغطّي كل شيء.';

  @override
  String get askNoIncome => 'لا راتب متوقّع بعد، فلا وقت لاحق للمقارنة.';

  @override
  String askAssumption(String date) {
    return 'بافتراض وصول راتبك كما هو متوقّع في $date.';
  }

  @override
  String get askNoVerdict => 'لا يقول أوبينو نعم أو لا. المفاضلة لك.';

  @override
  String get receipt => 'الإيصال';

  @override
  String get receiptAdd => 'أضف إيصالاً';

  @override
  String get receiptCamera => 'التقاط صورة';

  @override
  String get receiptGallery => 'اختيار صورة';

  @override
  String get receiptAttached => 'أُرفق الإيصال';

  @override
  String get receiptRemove => 'إزالة الصورة';
}
