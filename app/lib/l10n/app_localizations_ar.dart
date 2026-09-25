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
  String get onboardingBalanceLabel => 'مدّخراتك اليوم';

  @override
  String get onboardingBalanceHint =>
      'المال الذي يمكنك الإنفاق منه فعلاً، لا ما تنوي إبقاءه دون مساس.';

  @override
  String get onboardingIncomeLabel => 'كم تكسب في الشهر؟';

  @override
  String get onboardingIncomeHint =>
      'إن كان متغيّراً فاذكر المدى. تُبنى خطتك على الحد الأدنى.';

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
  String currencyChangeTitle(String currency) {
    return 'التحويل إلى $currency؟';
  }

  @override
  String currencyChangeBlurb(String currency) {
    return 'يحتفظ كل مبلغ في خطتك برقمه ويُعرض بـ $currency من الآن. لا يُحوَّل أي شيء بسعر صرف، فاستخدم هذا لتصحيح العملة لا لتحويل أموالك.';
  }

  @override
  String get currencyChangeConfirm => 'تحويل';

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

  @override
  String get onboardingIncomeFrom => 'على الأقل';

  @override
  String get onboardingIncomeTo => 'حتى';

  @override
  String get onboardingIncomeToOptional => 'اختياري';

  @override
  String incomeRange(String low, String high) {
    return '$low إلى $high';
  }

  @override
  String incomeRangeNote(String low) {
    return 'خطتك مبنية على $low. وما زاد فهو لك حين يصل.';
  }

  @override
  String get categoryFood => 'طعام';

  @override
  String get categoryTransport => 'مواصلات';

  @override
  String get categoryBills => 'فواتير';

  @override
  String get categoryShopping => 'تسوّق';

  @override
  String get categoryHealth => 'صحة';

  @override
  String get categoryFun => 'ترفيه';

  @override
  String get categoryOther => 'أخرى';

  @override
  String get categoryUnsorted => 'غير مصنّف';

  @override
  String get categoryPrompt => 'لأيّ شيء كان؟';

  @override
  String get spendingTitle => 'أين ذهب المال';

  @override
  String get spendingWindow => 'المصروفات المسجلة في آخر 30 يومًا';

  @override
  String get backupSection => 'نسخة احتياطية';

  @override
  String get backupSave => 'حفظ نسخة احتياطية';

  @override
  String get backupSaveSub =>
      'مقفلة بكلمة مرور. أرسلها إلى مكان آمن مثل تخزينك السحابي.';

  @override
  String get backupRestore => 'الاستعادة من نسخة احتياطية';

  @override
  String get backupRestoreSub => 'تستبدل الخطة على هذا الهاتف';

  @override
  String get backupPassword => 'كلمة المرور';

  @override
  String get backupPasswordRepeat => 'أعد كتابة كلمة المرور';

  @override
  String get backupPasswordSaveBlurb =>
      'ستحتاج كلمة المرور هذه للاستعادة، ولا يمكن استرجاعها إن نسيتها. صور الإيصالات غير مشمولة.';

  @override
  String get backupPasswordOpenBlurb =>
      'كلمة المرور التي حُفظت بها هذه النسخة.';

  @override
  String get backupPasswordShort => '6 أحرف على الأقل';

  @override
  String get backupPasswordMismatch => 'الكلمتان غير متطابقتين';

  @override
  String get backupOpen => 'فتح';

  @override
  String get backupReplaceTitle => 'استبدال هذه الخطة؟';

  @override
  String get backupReplaceBlurb =>
      'يُستبدل كل ما على هذا الهاتف بمحتوى النسخة الاحتياطية. لا يمكن التراجع.';

  @override
  String get backupReplace => 'استبدال';

  @override
  String get backupRestored => 'تمت الاستعادة';

  @override
  String get backupWrongPassword => 'كلمة المرور هذه لا تفتح النسخة.';

  @override
  String get backupNotABackup => 'هذا الملف ليس نسخة احتياطية من Upino.';

  @override
  String get backupUnreadable =>
      'أُنشئت هذه النسخة بإصدار أحدث من Upino. حدّث التطبيق وحاول مجددًا.';

  @override
  String get inflationTitle => 'التضخم';

  @override
  String get inflationNotSet =>
      'غير محدد. أضف المعدل السنوي في بلدك لترى الكلفة الحقيقية للأهداف.';

  @override
  String inflationRate(String rate) {
    return '$rate% سنويًا';
  }

  @override
  String get inflationDialogTitle => 'التضخم السنوي';

  @override
  String get inflationDialogBlurb =>
      'ترتفع الأسعار، فالهدف المحدد بأموال اليوم يكلف أكثر في موعده. أدخل المعدل المتوقع، واتركه فارغًا لإيقاف ذلك.';

  @override
  String goalsInflated(String rate, String amount) {
    return 'بمعدل $rate% سنويًا، سيكلف هذا نحو $amount بحلول ذلك الوقت.';
  }

  @override
  String get holdingsTitle => 'مدخرات أخرى';

  @override
  String get holdingsBlurb =>
      'دولارات، ذهب، عملات. تُعرض بجانب خطتك ولا تُحسب أبدًا ضمن ما يمكنك إنفاقه.';

  @override
  String get holdingsAdd => 'إضافة مدخرات';

  @override
  String get holdingsAddSub => 'لا تُحسب ضمن ما يمكنك إنفاقه';

  @override
  String get holdingsTotal => 'المجموع';

  @override
  String holdingSummary(String quantity, String price, String date) {
    return '$quantity × $price · سعر $date';
  }

  @override
  String get holdingEditNew => 'مدخرات جديدة';

  @override
  String get holdingEditExisting => 'تعديل المدخرات';

  @override
  String get holdingName => 'ما هي؟';

  @override
  String get holdingNameHint => 'دولار، ذهب…';

  @override
  String get holdingUsd => 'دولار';

  @override
  String get holdingEur => 'يورو';

  @override
  String get holdingGold => 'ذهب (غرام)';

  @override
  String get holdingCoin => 'جنيه ذهب';

  @override
  String get holdingQuantity => 'كم';

  @override
  String get holdingUnitPrice => 'قيمة الواحد اليوم';

  @override
  String holdingWorth(String amount) {
    return 'القيمة الإجمالية $amount';
  }

  @override
  String get holdingDelete => 'إزالة هذه المدخرات';

  @override
  String get fasterTitle => 'إدخال أسرع';

  @override
  String get smsTitle => 'قراءة رسائل البنك';

  @override
  String get smsDetail =>
      'تُعرض عليك المصروفات التي يرسل بها البنك رسائل لتسجيلها بلمسة. تُقرأ الرسائل على هذا الهاتف فقط ولا تُرسل إلى أي مكان.';

  @override
  String get smsDenied =>
      'لم يُسمح لـ Upino بقراءة الرسائل. يمكنك السماح بذلك من إعدادات الهاتف.';

  @override
  String smsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count رسائل بنكية للمراجعة',
      one: 'رسالة بنكية واحدة للمراجعة',
    );
    return '$_temp0';
  }

  @override
  String get smsWaitingSub => 'سجّل كلًا منها بلمسة أو تخطَّه';

  @override
  String get smsReviewTitle => 'من بنكك';

  @override
  String get smsReviewBlurb =>
      'لا يُسجَّل شيء حتى تضغط «تسجيل». طابق المبلغ مع الرسالة.';

  @override
  String get smsReviewDone => 'لا شيء متبقٍ.';

  @override
  String get smsRecord => 'تسجيل';

  @override
  String get smsSkip => 'تخطٍّ';

  @override
  String get reminderTitleSetting => 'تذكير مسائي';

  @override
  String get reminderDetail =>
      'في التاسعة مساءً، فقط في الأيام التي لم يُسجَّل فيها شيء.';

  @override
  String get reminderDenied =>
      'لم يُسمح لـ Upino بعرض الإشعارات. يمكنك السماح بذلك من الإعدادات.';

  @override
  String get reminderTitle => 'هل أنفقت شيئًا اليوم؟';

  @override
  String get reminderBody => 'سجّله في ثوانٍ ليكون رقم الغد صحيحًا.';

  @override
  String get reminderChannel => 'تذكير مسائي';

  @override
  String get widgetSpend => '+ مصروف';

  @override
  String get widgetAdd => 'إضافة إلى الشاشة الرئيسية';

  @override
  String get widgetAddSub => 'ما يمكنك إنفاقه وزر لتسجيل مصروف دون فتح التطبيق';

  @override
  String get voiceListening => 'أستمع… قل المبلغ وفيمَ كان.';

  @override
  String voiceHeard(String text) {
    return 'سُمع: «$text». راجع المبلغ ثم احفظ.';
  }

  @override
  String get voiceNothing => 'لم يُسمع مبلغ. حاول مجددًا أو اكتبه.';

  @override
  String get voicePrivacy =>
      'يحوّل هاتفك الكلام إلى نص. في الهواتف دون تعرّف دون اتصال، يمر ذلك عبر خدمة الكلام في الهاتف.';

  @override
  String get voiceButton => 'قُلها';

  @override
  String get voiceUnavailable =>
      'لا يوجد في هذا الهاتف تعرّف على الكلام يمكن للتطبيق استخدامه. اكتب المبلغ.';

  @override
  String get voiceNoPermission =>
      'لم يُسمح لـ Upino باستخدام الميكروفون. يمكنك السماح بذلك من الإعدادات.';

  @override
  String get voiceNetwork =>
      'يحتاج التعرّف على الكلام في هذا الهاتف إلى الإنترنت ولم يتمكن من الوصول إليه.';

  @override
  String voiceNoAmount(String text) {
    return 'سُمع «$text» لكن دون مبلغ. حاول مجددًا أو اكتبه.';
  }

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get navAsk => 'اسأل';

  @override
  String get alertsTitle => 'يحتاج انتباهك';

  @override
  String get alertsEmpty => 'لا شيء يحتاجك الآن. الخطة محدّثة.';

  @override
  String alertUnfunded(String label, String amount) {
    return 'ينقص $label مبلغ $amount';
  }

  @override
  String get alertUnfundedDetail => 'شيء يجب دفعه غير مغطّى بما لديك.';

  @override
  String alertIncomeLate(String date) {
    return 'كان راتبك متوقعًا في $date';
  }

  @override
  String get alertIncomeLateDetail =>
      'لا يُحتسب حتى يصل. غيّر التاريخ في الخطة إن تغيّر.';

  @override
  String alertGoalBehind(String name, String amount) {
    return '$name متأخر بمبلغ $amount هذه الفترة';
  }

  @override
  String get alertGoalBehindDetail =>
      'ما لديك لا يكفي حصة هذه الفترة من الهدف.';

  @override
  String get chatHint => 'اسألني أي شيء أو اكتب سعرًا';

  @override
  String get chatSuggestSafe => 'كم يمكنني أن أنفق؟';

  @override
  String get chatSuggestPay => 'متى راتبي القادم؟';

  @override
  String get chatSuggestWhere => 'أين ذهب مالي؟';

  @override
  String get chatSuggestAside => 'ما المبلغ المجنّب؟';

  @override
  String chatSafe(String amount, String date) {
    return 'يمكنك إنفاق $amount حتى $date.';
  }

  @override
  String get chatSafeStale =>
      'ملاحظة: رصيدك يحتاج إلى تأكيد، فاعتبر هذا تقديرًا.';

  @override
  String chatPay(String amount, String date) {
    return 'راتبك القادم $amount، متوقع في $date.';
  }

  @override
  String get chatPayNone => 'لا أعرف راتبك القادم بعد. أضفه في الخطة وسأتابعه.';

  @override
  String get chatWhere => 'إليك أين ذهب المال في آخر 30 يومًا:';

  @override
  String get chatWhereNone =>
      'لا مصروفات في آخر 30 يومًا. إما شهر هادئ أو لم تُسجَّل.';

  @override
  String chatAside(String amount) {
    return 'يُجنَّب $amount قبل احتساب أي شيء قابل للإنفاق:';
  }

  @override
  String chatPurchase(String amount) {
    return 'لنرَ ماذا سيفعل $amount.';
  }

  @override
  String get chatHelp =>
      'همم، لم أفهم ذلك تمامًا. أستطيع أن أخبرك كم يمكنك إنفاقه، ومتى يصل راتبك، وأين ذهب مالك، وما المجنّب، أو كيف تنفق أقل. أو اكتب سعرًا لأريك أثر الشراء.';

  @override
  String get chatHelloNew =>
      'مرحبًا! أنا Upino. أنت جديد هنا، لذا أعرف الأساسيات فقط: رصيدك وراتبك وما جنّبته. هذا يكفي لأخبرك كم يمكنك أن تنفق وما أثر أي شراء. استمر في تسجيل مصروفاتك، وبعد نحو فصل سأعرف عاداتك بما يكفي لأكون مستشارك المالي.';

  @override
  String chatHelloLearning(int days, int spends, int remaining) {
    return 'أهلًا بعودتك! تعلّمت حتى الآن من $days يومًا و$spends مصروفًا. بعد نحو $remaining يومًا سيكون لديّ فصل كامل.';
  }

  @override
  String chatHelloFamiliar(int days) {
    return 'أهلًا بعودتك! رأيت $days يومًا من أموالك، فاسألني أي شيء، حتى كيف تنفق أقل.';
  }

  @override
  String chatHelloAlerts(int count) {
    return 'بالمناسبة، هناك $count أمور تحتاجك؛ تجدها تحت الجرس.';
  }

  @override
  String chatPurchaseFits(String left) {
    return 'الشراء اليوم يُبقي كل ما يجب دفعه مغطًّى، ويبقى لديك $left.';
  }

  @override
  String chatPurchaseWait(String date) {
    return 'الشراء اليوم سيترك شيئًا يجب دفعه دون تغطية. إن انتظرت حتى $date فسيُغطّى كل شيء.';
  }

  @override
  String chatPurchaseStillShort(String date) {
    return 'انتبه: حتى بعد راتبك في $date، سيبقى شيء يجب دفعه دون تغطية.';
  }

  @override
  String get chatPurchaseShort =>
      'الشراء اليوم سيترك شيئًا يجب دفعه دون تغطية.';

  @override
  String chatSafeNothing(String date) {
    return 'حاليًا لا يوجد فائض حتى $date: كل ما لديك مخصّص لما يجب دفعه.';
  }

  @override
  String chatPayIn(int days) {
    return 'أي بعد $days يومًا.';
  }

  @override
  String get chatPayLate => 'لقد تأخر، لذا لن يُحتسب حتى تؤكد وصوله.';

  @override
  String get chatPayRange =>
      'الخطة تعتمد على الحد الأدنى، فالشهر الجيد مكافأة لا ثغرة.';

  @override
  String chatWhereSoFar(int days) {
    return 'رأيت $days يومًا فقط حتى الآن، فهذه نظرة أولى:';
  }

  @override
  String chatWhereTop(String category, int share) {
    return '$category هو الأكبر: $share% من الإجمالي.';
  }

  @override
  String get chatWhereTooSoon =>
      'الوقت مبكر قليلًا: بالكاد رأيت أي مصروفات. سجّل بعضها واسألني الأسبوع القادم.';

  @override
  String get chatAdviceTooSoon =>
      'أودّ المساعدة، لكن بصراحة لا أعرف مصروفاتك جيدًا بعد، والنصيحة دونها مجرد تخمين. سجّل مصروفاتك (تصنيفها يساعد كثيرًا) واسألني بعد بضعة أسابيع.';

  @override
  String chatAdviceBiggest(String category, String amount, String tenth) {
    return 'أكبر إنفاقك في آخر 30 يومًا كان $category بمبلغ $amount. تقليله بعُشر يوفّر نحو $tenth شهريًا.';
  }

  @override
  String get chatAdviceSort =>
      'أرى كم تنفق لكن لا أعرف على ماذا. صنّف مصروفاتك عند تسجيلها وسأخبرك أين تقلّص.';

  @override
  String chatAdviceMore(String amount) {
    return 'أنفقت $amount أكثر من الشهر السابق.';
  }

  @override
  String chatAdviceLess(String amount) {
    return 'أحسنت: هذا أقل بـ$amount من الشهر السابق.';
  }

  @override
  String get chatAdviceLearning =>
      'ما زلت أتعلّم عاداتك، فاعتبر هذا تلميحًا أوليًا لا الصورة الكاملة.';

  @override
  String get chatSmallHello => 'مرحبًا! ماذا تودّ أن تعرف عن مالك؟';

  @override
  String get chatSmallThanks => 'في أي وقت! أنا هنا كلما أوشكت على الإنفاق.';

  @override
  String get chatSmallWho =>
      'أنا مساعد Upino. أعرف فقط ما في خطتك، وكل رقم أقدّمه يأتي منها مباشرة؛ ولا يغادر شيء هذا الهاتف. لن أقول نعم أو لا، لكن سأريك ما يتركه لك كل خيار.';

  @override
  String get chatSuggestAdvice => 'كيف أنفق أقل؟';

  @override
  String get chatTitle => 'Upino';

  @override
  String get chatNew => 'محادثة جديدة';

  @override
  String get chatResumed => 'الإجابات هنا محسوبة من خطتك كما هي اليوم.';

  @override
  String get chatWhy => 'هكذا يُحسب الرقم:';

  @override
  String get chatWhyHave => 'ما لديك';

  @override
  String get chatWhySetAside => 'يُجنَّب أولًا';

  @override
  String get chatWhyLeft => 'آمن للإنفاق';

  @override
  String get chatSmallHowAreYou =>
      'أنا بخير، شكرًا لسؤالك! مالك حيث تركناه. ماذا تودّ أن تعرف؟';

  @override
  String get chatSmallBye => 'إلى اللقاء! عُد قبل إنفاقك الكبير القادم.';

  @override
  String get chatSmallOkay => 'هل هناك شيء آخر تريد التحقق منه؟';

  @override
  String get askHubTitle => 'تحدّث مع Upino';

  @override
  String get askHubNew =>
      'اسأل كم يمكنك أن تنفق، أو أثر شراء ما، أو متى يصل راتبك. ما زلت أتعرّف عليك، فكلما سجّلت أكثر صرت أنفع.';

  @override
  String askHubLearning(int days) {
    return 'أتعلّم عاداتك: بعد نحو $days يومًا سيكون لديّ فصل كامل للنصح.';
  }

  @override
  String get askHubFamiliar =>
      'أعرف أموالك جيدًا الآن. اسألني أي شيء، حتى كيف تنفق أقل.';

  @override
  String get askHubStart => 'ابدأ محادثة';

  @override
  String get askHubCommon => 'أسئلة شائعة';

  @override
  String get askHubHistory => 'محادثاتك';

  @override
  String askHubTurns(int count) {
    return '$count أسئلة';
  }

  @override
  String askHubAsidePreview(String amount, int count) {
    return '$amount مجنّبة لـ$count التزامات';
  }

  @override
  String get askHubDeleteTitle => 'حذف هذه المحادثة؟';

  @override
  String get askHubDeleteBlurb => 'تُحذف المحادثة فقط، ولا يتغير شيء في خطتك.';

  @override
  String get chatSmallHi => 'مرحبًا!';

  @override
  String get chatSmallHiFine => 'مرحبًا! أنا بخير، شكرًا.';

  @override
  String chatSafeLasts(int days) {
    return 'يجب أن يكفي هذا $days يومًا حتى راتبك.';
  }

  @override
  String homeSpokenFor(String amount, String date) {
    return '$amount من أموالك محجوزة مسبقًا حتى $date.';
  }

  @override
  String askGoalLater(String goal, int days) {
    return '$goal · متأخر نحو $days يوم';
  }

  @override
  String get askGoalsTitle => 'الأهداف تتأخر';

  @override
  String get askGoalsNote => 'تقريبًا، بالوتيرة التي يُدَّخر بها لكل هدف.';

  @override
  String chatPurchaseGoal(String goal, int days) {
    return 'سيؤخر $goal نحو $days يوم.';
  }

  @override
  String get monthTitle => 'شهرك';

  @override
  String get monthWindow => 'آخر 30 يومًا مقارنةً بالـ30 التي قبلها';

  @override
  String monthTooSoon(int days) {
    return 'مراجعة الشهر تحتاج إلى شهر من الإنفاق. ستكون جاهزة بعد $days يوم.';
  }

  @override
  String monthSpent(String amount) {
    return 'في آخر 30 يومًا، خرج $amount.';
  }

  @override
  String get monthNothing => 'لم يُسجَّل شيء في آخر 30 يومًا.';

  @override
  String monthMore(String amount) {
    return 'أي أكثر بـ$amount من الـ30 يومًا السابقة.';
  }

  @override
  String monthLess(String amount) {
    return 'أي أقل بـ$amount من الـ30 يومًا السابقة.';
  }

  @override
  String get monthSame => 'تقريبًا مثل الـ30 يومًا السابقة.';

  @override
  String monthUp(String category, String amount) {
    return 'الأكثر ارتفاعًا: $category، بمقدار $amount.';
  }

  @override
  String monthDown(String category, String amount) {
    return 'الأكثر انخفاضًا: $category، بمقدار $amount.';
  }

  @override
  String monthGoals(int onTrack, int total) {
    return 'الأهداف على المسار: $onTrack من $total.';
  }

  @override
  String get chatSuggestMonth => 'كيف كان شهري؟';

  @override
  String get timelineTitle => 'أموالك في الأيام القادمة';

  @override
  String get timelineToday => 'اليوم';

  @override
  String get timelineNow => 'الآن';

  @override
  String get timelineProjected => 'متوقع';

  @override
  String get timelineRecorded => 'مسجَّل';

  @override
  String get timelineFree => 'متاح للإنفاق';

  @override
  String get timelineHad => 'كان لديك';

  @override
  String timelineBalance(String amount) {
    return 'الرصيد $amount';
  }

  @override
  String timelineSetAside(String amount) {
    return 'محجوز $amount';
  }

  @override
  String timelinePayMark(String amount) {
    return 'الراتب $amount';
  }

  @override
  String timelineShort(String amount) {
    return 'ينقص $amount لدفعة لا بد منها';
  }

  @override
  String timelineWithout(String amount) {
    return 'بدونها: $amount';
  }

  @override
  String get timelineBuyAfterPay => 'الشراء بعد الراتب';

  @override
  String get timelineBalanceLegend => 'الرصيد';

  @override
  String get timelineWithPurchase => 'مع الشراء';

  @override
  String get timelinePay => 'يوم الراتب';

  @override
  String get timelineAssumptions =>
      'ما بعد اليوم توقُّع: راتبك في موعده، والفواتير في مواعيدها، وما خُصص للمعيشة يُنفق بالتساوي، ولا شيء غير ذلك. اسحب على الرسم لترى أي يوم.';

  @override
  String get timelineSemantics =>
      'رسم بياني لرصيدك وما هو متاح للإنفاق يومًا بيوم';

  @override
  String goalChartSemantics(String goal) {
    return 'رسم بياني لوصول $goal إلى هدفه';
  }

  @override
  String goalChartTarget(String amount, String date) {
    return 'الهدف $amount بحلول $date';
  }

  @override
  String goalPaceLabel(String amount) {
    return 'ادخار كل فترة راتب: $amount';
  }

  @override
  String goalOnTrack(String date) {
    return 'على المسار: يتحقق بحلول $date.';
  }

  @override
  String goalLate(String date, int days) {
    return 'بهذه الوتيرة يتحقق في $date، بعد موعده بـ$days يوم.';
  }

  @override
  String get goalNotMoving => 'لا يذهب إليه شيء حاليًا، لذا لا يقترب.';

  @override
  String goalUsePace(String date) {
    return 'انقل موعد الهدف إلى $date';
  }

  @override
  String get goalPaceNote => 'مجرد افتراض: لا يتغير شيء حتى تختار.';

  @override
  String get goalShowPath => 'انظر كيف يصل';

  @override
  String get goalHidePath => 'إخفاء';

  @override
  String get billsTitle => 'الفواتير والاشتراكات';

  @override
  String get billAdd => 'إضافة فاتورة أو اشتراك';

  @override
  String get billAddSub =>
      'الهاتف والإنترنت والتأمين والبث… كلٌّ يُحجز قبل موعده.';

  @override
  String get billEditNew => 'فاتورة جديدة';

  @override
  String get billEditExisting => 'تعديل الفاتورة';

  @override
  String get billName => 'ما هي؟';

  @override
  String get billNameHint => 'مثلًا الإنترنت';

  @override
  String get billAmount => 'كل دفعة';

  @override
  String get billEvery => 'كم مرة';

  @override
  String get billEveryWeek => 'أسبوعيًا';

  @override
  String get billEveryMonth => 'شهريًا';

  @override
  String get billEveryQuarter => 'كل 3 أشهر';

  @override
  String get billEveryYear => 'سنويًا';

  @override
  String get billNext => 'الدفعة التالية';

  @override
  String get billKind => 'النوع';

  @override
  String get billKindBill => 'فاتورة';

  @override
  String get billKindSubscription => 'اشتراك';

  @override
  String get billRepays => 'يسدد';

  @override
  String get billRepaysNothing => 'لا شيء، إنها تكلفة';

  @override
  String get billAddThis => 'أضف هذه الفاتورة';

  @override
  String get billDelete => 'احذف هذه الفاتورة';

  @override
  String billRow(String every, String date) {
    return '$every · التالية $date';
  }

  @override
  String billOverdue(String date) {
    return 'كان مستحقًا في $date';
  }

  @override
  String get billPay => 'تم الدفع';

  @override
  String get billEdit => 'تعديل';

  @override
  String get dayToday => 'اليوم';

  @override
  String dayIn(int days) {
    return 'بعد $days يوم';
  }

  @override
  String dayAgo(int days) {
    return 'قبل $days يوم';
  }

  @override
  String get homeComingUp => 'القادم';

  @override
  String homeComingUpTotal(String amount) {
    return '$amount فواتير مستحقة خلال 30 يومًا.';
  }

  @override
  String payDueTitle(String date) {
    return 'كان راتبك مستحقًا في $date. هل وصل؟';
  }

  @override
  String get payDueSub => 'أخبرنا بما وصل، ويُتوقع الراتب التالي بعد فترة.';

  @override
  String get payArrived => 'وصل';

  @override
  String get payArrivedTitle => 'كم وصل؟';

  @override
  String get planRecordPay => 'وصل الراتب';

  @override
  String get planRecordPaySub => 'سجله لينتقل الراتب التالي فترة';

  @override
  String get accountsTitle => 'الحسابات';

  @override
  String get accountMain => 'الحساب الرئيسي';

  @override
  String get accountKindBank => 'حساب بنكي';

  @override
  String get accountKindCash => 'نقد';

  @override
  String get accountKindSavings => 'مدخرات';

  @override
  String get accountKindCard => 'بطاقة ائتمان';

  @override
  String get accountKindLoan => 'قرض';

  @override
  String get accountAdd => 'إضافة حساب';

  @override
  String get accountAddSub => 'نقد أو مدخرات أو بطاقة أو قرض. دون ربط بالبنك.';

  @override
  String get accountEditNew => 'حساب جديد';

  @override
  String get accountNameHint => 'مثلًا المحفظة';

  @override
  String get accountHolds => 'ما فيه الآن';

  @override
  String get accountOwes => 'المستحق الآن';

  @override
  String get accountCounted => 'احسبه في الخطة';

  @override
  String get accountCountedSub => 'يمكن إنفاق هذا المال هذا الشهر.';

  @override
  String accountOwed(String amount) {
    return 'مستحق $amount';
  }

  @override
  String get accountNotCounted => 'غير محسوب في الخطة';

  @override
  String get accountConfirm => 'أدخل رصيده الفعلي';

  @override
  String get accountMove => 'نقل المال';

  @override
  String accountMoveTo(String name) {
    return 'نقل إلى $name';
  }

  @override
  String get accountMoveBlurb => 'نقل المال بين حساباتك ليس إنفاقًا ولا دخلًا.';

  @override
  String get accountPayCard => 'سداد جزء منه';

  @override
  String get accountPayBlurb =>
      'يُدفع من الحساب الرئيسي. يسدد الدين، وليس إنفاقًا ثانيًا.';

  @override
  String get accountRemove => 'إزالة هذا الحساب';

  @override
  String get accountInUse =>
      'له سجل، لذا يبقى. يمكنك إيقاف احتسابه بدلًا من ذلك.';

  @override
  String get paidFrom => 'الدفع من';

  @override
  String get categorySuggested =>
      'مقترح من مصاريفك السابقة. اضغط غيره للتغيير.';

  @override
  String get recoverTitle => 'أموال عائدة';

  @override
  String recoverTotal(String amount) {
    return 'قد يعود $amount. لا يُحتسب حتى يصل.';
  }

  @override
  String get recoverReturnable => 'قابل للإرجاع';

  @override
  String get recoverExpect => 'أُعيد، والاسترداد متوقع';

  @override
  String get recoverArrived => 'وصل الاسترداد';

  @override
  String get recoverKept => 'احتفظت به';

  @override
  String get recoverPending => 'الاسترداد في الطريق';

  @override
  String get recoverRefunded => 'تم الاسترداد';

  @override
  String get recoverPrompt => 'استرداد المال';

  @override
  String recoverWhere(String amount) {
    return 'عاد $amount. إلى أين يذهب؟';
  }

  @override
  String recoverToGoal(String goal) {
    return 'نحو $goal';
  }

  @override
  String get recoverToBuffer => 'إلى احتياطي الطوارئ';

  @override
  String get recoverLeave => 'اتركه متاحًا للإنفاق';

  @override
  String get accountStopCounting => 'أوقف احتسابه في الخطة';

  @override
  String get moveTitle => 'أفضل خطوة';

  @override
  String get moveTagMove => 'انقل';

  @override
  String get moveTagWait => 'انتظر';

  @override
  String get moveTagSave => 'ادّخر';

  @override
  String get moveTagSpend => 'أنفق';

  @override
  String moveMove(String amount, String account) {
    return 'انقل $amount من $account لتغطية ما يجب دفعه.';
  }

  @override
  String moveMoveWhy(String claim) {
    return '$claim ناقص، وهذا المال خارج الخطة.';
  }

  @override
  String get moveDoIt => 'انقله';

  @override
  String moveWaitGap(String date, String amount) {
    return 'أجّل الكماليات: في $date سينقص $amount من دفعة لا بد منها.';
  }

  @override
  String get moveWaitGapWhy =>
      'يحسب التوقع راتبك وفواتيرك ومعيشتك حتى ذلك اليوم.';

  @override
  String moveWaitPay(int days, String now, String later) {
    return 'راتبك بعد $days يوم. الانتظار يحوّل $now المتاحة إلى $later.';
  }

  @override
  String get moveWaitPayWhy =>
      'فقط إن كان ما تفكر فيه يحتمل الانتظار. لا خطر في الحالتين.';

  @override
  String moveSave(String amount, String account, String goal) {
    return 'انقل $amount إلى $account من أجل $goal.';
  }

  @override
  String moveSaveWhy(int days) {
    return 'يصل قبل نحو $days يوم، ويبقى المتاح ضعف إنفاقك الشهري المعتاد.';
  }

  @override
  String moveSpend(String amount, String date) {
    return 'أنت مغطى حتى $date: $amount متاح لك.';
  }

  @override
  String get moveSpendWhy =>
      'الفواتير والأهداف محجوزة، ولا نقص قادم، وهذا أعلى بكثير من إنفاقك المعتاد.';

  @override
  String get moveNotNow => 'ليس الآن';

  @override
  String get moveNone => 'لا توجد خطوة تستحق الاقتراح الآن. خطتك قائمة كما هي.';

  @override
  String monthIncome(String amount) {
    return 'الدخل الوارد: $amount.';
  }

  @override
  String monthToGoals(String amount) {
    return 'وُضع للأهداف: $amount.';
  }

  @override
  String monthNow(String free, String aside) {
    return 'الآن: $free متاح، و$aside محجوز.';
  }

  @override
  String get monthAheadTitle => 'الأيام الثلاثون القادمة';

  @override
  String monthAheadBills(int count, String amount) {
    return '$count فواتير بمجموع $amount.';
  }

  @override
  String monthAheadPay(String date) {
    return 'يُتوقع راتبك التالي في $date.';
  }

  @override
  String monthAheadTightest(String date, String amount) {
    return 'أضيق يوم هو $date، بمبلغ متاح $amount.';
  }

  @override
  String monthAheadShort(String date, String amount) {
    return 'في $date سينقص $amount من دفعة لا بد منها.';
  }

  @override
  String get monthWorthKnowing => 'يستحق المعرفة';

  @override
  String insightUp(String category, String amount) {
    return '$category ارتفع $amount عن الشهر السابق.';
  }

  @override
  String insightGoal(int days, String goal) {
    return 'إن استمر، فهو نحو $days يوم من $goal كل شهر.';
  }

  @override
  String get chatSuggestMove => 'ماذا أفعل الآن؟';

  @override
  String get chatSuggestComing => 'ما الفواتير القادمة؟';

  @override
  String get chatComingNone =>
      'لا فواتير مستحقة خلال 30 يومًا. أضف فواتيرك في «الخطة» وسأتابعها.';

  @override
  String get quickAsk => 'اسأل';

  @override
  String get quickPay => 'وصل الراتب';

  @override
  String get quickBills => 'الفواتير';

  @override
  String get quickMonth => 'شهري';

  @override
  String get quickPayDue => 'حان موعد راتبك. أخبرنا إن وصل.';

  @override
  String get chartAvg => 'المتوسط';

  @override
  String get flowsTitle => 'المال الداخل والخارج';

  @override
  String get flowsBlurb =>
      'أسبوعًا بأسبوع: الراتب والمستردات فوق الخط، والإنفاق والسداد تحته.';

  @override
  String flowsWeek(String date) {
    return 'أسبوع $date';
  }

  @override
  String flowsInOut(String moneyIn, String moneyOut) {
    return 'داخل $moneyIn · خارج $moneyOut';
  }

  @override
  String get balanceHistoryTitle => 'رصيدك عبر الوقت';

  @override
  String rangeMonths(int count) {
    return '$count أشهر';
  }

  @override
  String get rangeYear => 'سنة';

  @override
  String get weekSpentTitle => 'آخر 7 أيام';

  @override
  String weekSpentTotal(String amount) {
    return 'أُنفق $amount';
  }

  @override
  String get payGaugeTitle => 'حتى راتبك التالي';

  @override
  String payGaugeDaysLabel(int days) {
    return 'يوم متبقٍ';
  }

  @override
  String payGaugeAfter(String date, String amount) {
    return 'بعد راتب $date: $amount متاح';
  }

  @override
  String payGaugeLasts(String amount) {
    return 'يجب أن يكفي $amount حتى ذلك الحين.';
  }

  @override
  String get goalsOverall => 'من كل أهدافك';

  @override
  String goalsThisMonth(String amount) {
    return '+$amount هذا الشهر';
  }

  @override
  String get goalsNothingThisMonth => 'لم يُضف شيء هذا الشهر';

  @override
  String get goalsAllOnTrack => 'الكل على المسار';

  @override
  String goalsOnTrackCount(int onTrack, int total) {
    return '$onTrack من $total على المسار';
  }

  @override
  String goalsNextUp(String goal, String date) {
    return 'التالي: $goal، $date';
  }

  @override
  String get goalsTips => 'طرق للوصول أسرع';

  @override
  String get goalsTipsSub => 'اسأل Upino، بناءً على إنفاقك';

  @override
  String get goalsDetailTitle => 'كل هدف';

  @override
  String get demoTry => 'جرّبه ببيانات نموذجية';

  @override
  String get demoTrySub =>
      'أربعة أهداف وفواتير وثلاثة أشهر من السجل، في نسخة ليست لك ولا تُحفظ.';

  @override
  String get demoBanner => 'بيانات نموذجية: لا شيء هنا لك أو محفوظ.';

  @override
  String get demoExit => 'خروج';

  @override
  String get demoGoalTrip => 'رحلة';

  @override
  String get demoGoalLaptop => 'حاسوب';

  @override
  String get demoGoalEmergency => 'طوارئ';

  @override
  String get demoGoalCar => 'سيارة';

  @override
  String get demoBillPhone => 'الهاتف';

  @override
  String get demoBillInternet => 'الإنترنت';

  @override
  String get demoBillGym => 'النادي';

  @override
  String get voiceExample => 'مثلًا: «خمسون ريالًا غداء»';

  @override
  String get voiceTitleListening => 'جارٍ الاستماع';

  @override
  String get voiceTitleHeard => 'تم السماع';

  @override
  String get voiceTitleFailed => 'لم أفهم ذلك';

  @override
  String get voiceStop => 'إيقاف';

  @override
  String get voiceRetry => 'مجددًا';

  @override
  String heroUntil(String date) {
    return 'حتى $date';
  }

  @override
  String get goalIcon => 'أيقونة';

  @override
  String get payGaugeToLast => 'يجب أن يكفي';

  @override
  String get payGaugeNextPay => 'الراتب القادم';
}
