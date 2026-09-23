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
  String get onboardingBalanceLabel => 'الان چقدر پول دارید؟';

  @override
  String get onboardingBalanceHint =>
      'روی هم، در حساب‌هایی که از آن‌ها خرج می‌کنید';

  @override
  String get onboardingIncomeLabel => 'حقوق بعدی‌تان چقدر است؟';

  @override
  String get onboardingIncomeHint => 'مبلغ همیشگی‌تان کافی است';

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
  String get onboardingFinish => 'ببین چقدر می‌توانم خرج کنم';

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
}
