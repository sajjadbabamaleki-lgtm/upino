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

  @override
  String get voiceListening => 'सुन रहा है… रकम और किस लिए था, बोलें।';

  @override
  String voiceHeard(String text) {
    return 'सुना: “$text”। रकम जाँचें, फिर सहेजें।';
  }

  @override
  String get voiceNothing => 'कोई रकम नहीं सुनी। फिर कोशिश करें या टाइप करें।';

  @override
  String get voicePrivacy =>
      'आपका फ़ोन बोली को टेक्स्ट में बदलता है। ऑफ़लाइन पहचान न हो तो यह फ़ोन की स्पीच सेवा से होता है।';

  @override
  String get voiceButton => 'बोलें';

  @override
  String get voiceUnavailable =>
      'इस फ़ोन में ऐप के लिए कोई वाक् पहचान नहीं है। रकम टाइप करें।';

  @override
  String get voiceNoPermission =>
      'Upino को माइक्रोफ़ोन की अनुमति नहीं मिली। सेटिंग में अनुमति दे सकते हैं।';

  @override
  String get voiceNetwork =>
      'इस फ़ोन की वाक् पहचान को इंटरनेट चाहिए और वह नहीं मिला।';

  @override
  String voiceNoAmount(String text) {
    return '“$text” सुना, पर उसमें रकम नहीं थी। फिर कोशिश करें या टाइप करें।';
  }

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get navAsk => 'पूछें';

  @override
  String get alertsTitle => 'ध्यान चाहिए';

  @override
  String get alertsEmpty => 'अभी कुछ ध्यान नहीं चाहिए। योजना अद्यतन है।';

  @override
  String alertUnfunded(String label, String amount) {
    return '$label में $amount कम है';
  }

  @override
  String get alertUnfundedDetail =>
      'जो चुकाना ज़रूरी है, वह आपके पैसे से पूरा नहीं होता।';

  @override
  String alertIncomeLate(String date) {
    return 'आपका वेतन $date को आना था';
  }

  @override
  String get alertIncomeLateDetail =>
      'आने तक गिना नहीं जाता। तारीख बदली हो तो योजना में बदलें।';

  @override
  String alertGoalBehind(String name, String amount) {
    return '$name इस अवधि में $amount पीछे है';
  }

  @override
  String get alertGoalBehindDetail =>
      'आपके पैसे इस अवधि के हिस्से तक नहीं पहुँचते।';

  @override
  String get chatHint => 'कुछ भी पूछें या दाम लिखें';

  @override
  String get chatSuggestSafe => 'कितना खर्च कर सकता हूँ?';

  @override
  String get chatSuggestPay => 'अगला वेतन कब है?';

  @override
  String get chatSuggestWhere => 'मेरा पैसा कहाँ गया?';

  @override
  String get chatSuggestAside => 'क्या अलग रखा है?';

  @override
  String chatSafe(String amount, String date) {
    return 'आप $date तक $amount खर्च कर सकते हैं।';
  }

  @override
  String get chatSafeStale =>
      'एक बात: बैलेंस की पुष्टि बाकी है, इसे अनुमान समझें।';

  @override
  String chatPay(String amount, String date) {
    return 'आपका अगला वेतन $amount है, $date को आएगा।';
  }

  @override
  String get chatPayNone =>
      'अभी अगला वेतन पता नहीं। योजना में जोड़ें, मैं ध्यान रखूँगा।';

  @override
  String get chatWhere => 'पिछले 30 दिनों में पैसा यहाँ गया:';

  @override
  String get chatWhereNone =>
      'पिछले 30 दिनों में कोई खर्च नहीं। या तो शांत महीना था या दर्ज नहीं हुए।';

  @override
  String chatAside(String amount) {
    return 'कुछ भी खर्च-योग्य गिनने से पहले $amount अलग रखा है:';
  }

  @override
  String chatPurchase(String amount) {
    return 'देखते हैं $amount से क्या होगा।';
  }

  @override
  String get chatHelp =>
      'हम्म, यह ठीक से समझ नहीं आया। मैं बता सकता हूँ कितना खर्च कर सकते हैं, वेतन कब आएगा, पैसा कहाँ गया, क्या अलग रखा है, या कम खर्च कैसे करें। या कोई दाम लिखें, मैं खरीदने का असर दिखाऊँगा।';

  @override
  String get chatHelloNew =>
      'नमस्ते! मैं Upino हूँ। आप नए हैं, तो अभी मुझे बस बुनियादी बातें पता हैं: आपका बैलेंस, वेतन और जो आपने अलग रखा है। इतने से ही बता सकता हूँ कि कितना खर्च कर सकते हैं और किसी खरीद का क्या असर होगा। खर्च दर्ज करते रहिए, लगभग एक मौसम बाद मैं आपकी आदतें इतनी जान लूँगा कि आपका निजी सलाहकार बन सकूँ।';

  @override
  String chatHelloLearning(int days, int spends, int remaining) {
    return 'वापसी पर स्वागत! अब तक $days दिन और $spends खर्चों से सीख रहा हूँ। लगभग $remaining दिन और, फिर पूरा एक मौसम होगा।';
  }

  @override
  String chatHelloFamiliar(int days) {
    return 'वापसी पर स्वागत! अब तक आपके पैसे के $days दिन देख चुका हूँ, कुछ भी पूछिए, कम खर्च कैसे करें भी।';
  }

  @override
  String chatHelloAlerts(int count) {
    return 'वैसे, $count बातें आपका इंतज़ार कर रही हैं: घंटी में देखें।';
  }

  @override
  String chatPurchaseFits(String left) {
    return 'आज खरीदने पर भी जो चुकाना है वह सब कवर रहेगा, और $left बचेगा।';
  }

  @override
  String chatPurchaseWait(String date) {
    return 'आज खरीदने पर कोई ज़रूरी भुगतान कम पड़ेगा। $date तक रुकें तो सब कवर हो जाएगा।';
  }

  @override
  String chatPurchaseStillShort(String date) {
    return 'ध्यान दें: $date के वेतन के बाद भी कोई ज़रूरी भुगतान कम पड़ेगा।';
  }

  @override
  String get chatPurchaseShort => 'आज खरीदने पर कोई ज़रूरी भुगतान कम पड़ेगा।';

  @override
  String chatSafeNothing(String date) {
    return 'अभी $date तक कुछ भी खाली नहीं: जो है सब ज़रूरी भुगतानों के लिए रखा है।';
  }

  @override
  String chatPayIn(int days) {
    return 'यानी $days दिन में।';
  }

  @override
  String get chatPayLate =>
      'यह देर से है, इसलिए पुष्टि होने तक गिना नहीं जाता।';

  @override
  String get chatPayRange =>
      'योजना कम राशि पर चलती है, तो अच्छा महीना बोनस है, कमी नहीं।';

  @override
  String chatWhereSoFar(int days) {
    return 'अभी सिर्फ़ $days दिन देखे हैं, तो यह पहली झलक है:';
  }

  @override
  String chatWhereTop(String category, int share) {
    return 'सबसे ज़्यादा $category: कुल का $share%।';
  }

  @override
  String get chatWhereTooSoon =>
      'अभी थोड़ा जल्दी है: मैंने ज़्यादा खर्च देखे ही नहीं। कुछ दर्ज करें और अगले हफ़्ते पूछें।';

  @override
  String get chatAdviceTooSoon =>
      'मदद करना चाहूँगा, पर सच कहूँ तो अभी आपके खर्च ठीक से नहीं जानता, और बिना उसके सलाह बस अंदाज़ा होगी। खर्च दर्ज करें (श्रेणी देने से बहुत मदद मिलती है) और कुछ हफ़्तों बाद पूछें।';

  @override
  String chatAdviceBiggest(String category, String amount, String tenth) {
    return 'पिछले 30 दिनों में सबसे बड़ा खर्च $category था, $amount। इसमें दसवाँ हिस्सा कम करें तो महीने में लगभग $tenth बचेगा।';
  }

  @override
  String get chatAdviceSort =>
      'मैं देख रहा हूँ कितना खर्च हुआ, पर किस पर, यह नहीं। दर्ज करते समय श्रेणी दें, फिर बताऊँगा कहाँ कम करें।';

  @override
  String chatAdviceMore(String amount) {
    return 'पिछले महीने से $amount ज़्यादा खर्च हुआ।';
  }

  @override
  String chatAdviceLess(String amount) {
    return 'बढ़िया: पिछले महीने से $amount कम।';
  }

  @override
  String get chatAdviceLearning =>
      'मैं अभी आपकी आदतें सीख रहा हूँ, इसे पहला संकेत मानें।';

  @override
  String get chatSmallHello => 'नमस्ते! अपने पैसे के बारे में क्या जानना है?';

  @override
  String get chatSmallThanks =>
      'कभी भी! जब भी खर्च करने वाले हों, मैं यहीं हूँ।';

  @override
  String get chatSmallWho =>
      'मैं Upino का सहायक हूँ। मुझे सिर्फ़ आपकी योजना पता है, और हर आँकड़ा वहीं से आता है; कुछ भी इस फ़ोन से बाहर नहीं जाता। हाँ या ना नहीं कहूँगा, पर दिखाऊँगा हर विकल्प आपके लिए क्या छोड़ता है।';

  @override
  String get chatSuggestAdvice => 'कम खर्च कैसे करूँ?';

  @override
  String get chatTitle => 'Upino';

  @override
  String get chatNew => 'नई बातचीत';

  @override
  String get chatResumed => 'यहाँ के जवाब आज की आपकी योजना से निकाले गए हैं।';

  @override
  String get chatWhy => 'यह आँकड़ा ऐसे बनता है:';

  @override
  String get chatWhyHave => 'आपके पास';

  @override
  String get chatWhySetAside => 'पहले अलग रखा';

  @override
  String get chatWhyLeft => 'खर्च योग्य';

  @override
  String get chatSmallHowAreYou =>
      'मैं ठीक हूँ, पूछने के लिए शुक्रिया! आपका पैसा वहीं है जहाँ छोड़ा था। क्या जानना है?';

  @override
  String get chatSmallBye => 'फिर मिलेंगे! अगले बड़े खर्च से पहले आइएगा।';

  @override
  String get chatSmallOkay => 'और कुछ देखना है?';

  @override
  String get askHubTitle => 'Upino से बात करें';

  @override
  String get askHubNew =>
      'पूछें कितना खर्च कर सकते हैं, किसी खरीद का असर, या वेतन कब आएगा। मैं अभी आपको जान रहा हूँ; जितना दर्ज करेंगे, उतना काम आऊँगा।';

  @override
  String askHubLearning(int days) {
    return 'आपकी आदतें सीख रहा हूँ: लगभग $days दिन में सलाह के लिए पूरा मौसम होगा।';
  }

  @override
  String get askHubFamiliar =>
      'अब आपका पैसा अच्छी तरह जानता हूँ। कुछ भी पूछें, कम खर्च कैसे करें भी।';

  @override
  String get askHubStart => 'बातचीत शुरू करें';

  @override
  String get askHubCommon => 'आम सवाल';

  @override
  String get askHubHistory => 'आपकी बातचीत';

  @override
  String askHubTurns(int count) {
    return '$count सवाल';
  }

  @override
  String askHubAsidePreview(String amount, int count) {
    return '$count प्रतिबद्धताओं के लिए $amount अलग रखा';
  }

  @override
  String get askHubDeleteTitle => 'यह बातचीत हटाएँ?';

  @override
  String get askHubDeleteBlurb =>
      'सिर्फ़ बातचीत हटेगी। योजना में कुछ नहीं बदलेगा।';

  @override
  String get chatSmallHi => 'नमस्ते!';

  @override
  String get chatSmallHiFine => 'नमस्ते! मैं ठीक हूँ, शुक्रिया।';

  @override
  String chatSafeLasts(int days) {
    return 'यह वेतन तक $days दिन चलना है।';
  }

  @override
  String homeSpokenFor(String amount, String date) {
    return '$date तक आपके पैसे में से $amount पहले से तय है।';
  }

  @override
  String askGoalLater(String goal, int days) {
    return '$goal · लगभग $days दिन बाद';
  }

  @override
  String get askGoalsTitle => 'लक्ष्य आगे खिसकते हैं';

  @override
  String get askGoalsNote =>
      'अनुमानित, उसी गति से जिससे हर लक्ष्य के लिए बचत हो रही है।';

  @override
  String chatPurchaseGoal(String goal, int days) {
    return 'इससे $goal लगभग $days दिन पीछे चला जाएगा।';
  }

  @override
  String get monthTitle => 'आपका महीना';

  @override
  String get monthWindow => 'पिछले 30 दिन, उससे पहले के 30 दिनों के मुकाबले';

  @override
  String monthTooSoon(int days) {
    return 'महीने की समीक्षा के लिए एक महीने का खर्च चाहिए। आपकी $days दिन में तैयार होगी।';
  }

  @override
  String monthSpent(String amount) {
    return 'पिछले 30 दिनों में $amount खर्च हुए।';
  }

  @override
  String get monthNothing => 'पिछले 30 दिनों में कुछ दर्ज नहीं हुआ।';

  @override
  String monthMore(String amount) {
    return 'यह पिछले 30 दिनों से $amount ज़्यादा है।';
  }

  @override
  String monthLess(String amount) {
    return 'यह पिछले 30 दिनों से $amount कम है।';
  }

  @override
  String get monthSame => 'पिछले 30 दिनों जितना ही।';

  @override
  String monthUp(String category, String amount) {
    return 'सबसे ज़्यादा बढ़ा: $category, $amount।';
  }

  @override
  String monthDown(String category, String amount) {
    return 'सबसे ज़्यादा घटा: $category, $amount।';
  }

  @override
  String monthGoals(int onTrack, int total) {
    return 'सही राह पर लक्ष्य: $total में से $onTrack।';
  }

  @override
  String get chatSuggestMonth => 'मेरा महीना कैसा रहा?';

  @override
  String get timelineTitle => 'आगे आपका पैसा';

  @override
  String get timelineToday => 'आज';

  @override
  String get timelineNow => 'अभी';

  @override
  String get timelineProjected => 'अनुमान';

  @override
  String get timelineRecorded => 'दर्ज';

  @override
  String get timelineFree => 'खर्च के लिए खाली';

  @override
  String get timelineHad => 'आपके पास था';

  @override
  String timelineBalance(String amount) {
    return 'शेष $amount';
  }

  @override
  String timelineSetAside(String amount) {
    return 'अलग रखा $amount';
  }

  @override
  String timelinePayMark(String amount) {
    return 'वेतन $amount';
  }

  @override
  String timelineShort(String amount) {
    return 'ज़रूरी भुगतान के लिए $amount कम';
  }

  @override
  String timelineWithout(String amount) {
    return 'इसके बिना: $amount';
  }

  @override
  String get timelineBuyAfterPay => 'वेतन के बाद खरीदें';

  @override
  String get timelineBalanceLegend => 'शेष';

  @override
  String get timelineWithPurchase => 'खरीद के साथ';

  @override
  String get timelinePay => 'वेतन का दिन';

  @override
  String get timelineAssumptions =>
      'आगे का हिस्सा अनुमान है: वेतन अपनी तारीख पर, बिल अपनी तारीखों पर, जीवन-खर्च के लिए रखा पैसा बराबर खर्च, और कुछ नहीं। किसी भी दिन को देखने के लिए चार्ट पर उँगली खिसकाएँ।';

  @override
  String get timelineSemantics =>
      'आपके शेष और खर्च योग्य राशि का दिन-ब-दिन चार्ट';

  @override
  String goalChartSemantics(String goal) {
    return '$goal के लक्ष्य तक पहुँचने का चार्ट';
  }

  @override
  String goalChartTarget(String amount, String date) {
    return '$date तक लक्ष्य $amount';
  }

  @override
  String goalPaceLabel(String amount) {
    return 'हर वेतन अवधि में अलग रखें: $amount';
  }

  @override
  String goalOnTrack(String date) {
    return 'सही राह पर: $date तक पूरा।';
  }

  @override
  String goalLate(String date, int days) {
    return 'इस गति से यह $date को पूरा होगा, अपनी तारीख से $days दिन बाद।';
  }

  @override
  String get goalNotMoving =>
      'अभी इसमें कुछ नहीं जा रहा, इसलिए यह करीब नहीं आ रहा।';

  @override
  String goalUsePace(String date) {
    return 'लक्ष्य तारीख $date करें';
  }

  @override
  String get goalPaceNote => 'बस एक अनुमान: जब तक आप न चुनें, कुछ नहीं बदलता।';

  @override
  String get goalShowPath => 'देखें यह कैसे पहुँचता है';

  @override
  String get goalHidePath => 'छिपाएँ';

  @override
  String get billsTitle => 'बिल और सदस्यताएँ';

  @override
  String get billAdd => 'बिल या सदस्यता जोड़ें';

  @override
  String get billAddSub =>
      'फ़ोन, इंटरनेट, बीमा, स्ट्रीमिंग… हर एक अपनी तारीख से पहले अलग रखा जाता है।';

  @override
  String get billEditNew => 'नया बिल';

  @override
  String get billEditExisting => 'बिल बदलें';

  @override
  String get billName => 'यह क्या है?';

  @override
  String get billNameHint => 'जैसे इंटरनेट';

  @override
  String get billAmount => 'हर भुगतान';

  @override
  String get billEvery => 'कितनी बार';

  @override
  String get billEveryWeek => 'साप्ताहिक';

  @override
  String get billEveryMonth => 'मासिक';

  @override
  String get billEveryQuarter => 'तिमाही';

  @override
  String get billEveryYear => 'वार्षिक';

  @override
  String get billNext => 'अगला भुगतान';

  @override
  String get billKind => 'यह है';

  @override
  String get billKindBill => 'बिल';

  @override
  String get billKindSubscription => 'सदस्यता';

  @override
  String get billRepays => 'चुकाता है';

  @override
  String get billRepaysNothing => 'कुछ नहीं, यह खर्च है';

  @override
  String get billAddThis => 'यह बिल जोड़ें';

  @override
  String get billDelete => 'यह बिल हटाएँ';

  @override
  String billRow(String every, String date) {
    return '$every · अगला $date';
  }

  @override
  String billOverdue(String date) {
    return '$date को देय था';
  }

  @override
  String get billPay => 'भुगतान हो गया';

  @override
  String get billEdit => 'बदलें';

  @override
  String get dayToday => 'आज';

  @override
  String dayIn(int days) {
    return '$days दिन में';
  }

  @override
  String dayAgo(int days) {
    return '$days दिन पहले';
  }

  @override
  String get homeComingUp => 'आने वाले';

  @override
  String homeComingUpTotal(String amount) {
    return 'अगले 30 दिनों में $amount के बिल देय।';
  }

  @override
  String payDueTitle(String date) {
    return 'आपका वेतन $date को आना था। क्या आ गया?';
  }

  @override
  String get payDueSub => 'बताइए कितना आया; अगला वेतन एक अवधि बाद अपेक्षित है।';

  @override
  String get payArrived => 'आ गया';

  @override
  String get payArrivedTitle => 'कितना आया?';

  @override
  String get planRecordPay => 'वेतन आ गया';

  @override
  String get planRecordPaySub => 'दर्ज करें, अगला एक अवधि आगे जाएगा';

  @override
  String get accountsTitle => 'खाते';

  @override
  String get accountMain => 'मुख्य खाता';

  @override
  String get accountKindBank => 'बैंक खाता';

  @override
  String get accountKindCash => 'नकद';

  @override
  String get accountKindSavings => 'बचत';

  @override
  String get accountKindCard => 'क्रेडिट कार्ड';

  @override
  String get accountKindLoan => 'ऋण';

  @override
  String get accountAdd => 'खाता जोड़ें';

  @override
  String get accountAddSub =>
      'नकद, बचत, कार्ड या ऋण। बैंक जोड़ने की ज़रूरत नहीं।';

  @override
  String get accountEditNew => 'नया खाता';

  @override
  String get accountNameHint => 'जैसे बटुआ';

  @override
  String get accountHolds => 'अभी कितना है';

  @override
  String get accountOwes => 'अभी कितना बकाया';

  @override
  String get accountCounted => 'योजना में गिनें';

  @override
  String get accountCountedSub => 'यह पैसा इस महीने खर्च हो सकता है।';

  @override
  String accountOwed(String amount) {
    return 'बकाया $amount';
  }

  @override
  String get accountNotCounted => 'योजना में नहीं गिना';

  @override
  String get accountConfirm => 'असली शेष बताएँ';

  @override
  String get accountMove => 'पैसा स्थानांतरित करें';

  @override
  String accountMoveTo(String name) {
    return '$name में भेजें';
  }

  @override
  String get accountMoveBlurb => 'अपने खातों के बीच पैसा भेजना न खर्च है न आय।';

  @override
  String get accountPayCard => 'कुछ चुकाएँ';

  @override
  String get accountPayBlurb =>
      'मुख्य खाते से भुगतान। यह बकाया चुकाता है; दूसरा खर्च नहीं।';

  @override
  String get accountRemove => 'यह खाता हटाएँ';

  @override
  String get accountInUse =>
      'इसका इतिहास है, इसलिए रहेगा। आप इसे गिनना बंद कर सकते हैं।';

  @override
  String get paidFrom => 'भुगतान इससे';

  @override
  String get categorySuggested =>
      'पिछले खर्चों से सुझाया गया। बदलने के लिए दूसरा चुनें।';

  @override
  String get recoverTitle => 'वापस आने वाला पैसा';

  @override
  String recoverTotal(String amount) {
    return '$amount वापस आ सकता है। आने तक गिना नहीं जाता।';
  }

  @override
  String get recoverReturnable => 'लौटाया जा सकता है';

  @override
  String get recoverExpect => 'लौटा दिया, रिफ़ंड अपेक्षित';

  @override
  String get recoverArrived => 'रिफ़ंड आ गया';

  @override
  String get recoverKept => 'रख लिया';

  @override
  String get recoverPending => 'रिफ़ंड रास्ते में';

  @override
  String get recoverRefunded => 'रिफ़ंड हुआ';

  @override
  String get recoverPrompt => 'पैसा वापस पाना';

  @override
  String recoverWhere(String amount) {
    return '$amount वापस आया। इसे कहाँ रखें?';
  }

  @override
  String recoverToGoal(String goal) {
    return '$goal के लिए';
  }

  @override
  String get recoverToBuffer => 'आपात बफ़र में';

  @override
  String get recoverLeave => 'खर्च के लिए खाली छोड़ें';

  @override
  String get accountStopCounting => 'योजना में गिनना बंद करें';

  @override
  String get moveTitle => 'सबसे अच्छा कदम';

  @override
  String get moveTagMove => 'स्थानांतरित';

  @override
  String get moveTagWait => 'रुकें';

  @override
  String get moveTagSave => 'बचाएँ';

  @override
  String get moveTagSpend => 'खर्च करें';

  @override
  String moveMove(String amount, String account) {
    return 'ज़रूरी भुगतान के लिए $account से $amount स्थानांतरित करें।';
  }

  @override
  String moveMoveWhy(String claim) {
    return '$claim में कमी है, और यह पैसा योजना से बाहर पड़ा है।';
  }

  @override
  String get moveDoIt => 'स्थानांतरित करें';

  @override
  String moveWaitGap(String date, String amount) {
    return 'अतिरिक्त खर्च रोकें: $date को ज़रूरी भुगतान में $amount कम पड़ेगा।';
  }

  @override
  String get moveWaitGapWhy =>
      'अनुमान उस दिन तक आपका वेतन, बिल और जीवन-खर्च गिनता है।';

  @override
  String moveWaitPay(int days, String now, String later) {
    return 'आपका वेतन $days दिन दूर है। इंतज़ार करने से $now की गुंजाइश $later हो जाती है।';
  }

  @override
  String get moveWaitPayWhy =>
      'केवल अगर जो सोच रहे हैं वह रुक सकता है। किसी भी हाल में जोखिम नहीं।';

  @override
  String moveSave(String amount, String account, String goal) {
    return '$goal के लिए $amount को $account में रखें।';
  }

  @override
  String moveSaveWhy(int days) {
    return 'यह लगभग $days दिन पहले पूरा होगा, और खाली पैसा फिर भी आपके सामान्य महीने का दोगुना रहेगा।';
  }

  @override
  String moveSpend(String amount, String date) {
    return '$date तक आप सुरक्षित हैं: $amount इस्तेमाल के लिए खाली है।';
  }

  @override
  String get moveSpendWhy =>
      'बिल और लक्ष्य पहले से अलग रखे हैं, आगे कुछ कम नहीं पड़ता, और यह आपके सामान्य खर्च से काफ़ी ज़्यादा है।';

  @override
  String get moveNotNow => 'अभी नहीं';

  @override
  String get moveNone =>
      'अभी सुझाने लायक कोई कदम नहीं है। आपकी योजना जैसी है वैसी ठीक है।';

  @override
  String monthIncome(String amount) {
    return 'आया वेतन: $amount।';
  }

  @override
  String monthToGoals(String amount) {
    return 'लक्ष्यों में डाला: $amount।';
  }

  @override
  String monthNow(String free, String aside) {
    return 'अभी: $free खर्च योग्य, $aside अलग रखा।';
  }

  @override
  String get monthAheadTitle => 'अगले 30 दिन';

  @override
  String monthAheadBills(int count, String amount) {
    return '$count बिल, कुल $amount।';
  }

  @override
  String monthAheadPay(String date) {
    return 'अगला वेतन $date को अपेक्षित है।';
  }

  @override
  String monthAheadTightest(String date, String amount) {
    return 'सबसे तंग दिन $date है, $amount खाली के साथ।';
  }

  @override
  String monthAheadShort(String date, String amount) {
    return '$date को ज़रूरी भुगतान में $amount कम पड़ेगा।';
  }

  @override
  String get monthWorthKnowing => 'जानने लायक';

  @override
  String insightUp(String category, String amount) {
    return '$category पिछले महीने से $amount बढ़ा है।';
  }

  @override
  String insightGoal(int days, String goal) {
    return 'ऐसा चलता रहा तो यह हर महीने $goal के लगभग $days दिन के बराबर है।';
  }

  @override
  String get chatSuggestMove => 'अब मुझे क्या करना चाहिए?';

  @override
  String get chatSuggestComing => 'कौन से बिल आने वाले हैं?';

  @override
  String get chatComingNone =>
      'अगले 30 दिनों में कोई बिल देय नहीं है। प्लान में अपने बिल जोड़ें, मैं उन पर नज़र रखूँगा।';

  @override
  String get quickAsk => 'पूछें';

  @override
  String get quickPay => 'वेतन आया';

  @override
  String get quickBills => 'बिल';

  @override
  String get quickMonth => 'मेरा महीना';

  @override
  String get quickPayDue => 'वेतन का समय है। बताइए आया या नहीं।';

  @override
  String get chartAvg => 'औसत';

  @override
  String get flowsTitle => 'आया और गया पैसा';

  @override
  String get flowsBlurb =>
      'हफ़्ते-दर-हफ़्ते: वेतन और रिफ़ंड रेखा के ऊपर, खर्च और किस्तें नीचे।';

  @override
  String flowsWeek(String date) {
    return '$date वाला हफ़्ता';
  }

  @override
  String flowsInOut(String moneyIn, String moneyOut) {
    return 'आया $moneyIn · गया $moneyOut';
  }

  @override
  String get balanceHistoryTitle => 'समय के साथ आपका शेष';

  @override
  String rangeMonths(int count) {
    return '$count मा';
  }

  @override
  String get rangeYear => '1 वर्ष';

  @override
  String get weekSpentTitle => 'पिछले 7 दिन';

  @override
  String weekSpentTotal(String amount) {
    return '$amount खर्च';
  }

  @override
  String get payGaugeTitle => 'अगले वेतन तक';

  @override
  String payGaugeDaysLabel(int days) {
    return 'दिन बाकी';
  }

  @override
  String payGaugeAfter(String date, String amount) {
    return '$date के वेतन के बाद: $amount खाली';
  }

  @override
  String payGaugeLasts(String amount) {
    return '$amount को तब तक चलना है।';
  }

  @override
  String get goalsOverall => 'आपके सभी लक्ष्यों का';

  @override
  String goalsThisMonth(String amount) {
    return 'इस महीने +$amount';
  }

  @override
  String get goalsNothingThisMonth => 'इस महीने कुछ नहीं जोड़ा';

  @override
  String get goalsAllOnTrack => 'सब सही राह पर';

  @override
  String goalsOnTrackCount(int onTrack, int total) {
    return '$total में से $onTrack सही राह पर';
  }

  @override
  String goalsNextUp(String goal, String date) {
    return 'अगला: $goal, $date';
  }

  @override
  String get goalsTips => 'जल्दी पहुँचने के तरीके';

  @override
  String get goalsTipsSub => 'अपने खर्च के आधार पर Upino से पूछें';

  @override
  String get goalsDetailTitle => 'हर लक्ष्य';

  @override
  String get demoTry => 'नमूना डेटा के साथ आज़माएँ';

  @override
  String get demoTrySub =>
      'चार लक्ष्य, बिल और तीन महीने का इतिहास, एक अलग प्रति में जो आपकी नहीं है और सहेजी नहीं जाती।';

  @override
  String get demoBanner =>
      'नमूना डेटा: यहाँ कुछ भी आपका नहीं है और सहेजा नहीं जाता।';

  @override
  String get demoExit => 'बाहर';

  @override
  String get demoGoalTrip => 'यात्रा';

  @override
  String get demoGoalLaptop => 'लैपटॉप';

  @override
  String get demoGoalEmergency => 'आपातकाल';

  @override
  String get demoGoalCar => 'कार';

  @override
  String get demoBillPhone => 'फ़ोन';

  @override
  String get demoBillInternet => 'इंटरनेट';

  @override
  String get demoBillGym => 'जिम';

  @override
  String get voiceExample => 'जैसे: “दो सौ रुपये, खाना”';

  @override
  String get voiceTitleListening => 'सुन रहे हैं';

  @override
  String get voiceTitleHeard => 'सुन लिया';

  @override
  String get voiceTitleFailed => 'समझ नहीं आया';

  @override
  String get voiceStop => 'रोकें';

  @override
  String get voiceRetry => 'फिर से';

  @override
  String heroUntil(String date) {
    return '$date तक';
  }

  @override
  String get goalIcon => 'आइकन';

  @override
  String get payGaugeToLast => 'चलाना है';

  @override
  String get payGaugeNextPay => 'अगला वेतन';
}
