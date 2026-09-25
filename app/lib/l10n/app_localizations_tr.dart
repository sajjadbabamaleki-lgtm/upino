// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get navHome => 'Ana sayfa';

  @override
  String get navPlan => 'Plan';

  @override
  String get navGoals => 'Hedefler';

  @override
  String get navActivity => 'Hareketler';

  @override
  String get navProfile => 'Profil';

  @override
  String get currencyTitle => 'Hangi para birimi?';

  @override
  String get currencyBlurb =>
      'Planınızdaki her şey bu birimde tutulur. Maaşınızı gerçekten hangi parayla alıyorsanız onu seçin.';

  @override
  String get currencySearchHint => 'Ülke, para birimi veya kod ara';

  @override
  String currencyNoMatch(String query) {
    return '“$query” ile eşleşen bir şey yok. Ülke adını veya üç harfli kodu deneyin.';
  }

  @override
  String get onboardingBadge => 'Yaklaşık bir dakika sürer';

  @override
  String get onboardingTitle => 'Planınızı kurun';

  @override
  String get onboardingBlurb =>
      'Başlamak için iki cevap yeter. Gerisi bekleyebilir.';

  @override
  String get onboardingBalanceLabel => 'Bugünkü birikiminiz';

  @override
  String get onboardingBalanceHint =>
      'Gerçekten harcayabileceğiniz para; dokunmamayı düşündüğünüz kısım değil.';

  @override
  String get onboardingIncomeLabel => 'Ayda ne kadar kazanıyorsunuz?';

  @override
  String get onboardingIncomeHint =>
      'Değişkense aralığı yazın. Planınız alt uca göre kurulur.';

  @override
  String get onboardingPayDay => 'Bir sonraki maaşınız ne zaman?';

  @override
  String onboardingDays(int count) {
    return '$count gün';
  }

  @override
  String get onboardingCommitments => 'Yükümlülüklerinizi ekleyin';

  @override
  String get onboardingCommitmentsOpen => 'Kira, zorunlu giderler ve bir hedef';

  @override
  String get onboardingCommitmentsShut =>
      'İsteğe bağlı, sonra da yapabilirsiniz';

  @override
  String get onboardingRentLabel => 'Kira ve sabit faturalar';

  @override
  String get onboardingRentHint => 'Bir sonraki maaştan önce ödenecek';

  @override
  String get onboardingEssentialsLabel => 'Yemek ve ulaşım';

  @override
  String get onboardingEssentialsHint => 'Bu dönemi geçirmek için gerekenler';

  @override
  String get onboardingGoalLabel => 'Bir hedef için birikim';

  @override
  String get onboardingGoalHint => 'Bu dönem ne kadar ayırmak istiyorsunuz';

  @override
  String get onboardingFinish => 'Planımı oluştur';

  @override
  String get onboardingIncomplete => 'Devam etmek için ilk iki cevabı doldurun';

  @override
  String get tapToType => 'Dokunup yazın';

  @override
  String get heroSafeToSpend => 'Şimdi harcayabilirsiniz';

  @override
  String get heroNotUpToDate => 'Güncel değil';

  @override
  String get heroRecordSpend => 'Bir harcama kaydet';

  @override
  String get heroSeeShort => 'Neyin eksik olduğunu gör';

  @override
  String get heroConfirmBalance => 'Bakiyeyi onayla';

  @override
  String get heroReviewBlurb =>
      'Bu sayıya yeniden güvenilebilmesi için bakiyenizi kontrol edin.';

  @override
  String heroUntilSetAside(String date, String amount) {
    return '$date tarihine kadar · $amount ayrıldı';
  }

  @override
  String heroShort(String amount) {
    return '$amount eksik';
  }

  @override
  String heroUnfunded(String label, String amount) {
    return '$label · $amount karşılanmadı';
  }

  @override
  String get heroBalanceNever => 'Bakiye henüz onaylanmadı';

  @override
  String get heroBalanceToday => 'Bakiye bugün onaylandı';

  @override
  String get heroBalanceYesterday => 'Bakiye dün onaylandı';

  @override
  String heroBalanceDays(int count) {
    return 'Bakiye $count gün önce onaylandı';
  }

  @override
  String get confirm => 'Onayla';

  @override
  String get homeTitle => 'Planınız';

  @override
  String homeUntilTotal(String date, String amount) {
    return '$date tarihine kadar · toplam $amount';
  }

  @override
  String homeRecorded(String amount) {
    return '$amount kaydedildi';
  }

  @override
  String get homeAttention => 'Dikkatinizi bekliyor';

  @override
  String homeNotCovered(String amount) {
    return '$amount karşılanmadı';
  }

  @override
  String get homeAfterNextPay => 'Bir sonraki maaştan sonra';

  @override
  String homeOncePayArrives(String date) {
    return 'Maaşınız $date tarihinde geldiğinde';
  }

  @override
  String get homeSetAsideFirst => 'Önce ayrılır';

  @override
  String get homeProtectedBlurb => 'Harcanabilir hale gelmeden önce korunur.';

  @override
  String get homeNothingSetAside =>
      'Henüz bir şey ayrılmadı. Elinizdekinin tamamı harcanabilir.';

  @override
  String get homeWhyThisNumber => 'Bu sayı neden';

  @override
  String get homeWhatIsShort => 'Neyin eksik olduğu';

  @override
  String get homeShortBlurb =>
      'Buradaki hiçbir şey sizin yerinize taşınmaz veya ertelenmez. Bunlar mevcut paranızın karşılamadığı yükümlülükler.';

  @override
  String get askSpendTitle => 'Ne kadar harcadınız?';

  @override
  String get askBalanceTitle => 'Şu anki bakiyeniz ne kadar?';

  @override
  String get askBalanceBlurb =>
      'Herhangi bir fark harcama olarak değil, düzeltme olarak kaydedilir.';

  @override
  String get whyNoChange => 'Son planınızdan bu yana bir şey değişmedi.';

  @override
  String get whyPayArrived => 'Maaşınız geldi, plan yenilendi.';

  @override
  String get whyBillPaid => 'Para ayırdığınız bir fatura ödendi.';

  @override
  String get whyHeldForBill =>
      'Bir sonraki maaşınızdan hemen sonra ödenecek bir fatura için para tutuluyor.';

  @override
  String get whyOvercommitted =>
      'Şu anda sahip olduğunuzdan fazlasına söz verdiniz.';

  @override
  String get whyStale => 'Bakiyeniz son zamanlarda onaylanmadı.';

  @override
  String get whyCardLarger => 'Kart borcunuz elinizdeki paradan büyük.';

  @override
  String get whyPayLate => 'Beklediğiniz maaş henüz gelmedi.';

  @override
  String get whyOverdue => 'Bir şeyin vadesi geçmiş.';

  @override
  String get whyBufferShort => 'Acil durum rezerviniz tam dolmadı.';

  @override
  String get whyGoalShort =>
      'Birikim hedefiniz şu anda tam olarak karşılanamıyor.';

  @override
  String get whyFlexibleLess => 'Esnek bir hedef planlanandan az aldı.';

  @override
  String get whyDuplicate => 'Tekrarlanan bir işlem yalnızca bir kez sayıldı.';

  @override
  String get planTitle => 'Plan';

  @override
  String get planBlurb =>
      'Bir şey harcanabilir hale gelmeden önce paranızın neye söz verdiği.';

  @override
  String get planMoneyAndIncome => 'Para ve gelir';

  @override
  String get planMoneyYouHave => 'Elinizdeki para';

  @override
  String get planNextPay => 'Sonraki maaş';

  @override
  String get planYourNextPay => 'Bir sonraki maaşınız';

  @override
  String get planNotSet => 'Belirlenmedi';

  @override
  String get planExpectedBlurb =>
      'Bu yalnızca beklenen bir tutar, bu yüzden şimdi harcayabileceğinizin dışında kalır.';

  @override
  String get planSetAsideFirst => 'Önce ayrılır';

  @override
  String get planNothingSetAside =>
      'Bir şey ayrılmadı, bu yüzden elinizdekinin tamamı harcanabilir.';

  @override
  String get planAddToPlan => 'Planınıza ekleyin';

  @override
  String get planGoals => 'Hedefler';

  @override
  String get planSaveToward => 'Bir şey için biriktirin';

  @override
  String get planSaveTowardSub => 'Bir gezi, bir depozito, yeni bir dizüstü';

  @override
  String get planAllGoals => 'Tüm hedefler';

  @override
  String get planAllGoalsSub => 'Ekleyin, düzenleyin veya para ayırın';

  @override
  String get planHowMuchSetAside => 'Bunun için ne kadar ayırmanız gerekiyor?';

  @override
  String get planChangeOrRemove =>
      'Tutarı değiştirin veya planınızdan çıkarın.';

  @override
  String get planRemove => 'Plandan çıkar';

  @override
  String planDue(String date) {
    return ' · vade $date';
  }

  @override
  String get priorityMandatory => 'Ödenmesi şart — önce gelir';

  @override
  String get priorityEssential => 'Günlük ihtiyaçlar';

  @override
  String get priorityBuffer => 'Acil durumlar için tutulur';

  @override
  String get priorityCard => 'Zaten kartla harcandı';

  @override
  String get prioritySinkingFund => 'Bilinen bir fatura için birikim';

  @override
  String get priorityGoal => 'Söz verdiğiniz bir hedef';

  @override
  String get priorityDiscretionary => 'Olsa iyi olur — önce o feragat eder';

  @override
  String get goalsTitle => 'Hedefler';

  @override
  String get goalsBlurbEmpty => 'Henüz bir şey için biriktirilmedi.';

  @override
  String get goalsBlurb => 'Her hedefin bu maaş döneminden ne istediği.';

  @override
  String get goalsEmptyCard =>
      'Biriktirdiğiniz bir şeyi ekleyin — bir gezi, bir depozito, yeni bir dizüstü. Upino zamanında ulaşması için her maaş döneminde ne kadar tutulması gerektiğini hesaplar.';

  @override
  String get goalsNew => 'Yeni hedef';

  @override
  String get goalsNewSub => 'Para ayırdığınız bir şey';

  @override
  String get goalsAddMoney => 'Para ekle';

  @override
  String goalsAddTo(String name) {
    return '$name hedefine ekle';
  }

  @override
  String get goalsAddBlurb =>
      'Bu, ne kadar ayırdığınızı kaydeder. Hiçbir şey harcanmaz — bundan sonra tutulması gereken tutarı düşürür.';

  @override
  String get goalsEachPeriod => 'Her maaş dönemi';

  @override
  String get goalsTargetDate => 'Hedef tarih';

  @override
  String goalsOf(String amount) {
    return '/ $amount';
  }

  @override
  String goalsPeriodsToGo(int count) {
    return '$count maaş dönemi kaldı';
  }

  @override
  String get goalsDone => 'Tamamen biriktirildi';

  @override
  String get goalsPausedStatus => 'Duraklatıldı — hiçbir şey tutulmuyor';

  @override
  String get goalsFlexibleStatus =>
      'Esnek — ödemeniz gereken her şeye yol verir';

  @override
  String get goalEditNew => 'Ne için biriktiriyorsunuz?';

  @override
  String get goalEditExisting => 'Hedefi düzenle';

  @override
  String get goalName => 'Ad';

  @override
  String get goalNameHint => 'Bir gezi, bir depozito, bir dizüstü';

  @override
  String get goalTotal => 'Toplam ne kadar';

  @override
  String get goalByWhen => 'Ne zamana kadar';

  @override
  String goalMonths(int count) {
    return '$count ay';
  }

  @override
  String get goalOneYear => '1 yıl';

  @override
  String get goalTwoYears => '2 yıl';

  @override
  String get goalFirmness => 'Ne kadar kesin?';

  @override
  String get goalKindHard => 'Kesin';

  @override
  String get goalKindHardSub => 'Harcanabilir hale gelmeden önce tutulur';

  @override
  String get goalKindFlexible => 'Esnek';

  @override
  String get goalKindFlexibleSub => 'Ödemeniz gereken her şeye yol verir';

  @override
  String get goalKindPaused => 'Duraklatıldı';

  @override
  String get goalKindPausedSub => 'Görünür kalır, hiçbir şey tutulmaz';

  @override
  String get goalSaveChanges => 'Değişiklikleri kaydet';

  @override
  String get goalAddThis => 'Bu hedefi ekle';

  @override
  String get goalDelete => 'Bu hedefi sil';

  @override
  String get activityTitle => 'Hareketler';

  @override
  String get activityBlurb => 'Kaydettiğiniz her şey, en yenisi önce.';

  @override
  String get activityEmpty =>
      'Bir harcama kaydettiğinizde burada görünür; yanlış girdiyseniz kaldırabilirsiniz.';

  @override
  String get activityRemoveIt => 'Kaldır';

  @override
  String get activityKeepIt => 'Kalsın';

  @override
  String get activitySpent => 'Harcama';

  @override
  String get activityIncome => 'Maaş';

  @override
  String get activityCorrection => 'Düzeltme';

  @override
  String get activityRemoved => 'Kaldırıldı';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileConfirmBalance => 'Bakiyenizi onaylayın';

  @override
  String get profileTrustTitle => 'Bu sayıya ne kadar güvenilir?';

  @override
  String get profileTrustFresh => 'Güncel. Dikkatinizi bekleyen bir şey yok.';

  @override
  String get profileTrustDegraded =>
      'Bakiyeniz bir süredir onaylanmadı. Sayı hâlâ gösteriliyor, yalnızca daha az kesin.';

  @override
  String get profileTrustReview =>
      'Güvenilmeyecek kadar eski veya belirsiz. Düzeltmek için bakiyenizi onaylayın.';

  @override
  String get profileConfirmedNever => 'Henüz onaylanmadı';

  @override
  String get profileConfirmedToday => 'Bugün onaylandı';

  @override
  String get profileConfirmedYesterday => 'Dün onaylandı';

  @override
  String profileConfirmedDays(int count) {
    return '$count gün önce onaylandı';
  }

  @override
  String get profileAppearance => 'Görünüm';

  @override
  String get profileTheme => 'Tema';

  @override
  String get profileThemeBlurb =>
      'Varsayılan, telefonunuzu izlemektir; hiçbir şey dayatılmaz.';

  @override
  String get themePhone => 'Telefon';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get profileLanguage => 'Dil';

  @override
  String get profileLanguageBlurb =>
      'Varsayılan, telefonunuzu izlemektir; hiçbir şey dayatılmaz.';

  @override
  String get languagePhone => 'Telefon';

  @override
  String get profileCurrency => 'Para birimi';

  @override
  String currencyChangeTitle(String currency) {
    return '$currency para birimine geçilsin mi?';
  }

  @override
  String currencyChangeBlurb(String currency) {
    return 'Planınızdaki her tutar sayısını korur ve bundan sonra $currency olarak gösterilir. Hiçbir şey döviz kuruyla çevrilmez; bunu para birimini düzeltmek için kullanın, paranızı çevirmek için değil.';
  }

  @override
  String get currencyChangeConfirm => 'Geç';

  @override
  String get profileYourData => 'Verileriniz';

  @override
  String get profileDelete => 'Planımı sil';

  @override
  String get profileDeleteSub => 'Her şeyi temizler ve kuruluma döner';

  @override
  String get profileStartOver => 'Baştan başlansın mı?';

  @override
  String get profileStartOverBlurb =>
      'Planınız ve kaydettiğiniz her şey silinir. Bu geri alınamaz.';

  @override
  String get profileDeleteEverything => 'Her şeyi sil';

  @override
  String get profileKeepPlan => 'Planım kalsın';

  @override
  String get save => 'Kaydet';

  @override
  String get cancel => 'İptal';

  @override
  String activityRemoveAmount(String amount) {
    return '$amount kaldırılsın mı?';
  }

  @override
  String get activityRemoveDetail =>
      'Planınıza saymayı hemen bırakır. Kayıt bu listede kaldırıldı işaretiyle kalır, böylece geçmişiniz eksiksiz olur.';

  @override
  String get activityCardPurchase => 'Kartla alışveriş';

  @override
  String get activityCardPayment => 'Kart ödemesi';

  @override
  String get activityRefund => 'İade';

  @override
  String get activityTransfer => 'Hesaplar arası aktarım';

  @override
  String get activityLoan => 'Alınan kredi';

  @override
  String get activityDebtPayment => 'Borç ödemesi';

  @override
  String get activityBalanceCorrected => 'Bakiye düzeltmesi';

  @override
  String get activityBlurbEmpty => 'Henüz bir şey kaydedilmedi.';

  @override
  String get profileStartAgain => 'Yeniden başla';

  @override
  String get claimRent => 'Kira ve faturalar';

  @override
  String get claimCardMinimum => 'Kart asgari ödemesi';

  @override
  String get claimEssentials => 'Yemek ve ulaşım';

  @override
  String get claimBuffer => 'Acil durum rezervi';

  @override
  String get languageTitle => 'Hangi dil?';

  @override
  String get languageBlurb => 'Bunu sonra Profil’den değiştirebilirsiniz.';

  @override
  String get profileLedgerTitle => 'Kayıt eksiksiz mi?';

  @override
  String get ledgerComplete => 'Harcadığınız her şey kayıtlı.';

  @override
  String get ledgerPartial =>
      'Bazı harcamalar ancak bakiyenizi onayladığınızda ortaya çıktı.';

  @override
  String get ledgerUnknown =>
      'Upino ne kadarının eksik olduğunu bilemiyor. Öğrenmek için bakiyenizi onaylayın.';

  @override
  String get askTitle => 'Harcamadan önce sor';

  @override
  String get askBlurb =>
      'Bir alışverişi planınıza karşı deneyin. Hiçbir şey kaydedilmez, hiçbir şey değişmez.';

  @override
  String get askAmountLabel => 'Ne kadar tutar?';

  @override
  String get askRun => 'Ne yapacağını gör';

  @override
  String get askDoNotBuy => 'Almamak';

  @override
  String get askBuyNow => 'Bugün al';

  @override
  String askBuyAfter(String date) {
    return '$date tarihinden sonra al';
  }

  @override
  String get askUnchanged => 'Planınız olduğu gibi kalır.';

  @override
  String get askStsAfter => 'Sonrasında harcayabileceğiniz';

  @override
  String get askBreaks => 'Bu, ödemeniz gereken bir şeyi karşılıksız bırakır.';

  @override
  String get askSafe => 'Ödemeniz gereken hiçbir şey karşılıksız kalmıyor.';

  @override
  String get askCosts => 'Ne azalıyor';

  @override
  String askCostLine(String label, String amount) {
    return '$label · $amount daha az';
  }

  @override
  String get askWaitingHelps =>
      'Maaşınız gelene kadar beklemek her şeyi karşılıyor.';

  @override
  String get askNoIncome =>
      'Henüz beklenen bir maaş yok, bu yüzden karşılaştırılacak ileri bir an yok.';

  @override
  String askAssumption(String date) {
    return 'Maaşınızın $date tarihinde beklendiği gibi geleceği varsayılır.';
  }

  @override
  String get askNoVerdict => 'Upino evet ya da hayır demez. Karar sizin.';

  @override
  String get receipt => 'Fiş';

  @override
  String get receiptAdd => 'Fiş ekle';

  @override
  String get receiptCamera => 'Fotoğraf çek';

  @override
  String get receiptGallery => 'Fotoğraf seç';

  @override
  String get receiptAttached => 'Fiş eklendi';

  @override
  String get receiptRemove => 'Fotoğrafı kaldır';

  @override
  String get onboardingIncomeFrom => 'En az';

  @override
  String get onboardingIncomeTo => 'En çok';

  @override
  String get onboardingIncomeToOptional => 'İsteğe bağlı';

  @override
  String incomeRange(String low, String high) {
    return '$low – $high';
  }

  @override
  String incomeRangeNote(String low) {
    return 'Planınız $low üzerine kurulu. Üstü, geldiğinde sizindir.';
  }

  @override
  String get categoryFood => 'Yemek';

  @override
  String get categoryTransport => 'Ulaşım';

  @override
  String get categoryBills => 'Faturalar';

  @override
  String get categoryShopping => 'Alışveriş';

  @override
  String get categoryHealth => 'Sağlık';

  @override
  String get categoryFun => 'Eğlence';

  @override
  String get categoryOther => 'Diğer';

  @override
  String get categoryUnsorted => 'Sınıflanmamış';

  @override
  String get categoryPrompt => 'Ne içindi?';

  @override
  String get spendingTitle => 'Para nereye gitti';

  @override
  String get spendingWindow => 'Son 30 günde kaydedilen harcamalar';

  @override
  String get backupSection => 'Yedek';

  @override
  String get backupSave => 'Yedek kaydet';

  @override
  String get backupSaveSub =>
      'Parolayla kilitlenir. Bulut depolama gibi güvenli bir yere gönderin.';

  @override
  String get backupRestore => 'Yedekten geri yükle';

  @override
  String get backupRestoreSub => 'Bu telefondaki planın yerini alır';

  @override
  String get backupPassword => 'Parola';

  @override
  String get backupPasswordRepeat => 'Parolayı tekrarlayın';

  @override
  String get backupPasswordSaveBlurb =>
      'Geri yüklemek için bu parola gerekir. Unutursanız kurtarılamaz. Fiş fotoğrafları dahil değildir.';

  @override
  String get backupPasswordOpenBlurb => 'Bu yedeğin kaydedildiği parola.';

  @override
  String get backupPasswordShort => 'En az 6 karakter';

  @override
  String get backupPasswordMismatch => 'İkisi eşleşmiyor';

  @override
  String get backupOpen => 'Aç';

  @override
  String get backupReplaceTitle => 'Bu plan değiştirilsin mi?';

  @override
  String get backupReplaceBlurb =>
      'Bu telefondaki her şey yedektekiyle değiştirilir. Geri alınamaz.';

  @override
  String get backupReplace => 'Değiştir';

  @override
  String get backupRestored => 'Yedek geri yüklendi';

  @override
  String get backupWrongPassword => 'Bu parola yedeği açmıyor.';

  @override
  String get backupNotABackup => 'Bu dosya bir Upino yedeği değil.';

  @override
  String get backupUnreadable =>
      'Bu yedek Upino\'nun daha yeni bir sürümüyle yapılmış. Uygulamayı güncelleyip tekrar deneyin.';

  @override
  String get inflationTitle => 'Enflasyon';

  @override
  String get inflationNotSet =>
      'Ayarlanmadı. Hedeflerin gerçek maliyetini görmek için yıllık oranı girin.';

  @override
  String inflationRate(String rate) {
    return 'Yıllık %$rate';
  }

  @override
  String get inflationDialogTitle => 'Yıllık enflasyon';

  @override
  String get inflationDialogBlurb =>
      'Fiyatlar artar; bugünün parasıyla belirlenen hedef vadesinde daha pahalıya gelir. Beklediğiniz oranı girin; kapatmak için boş bırakın.';

  @override
  String goalsInflated(String rate, String amount) {
    return 'Yıllık %$rate ile, o zamana kadar yaklaşık $amount tutacak.';
  }

  @override
  String get holdingsTitle => 'Diğer birikimler';

  @override
  String get holdingsBlurb =>
      'Dolar, altın, sikke. Planın yanında gösterilir, harcanabilir paraya asla katılmaz.';

  @override
  String get holdingsAdd => 'Birikim ekle';

  @override
  String get holdingsAddSub => 'Harcanabilir paraya katılmaz';

  @override
  String get holdingsTotal => 'Toplam';

  @override
  String holdingSummary(String quantity, String price, String date) {
    return '$quantity × $price · fiyat $date';
  }

  @override
  String get holdingEditNew => 'Yeni birikim';

  @override
  String get holdingEditExisting => 'Birikimi değiştir';

  @override
  String get holdingName => 'Nedir?';

  @override
  String get holdingNameHint => 'Dolar, altın…';

  @override
  String get holdingUsd => 'Dolar';

  @override
  String get holdingEur => 'Euro';

  @override
  String get holdingGold => 'Altın (gram)';

  @override
  String get holdingCoin => 'Altın sikke';

  @override
  String get holdingQuantity => 'Ne kadar';

  @override
  String get holdingUnitPrice => 'Bugün bir tanesinin değeri';

  @override
  String holdingWorth(String amount) {
    return 'Toplam değeri $amount';
  }

  @override
  String get holdingDelete => 'Bu birikimi kaldır';

  @override
  String get fasterTitle => 'Daha hızlı kayıt';

  @override
  String get smsTitle => 'Banka mesajlarını oku';

  @override
  String get smsDetail =>
      'Bankanın mesajla bildirdiği harcamalar tek dokunuşla kaydetmeniz için önerilir. Mesajlar yalnızca bu telefonda okunur, hiçbir yere gönderilmez.';

  @override
  String get smsDenied =>
      'Upino\'nun mesajları okumasına izin verilmedi. Telefon ayarlarından izin verebilirsiniz.';

  @override
  String smsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'İncelenecek $count banka mesajı',
    );
    return '$_temp0';
  }

  @override
  String get smsWaitingSub => 'Her birini tek dokunuşla kaydedin ya da geçin';

  @override
  String get smsReviewTitle => 'Bankanızdan';

  @override
  String get smsReviewBlurb =>
      'Kaydet\'e dokunana kadar hiçbir şey kaydedilmez. Tutarı mesajla karşılaştırın.';

  @override
  String get smsReviewDone => 'Hepsi tamam.';

  @override
  String get smsRecord => 'Kaydet';

  @override
  String get smsSkip => 'Geç';

  @override
  String get reminderTitleSetting => 'Akşam hatırlatıcısı';

  @override
  String get reminderDetail =>
      'Akşam 9\'da, yalnızca hiçbir şey kaydedilmeyen günlerde.';

  @override
  String get reminderDenied =>
      'Upino\'nun bildirim göstermesine izin verilmedi. Ayarlardan izin verebilirsiniz.';

  @override
  String get reminderTitle => 'Bugün harcama yaptınız mı?';

  @override
  String get reminderBody =>
      'Yarının rakamı doğru olsun diye birkaç saniyede kaydedin.';

  @override
  String get reminderChannel => 'Akşam hatırlatıcısı';

  @override
  String get widgetSpend => '+ Harcama';

  @override
  String get widgetAdd => 'Ana ekrana ekle';

  @override
  String get widgetAddSub =>
      'Uygulamayı açmadan harcayabileceğiniz tutar ve kayıt düğmesi';

  @override
  String get voiceListening =>
      'Dinleniyor… tutarı ve ne için olduğunu söyleyin.';

  @override
  String voiceHeard(String text) {
    return 'Duyulan: “$text”. Tutarı kontrol edip kaydedin.';
  }

  @override
  String get voiceNothing => 'Tutar duyulmadı. Tekrar deneyin ya da yazın.';

  @override
  String get voicePrivacy =>
      'Telefonunuz konuşmayı metne çevirir. Çevrimdışı tanıma yoksa bu, telefonun konuşma hizmetinden geçer.';

  @override
  String get voiceButton => 'Söyle';

  @override
  String get voiceUnavailable =>
      'Bu telefonda uygulamanın kullanabileceği konuşma tanıma yok. Tutarı yazın.';

  @override
  String get voiceNoPermission =>
      'Upino\'nun mikrofonu kullanmasına izin verilmedi. Ayarlardan izin verebilirsiniz.';

  @override
  String get voiceNetwork =>
      'Bu telefondaki konuşma tanıma internete ihtiyaç duyuyor ve bağlanamadı.';

  @override
  String voiceNoAmount(String text) {
    return '“$text” duyuldu ama tutar yok. Tekrar deneyin ya da yazın.';
  }

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get navAsk => 'Sor';

  @override
  String get alertsTitle => 'İlgi bekliyor';

  @override
  String get alertsEmpty => 'Şu an ilgi bekleyen bir şey yok. Plan güncel.';

  @override
  String alertUnfunded(String label, String amount) {
    return '$label için $amount eksik';
  }

  @override
  String get alertUnfundedDetail =>
      'Ödemeniz gereken bir şey eldekiyle karşılanmıyor.';

  @override
  String alertIncomeLate(String date) {
    return 'Maaşınız $date tarihinde bekleniyordu';
  }

  @override
  String get alertIncomeLateDetail =>
      'Gelene kadar sayılmaz. Tarih değiştiyse Plan\'dan güncelleyin.';

  @override
  String alertGoalBehind(String name, String amount) {
    return '$name bu dönem $amount geride';
  }

  @override
  String get alertGoalBehindDetail => 'Eldeki para bu dönemin payına yetmiyor.';

  @override
  String get chatHint => 'Ne istersen sor ya da fiyat yaz';

  @override
  String get chatSuggestSafe => 'Ne kadar harcayabilirim?';

  @override
  String get chatSuggestPay => 'Sonraki maaş ne zaman?';

  @override
  String get chatSuggestWhere => 'Param nereye gitti?';

  @override
  String get chatSuggestAside => 'Ne ayrıldı?';

  @override
  String chatSafe(String amount, String date) {
    return '$date tarihine kadar $amount harcayabilirsin.';
  }

  @override
  String get chatSafeStale =>
      'Bir şey: bakiyenin onaylanması gerekiyor, bunu tahmin olarak gör.';

  @override
  String chatPay(String amount, String date) {
    return 'Sonraki maaşın $amount, $date tarihinde bekleniyor.';
  }

  @override
  String get chatPayNone =>
      'Sonraki maaşını henüz bilmiyorum. Plan\'a ekle, takip edeyim.';

  @override
  String get chatWhere => 'Son 30 günde para buraya gitti:';

  @override
  String get chatWhereNone =>
      'Son 30 günde harcama yok. Ya sakin bir aydı ya da kaydedilmedi.';

  @override
  String chatAside(String amount) {
    return 'Harcanabilir sayılmadan önce $amount ayrıldı:';
  }

  @override
  String chatPurchase(String amount) {
    return 'Bakalım $amount ne yapar.';
  }

  @override
  String get chatHelp =>
      'Hmm, tam anlayamadım. Ne kadar harcayabileceğini, maaşın ne zaman geleceğini, paranın nereye gittiğini, ne ayrıldığını ya da nasıl daha az harcayacağını söyleyebilirim. Ya da bir fiyat yaz, almanın etkisini göstereyim.';

  @override
  String get chatHelloNew =>
      'Merhaba! Ben Upino. Yenisin, o yüzden şimdilik sadece temel şeyleri biliyorum: bakiyeni, maaşını ve ayırdıklarını. Bu kadarı bile ne kadar harcayabileceğini ve bir alışverişin etkisini söylemeye yeter. Harcamalarını kaydetmeye devam et; yaklaşık bir mevsim sonra alışkanlıklarını kişisel danışmanın olacak kadar tanırım.';

  @override
  String chatHelloLearning(int days, int spends, int remaining) {
    return 'Tekrar hoş geldin! Şimdiye kadar $days gün ve $spends harcamadan öğrendim. Yaklaşık $remaining gün sonra elimde tam bir mevsim olacak.';
  }

  @override
  String chatHelloFamiliar(int days) {
    return 'Tekrar hoş geldin! Paranın $days gününü gördüm; ne istersen sor, daha az harcamayı bile.';
  }

  @override
  String chatHelloAlerts(int count) {
    return 'Bu arada, seni bekleyen $count şey var: zilin altında.';
  }

  @override
  String chatPurchaseFits(String left) {
    return 'Bugün alırsan ödemen gereken her şey karşılanır ve hâlâ $left artar.';
  }

  @override
  String chatPurchaseWait(String date) {
    return 'Bugün alırsan ödemen gereken bir şey açıkta kalır. $date tarihine kadar beklersen her şey karşılanır.';
  }

  @override
  String chatPurchaseStillShort(String date) {
    return 'Dikkat: $date maaşından sonra bile ödemen gereken bir şey açıkta kalır.';
  }

  @override
  String get chatPurchaseShort =>
      'Bugün alırsan ödemen gereken bir şey açıkta kalır.';

  @override
  String chatSafeNothing(String date) {
    return 'Şu an $date tarihine kadar boşta para yok: elindeki her şey ödemelere ayrılmış.';
  }

  @override
  String chatPayIn(int days) {
    return 'Yani $days gün sonra.';
  }

  @override
  String get chatPayLate => 'Gecikti, geldiğini onaylayana kadar sayılmıyor.';

  @override
  String get chatPayRange =>
      'Plan alt sınıra göre hesaplar; iyi bir ay ikramiyedir, açık değil.';

  @override
  String chatWhereSoFar(int days) {
    return 'Şimdiye kadar sadece $days gün gördüm, yani bu ilk bakış:';
  }

  @override
  String chatWhereTop(String category, int share) {
    return 'En büyüğü $category: toplamın %$share\'i.';
  }

  @override
  String get chatWhereTooSoon =>
      'Bunun için biraz erken: henüz neredeyse hiç harcama görmedim. Birkaç tane kaydet, gelecek hafta tekrar sor.';

  @override
  String get chatAdviceTooSoon =>
      'Yardım etmeyi çok isterim ama açıkçası harcamalarını henüz yeterince tanımıyorum; onsuz tavsiye sadece tahmin olur. Harcamalarını kaydet (kategori vermek çok işe yarar), birkaç hafta sonra tekrar sor.';

  @override
  String chatAdviceBiggest(String category, String amount, String tenth) {
    return 'Son 30 günde en büyük harcaman $category: $amount. Onda birini kısarsan ayda yaklaşık $tenth açılır.';
  }

  @override
  String get chatAdviceSort =>
      'Ne kadar harcadığını görüyorum ama neye harcadığını değil. Kaydederken kategori ver, nereden kısacağını söyleyeyim.';

  @override
  String chatAdviceMore(String amount) {
    return 'Önceki aya göre $amount fazla harcadın.';
  }

  @override
  String chatAdviceLess(String amount) {
    return 'Güzel: önceki aydan $amount az.';
  }

  @override
  String get chatAdviceLearning =>
      'Alışkanlıklarını hâlâ öğreniyorum, bunu tam tablo değil ilk ipucu olarak gör.';

  @override
  String get chatSmallHello => 'Merhaba! Paranla ilgili ne öğrenmek istersin?';

  @override
  String get chatSmallThanks =>
      'Ne zaman istersen! Harcamadan önce hep buradayım.';

  @override
  String get chatSmallWho =>
      'Ben Upino\'nun asistanıyım. Sadece planındakileri bilirim ve verdiğim her rakam doğrudan oradan gelir; hiçbir şey bu telefondan çıkmaz. Evet ya da hayır demem ama her seçeneğin sana ne bırakacağını gösteririm.';

  @override
  String get chatSuggestAdvice => 'Nasıl daha az harcarım?';

  @override
  String get chatTitle => 'Upino';

  @override
  String get chatNew => 'Yeni sohbet';

  @override
  String get chatResumed =>
      'Buradaki yanıtlar planının bugünkü haline göre hesaplandı.';

  @override
  String get chatWhy => 'Rakam şöyle çıkıyor:';

  @override
  String get chatWhyHave => 'Elindeki';

  @override
  String get chatWhySetAside => 'Önce ayrılan';

  @override
  String get chatWhyLeft => 'Harcanabilir';

  @override
  String get chatSmallHowAreYou =>
      'İyiyim, sorduğun için teşekkürler! Paran bıraktığımız yerde. Ne öğrenmek istersin?';

  @override
  String get chatSmallBye =>
      'Görüşürüz! Bir sonraki büyük harcamadan önce uğra.';

  @override
  String get chatSmallOkay => 'Bakmak istediğin başka bir şey var mı?';

  @override
  String get askHubTitle => 'Upino ile konuş';

  @override
  String get askHubNew =>
      'Ne kadar harcayabileceğini, bir alışverişin etkisini ya da maaşın ne zaman geleceğini sor. Seni hâlâ tanıyorum; ne kadar kaydedersen o kadar işe yararım.';

  @override
  String askHubLearning(int days) {
    return 'Alışkanlıklarını öğreniyorum: yaklaşık $days gün sonra tavsiye için tam bir mevsimim olacak.';
  }

  @override
  String get askHubFamiliar =>
      'Artık paranı iyi tanıyorum. Ne istersen sor, daha az harcamayı bile.';

  @override
  String get askHubStart => 'Sohbete başla';

  @override
  String get askHubCommon => 'Sık sorulanlar';

  @override
  String get askHubHistory => 'Sohbetlerin';

  @override
  String askHubTurns(int count) {
    return '$count soru';
  }

  @override
  String askHubAsidePreview(String amount, int count) {
    return '$count yükümlülük için $amount ayrıldı';
  }

  @override
  String get askHubDeleteTitle => 'Bu sohbet silinsin mi?';

  @override
  String get askHubDeleteBlurb =>
      'Sadece sohbet silinir. Planında bir şey değişmez.';

  @override
  String get chatSmallHi => 'Merhaba!';

  @override
  String get chatSmallHiFine => 'Merhaba! İyiyim, teşekkürler.';

  @override
  String chatSafeLasts(int days) {
    return 'Bu, maaşa kadar $days gün yetmeli.';
  }

  @override
  String homeSpokenFor(String amount, String date) {
    return '$date tarihine kadar paranızın $amount kadarı zaten ayrılmış durumda.';
  }

  @override
  String askGoalLater(String goal, int days) {
    return '$goal · yaklaşık $days gün sonra';
  }

  @override
  String get askGoalsTitle => 'Hedefler gecikir';

  @override
  String get askGoalsNote =>
      'Yaklaşık olarak, her hedef için biriktirilen hızla.';

  @override
  String chatPurchaseGoal(String goal, int days) {
    return 'Bu, $goal hedefini yaklaşık $days gün geciktirir.';
  }

  @override
  String get monthTitle => 'Ayınız';

  @override
  String get monthWindow => 'Son 30 gün, önceki 30 güne karşı';

  @override
  String monthTooSoon(int days) {
    return 'Ay özeti için bir aylık harcama gerekir. Sizinki $days gün içinde hazır olur.';
  }

  @override
  String monthSpent(String amount) {
    return 'Son 30 günde $amount harcandı.';
  }

  @override
  String get monthNothing => 'Son 30 günde hiçbir şey kaydedilmedi.';

  @override
  String monthMore(String amount) {
    return 'Bu, önceki 30 günden $amount fazla.';
  }

  @override
  String monthLess(String amount) {
    return 'Bu, önceki 30 günden $amount az.';
  }

  @override
  String get monthSame => 'Önceki 30 günle hemen hemen aynı.';

  @override
  String monthUp(String category, String amount) {
    return 'En çok artan: $category, $amount.';
  }

  @override
  String monthDown(String category, String amount) {
    return 'En çok azalan: $category, $amount.';
  }

  @override
  String monthGoals(int onTrack, int total) {
    return 'Yolunda giden hedefler: $total hedefin $onTrack tanesi.';
  }

  @override
  String get chatSuggestMonth => 'Ayım nasıl geçti?';

  @override
  String get timelineTitle => 'Önümüzdeki günlerde paranız';

  @override
  String get timelineToday => 'Bugün';

  @override
  String get timelineNow => 'Şimdi';

  @override
  String get timelineProjected => 'Tahmin';

  @override
  String get timelineRecorded => 'Kayıtlı';

  @override
  String get timelineFree => 'Harcanabilir';

  @override
  String get timelineHad => 'Paranız';

  @override
  String timelineBalance(String amount) {
    return 'Bakiye $amount';
  }

  @override
  String timelineSetAside(String amount) {
    return 'Ayrılan $amount';
  }

  @override
  String timelinePayMark(String amount) {
    return 'Maaş $amount';
  }

  @override
  String timelineShort(String amount) {
    return 'Zorunlu bir ödeme için $amount eksik';
  }

  @override
  String timelineWithout(String amount) {
    return 'Onsuz: $amount';
  }

  @override
  String get timelineBuyAfterPay => 'Maaştan sonra al';

  @override
  String get timelineBalanceLegend => 'Bakiye';

  @override
  String get timelineWithPurchase => 'Alışverişle';

  @override
  String get timelinePay => 'Maaş günü';

  @override
  String get timelineAssumptions =>
      'İleriye dönük kısım bir tahmindir: maaş kendi tarihinde, faturalar kendi tarihlerinde, yaşam için ayrılan para eşit harcanır ve başka bir şey yok. Herhangi bir günü görmek için grafikte kaydırın.';

  @override
  String get timelineSemantics =>
      'Bakiyenizin ve harcanabilir tutarın günlük grafiği';

  @override
  String goalChartSemantics(String goal) {
    return '$goal hedefine nasıl ulaşır grafiği';
  }

  @override
  String goalChartTarget(String amount, String date) {
    return '$date tarihine kadar hedef $amount';
  }

  @override
  String goalPaceLabel(String amount) {
    return 'Her maaş döneminde ayır: $amount';
  }

  @override
  String goalOnTrack(String date) {
    return 'Yolunda: $date tarihinde ulaşılır.';
  }

  @override
  String goalLate(String date, int days) {
    return 'Bu hızla $date tarihinde, hedef tarihinden $days gün sonra ulaşılır.';
  }

  @override
  String get goalNotMoving =>
      'Şu an bu hedefe hiçbir şey gitmiyor, bu yüzden yaklaşmıyor.';

  @override
  String goalUsePace(String date) {
    return 'Hedef tarihini $date yap';
  }

  @override
  String get goalPaceNote =>
      'Sadece bir deneme: siz seçene kadar hiçbir şey değişmez.';

  @override
  String get goalShowPath => 'Nasıl ulaşacağını gör';

  @override
  String get goalHidePath => 'Gizle';

  @override
  String get billsTitle => 'Faturalar ve abonelikler';

  @override
  String get billAdd => 'Fatura veya abonelik ekle';

  @override
  String get billAddSub =>
      'Telefon, internet, sigorta, yayın… her biri tarihinden önce ayrılır.';

  @override
  String get billEditNew => 'Yeni fatura';

  @override
  String get billEditExisting => 'Faturayı değiştir';

  @override
  String get billName => 'Bu ne?';

  @override
  String get billNameHint => 'ör. İnternet';

  @override
  String get billAmount => 'Her ödeme';

  @override
  String get billEvery => 'Ne sıklıkla';

  @override
  String get billEveryWeek => 'Haftalık';

  @override
  String get billEveryMonth => 'Aylık';

  @override
  String get billEveryQuarter => '3 aylık';

  @override
  String get billEveryYear => 'Yıllık';

  @override
  String get billNext => 'Sonraki ödeme';

  @override
  String get billKind => 'Türü';

  @override
  String get billKindBill => 'Fatura';

  @override
  String get billKindSubscription => 'Abonelik';

  @override
  String get billRepays => 'Öder';

  @override
  String get billRepaysNothing => 'Hiçbir şey, bir gider';

  @override
  String get billAddThis => 'Faturayı ekle';

  @override
  String get billDelete => 'Faturayı sil';

  @override
  String billRow(String every, String date) {
    return '$every · sonraki $date';
  }

  @override
  String billOverdue(String date) {
    return '$date tarihinde vadesi geçti';
  }

  @override
  String get billPay => 'Ödendi olarak işaretle';

  @override
  String get billEdit => 'Değiştir';

  @override
  String get dayToday => 'Bugün';

  @override
  String dayIn(int days) {
    return '$days gün sonra';
  }

  @override
  String dayAgo(int days) {
    return '$days gün önce';
  }

  @override
  String get homeComingUp => 'Yaklaşanlar';

  @override
  String homeComingUpTotal(String amount) {
    return 'Önümüzdeki 30 günde $amount fatura ödenecek.';
  }

  @override
  String payDueTitle(String date) {
    return 'Maaşınız $date tarihinde bekleniyordu. Geldi mi?';
  }

  @override
  String get payDueSub =>
      'Ne kadar geldiğini söyleyin; sonraki maaş bir dönem sonra beklenir.';

  @override
  String get payArrived => 'Geldi';

  @override
  String get payArrivedTitle => 'Ne kadar geldi?';

  @override
  String get planRecordPay => 'Maaş geldi';

  @override
  String get planRecordPaySub => 'Kaydedin, sonraki bir dönem ilerler';

  @override
  String get accountsTitle => 'Hesaplar';

  @override
  String get accountMain => 'Ana hesap';

  @override
  String get accountKindBank => 'Banka hesabı';

  @override
  String get accountKindCash => 'Nakit';

  @override
  String get accountKindSavings => 'Birikim';

  @override
  String get accountKindCard => 'Kredi kartı';

  @override
  String get accountKindLoan => 'Kredi';

  @override
  String get accountAdd => 'Hesap ekle';

  @override
  String get accountAddSub =>
      'Nakit, birikim, kart veya kredi. Banka bağlantısı gerekmez.';

  @override
  String get accountEditNew => 'Yeni hesap';

  @override
  String get accountNameHint => 'ör. Cüzdan';

  @override
  String get accountHolds => 'Şu an içindeki';

  @override
  String get accountOwes => 'Şu anki borç';

  @override
  String get accountCounted => 'Plana dahil et';

  @override
  String get accountCountedSub => 'Bu para bu ay harcanabilir.';

  @override
  String accountOwed(String amount) {
    return 'Borç $amount';
  }

  @override
  String get accountNotCounted => 'Plana dahil değil';

  @override
  String get accountConfirm => 'Gerçek bakiyeyi gir';

  @override
  String get accountMove => 'Para aktar';

  @override
  String accountMoveTo(String name) {
    return '$name hesabına aktar';
  }

  @override
  String get accountMoveBlurb =>
      'Kendi hesaplarınız arasında aktarım ne harcama ne gelirdir.';

  @override
  String get accountPayCard => 'Bir kısmını öde';

  @override
  String get accountPayBlurb =>
      'Ana hesaptan ödenir. Borcu kapatır; ikinci bir harcama değildir.';

  @override
  String get accountRemove => 'Bu hesabı kaldır';

  @override
  String get accountInUse =>
      'Geçmişi olduğu için kalır. Bunun yerine plandan çıkarabilirsiniz.';

  @override
  String get paidFrom => 'Ödeme kaynağı';

  @override
  String get categorySuggested =>
      'Geçmiş harcamalarınıza göre önerildi. Değiştirmek için başkasına dokunun.';

  @override
  String get recoverTitle => 'Geri gelecek para';

  @override
  String recoverTotal(String amount) {
    return '$amount geri gelebilir. Gelene kadar sayılmaz.';
  }

  @override
  String get recoverReturnable => 'İade edilebilir';

  @override
  String get recoverExpect => 'İade edildi, geri ödeme bekleniyor';

  @override
  String get recoverArrived => 'Geri ödeme geldi';

  @override
  String get recoverKept => 'Tuttum';

  @override
  String get recoverPending => 'Geri ödeme yolda';

  @override
  String get recoverRefunded => 'İade edildi';

  @override
  String get recoverPrompt => 'Parayı geri alma';

  @override
  String recoverWhere(String amount) {
    return '$amount geri geldi. Nereye gitsin?';
  }

  @override
  String recoverToGoal(String goal) {
    return '$goal için';
  }

  @override
  String get recoverToBuffer => 'Acil durum tamponuna';

  @override
  String get recoverLeave => 'Harcanabilir kalsın';

  @override
  String get accountStopCounting => 'Plandan çıkar';

  @override
  String get moveTitle => 'En iyi adım';

  @override
  String get moveTagMove => 'Aktar';

  @override
  String get moveTagWait => 'Bekle';

  @override
  String get moveTagSave => 'Biriktir';

  @override
  String get moveTagSpend => 'Harca';

  @override
  String moveMove(String amount, String account) {
    return 'Zorunlu ödemeyi karşılamak için $account hesabından $amount aktarın.';
  }

  @override
  String moveMoveWhy(String claim) {
    return '$claim için eksik var ve bu para planın dışında duruyor.';
  }

  @override
  String get moveDoIt => 'Aktar';

  @override
  String moveWaitGap(String date, String amount) {
    return 'Ekstralara ara verin: $date tarihinde zorunlu bir ödeme için $amount eksik kalır.';
  }

  @override
  String get moveWaitGapWhy =>
      'Tahmin o güne kadar maaşınızı, faturaları ve yaşam giderlerini sayar.';

  @override
  String moveWaitPay(int days, String now, String later) {
    return 'Maaşınıza $days gün var. Beklemek $now olan payı $later yapar.';
  }

  @override
  String get moveWaitPayWhy =>
      'Aklınızdaki şey bekleyebilirse. Her iki durumda da risk yok.';

  @override
  String moveSave(String amount, String account, String goal) {
    return '$goal için $amount tutarını $account hesabına aktarın.';
  }

  @override
  String moveSaveWhy(int days) {
    return 'Hedefe yaklaşık $days gün önce ulaşılır ve serbest kalan para yine de normal ayınızın iki katıdır.';
  }

  @override
  String moveSpend(String amount, String date) {
    return '$date tarihine kadar güvendesiniz: $amount kullanmanız için serbest.';
  }

  @override
  String get moveSpendWhy =>
      'Faturalar ve hedefler zaten ayrıldı, ileride eksik yok ve bu normal harcamanızın epey üstünde.';

  @override
  String get moveNotNow => 'Şimdi değil';

  @override
  String get moveNone =>
      'Şu an önerilecek bir adım yok. Planınız olduğu gibi duruyor.';

  @override
  String monthIncome(String amount) {
    return 'Gelen maaş: $amount.';
  }

  @override
  String monthToGoals(String amount) {
    return 'Hedeflere ayrılan: $amount.';
  }

  @override
  String monthNow(String free, String aside) {
    return 'Şu an: $free harcanabilir, $aside ayrılmış.';
  }

  @override
  String get monthAheadTitle => 'Önümüzdeki 30 gün';

  @override
  String monthAheadBills(int count, String amount) {
    return '$count fatura, toplam $amount.';
  }

  @override
  String monthAheadPay(String date) {
    return 'Sonraki maaşınız $date tarihinde bekleniyor.';
  }

  @override
  String monthAheadTightest(String date, String amount) {
    return 'En sıkışık gün $date, $amount serbest.';
  }

  @override
  String monthAheadShort(String date, String amount) {
    return '$date tarihinde zorunlu bir ödeme için $amount eksik kalır.';
  }

  @override
  String get monthWorthKnowing => 'Bilmeye değer';

  @override
  String insightUp(String category, String amount) {
    return '$category önceki aya göre $amount arttı.';
  }

  @override
  String insightGoal(int days, String goal) {
    return 'Böyle sürerse, her ay $goal hedefinin yaklaşık $days günü eder.';
  }

  @override
  String get chatSuggestMove => 'Şimdi ne yapmalıyım?';

  @override
  String get chatSuggestComing => 'Hangi faturalar yaklaşıyor?';

  @override
  String get chatComingNone =>
      'Önümüzdeki 30 günde fatura yok. Faturalarınızı Plan\'a ekleyin, takip edeyim.';

  @override
  String get quickAsk => 'Sor';

  @override
  String get quickPay => 'Maaş geldi';

  @override
  String get quickBills => 'Faturalar';

  @override
  String get quickMonth => 'Ayım';

  @override
  String get quickPayDue => 'Maaş zamanı geldi. Gelip gelmediğini söyleyin.';

  @override
  String get chartAvg => 'Ort.';

  @override
  String get flowsTitle => 'Giren ve çıkan para';

  @override
  String get flowsBlurb =>
      'Haftadan haftaya: maaş ve iadeler çizginin üstünde, harcama ve taksitler altında.';

  @override
  String flowsWeek(String date) {
    return '$date haftası';
  }

  @override
  String flowsInOut(String moneyIn, String moneyOut) {
    return 'Giren $moneyIn · Çıkan $moneyOut';
  }

  @override
  String get balanceHistoryTitle => 'Zaman içinde bakiyeniz';

  @override
  String rangeMonths(int count) {
    return '$count ay';
  }

  @override
  String get rangeYear => '1 yıl';

  @override
  String get weekSpentTitle => 'Son 7 gün';

  @override
  String weekSpentTotal(String amount) {
    return '$amount harcandı';
  }

  @override
  String get payGaugeTitle => 'Sonraki maaşa kadar';

  @override
  String payGaugeDaysLabel(int days) {
    return 'gün kaldı';
  }

  @override
  String payGaugeAfter(String date, String amount) {
    return '$date maaşından sonra: $amount serbest';
  }

  @override
  String payGaugeLasts(String amount) {
    return '$amount o güne kadar yetmeli.';
  }

  @override
  String get goalsOverall => 'tüm hedeflerinizin';

  @override
  String goalsThisMonth(String amount) {
    return 'Bu ay +$amount';
  }

  @override
  String get goalsNothingThisMonth => 'Bu ay eklenen yok';

  @override
  String get goalsAllOnTrack => 'Hepsi yolunda';

  @override
  String goalsOnTrackCount(int onTrack, int total) {
    return '$total hedefin $onTrack tanesi yolunda';
  }

  @override
  String goalsNextUp(String goal, String date) {
    return 'Sıradaki: $goal, $date';
  }

  @override
  String get goalsTips => 'Daha erken ulaşmanın yolları';

  @override
  String get goalsTipsSub => 'Harcamalarınıza göre Upino\'ya sorun';

  @override
  String get goalsDetailTitle => 'Her hedef';

  @override
  String get demoTry => 'Örnek verilerle dene';

  @override
  String get demoTrySub =>
      'Dört hedef, faturalar ve üç aylık geçmiş; size ait olmayan ve kaydedilmeyen bir kopyada.';

  @override
  String get demoBanner =>
      'Örnek veri: buradaki hiçbir şey sizin değil ve kaydedilmez.';

  @override
  String get demoExit => 'Çık';

  @override
  String get demoGoalTrip => 'Seyahat';

  @override
  String get demoGoalLaptop => 'Dizüstü';

  @override
  String get demoGoalEmergency => 'Acil';

  @override
  String get demoGoalCar => 'Araba';

  @override
  String get demoBillPhone => 'Telefon';

  @override
  String get demoBillInternet => 'İnternet';

  @override
  String get demoBillGym => 'Spor salonu';

  @override
  String get voiceExample => 'Örneğin: “yüz elli lira, öğle yemeği”';

  @override
  String get voiceTitleListening => 'Dinleniyor';

  @override
  String get voiceTitleHeard => 'Duyuldu';

  @override
  String get voiceTitleFailed => 'Anlaşılamadı';

  @override
  String get voiceStop => 'Durdur';

  @override
  String get voiceRetry => 'Tekrar';

  @override
  String heroUntil(String date) {
    return '$date tarihine kadar';
  }

  @override
  String get goalIcon => 'Simge';

  @override
  String get payGaugeToLast => 'Yetmesi gereken';

  @override
  String get payGaugeNextPay => 'Sonraki maaş';
}
