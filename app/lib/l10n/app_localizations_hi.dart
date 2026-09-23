// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get navHome => 'होम';

  @override
  String get navPlan => 'योजना';

  @override
  String get navGoals => 'लक्ष्य';

  @override
  String get navActivity => 'गतिविधि';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get currencyTitle => 'कौन-सी मुद्रा?';

  @override
  String get currencyBlurb =>
      'आपकी पूरी योजना इसी एक मुद्रा में रखी जाती है। वही चुनें जिसमें आपको असल में वेतन मिलता है।';

  @override
  String get currencySearchHint => 'देश, मुद्रा या कोड खोजें';

  @override
  String currencyNoMatch(String query) {
    return '“$query” से कुछ नहीं मिला। देश का नाम या तीन अक्षरों का कोड आज़माएँ।';
  }

  @override
  String get onboardingBadge => 'करीब एक मिनट लगेगा';

  @override
  String get onboardingTitle => 'अपनी योजना बनाएँ';

  @override
  String get onboardingBlurb =>
      'शुरू करने के लिए दो जवाब काफ़ी हैं। बाक़ी बाद में हो सकता है।';

  @override
  String get onboardingBalanceLabel => 'आज आपकी बचत';

  @override
  String get onboardingBalanceHint =>
      'वह पैसा जिससे आप वाक़ई ख़र्च कर सकते हैं, वह नहीं जिसे अछूता रखना चाहते हैं।';

  @override
  String get onboardingIncomeLabel => 'महीने में आप कितना कमाते हैं?';

  @override
  String get onboardingIncomeHint =>
      'अगर बदलता है तो दायरा बताएँ। योजना निचले सिरे पर बनती है।';

  @override
  String get onboardingPayDay => 'अगली तनख़्वाह कब आएगी?';

  @override
  String onboardingDays(int count) {
    return '$count दिन';
  }

  @override
  String get onboardingCommitments => 'अपनी प्रतिबद्धताएँ जोड़ें';

  @override
  String get onboardingCommitmentsOpen => 'किराया, ज़रूरी ख़र्च और एक लक्ष्य';

  @override
  String get onboardingCommitmentsShut => 'वैकल्पिक है, बाद में भी कर सकते हैं';

  @override
  String get onboardingRentLabel => 'किराया और तय बिल';

  @override
  String get onboardingRentHint => 'अगली तनख़्वाह से पहले देने हैं';

  @override
  String get onboardingEssentialsLabel => 'खाना और आवागमन';

  @override
  String get onboardingEssentialsHint => 'इस अवधि को निकालने के लिए जो चाहिए';

  @override
  String get onboardingGoalLabel => 'किसी लक्ष्य के लिए बचत';

  @override
  String get onboardingGoalHint => 'इस अवधि में कितना अलग रखना चाहते हैं';

  @override
  String get onboardingFinish => 'मेरी योजना बनाएँ';

  @override
  String get onboardingIncomplete => 'आगे बढ़ने के लिए पहले दो जवाब भरें';

  @override
  String get tapToType => 'टैप करके लिखें';

  @override
  String get heroSafeToSpend => 'अभी ख़र्च कर सकते हैं';

  @override
  String get heroNotUpToDate => 'अद्यतन नहीं';

  @override
  String get heroRecordSpend => 'एक ख़र्च दर्ज करें';

  @override
  String get heroSeeShort => 'देखें क्या कम है';

  @override
  String get heroConfirmBalance => 'शेष की पुष्टि करें';

  @override
  String get heroReviewBlurb =>
      'अपना शेष जाँचें ताकि इस आँकड़े पर फिर भरोसा किया जा सके।';

  @override
  String heroUntilSetAside(String date, String amount) {
    return '$date तक · $amount अलग रखा गया';
  }

  @override
  String heroShort(String amount) {
    return '$amount कम है';
  }

  @override
  String heroUnfunded(String label, String amount) {
    return '$label · $amount की व्यवस्था नहीं';
  }

  @override
  String get heroBalanceNever => 'शेष की पुष्टि अभी नहीं हुई';

  @override
  String get heroBalanceToday => 'शेष की पुष्टि आज हुई';

  @override
  String get heroBalanceYesterday => 'शेष की पुष्टि कल हुई';

  @override
  String heroBalanceDays(int count) {
    return 'शेष की पुष्टि $count दिन पहले हुई';
  }

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get homeTitle => 'आपकी योजना';

  @override
  String homeUntilTotal(String date, String amount) {
    return '$date तक · कुल $amount';
  }

  @override
  String homeRecorded(String amount) {
    return '$amount दर्ज हुआ';
  }

  @override
  String get homeAttention => 'आपके ध्यान की ज़रूरत है';

  @override
  String homeNotCovered(String amount) {
    return '$amount की व्यवस्था नहीं';
  }

  @override
  String get homeAfterNextPay => 'अगली तनख़्वाह के बाद';

  @override
  String homeOncePayArrives(String date) {
    return 'जब $date को आपकी तनख़्वाह आएगी';
  }

  @override
  String get homeSetAsideFirst => 'पहले अलग रखा जाता है';

  @override
  String get homeProtectedBlurb =>
      'कुछ भी ख़र्च योग्य होने से पहले सुरक्षित रखा जाता है।';

  @override
  String get homeNothingSetAside =>
      'अभी कुछ अलग नहीं रखा गया। आपके पास जो है सब ख़र्च योग्य है।';

  @override
  String get homeWhyThisNumber => 'यह आँकड़ा क्यों';

  @override
  String get homeWhatIsShort => 'क्या कम है';

  @override
  String get homeShortBlurb =>
      'यहाँ कुछ भी आपके लिए हटाया या टाला नहीं जाता। ये वे प्रतिबद्धताएँ हैं जिन्हें आपका मौजूदा पैसा पूरा नहीं करता।';

  @override
  String get askSpendTitle => 'आपने कितना ख़र्च किया?';

  @override
  String get askBalanceTitle => 'अभी आपका शेष कितना है?';

  @override
  String get askBalanceBlurb =>
      'कोई भी अंतर सुधार के रूप में दर्ज होता है, ख़र्च के रूप में कभी नहीं।';

  @override
  String get whyNoChange => 'पिछली योजना के बाद कुछ नहीं बदला।';

  @override
  String get whyPayArrived => 'आपकी तनख़्वाह आ गई, इसलिए योजना ताज़ा हुई।';

  @override
  String get whyBillPaid => 'जिस बिल के लिए आपने पैसा रखा था वह चुक गया।';

  @override
  String get whyHeldForBill =>
      'अगली तनख़्वाह के तुरंत बाद देय बिल के लिए पैसा रोका गया है।';

  @override
  String get whyOvercommitted =>
      'आपने अपनी मौजूदा रक़म से ज़्यादा की प्रतिबद्धता की है।';

  @override
  String get whyStale => 'आपके शेष की पुष्टि हाल में नहीं हुई।';

  @override
  String get whyCardLarger =>
      'आपके कार्ड का बकाया आपके पास मौजूद पैसे से ज़्यादा है।';

  @override
  String get whyPayLate => 'अपेक्षित तनख़्वाह अभी नहीं आई।';

  @override
  String get whyOverdue => 'कोई चीज़ अपनी नियत तिथि पार कर चुकी है।';

  @override
  String get whyBufferShort => 'आपका आपातकालीन कोष पूरा नहीं भरा।';

  @override
  String get whyGoalShort => 'आपका बचत लक्ष्य अभी पूरा नहीं भरा जा सकता।';

  @override
  String get whyFlexibleLess => 'एक लचीले लक्ष्य को योजना से कम मिला।';

  @override
  String get whyDuplicate => 'दोहराया गया लेनदेन केवल एक बार गिना गया।';

  @override
  String get planTitle => 'योजना';

  @override
  String get planBlurb =>
      'कुछ भी ख़र्च योग्य होने से पहले आपका पैसा किसे वचन दिया गया है।';

  @override
  String get planMoneyAndIncome => 'पैसा और आय';

  @override
  String get planMoneyYouHave => 'आपके पास मौजूद पैसा';

  @override
  String get planNextPay => 'अगली तनख़्वाह';

  @override
  String get planYourNextPay => 'आपकी अगली तनख़्वाह';

  @override
  String get planNotSet => 'तय नहीं';

  @override
  String get planExpectedBlurb =>
      'यह केवल अपेक्षित है, इसलिए अभी जो आप ख़र्च कर सकते हैं उससे बाहर रहता है।';

  @override
  String get planSetAsideFirst => 'पहले अलग रखा जाता है';

  @override
  String get planNothingSetAside =>
      'कुछ अलग नहीं रखा गया, इसलिए आपके पास जो है सब ख़र्च योग्य है।';

  @override
  String get planAddToPlan => 'अपनी योजना में जोड़ें';

  @override
  String get planGoals => 'लक्ष्य';

  @override
  String get planSaveToward => 'किसी चीज़ के लिए बचत करें';

  @override
  String get planSaveTowardSub => 'एक यात्रा, एक जमानत राशि, एक नया लैपटॉप';

  @override
  String get planAllGoals => 'सभी लक्ष्य';

  @override
  String get planAllGoalsSub => 'जोड़ें, बदलें या पैसा अलग रखें';

  @override
  String get planHowMuchSetAside => 'इसके लिए कितना अलग रखना होगा?';

  @override
  String get planChangeOrRemove => 'रक़म बदलें, या इसे अपनी योजना से हटाएँ।';

  @override
  String get planRemove => 'योजना से हटाएँ';

  @override
  String planDue(String date) {
    return ' · देय $date';
  }

  @override
  String get priorityMandatory => 'चुकाना ज़रूरी — सबसे पहले';

  @override
  String get priorityEssential => 'रोज़मर्रा की ज़रूरतें';

  @override
  String get priorityBuffer => 'आपात स्थिति के लिए रखा गया';

  @override
  String get priorityCard => 'कार्ड से पहले ही ख़र्च';

  @override
  String get prioritySinkingFund => 'एक ज्ञात बिल के लिए बचत';

  @override
  String get priorityGoal => 'एक लक्ष्य जिसकी आपने प्रतिबद्धता की';

  @override
  String get priorityDiscretionary => 'हो तो अच्छा — पहले यही छोड़ता है';

  @override
  String get goalsTitle => 'लक्ष्य';

  @override
  String get goalsBlurbEmpty => 'अभी किसी चीज़ के लिए बचत नहीं हो रही।';

  @override
  String get goalsBlurb => 'इस वेतन अवधि से हर लक्ष्य को क्या चाहिए।';

  @override
  String get goalsEmptyCard =>
      'जिसके लिए आप बचत कर रहे हैं उसे जोड़ें — एक यात्रा, एक जमानत राशि, एक नया लैपटॉप। Upino हिसाब लगाता है कि हर अवधि में कितना रोकना है ताकि वह समय पर पहुँचे।';

  @override
  String get goalsNew => 'नया लक्ष्य';

  @override
  String get goalsNewSub => 'जिसके लिए आप पैसा अलग रखते हैं';

  @override
  String get goalsAddMoney => 'पैसा जोड़ें';

  @override
  String goalsAddTo(String name) {
    return '$name में जोड़ें';
  }

  @override
  String get goalsAddBlurb =>
      'यह दर्ज करता है कि आपने कितना अलग रखा। कुछ ख़र्च नहीं होता — आगे से जो रोकना है वह कम हो जाता है।';

  @override
  String get goalsEachPeriod => 'हर वेतन अवधि';

  @override
  String get goalsTargetDate => 'लक्ष्य तिथि';

  @override
  String goalsOf(String amount) {
    return '$amount में से';
  }

  @override
  String goalsPeriodsToGo(int count) {
    return '$count वेतन अवधि बाक़ी';
  }

  @override
  String get goalsDone => 'पूरी तरह बचा लिया';

  @override
  String get goalsPausedStatus => 'रुका हुआ — कुछ नहीं रोका जाता';

  @override
  String get goalsFlexibleStatus =>
      'लचीला — जो चुकाना ज़रूरी है उसके आगे झुक जाता है';

  @override
  String get goalEditNew => 'आप किसके लिए बचत कर रहे हैं?';

  @override
  String get goalEditExisting => 'लक्ष्य बदलें';

  @override
  String get goalName => 'नाम';

  @override
  String get goalNameHint => 'एक यात्रा, एक जमानत राशि, एक लैपटॉप';

  @override
  String get goalTotal => 'कुल कितना';

  @override
  String get goalByWhen => 'कब तक';

  @override
  String goalMonths(int count) {
    return '$count माह';
  }

  @override
  String get goalOneYear => '1 वर्ष';

  @override
  String get goalTwoYears => '2 वर्ष';

  @override
  String get goalFirmness => 'यह कितना पक्का है?';

  @override
  String get goalKindHard => 'प्रतिबद्ध';

  @override
  String get goalKindHardSub => 'कुछ भी ख़र्च योग्य होने से पहले रोका जाता है';

  @override
  String get goalKindFlexible => 'लचीला';

  @override
  String get goalKindFlexibleSub => 'जो चुकाना ज़रूरी है उसके आगे झुक जाता है';

  @override
  String get goalKindPaused => 'रुका हुआ';

  @override
  String get goalKindPausedSub => 'दिखता रहता है, कुछ रोका नहीं जाता';

  @override
  String get goalSaveChanges => 'बदलाव सहेजें';

  @override
  String get goalAddThis => 'यह लक्ष्य जोड़ें';

  @override
  String get goalDelete => 'यह लक्ष्य हटाएँ';

  @override
  String get activityTitle => 'गतिविधि';

  @override
  String get activityBlurb => 'आपने जो दर्ज किया, नवीनतम पहले।';

  @override
  String get activityEmpty =>
      'जब आप कोई ख़र्च दर्ज करेंगे तो वह यहाँ दिखेगा, और ग़लती होने पर हटा सकते हैं।';

  @override
  String get activityRemoveIt => 'हटा दें';

  @override
  String get activityKeepIt => 'रहने दें';

  @override
  String get activitySpent => 'ख़र्च';

  @override
  String get activityIncome => 'तनख़्वाह';

  @override
  String get activityCorrection => 'सुधार';

  @override
  String get activityRemoved => 'हटाया गया';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get profileConfirmBalance => 'अपने शेष की पुष्टि करें';

  @override
  String get profileTrustTitle => 'आँकड़ा कितना भरोसेमंद है?';

  @override
  String get profileTrustFresh =>
      'अद्यतन है। कुछ भी आपके ध्यान की माँग नहीं करता।';

  @override
  String get profileTrustDegraded =>
      'कुछ समय से आपके शेष की पुष्टि नहीं हुई। आँकड़ा अब भी दिखता है, बस कम निश्चित है।';

  @override
  String get profileTrustReview =>
      'भरोसा करने के लिए बहुत पुराना या अनिश्चित। ठीक करने के लिए अपने शेष की पुष्टि करें।';

  @override
  String get profileConfirmedNever => 'अभी पुष्टि नहीं हुई';

  @override
  String get profileConfirmedToday => 'आज पुष्टि हुई';

  @override
  String get profileConfirmedYesterday => 'कल पुष्टि हुई';

  @override
  String profileConfirmedDays(int count) {
    return '$count दिन पहले पुष्टि हुई';
  }

  @override
  String get profileAppearance => 'रूप';

  @override
  String get profileTheme => 'थीम';

  @override
  String get profileThemeBlurb =>
      'फ़ोन का अनुसरण डिफ़ॉल्ट है, इसलिए कुछ थोपा नहीं जाता।';

  @override
  String get themePhone => 'फ़ोन';

  @override
  String get themeLight => 'हल्का';

  @override
  String get themeDark => 'गहरा';

  @override
  String get profileLanguage => 'भाषा';

  @override
  String get profileLanguageBlurb =>
      'फ़ोन का अनुसरण डिफ़ॉल्ट है, इसलिए कुछ थोपा नहीं जाता।';

  @override
  String get languagePhone => 'फ़ोन';

  @override
  String get profileCurrency => 'मुद्रा';

  @override
  String currencyChangeTitle(String currency) {
    return '$currency पर बदलें?';
  }

  @override
  String currencyChangeBlurb(String currency) {
    return 'आपकी योजना की हर राशि अपनी संख्या रखती है और अब से $currency में दिखेगी। किसी विनिमय दर से कुछ नहीं बदला जाता, इसलिए इसे मुद्रा सुधारने के लिए इस्तेमाल करें, पैसे बदलने के लिए नहीं।';
  }

  @override
  String get currencyChangeConfirm => 'बदलें';

  @override
  String get profileYourData => 'आपका डेटा';

  @override
  String get profileDelete => 'मेरी योजना मिटाएँ';

  @override
  String get profileDeleteSub => 'सब कुछ साफ़ करके सेटअप पर लौटाता है';

  @override
  String get profileStartOver => 'फिर से शुरू करें?';

  @override
  String get profileStartOverBlurb =>
      'आपकी योजना और आपने जो दर्ज किया सब मिट जाएगा। इसे पलटा नहीं जा सकता।';

  @override
  String get profileDeleteEverything => 'सब कुछ मिटाएँ';

  @override
  String get profileKeepPlan => 'मेरी योजना रहने दें';

  @override
  String get save => 'सहेजें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String activityRemoveAmount(String amount) {
    return '$amount हटाएँ?';
  }

  @override
  String get activityRemoveDetail =>
      'यह तुरंत आपकी योजना में गिना जाना बंद कर देता है। प्रविष्टि इस सूची में हटाया गया के रूप में बनी रहती है, ताकि आपका रिकॉर्ड पूरा रहे।';

  @override
  String get activityCardPurchase => 'कार्ड से ख़रीद';

  @override
  String get activityCardPayment => 'कार्ड भुगतान';

  @override
  String get activityRefund => 'वापसी';

  @override
  String get activityTransfer => 'खातों के बीच स्थानांतरित';

  @override
  String get activityLoan => 'ऋण प्राप्त';

  @override
  String get activityDebtPayment => 'ऋण भुगतान';

  @override
  String get activityBalanceCorrected => 'शेष सुधारा गया';

  @override
  String get activityBlurbEmpty => 'अभी कुछ दर्ज नहीं।';

  @override
  String get profileStartAgain => 'फिर से शुरू करें';

  @override
  String get claimRent => 'किराया और बिल';

  @override
  String get claimCardMinimum => 'कार्ड का न्यूनतम बकाया';

  @override
  String get claimEssentials => 'खाना और आवागमन';

  @override
  String get claimBuffer => 'आपातकालीन कोष';

  @override
  String get languageTitle => 'कौन-सी भाषा?';

  @override
  String get languageBlurb => 'आप इसे बाद में प्रोफ़ाइल में बदल सकते हैं।';

  @override
  String get profileLedgerTitle => 'क्या रिकॉर्ड पूरा है?';

  @override
  String get ledgerComplete => 'आपने जो ख़र्च किया सब दर्ज है।';

  @override
  String get ledgerPartial =>
      'कुछ ख़र्च तभी सामने आया जब आपने शेष की पुष्टि की।';

  @override
  String get ledgerUnknown =>
      'Upino नहीं बता सकता कितना छूटा है। जानने के लिए शेष की पुष्टि करें।';

  @override
  String get askTitle => 'ख़र्च करने से पहले पूछें';

  @override
  String get askBlurb =>
      'अपनी योजना पर एक ख़रीद आज़माएँ। कुछ दर्ज नहीं होता और कुछ बदलता नहीं।';

  @override
  String get askAmountLabel => 'यह कितने की होगी?';

  @override
  String get askRun => 'देखें इसका क्या असर होगा';

  @override
  String get askDoNotBuy => 'न ख़रीदें';

  @override
  String get askBuyNow => 'आज ख़रीदें';

  @override
  String askBuyAfter(String date) {
    return '$date के बाद ख़रीदें';
  }

  @override
  String get askUnchanged => 'आपकी योजना जैसी है वैसी रहती है।';

  @override
  String get askStsAfter => 'उसके बाद आप कितना ख़र्च कर सकते हैं';

  @override
  String get askBreaks =>
      'इससे कोई ऐसी चीज़ बिना व्यवस्था के रह जाती है जो चुकानी ज़रूरी है।';

  @override
  String get askSafe => 'चुकाने लायक़ कोई चीज़ बिना व्यवस्था के नहीं रहती।';

  @override
  String get askCosts => 'किसे कम मिलता है';

  @override
  String askCostLine(String label, String amount) {
    return '$label · $amount कम';
  }

  @override
  String get askWaitingHelps =>
      'तनख़्वाह आने तक रुकने से सब कुछ पूरा हो जाता है।';

  @override
  String get askNoIncome =>
      'अभी कोई तनख़्वाह अपेक्षित नहीं, इसलिए तुलना के लिए आगे कोई समय नहीं है।';

  @override
  String askAssumption(String date) {
    return 'यह मानकर कि आपकी तनख़्वाह $date को अपेक्षित रूप से आएगी।';
  }

  @override
  String get askNoVerdict => 'Upino हाँ या ना नहीं कहता। फ़ैसला आपका है।';

  @override
  String get receipt => 'रसीद';

  @override
  String get receiptAdd => 'रसीद जोड़ें';

  @override
  String get receiptCamera => 'फ़ोटो लें';

  @override
  String get receiptGallery => 'फ़ोटो चुनें';

  @override
  String get receiptAttached => 'रसीद जुड़ी';

  @override
  String get receiptRemove => 'फ़ोटो हटाएँ';

  @override
  String get onboardingIncomeFrom => 'कम से कम';

  @override
  String get onboardingIncomeTo => 'अधिकतम';

  @override
  String get onboardingIncomeToOptional => 'वैकल्पिक';

  @override
  String incomeRange(String low, String high) {
    return '$low से $high';
  }

  @override
  String incomeRangeNote(String low) {
    return 'आपकी योजना $low पर बनी है। उससे ऊपर जो आए वह आने पर आपका है।';
  }

  @override
  String get categoryFood => 'खाना';

  @override
  String get categoryTransport => 'आवागमन';

  @override
  String get categoryBills => 'बिल';

  @override
  String get categoryShopping => 'खरीदारी';

  @override
  String get categoryHealth => 'स्वास्थ्य';

  @override
  String get categoryFun => 'मनोरंजन';

  @override
  String get categoryOther => 'अन्य';

  @override
  String get categoryUnsorted => 'बिना श्रेणी';

  @override
  String get categoryPrompt => 'यह किस लिए था?';

  @override
  String get spendingTitle => 'पैसा कहाँ गया';

  @override
  String get spendingWindow => 'पिछले 30 दिनों में दर्ज खर्च';

  @override
  String get backupSection => 'बैकअप';

  @override
  String get backupSave => 'बैकअप सहेजें';

  @override
  String get backupSaveSub =>
      'पासवर्ड से सुरक्षित। इसे किसी सुरक्षित जगह, जैसे क्लाउड ड्राइव में भेजें।';

  @override
  String get backupRestore => 'बैकअप से वापस लाएँ';

  @override
  String get backupRestoreSub => 'इस फ़ोन की योजना बदल देता है';

  @override
  String get backupPassword => 'पासवर्ड';

  @override
  String get backupPasswordRepeat => 'पासवर्ड दोहराएँ';

  @override
  String get backupPasswordSaveBlurb =>
      'वापस लाने के लिए यह पासवर्ड चाहिए होगा। भूलने पर यह वापस नहीं मिल सकता। रसीदों की तस्वीरें शामिल नहीं हैं।';

  @override
  String get backupPasswordOpenBlurb =>
      'वह पासवर्ड जिससे यह बैकअप सहेजा गया था।';

  @override
  String get backupPasswordShort => 'कम से कम 6 अक्षर';

  @override
  String get backupPasswordMismatch => 'दोनों मेल नहीं खाते';

  @override
  String get backupOpen => 'खोलें';

  @override
  String get backupReplaceTitle => 'यह योजना बदलें?';

  @override
  String get backupReplaceBlurb =>
      'इस फ़ोन का सब कुछ बैकअप से बदल जाएगा। इसे पलटा नहीं जा सकता।';

  @override
  String get backupReplace => 'बदलें';

  @override
  String get backupRestored => 'बैकअप वापस आ गया';

  @override
  String get backupWrongPassword => 'यह पासवर्ड इस बैकअप को नहीं खोलता।';

  @override
  String get backupNotABackup => 'यह फ़ाइल Upino बैकअप नहीं है।';

  @override
  String get backupUnreadable =>
      'यह बैकअप Upino के नए संस्करण से बना है। ऐप अपडेट करके फिर कोशिश करें।';

  @override
  String get inflationTitle => 'महँगाई';

  @override
  String get inflationNotSet =>
      'सेट नहीं है। अपने यहाँ की सालाना दर डालें ताकि लक्ष्यों की असली लागत दिखे।';

  @override
  String inflationRate(String rate) {
    return '$rate% सालाना';
  }

  @override
  String get inflationDialogTitle => 'सालाना महँगाई';

  @override
  String get inflationDialogBlurb =>
      'दाम बढ़ते हैं, इसलिए आज के पैसे में तय लक्ष्य अपनी तारीख़ पर ज़्यादा महँगा होगा। अपेक्षित दर डालें, बंद करने के लिए खाली छोड़ें।';

  @override
  String goalsInflated(String rate, String amount) {
    return '$rate% सालाना से, तब तक इसकी लागत लगभग $amount होगी।';
  }

  @override
  String get holdingsTitle => 'अन्य बचत';

  @override
  String get holdingsBlurb =>
      'डॉलर, सोना, सिक्के। योजना के साथ दिखते हैं, खर्च करने योग्य रकम में कभी नहीं गिने जाते।';

  @override
  String get holdingsAdd => 'बचत जोड़ें';

  @override
  String get holdingsAddSub => 'खर्च योग्य रकम में नहीं गिना जाता';

  @override
  String get holdingsTotal => 'कुल';

  @override
  String holdingSummary(String quantity, String price, String date) {
    return '$quantity × $price · दाम $date';
  }

  @override
  String get holdingEditNew => 'नई बचत';

  @override
  String get holdingEditExisting => 'बचत बदलें';

  @override
  String get holdingName => 'यह क्या है?';

  @override
  String get holdingNameHint => 'डॉलर, सोना…';

  @override
  String get holdingUsd => 'डॉलर';

  @override
  String get holdingEur => 'यूरो';

  @override
  String get holdingGold => 'सोना (ग्राम)';

  @override
  String get holdingCoin => 'सोने का सिक्का';

  @override
  String get holdingQuantity => 'कितने';

  @override
  String get holdingUnitPrice => 'आज एक की क़ीमत';

  @override
  String holdingWorth(String amount) {
    return 'कुल क़ीमत $amount';
  }

  @override
  String get holdingDelete => 'यह बचत हटाएँ';

  @override
  String get fasterTitle => 'तेज़ एंट्री';

  @override
  String get smsTitle => 'बैंक संदेश पढ़ें';

  @override
  String get smsDetail =>
      'बैंक जिन खर्चों का संदेश भेजता है, उन्हें एक टैप में दर्ज करने के लिए दिखाया जाता है। संदेश सिर्फ़ इसी फ़ोन पर पढ़े जाते हैं, कहीं भेजे नहीं जाते।';

  @override
  String get smsDenied =>
      'Upino को संदेश पढ़ने की अनुमति नहीं मिली। फ़ोन की सेटिंग में अनुमति दे सकते हैं।';

  @override
  String smsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'देखने को $count बैंक संदेश',
      one: 'देखने को 1 बैंक संदेश',
    );
    return '$_temp0';
  }

  @override
  String get smsWaitingSub => 'हर एक को एक टैप में दर्ज करें या छोड़ें';

  @override
  String get smsReviewTitle => 'आपके बैंक से';

  @override
  String get smsReviewBlurb =>
      'जब तक आप \'दर्ज करें\' न दबाएँ, कुछ दर्ज नहीं होता। रकम संदेश से मिलाएँ।';

  @override
  String get smsReviewDone => 'सब देख लिया।';

  @override
  String get smsRecord => 'दर्ज करें';

  @override
  String get smsSkip => 'छोड़ें';

  @override
  String get reminderTitleSetting => 'शाम का रिमाइंडर';

  @override
  String get reminderDetail =>
      'रात 9 बजे, सिर्फ़ उन दिनों जब कुछ दर्ज न हुआ हो।';

  @override
  String get reminderDenied =>
      'Upino को सूचनाएँ दिखाने की अनुमति नहीं मिली। सेटिंग में अनुमति दे सकते हैं।';

  @override
  String get reminderTitle => 'आज कुछ खर्च किया?';

  @override
  String get reminderBody =>
      'कुछ सेकंड में दर्ज करें, ताकि कल का आँकड़ा सही रहे।';

  @override
  String get reminderChannel => 'शाम का रिमाइंडर';

  @override
  String get widgetSpend => '+ खर्च';

  @override
  String get widgetAdd => 'होम स्क्रीन पर जोड़ें';

  @override
  String get widgetAddSub =>
      'कितना खर्च कर सकते हैं, और खर्च दर्ज करने का बटन, ऐप खोले बिना';
}
