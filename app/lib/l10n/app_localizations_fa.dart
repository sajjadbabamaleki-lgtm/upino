// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get navHome => 'خانه';

  @override
  String get navPlan => 'برنامه';

  @override
  String get navGoals => 'اهداف';

  @override
  String get navActivity => 'رویدادها';

  @override
  String get navProfile => 'پروفایل';

  @override
  String get currencyTitle => 'کدام واحد پول؟';

  @override
  String get currencyBlurb =>
      'همهٔ برنامهٔ شما با همین یکی نگه داشته می‌شود. پولی را انتخاب کنید که واقعاً با آن حقوق می‌گیرید.';

  @override
  String get currencySearchHint => 'جست‌وجوی کشور، پول یا کد';

  @override
  String currencyNoMatch(String query) {
    return 'چیزی با «$query» پیدا نشد. اسم کشور یا کد سه‌حرفی را امتحان کنید.';
  }

  @override
  String get onboardingBadge => 'حدود یک دقیقه وقت می‌برد';

  @override
  String get onboardingTitle => 'برنامه‌تان را بسازید';

  @override
  String get onboardingBlurb =>
      'دو جواب برای شروع کافی است. بقیه می‌تواند صبر کند.';

  @override
  String get onboardingBalanceLabel => 'پس‌انداز فعلی شما';

  @override
  String get onboardingBalanceHint =>
      'پولی که واقعاً می‌توانید از آن خرج کنید، نه آنچه قصد دارید دست‌نخورده بماند.';

  @override
  String get onboardingIncomeLabel => 'در ماه چقدر درآمد دارید؟';

  @override
  String get onboardingIncomeHint =>
      'اگر ثابت نیست، بازه‌اش را بنویسید. برنامه روی کف بازه ساخته می‌شود.';

  @override
  String get onboardingPayDay => 'حقوق بعدی کی می‌رسد؟';

  @override
  String onboardingDays(int count) {
    return '$count روز';
  }

  @override
  String get onboardingCommitments => 'تعهدهایتان را اضافه کنید';

  @override
  String get onboardingCommitmentsOpen => 'اجاره، مخارج ضروری و یک هدف';

  @override
  String get onboardingCommitmentsShut => 'اختیاری است و بعداً هم می‌شود';

  @override
  String get onboardingRentLabel => 'اجاره و قبض‌های ثابت';

  @override
  String get onboardingRentHint => 'سررسیدشان قبل از حقوق بعدی است';

  @override
  String get onboardingEssentialsLabel => 'خوراک و رفت‌وآمد';

  @override
  String get onboardingEssentialsHint =>
      'چیزی که برای گذران این دوره لازم دارید';

  @override
  String get onboardingGoalLabel => 'پس‌انداز برای یک هدف';

  @override
  String get onboardingGoalHint => 'چقدر می‌خواهید این دوره کنار بگذارید';

  @override
  String get onboardingFinish => 'برنامه‌ام را بساز';

  @override
  String get onboardingIncomplete => 'برای ادامه، دو جواب اول را پر کنید';

  @override
  String get tapToType => 'بزنید و بنویسید';

  @override
  String get heroSafeToSpend => 'الان می‌توانید خرج کنید';

  @override
  String get heroNotUpToDate => 'به‌روز نیست';

  @override
  String get heroRecordSpend => 'ثبت یک خرج';

  @override
  String get heroSeeShort => 'ببین چه چیزی کم است';

  @override
  String get heroConfirmBalance => 'تأیید موجودی';

  @override
  String get heroReviewBlurb =>
      'موجودی‌تان را بررسی کنید تا دوباره بشود به این عدد اتکا کرد.';

  @override
  String heroUntilSetAside(String date, String amount) {
    return 'تا $date · $amount کنار گذاشته شده';
  }

  @override
  String heroShort(String amount) {
    return '$amount کم است';
  }

  @override
  String heroUnfunded(String label, String amount) {
    return '$label · $amount تأمین نشده';
  }

  @override
  String get heroBalanceNever => 'موجودی هنوز تأیید نشده';

  @override
  String get heroBalanceToday => 'موجودی امروز تأیید شد';

  @override
  String get heroBalanceYesterday => 'موجودی دیروز تأیید شد';

  @override
  String heroBalanceDays(int count) {
    return 'موجودی $count روز پیش تأیید شد';
  }

  @override
  String get confirm => 'تأیید';

  @override
  String get homeTitle => 'برنامهٔ شما';

  @override
  String homeUntilTotal(String date, String amount) {
    return 'تا $date · $amount در مجموع';
  }

  @override
  String homeRecorded(String amount) {
    return '$amount ثبت شد';
  }

  @override
  String get homeAttention => 'نیاز به توجه دارد';

  @override
  String homeNotCovered(String amount) {
    return '$amount پوشش داده نشده';
  }

  @override
  String get homeAfterNextPay => 'بعد از حقوق بعدی';

  @override
  String homeOncePayArrives(String date) {
    return 'وقتی حقوقتان در $date برسد';
  }

  @override
  String get homeSetAsideFirst => 'اول کنار گذاشته می‌شود';

  @override
  String get homeProtectedBlurb => 'پیش از هر خرجی محفوظ می‌ماند.';

  @override
  String get homeNothingSetAside =>
      'هنوز چیزی کنار گذاشته نشده. هرچه دارید قابل خرج است.';

  @override
  String get homeWhyThisNumber => 'چرا این عدد';

  @override
  String get homeWhatIsShort => 'چه چیزی کم است';

  @override
  String get homeShortBlurb =>
      'هیچ‌کدام از این‌ها برایتان جابه‌جا یا عقب انداخته نمی‌شود. این‌ها تعهدهایی هستند که پول فعلی‌تان پوششش نمی‌دهد.';

  @override
  String get askSpendTitle => 'چقدر خرج کردید؟';

  @override
  String get askBalanceTitle => 'الان موجودی‌تان چقدر است؟';

  @override
  String get askBalanceBlurb =>
      'هر اختلافی به‌عنوان اصلاح ثبت می‌شود، نه به‌عنوان خرج.';

  @override
  String get whyNoChange => 'از برنامهٔ قبلی‌تان چیزی عوض نشده.';

  @override
  String get whyPayArrived => 'حقوقتان رسید، پس برنامه به‌روز شد.';

  @override
  String get whyBillPaid => 'قبضی که برایش پول کنار گذاشته بودید پرداخت شد.';

  @override
  String get whyHeldForBill =>
      'پولی برای قبضی که کمی بعد از حقوق بعدی سررسید دارد نگه داشته شده.';

  @override
  String get whyOvercommitted => 'بیشتر از آنچه الان دارید تعهد داده‌اید.';

  @override
  String get whyStale => 'موجودی‌تان اخیراً تأیید نشده.';

  @override
  String get whyCardLarger => 'بدهی کارتتان از پولی که دارید بیشتر است.';

  @override
  String get whyPayLate => 'حقوقی که انتظارش را داشتید هنوز نرسیده.';

  @override
  String get whyOverdue => 'چیزی از سررسیدش گذشته.';

  @override
  String get whyBufferShort => 'ذخیرهٔ اضطراری‌تان کامل پر نشده.';

  @override
  String get whyGoalShort => 'هدف پس‌اندازتان الان کامل تأمین نمی‌شود.';

  @override
  String get whyFlexibleLess => 'یک هدف منعطف کمتر از برنامه دریافت کرد.';

  @override
  String get whyDuplicate => 'یک تراکنش تکراری فقط یک بار حساب شد.';

  @override
  String get planTitle => 'برنامه';

  @override
  String get planBlurb =>
      'پولتان به چه چیزهایی قول داده شده، پیش از آنکه چیزی قابل خرج باشد.';

  @override
  String get planMoneyAndIncome => 'پول و درآمد';

  @override
  String get planMoneyYouHave => 'پولی که دارید';

  @override
  String get planNextPay => 'حقوق بعدی';

  @override
  String get planYourNextPay => 'حقوق بعدی شما';

  @override
  String get planNotSet => 'تعیین نشده';

  @override
  String get planExpectedBlurb =>
      'این فقط انتظار می‌رود، پس بیرون از چیزی می‌ماند که الان می‌توانید خرج کنید.';

  @override
  String get planSetAsideFirst => 'اول کنار گذاشته می‌شود';

  @override
  String get planNothingSetAside =>
      'چیزی کنار گذاشته نشده، پس هرچه دارید قابل خرج است.';

  @override
  String get planAddToPlan => 'به برنامه اضافه کنید';

  @override
  String get planGoals => 'اهداف';

  @override
  String get planSaveToward => 'برای چیزی پس‌انداز کنید';

  @override
  String get planSaveTowardSub => 'یک سفر، یک ودیعه، یک لپ‌تاپ نو';

  @override
  String get planAllGoals => 'همهٔ اهداف';

  @override
  String get planAllGoalsSub => 'افزودن، ویرایش یا گذاشتن پول';

  @override
  String get planHowMuchSetAside => 'برای این چقدر باید کنار بگذارید؟';

  @override
  String get planChangeOrRemove => 'مبلغ را عوض کنید، یا از برنامه حذفش کنید.';

  @override
  String get planRemove => 'حذف از برنامه';

  @override
  String planDue(String date) {
    return ' · سررسید $date';
  }

  @override
  String get priorityMandatory => 'باید پرداخت شود — اول از همه';

  @override
  String get priorityEssential => 'نیازهای روزمره';

  @override
  String get priorityBuffer => 'برای مواقع اضطراری نگه داشته می‌شود';

  @override
  String get priorityCard => 'قبلاً با کارت خرج شده';

  @override
  String get prioritySinkingFund => 'پس‌انداز برای یک قبض مشخص';

  @override
  String get priorityGoal => 'هدفی که به آن متعهد شده‌اید';

  @override
  String get priorityDiscretionary => 'خوب است داشته باشید — اول کوتاه می‌آید';

  @override
  String get goalsTitle => 'اهداف';

  @override
  String get goalsBlurbEmpty => 'هنوز برای چیزی پس‌انداز نشده.';

  @override
  String get goalsBlurb => 'هر هدف از این دورهٔ حقوق چه می‌خواهد.';

  @override
  String get goalsEmptyCard =>
      'چیزی را که برایش پس‌انداز می‌کنید اضافه کنید — یک سفر، یک ودیعه، یک لپ‌تاپ نو. اوپینو حساب می‌کند هر دوره چقدر باید نگه داشته شود تا سر وقت برسد.';

  @override
  String get goalsNew => 'هدف جدید';

  @override
  String get goalsNewSub => 'چیزی که برایش پول کنار می‌گذارید';

  @override
  String get goalsAddMoney => 'افزودن پول';

  @override
  String goalsAddTo(String name) {
    return 'افزودن به $name';
  }

  @override
  String get goalsAddBlurb =>
      'این ثبت می‌کند که چقدر کنار گذاشته‌اید. چیزی خرج نمی‌شود — فقط از این به بعد کمتر باید نگه داشته شود.';

  @override
  String get goalsEachPeriod => 'هر دورهٔ حقوق';

  @override
  String get goalsTargetDate => 'تاریخ هدف';

  @override
  String goalsOf(String amount) {
    return 'از $amount';
  }

  @override
  String goalsPeriodsToGo(int count) {
    return '$count دورهٔ حقوق مانده';
  }

  @override
  String get goalsDone => 'کامل پس‌انداز شد';

  @override
  String get goalsPausedStatus => 'متوقف — چیزی نگه داشته نمی‌شود';

  @override
  String get goalsFlexibleStatus =>
      'منعطف — جلوی هر چیزی که باید بپردازید کوتاه می‌آید';

  @override
  String get goalEditNew => 'برای چه چیزی پس‌انداز می‌کنید؟';

  @override
  String get goalEditExisting => 'ویرایش هدف';

  @override
  String get goalName => 'نام';

  @override
  String get goalNameHint => 'یک سفر، یک ودیعه، یک لپ‌تاپ';

  @override
  String get goalTotal => 'در مجموع چقدر';

  @override
  String get goalByWhen => 'تا کی';

  @override
  String goalMonths(int count) {
    return '$count ماه';
  }

  @override
  String get goalOneYear => '۱ سال';

  @override
  String get goalTwoYears => '۲ سال';

  @override
  String get goalFirmness => 'چقدر قطعی است؟';

  @override
  String get goalKindHard => 'متعهد';

  @override
  String get goalKindHardSub => 'پیش از هر خرجی نگه داشته می‌شود';

  @override
  String get goalKindFlexible => 'منعطف';

  @override
  String get goalKindFlexibleSub =>
      'جلوی هر چیزی که باید بپردازید کوتاه می‌آید';

  @override
  String get goalKindPaused => 'متوقف';

  @override
  String get goalKindPausedSub => 'دیده می‌شود، ولی چیزی نگه داشته نمی‌شود';

  @override
  String get goalSaveChanges => 'ذخیرهٔ تغییرات';

  @override
  String get goalAddThis => 'افزودن این هدف';

  @override
  String get goalDelete => 'حذف این هدف';

  @override
  String get activityTitle => 'رویدادها';

  @override
  String get activityBlurb => 'هرچه ثبت کرده‌اید، از تازه‌ترین.';

  @override
  String get activityEmpty =>
      'وقتی خرجی ثبت کنید اینجا می‌آید، و اگر اشتباه شد می‌توانید حذفش کنید.';

  @override
  String get activityRemoveIt => 'حذفش کن';

  @override
  String get activityKeepIt => 'بماند';

  @override
  String get activitySpent => 'خرج';

  @override
  String get activityIncome => 'حقوق';

  @override
  String get activityCorrection => 'اصلاح';

  @override
  String get activityRemoved => 'حذف‌شده';

  @override
  String get profileTitle => 'پروفایل';

  @override
  String get profileConfirmBalance => 'تأیید موجودی';

  @override
  String get profileTrustTitle => 'چقدر می‌شود به این عدد اتکا کرد؟';

  @override
  String get profileTrustFresh => 'به‌روز است. چیزی نیاز به توجه شما ندارد.';

  @override
  String get profileTrustDegraded =>
      'مدتی است موجودی‌تان تأیید نشده. عدد هنوز نشان داده می‌شود، فقط کمتر قطعی است.';

  @override
  String get profileTrustReview =>
      'برای اتکا کردن خیلی قدیمی یا نامطمئن است. موجودی‌تان را تأیید کنید تا درست شود.';

  @override
  String get profileConfirmedNever => 'هنوز تأیید نشده';

  @override
  String get profileConfirmedToday => 'امروز تأیید شد';

  @override
  String get profileConfirmedYesterday => 'دیروز تأیید شد';

  @override
  String profileConfirmedDays(int count) {
    return '$count روز پیش تأیید شد';
  }

  @override
  String get profileAppearance => 'ظاهر';

  @override
  String get profileTheme => 'پوسته';

  @override
  String get profileThemeBlurb =>
      'پیروی از گوشی حالت پیش‌فرض است، پس چیزی تحمیل نمی‌شود.';

  @override
  String get themePhone => 'گوشی';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'تیره';

  @override
  String get profileLanguage => 'زبان';

  @override
  String get profileLanguageBlurb =>
      'پیروی از گوشی حالت پیش‌فرض است، پس چیزی تحمیل نمی‌شود.';

  @override
  String get languagePhone => 'گوشی';

  @override
  String get profileCurrency => 'واحد پول';

  @override
  String currencyChangeTitle(String currency) {
    return 'تغییر به $currency؟';
  }

  @override
  String currencyChangeBlurb(String currency) {
    return 'همهٔ مبلغ‌های برنامه همان عدد خود را نگه می‌دارند و از این پس به $currency نشان داده می‌شوند. هیچ تبدیلی با نرخ ارز انجام نمی‌شود؛ این برای اصلاح واحد پول است، نه تبدیل پول.';
  }

  @override
  String get currencyChangeConfirm => 'تغییر';

  @override
  String get profileYourData => 'داده‌های شما';

  @override
  String get profileDelete => 'حذف برنامهٔ من';

  @override
  String get profileDeleteSub =>
      'همه‌چیز پاک می‌شود و به مرحلهٔ ساخت برمی‌گردید';

  @override
  String get profileStartOver => 'از نو شروع شود؟';

  @override
  String get profileStartOverBlurb =>
      'برنامه‌تان و هرچه ثبت کرده‌اید حذف می‌شود. این کار برگشت‌پذیر نیست.';

  @override
  String get profileDeleteEverything => 'همه‌چیز را حذف کن';

  @override
  String get profileKeepPlan => 'برنامه‌ام بماند';

  @override
  String get save => 'ذخیره';

  @override
  String get cancel => 'انصراف';

  @override
  String activityRemoveAmount(String amount) {
    return '$amount حذف شود؟';
  }

  @override
  String get activityRemoveDetail =>
      'بلافاصله از حساب برنامه‌تان کنار گذاشته می‌شود. خود مورد با نشان «حذف‌شده» در این فهرست می‌ماند تا سابقه‌تان کامل بماند.';

  @override
  String get activityCardPurchase => 'خرید با کارت';

  @override
  String get activityCardPayment => 'پرداخت کارت';

  @override
  String get activityRefund => 'بازگشت وجه';

  @override
  String get activityTransfer => 'انتقال بین حساب‌ها';

  @override
  String get activityLoan => 'دریافت وام';

  @override
  String get activityDebtPayment => 'پرداخت بدهی';

  @override
  String get activityBalanceCorrected => 'اصلاح موجودی';

  @override
  String get activityBlurbEmpty => 'هنوز چیزی ثبت نشده.';

  @override
  String get profileStartAgain => 'شروع دوباره';

  @override
  String get claimRent => 'اجاره و قبض‌ها';

  @override
  String get claimCardMinimum => 'حداقل پرداخت کارت';

  @override
  String get claimEssentials => 'خوراک و رفت‌وآمد';

  @override
  String get claimBuffer => 'ذخیرهٔ اضطراری';

  @override
  String get languageTitle => 'کدام زبان؟';

  @override
  String get languageBlurb => 'بعداً می‌توانید از پروفایل عوضش کنید.';

  @override
  String get profileLedgerTitle => 'سابقه کامل است؟';

  @override
  String get ledgerComplete => 'هرچه خرج کرده‌اید ثبت شده.';

  @override
  String get ledgerPartial => 'بخشی از خرج‌ها فقط موقع تأیید موجودی پیدا شد.';

  @override
  String get ledgerUnknown =>
      'اوپینو نمی‌داند چقدر جا افتاده. موجودی‌تان را تأیید کنید تا معلوم شود.';

  @override
  String get askTitle => 'قبل از خرج کردن بپرس';

  @override
  String get askBlurb =>
      'یک خرید را روی برنامه‌تان امتحان کنید. چیزی ثبت نمی‌شود و چیزی عوض نمی‌شود.';

  @override
  String get askAmountLabel => 'چقدر می‌شود؟';

  @override
  String get askRun => 'ببین چه اثری دارد';

  @override
  String get askDoNotBuy => 'نخریدن';

  @override
  String get askBuyNow => 'همین امروز بخر';

  @override
  String askBuyAfter(String date) {
    return 'بعد از $date بخر';
  }

  @override
  String get askUnchanged => 'برنامه‌تان همان‌طور می‌ماند.';

  @override
  String get askStsAfter => 'بعدش چقدر می‌توانید خرج کنید';

  @override
  String get askBreaks => 'این کار چیزی را که باید بپردازید بی‌پوشش می‌گذارد.';

  @override
  String get askSafe =>
      'هیچ‌کدام از چیزهایی که باید بپردازید بی‌پوشش نمی‌ماند.';

  @override
  String get askCosts => 'چه چیزی کمتر می‌شود';

  @override
  String askCostLine(String label, String amount) {
    return '$label · $amount کمتر';
  }

  @override
  String get askWaitingHelps =>
      'اگر تا رسیدن حقوق صبر کنید، همه‌چیز پوشش داده می‌شود.';

  @override
  String get askNoIncome =>
      'هنوز حقوقی انتظار نمی‌رود، پس زمان بعدی‌ای برای مقایسه نیست.';

  @override
  String askAssumption(String date) {
    return 'با این فرض که حقوقتان طبق انتظار در $date برسد.';
  }

  @override
  String get askNoVerdict => 'اوپینو بله یا خیر نمی‌گوید. انتخاب با شماست.';

  @override
  String get receipt => 'فاکتور';

  @override
  String get receiptAdd => 'افزودن فاکتور';

  @override
  String get receiptCamera => 'گرفتن عکس';

  @override
  String get receiptGallery => 'انتخاب از گالری';

  @override
  String get receiptAttached => 'فاکتور پیوست شد';

  @override
  String get receiptRemove => 'حذف عکس';

  @override
  String get onboardingIncomeFrom => 'دست‌کم';

  @override
  String get onboardingIncomeTo => 'تا';

  @override
  String get onboardingIncomeToOptional => 'اختیاری';

  @override
  String incomeRange(String low, String high) {
    return '$low تا $high';
  }

  @override
  String incomeRangeNote(String low) {
    return 'برنامه روی $low ساخته شده. هرچه بیشتر بیاید، وقتی رسید مال خودتان است.';
  }

  @override
  String get categoryFood => 'خوراک';

  @override
  String get categoryTransport => 'رفت‌وآمد';

  @override
  String get categoryBills => 'قبض‌ها';

  @override
  String get categoryShopping => 'خرید';

  @override
  String get categoryHealth => 'سلامت';

  @override
  String get categoryFun => 'تفریح';

  @override
  String get categoryOther => 'سایر';

  @override
  String get categoryUnsorted => 'بدون دسته';

  @override
  String get categoryPrompt => 'برای چه بود؟';

  @override
  String get spendingTitle => 'پول کجا رفت';

  @override
  String get spendingWindow => 'خرج‌های ثبت‌شده در ۳۰ روز گذشته';

  @override
  String get backupSection => 'پشتیبان';

  @override
  String get backupSave => 'ذخیرهٔ نسخهٔ پشتیبان';

  @override
  String get backupSaveSub =>
      'با رمز قفل می‌شود. آن را جای امنی مثل فضای ابری خود بفرستید.';

  @override
  String get backupRestore => 'بازگردانی از نسخهٔ پشتیبان';

  @override
  String get backupRestoreSub => 'برنامهٔ روی این گوشی جایگزین می‌شود';

  @override
  String get backupPassword => 'رمز';

  @override
  String get backupPasswordRepeat => 'تکرار رمز';

  @override
  String get backupPasswordSaveBlurb =>
      'برای بازگردانی به این رمز نیاز دارید و اگر فراموشش کنید قابل بازیابی نیست. عکس رسیدها در پشتیبان نیستند.';

  @override
  String get backupPasswordOpenBlurb => 'رمزی که پشتیبان با آن ذخیره شده است.';

  @override
  String get backupPasswordShort => 'دست‌کم ۶ نویسه';

  @override
  String get backupPasswordMismatch => 'دو رمز یکسان نیستند';

  @override
  String get backupOpen => 'باز کردن';

  @override
  String get backupReplaceTitle => 'برنامهٔ فعلی جایگزین شود؟';

  @override
  String get backupReplaceBlurb =>
      'همهٔ داده‌های این گوشی با محتوای پشتیبان جایگزین می‌شود. این کار برگشت‌پذیر نیست.';

  @override
  String get backupReplace => 'جایگزین کن';

  @override
  String get backupRestored => 'پشتیبان بازگردانی شد';

  @override
  String get backupWrongPassword => 'این رمز پشتیبان را باز نمی‌کند.';

  @override
  String get backupNotABackup => 'این فایل پشتیبان Upino نیست.';

  @override
  String get backupUnreadable =>
      'این پشتیبان با نسخهٔ جدیدتری از Upino ساخته شده. اپ را به‌روز کنید و دوباره امتحان کنید.';

  @override
  String get inflationTitle => 'تورم';

  @override
  String get inflationNotSet =>
      'تنظیم نشده. نرخ سالانهٔ تورم را وارد کنید تا هزینهٔ واقعی هدف‌ها را ببینید.';

  @override
  String inflationRate(String rate) {
    return '$rate٪ در سال';
  }

  @override
  String get inflationDialogTitle => 'تورم سالانه';

  @override
  String get inflationDialogBlurb =>
      'قیمت‌ها بالا می‌روند، پس هدفی که با پول امروز تعیین شده در موعدش گران‌تر است. نرخی را که انتظار دارید وارد کنید. برای خاموش کردن خالی بگذارید.';

  @override
  String goalsInflated(String rate, String amount) {
    return 'با تورم $rate٪ در سال، این هدف تا آن موقع حدود $amount هزینه خواهد داشت.';
  }

  @override
  String get holdingsTitle => 'دارایی‌های دیگر';

  @override
  String get holdingsBlurb =>
      'دلار، طلا، سکه. کنار برنامه نشان داده می‌شود و هرگز جزو پول قابل خرج حساب نمی‌شود.';

  @override
  String get holdingsAdd => 'افزودن دارایی';

  @override
  String get holdingsAddSub => 'جزو پول قابل خرج حساب نمی‌شود';

  @override
  String get holdingsTotal => 'جمع';

  @override
  String holdingSummary(String quantity, String price, String date) {
    return '$quantity × $price · قیمت $date';
  }

  @override
  String get holdingEditNew => 'دارایی جدید';

  @override
  String get holdingEditExisting => 'ویرایش دارایی';

  @override
  String get holdingName => 'چه چیزی است؟';

  @override
  String get holdingNameHint => 'دلار، طلا…';

  @override
  String get holdingUsd => 'دلار';

  @override
  String get holdingEur => 'یورو';

  @override
  String get holdingGold => 'طلا (گرم)';

  @override
  String get holdingCoin => 'سکه';

  @override
  String get holdingQuantity => 'چه مقدار';

  @override
  String get holdingUnitPrice => 'قیمت امروزِ هر واحد';

  @override
  String holdingWorth(String amount) {
    return 'در مجموع $amount';
  }

  @override
  String get holdingDelete => 'حذف این دارایی';

  @override
  String get fasterTitle => 'ثبت سریع‌تر';

  @override
  String get smsTitle => 'خواندن پیامک‌های بانک';

  @override
  String get smsDetail =>
      'خرج‌هایی که بانک پیامکش را می‌فرستد با یک لمس برای ثبت پیشنهاد می‌شوند. پیامک‌ها فقط روی همین گوشی خوانده می‌شوند و به هیچ‌جا فرستاده نمی‌شوند.';

  @override
  String get smsDenied =>
      'اجازهٔ خواندن پیامک داده نشد. می‌توانید در تنظیمات گوشی اجازه دهید.';

  @override
  String smsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count پیامک بانک برای بررسی',
    );
    return '$_temp0';
  }

  @override
  String get smsWaitingSub => 'هرکدام را با یک لمس ثبت یا رد کنید';

  @override
  String get smsReviewTitle => 'از بانک شما';

  @override
  String get smsReviewBlurb =>
      'تا «ثبت» را نزنید چیزی ثبت نمی‌شود. مبلغ را با متن پیامک مقایسه کنید.';

  @override
  String get smsReviewDone => 'همه بررسی شد.';

  @override
  String get smsRecord => 'ثبت';

  @override
  String get smsSkip => 'رد کردن';

  @override
  String get reminderTitleSetting => 'یادآوری شبانه';

  @override
  String get reminderDetail => 'ساعت ۹ شب، فقط روزهایی که چیزی ثبت نشده.';

  @override
  String get reminderDenied =>
      'اجازهٔ نمایش اعلان داده نشد. می‌توانید در تنظیمات گوشی اجازه دهید.';

  @override
  String get reminderTitle => 'امروز خرجی داشتید؟';

  @override
  String get reminderBody => 'در چند ثانیه ثبتش کنید تا عدد فردا درست باشد.';

  @override
  String get reminderChannel => 'یادآوری شبانه';

  @override
  String get widgetSpend => '+ خرج';

  @override
  String get widgetAdd => 'افزودن به صفحهٔ اصلی گوشی';

  @override
  String get widgetAddSub => 'مبلغ قابل خرج و دکمهٔ ثبت خرج، بدون باز کردن اپ';

  @override
  String get voiceListening =>
      'در حال شنیدن… مبلغ و اینکه برای چه بود را بگویید.';

  @override
  String voiceHeard(String text) {
    return 'شنیده شد: «$text». مبلغ را بررسی و بعد ذخیره کنید.';
  }

  @override
  String get voiceNothing =>
      'مبلغی شنیده نشد. دوباره امتحان کنید یا تایپ کنید.';

  @override
  String get voicePrivacy =>
      'گوشی شما گفتار را به متن تبدیل می‌کند. در گوشی‌هایی که تشخیص آفلاین ندارند، این کار از سرویس گفتار گوشی انجام می‌شود.';

  @override
  String get voiceButton => 'بگویید';

  @override
  String get voiceUnavailable =>
      'این گوشی سرویس تشخیص گفتاری ندارد که اپ بتواند از آن استفاده کند. مبلغ را تایپ کنید.';

  @override
  String get voiceNoPermission =>
      'اجازهٔ استفاده از میکروفون داده نشد. می‌توانید در تنظیمات گوشی اجازه دهید.';

  @override
  String get voiceNetwork =>
      'تشخیص گفتار در این گوشی به اینترنت نیاز دارد و به آن دسترسی نداشت.';

  @override
  String voiceNoAmount(String text) {
    return '«$text» شنیده شد، ولی مبلغی در آن نبود. دوباره امتحان کنید یا تایپ کنید.';
  }

  @override
  String get yes => 'بله';

  @override
  String get no => 'خیر';
}
