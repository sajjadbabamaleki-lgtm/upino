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
}
