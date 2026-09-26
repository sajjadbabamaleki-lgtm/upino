// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get navHome => 'Beranda';

  @override
  String get navPlan => 'Rencana';

  @override
  String get navGoals => 'Tujuan';

  @override
  String get navActivity => 'Aktivitas';

  @override
  String get navProfile => 'Profil';

  @override
  String get currencyTitle => 'Mata uang apa?';

  @override
  String get currencyBlurb =>
      'Semua di rencanamu dicatat dalam mata uang ini. Pilih mata uang gajimu yang sebenarnya.';

  @override
  String get currencySearchHint => 'Cari negara, mata uang, atau kode';

  @override
  String currencyNoMatch(String query) {
    return 'Tidak ada yang cocok dengan “$query”. Coba nama negara atau kode tiga huruf.';
  }

  @override
  String get onboardingBadge => 'Sekitar satu menit';

  @override
  String get onboardingTitle => 'Siapkan rencanamu';

  @override
  String get onboardingBlurb =>
      'Dua jawaban cukup untuk mulai. Sisanya bisa nanti.';

  @override
  String get onboardingBalanceLabel => 'Tabunganmu hari ini';

  @override
  String get onboardingBalanceHint =>
      'Uang yang benar-benar bisa kamu pakai, bukan yang ingin kamu simpan.';

  @override
  String get onboardingIncomeLabel => 'Berapa penghasilanmu sebulan?';

  @override
  String get onboardingIncomeHint =>
      'Kalau berubah-ubah, isi rentangnya. Rencana dibuat dari angka terendah.';

  @override
  String get onboardingPayDay => 'Kapan gajian berikutnya?';

  @override
  String onboardingDays(int count) {
    return '$count hari';
  }

  @override
  String get onboardingCommitments => 'Tambahkan kewajibanmu';

  @override
  String get onboardingCommitmentsOpen =>
      'Sewa, kebutuhan pokok, dan satu tujuan';

  @override
  String get onboardingCommitmentsShut => 'Opsional, bisa nanti';

  @override
  String get onboardingRentLabel => 'Sewa dan tagihan tetap';

  @override
  String get onboardingRentHint => 'Jatuh tempo sebelum gajian berikutnya';

  @override
  String get onboardingEssentialsLabel => 'Makan dan transportasi';

  @override
  String get onboardingEssentialsHint =>
      'Yang kamu perlukan selama periode ini';

  @override
  String get onboardingGoalLabel => 'Menabung untuk tujuan';

  @override
  String get onboardingGoalHint => 'Yang ingin kamu sisihkan periode ini';

  @override
  String get onboardingFinish => 'Buat rencanaku';

  @override
  String get onboardingIncomplete => 'Isi dua jawaban pertama untuk lanjut';

  @override
  String get tapToType => 'Ketuk untuk mengetik';

  @override
  String get heroSafeToSpend => 'Aman dibelanjakan sekarang';

  @override
  String get heroNotUpToDate => 'Belum terbaru';

  @override
  String get heroRecordSpend => 'Catat pengeluaran';

  @override
  String get heroSeeShort => 'Lihat yang kurang';

  @override
  String get heroConfirmBalance => 'Konfirmasi saldo';

  @override
  String get heroReviewBlurb =>
      'Periksa saldomu agar angka ini bisa dipercaya lagi.';

  @override
  String heroUntilSetAside(String date, String amount) {
    return 'Sampai $date · $amount disisihkan';
  }

  @override
  String heroShort(String amount) {
    return 'Kurang $amount';
  }

  @override
  String heroUnfunded(String label, String amount) {
    return '$label · $amount belum tercukupi';
  }

  @override
  String get heroBalanceNever => 'Saldo belum dikonfirmasi';

  @override
  String get heroBalanceToday => 'Saldo dikonfirmasi hari ini';

  @override
  String get heroBalanceYesterday => 'Saldo dikonfirmasi kemarin';

  @override
  String heroBalanceDays(int count) {
    return 'Saldo dikonfirmasi $count hari lalu';
  }

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get homeTitle => 'Rencanamu';

  @override
  String homeUntilTotal(String date, String amount) {
    return 'Sampai $date · total $amount';
  }

  @override
  String homeRecorded(String amount) {
    return '$amount tercatat';
  }

  @override
  String get homeAttention => 'Perlu perhatianmu';

  @override
  String homeNotCovered(String amount) {
    return '$amount belum tertutup';
  }

  @override
  String get homeAfterNextPay => 'Setelah gajian berikutnya';

  @override
  String homeOncePayArrives(String date) {
    return 'Setelah gaji masuk pada $date';
  }

  @override
  String get homeSetAsideFirst => 'Disisihkan dulu';

  @override
  String get homeProtectedBlurb =>
      'Dilindungi sebelum ada yang bisa dibelanjakan.';

  @override
  String get homeNothingSetAside =>
      'Belum ada yang disisihkan. Semua uangmu bisa dibelanjakan.';

  @override
  String get homeWhyThisNumber => 'Kenapa angka ini';

  @override
  String get homeWhatIsShort => 'Yang kurang';

  @override
  String get homeShortBlurb =>
      'Tidak ada yang dipindahkan atau ditunda untukmu. Ini kewajiban yang belum tertutup oleh uangmu saat ini.';

  @override
  String get askSpendTitle => 'Berapa yang kamu belanjakan?';

  @override
  String get askBalanceTitle => 'Berapa saldomu sekarang?';

  @override
  String get askBalanceBlurb =>
      'Selisih apa pun dicatat sebagai koreksi, bukan pengeluaran.';

  @override
  String get whyNoChange => 'Tidak ada yang berubah sejak rencana terakhirmu.';

  @override
  String get whyPayArrived => 'Gajimu masuk, jadi rencana diperbarui.';

  @override
  String get whyBillPaid =>
      'Tagihan yang sudah kamu sisihkan uangnya telah dibayar.';

  @override
  String get whyHeldForBill =>
      'Uang ditahan untuk tagihan yang jatuh tempo tepat setelah gajian berikutnya.';

  @override
  String get whyOvercommitted =>
      'Kewajibanmu lebih besar dari uang yang kamu punya sekarang.';

  @override
  String get whyStale => 'Saldomu belum dikonfirmasi belakangan ini.';

  @override
  String get whyCardLarger =>
      'Saldo kartumu lebih besar dari uang yang kamu punya.';

  @override
  String get whyPayLate => 'Gaji yang ditunggu belum masuk.';

  @override
  String get whyOverdue => 'Ada yang sudah lewat jatuh tempo.';

  @override
  String get whyBufferShort => 'Dana daruratmu belum terisi penuh.';

  @override
  String get whyGoalShort =>
      'Tujuan tabunganmu belum bisa didanai penuh sekarang.';

  @override
  String get whyFlexibleLess =>
      'Tujuan fleksibel mendapat lebih sedikit dari rencana.';

  @override
  String get whyDuplicate => 'Transaksi yang terulang hanya dihitung sekali.';

  @override
  String get planTitle => 'Rencana';

  @override
  String get planBlurb =>
      'Untuk apa uangmu sudah dijanjikan, sebelum ada yang bisa dibelanjakan.';

  @override
  String get planMoneyAndIncome => 'Uang dan penghasilan';

  @override
  String get planMoneyYouHave => 'Uang yang kamu punya';

  @override
  String get planNextPay => 'Gaji berikutnya';

  @override
  String get planYourNextPay => 'Gaji berikutnya';

  @override
  String get planNotSet => 'Belum diatur';

  @override
  String get planExpectedBlurb =>
      'Ini baru perkiraan, jadi tidak masuk ke yang bisa kamu belanjakan sekarang.';

  @override
  String get planSetAsideFirst => 'Disisihkan dulu';

  @override
  String get planNothingSetAside =>
      'Tidak ada yang disisihkan, jadi semua uangmu bisa dibelanjakan.';

  @override
  String get planAddToPlan => 'Tambahkan ke rencana';

  @override
  String get planGoals => 'Tujuan';

  @override
  String get planSaveToward => 'Menabung untuk sesuatu';

  @override
  String get planSaveTowardSub => 'Liburan, uang muka, laptop baru';

  @override
  String get planAllGoals => 'Semua tujuan';

  @override
  String get planAllGoalsSub => 'Tambah, ubah, atau sisihkan uang';

  @override
  String get planHowMuchSetAside =>
      'Berapa yang perlu kamu sisihkan untuk ini?';

  @override
  String get planChangeOrRemove => 'Ubah jumlahnya, atau hapus dari rencana.';

  @override
  String get planRemove => 'Hapus dari rencana';

  @override
  String planDue(String date) {
    return ' · jatuh tempo $date';
  }

  @override
  String get priorityMandatory => 'Wajib dibayar — paling dulu';

  @override
  String get priorityEssential => 'Kebutuhan sehari-hari';

  @override
  String get priorityBuffer => 'Disimpan untuk darurat';

  @override
  String get priorityCard => 'Sudah dibelanjakan dengan kartu';

  @override
  String get prioritySinkingFund => 'Menabung untuk tagihan yang sudah pasti';

  @override
  String get priorityGoal => 'Tujuan yang sudah kamu komitmenkan';

  @override
  String get priorityDiscretionary => 'Kalau ada lebih — mengalah dulu';

  @override
  String get goalsTitle => 'Tujuan';

  @override
  String get goalsBlurbEmpty => 'Belum ada yang ditabung.';

  @override
  String get goalsBlurb => 'Yang dibutuhkan tiap tujuan dari periode gaji ini.';

  @override
  String get goalsEmptyCard =>
      'Tambahkan sesuatu yang sedang kamu tabung — liburan, uang muka, laptop baru. Upino menghitung berapa yang perlu disisihkan tiap gajian agar tepat waktu.';

  @override
  String get goalsNew => 'Tujuan baru';

  @override
  String get goalsNewSub => 'Sesuatu yang sedang kamu sisihkan uangnya';

  @override
  String get goalsAddMoney => 'Tambah uang';

  @override
  String goalsAddTo(String name) {
    return 'Tambah ke $name';
  }

  @override
  String get goalsAddBlurb =>
      'Ini mencatat yang sudah kamu sisihkan. Tidak ada yang dibelanjakan — ini mengurangi yang harus ditahan mulai sekarang.';

  @override
  String get goalsEachPeriod => 'Tiap periode gaji';

  @override
  String get goalsTargetDate => 'Tanggal target';

  @override
  String goalsOf(String amount) {
    return 'dari $amount';
  }

  @override
  String goalsPeriodsToGo(int count) {
    return '$count periode gaji lagi';
  }

  @override
  String get goalsDone => 'Terkumpul penuh';

  @override
  String get goalsPausedStatus => 'Dijeda — tidak ada yang ditahan';

  @override
  String get goalsFlexibleStatus =>
      'Fleksibel — mengalah pada yang wajib dibayar';

  @override
  String get goalEditNew => 'Kamu menabung untuk apa?';

  @override
  String get goalEditExisting => 'Ubah tujuan';

  @override
  String get goalName => 'Nama';

  @override
  String get goalNameHint => 'Liburan, uang muka, laptop';

  @override
  String get goalTotal => 'Berapa totalnya';

  @override
  String get goalByWhen => 'Kapan';

  @override
  String goalMonths(int count) {
    return '$count bln';
  }

  @override
  String get goalOneYear => '1 tahun';

  @override
  String get goalTwoYears => '2 tahun';

  @override
  String get goalFirmness => 'Seberapa pasti?';

  @override
  String get goalKindHard => 'Pasti';

  @override
  String get goalKindHardSub => 'Ditahan sebelum ada yang bisa dibelanjakan';

  @override
  String get goalKindFlexible => 'Fleksibel';

  @override
  String get goalKindFlexibleSub => 'Mengalah pada yang wajib dibayar';

  @override
  String get goalKindPaused => 'Dijeda';

  @override
  String get goalKindPausedSub => 'Tetap terlihat, tidak ada yang ditahan';

  @override
  String get goalSaveChanges => 'Simpan perubahan';

  @override
  String get goalAddThis => 'Tambahkan tujuan ini';

  @override
  String get goalDelete => 'Hapus tujuan ini';

  @override
  String get activityTitle => 'Aktivitas';

  @override
  String get activityBlurb => 'Semua yang kamu catat, terbaru dulu.';

  @override
  String get activityEmpty =>
      'Saat kamu mencatat pengeluaran, akan muncul di sini, dan kamu bisa menghapusnya kalau salah.';

  @override
  String get activityRemoveIt => 'Hapus';

  @override
  String get activityKeepIt => 'Simpan';

  @override
  String get activitySpent => 'Dibelanjakan';

  @override
  String get activityIncome => 'Gaji';

  @override
  String get activityCorrection => 'Koreksi';

  @override
  String get activityRemoved => 'Dihapus';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileConfirmBalance => 'Konfirmasi saldomu';

  @override
  String get profileTrustTitle => 'Seberapa bisa dipercaya angkanya?';

  @override
  String get profileTrustFresh => 'Terbaru. Tidak ada yang perlu perhatianmu.';

  @override
  String get profileTrustDegraded =>
      'Saldomu sudah lama tidak dikonfirmasi. Angkanya tetap ditampilkan, hanya kurang pasti.';

  @override
  String get profileTrustReview =>
      'Terlalu lama atau terlalu tidak pasti untuk diandalkan. Konfirmasi saldomu untuk memperbaikinya.';

  @override
  String get profileConfirmedNever => 'Belum dikonfirmasi';

  @override
  String get profileConfirmedToday => 'Dikonfirmasi hari ini';

  @override
  String get profileConfirmedYesterday => 'Dikonfirmasi kemarin';

  @override
  String profileConfirmedDays(int count) {
    return 'Dikonfirmasi $count hari lalu';
  }

  @override
  String get profileAppearance => 'Tampilan';

  @override
  String get profileTheme => 'Tema';

  @override
  String get profileThemeBlurb =>
      'Defaultnya mengikuti ponselmu, jadi tidak ada yang dipaksakan.';

  @override
  String get themePhone => 'Ponsel';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get profileLanguage => 'Bahasa';

  @override
  String get profileLanguageBlurb =>
      'Defaultnya mengikuti ponselmu, jadi tidak ada yang dipaksakan.';

  @override
  String get languagePhone => 'Ponsel';

  @override
  String get profileCurrency => 'Mata uang';

  @override
  String currencyChangeTitle(String currency) {
    return 'Ganti ke $currency?';
  }

  @override
  String currencyChangeBlurb(String currency) {
    return 'Setiap jumlah di rencanamu tetap angkanya dan mulai sekarang ditampilkan dalam $currency. Tidak ada konversi kurs, jadi gunakan ini untuk membetulkan mata uang, bukan menukar uangmu.';
  }

  @override
  String get currencyChangeConfirm => 'Ganti';

  @override
  String get profileYourData => 'Datamu';

  @override
  String get profileDelete => 'Hapus rencanaku';

  @override
  String get profileDeleteSub =>
      'Menghapus semua dan kembali ke pengaturan awal';

  @override
  String get profileStartOver => 'Mulai dari awal?';

  @override
  String get profileStartOverBlurb =>
      'Rencanamu dan semua yang kamu catat akan dihapus. Ini tidak bisa dibatalkan.';

  @override
  String get profileDeleteEverything => 'Hapus semua';

  @override
  String get profileKeepPlan => 'Simpan rencanaku';

  @override
  String get save => 'Simpan';

  @override
  String get cancel => 'Batal';

  @override
  String activityRemoveAmount(String amount) {
    return 'Hapus $amount?';
  }

  @override
  String get activityRemoveDetail =>
      'Langsung tidak dihitung lagi dalam rencanamu. Entri tetap di daftar ini dengan tanda dihapus, jadi catatanmu tetap lengkap.';

  @override
  String get activityCardPurchase => 'Pembelian kartu';

  @override
  String get activityCardPayment => 'Pembayaran kartu';

  @override
  String get activityRefund => 'Pengembalian dana';

  @override
  String get activityTransfer => 'Dipindah antar rekening';

  @override
  String get activityLoan => 'Pinjaman diterima';

  @override
  String get activityDebtPayment => 'Pembayaran utang';

  @override
  String get activityBalanceCorrected => 'Saldo dikoreksi';

  @override
  String get activityBlurbEmpty => 'Belum ada yang dicatat.';

  @override
  String get profileStartAgain => 'Mulai lagi';

  @override
  String get claimRent => 'Sewa dan tagihan';

  @override
  String get claimCardMinimum => 'Pembayaran minimum kartu';

  @override
  String get claimEssentials => 'Makan dan transportasi';

  @override
  String get claimBuffer => 'Dana darurat';

  @override
  String get languageTitle => 'Bahasa apa?';

  @override
  String get languageBlurb => 'Bisa kamu ubah nanti di Profil.';

  @override
  String get profileLedgerTitle => 'Apakah catatannya lengkap?';

  @override
  String get ledgerComplete => 'Semua yang kamu belanjakan sudah tercatat.';

  @override
  String get ledgerPartial =>
      'Sebagian pengeluaran baru ketahuan saat kamu mengonfirmasi saldo.';

  @override
  String get ledgerUnknown =>
      'Upino tidak tahu berapa yang hilang. Konfirmasi saldomu untuk mengetahuinya.';

  @override
  String get askTitle => 'Tanya sebelum belanja';

  @override
  String get askBlurb =>
      'Coba satu pembelian terhadap rencanamu. Tidak ada yang dicatat dan tidak ada yang berubah.';

  @override
  String get askAmountLabel => 'Berapa harganya?';

  @override
  String get askRun => 'Lihat dampaknya';

  @override
  String get askDoNotBuy => 'Jangan beli';

  @override
  String get askBuyNow => 'Beli hari ini';

  @override
  String askBuyAfter(String date) {
    return 'Beli setelah $date';
  }

  @override
  String get askUnchanged => 'Rencanamu tetap seperti sekarang.';

  @override
  String get askStsAfter => 'Aman dibelanjakan setelahnya';

  @override
  String get askBreaks =>
      'Ini membuat sesuatu yang wajib dibayar tidak tercukupi.';

  @override
  String get askSafe =>
      'Tidak ada yang wajib dibayar yang jadi tidak tercukupi.';

  @override
  String get askCosts => 'Yang jadi berkurang';

  @override
  String askCostLine(String label, String amount) {
    return '$label · berkurang $amount';
  }

  @override
  String get askWaitingHelps =>
      'Kalau menunggu sampai gajian, semuanya tertutup.';

  @override
  String get askNoIncome =>
      'Belum ada gaji yang ditunggu, jadi tidak ada pembanding nanti.';

  @override
  String askAssumption(String date) {
    return 'Dengan asumsi gajimu masuk seperti biasa pada $date.';
  }

  @override
  String get askNoVerdict =>
      'Upino tidak bilang ya atau tidak. Keputusannya milikmu.';

  @override
  String get receipt => 'Struk';

  @override
  String get receiptAdd => 'Tambah struk';

  @override
  String get receiptCamera => 'Ambil foto';

  @override
  String get receiptGallery => 'Pilih foto';

  @override
  String get receiptAttached => 'Struk terlampir';

  @override
  String get receiptRemove => 'Hapus foto';

  @override
  String get onboardingIncomeFrom => 'Paling sedikit';

  @override
  String get onboardingIncomeTo => 'Paling banyak';

  @override
  String get onboardingIncomeToOptional => 'Opsional';

  @override
  String incomeRange(String low, String high) {
    return '$low sampai $high';
  }

  @override
  String incomeRangeNote(String low) {
    return 'Rencanamu dibuat dari $low. Lebihnya milikmu saat masuk.';
  }

  @override
  String get categoryFood => 'Makan';

  @override
  String get categoryTransport => 'Transportasi';

  @override
  String get categoryBills => 'Tagihan';

  @override
  String get categoryShopping => 'Belanja';

  @override
  String get categoryHealth => 'Kesehatan';

  @override
  String get categoryFun => 'Jalan-jalan';

  @override
  String get categoryOther => 'Lainnya';

  @override
  String get categoryUnsorted => 'Belum dipilah';

  @override
  String get categoryPrompt => 'Untuk apa?';

  @override
  String get spendingTitle => 'Ke mana uangnya';

  @override
  String get spendingWindow => 'Pengeluaran yang dicatat 30 hari terakhir';

  @override
  String get backupSection => 'Cadangan';

  @override
  String get backupSave => 'Simpan cadangan';

  @override
  String get backupSaveSub =>
      'Dikunci dengan kata sandi. Simpan di tempat aman, seperti penyimpanan cloud.';

  @override
  String get backupRestore => 'Pulihkan dari cadangan';

  @override
  String get backupRestoreSub => 'Mengganti rencana di ponsel ini';

  @override
  String get backupPassword => 'Kata sandi';

  @override
  String get backupPasswordRepeat => 'Ulangi kata sandi';

  @override
  String get backupPasswordSaveBlurb =>
      'Kata sandi ini diperlukan untuk memulihkan. Kalau lupa, tidak bisa dipulihkan. Foto struk tidak ikut.';

  @override
  String get backupPasswordOpenBlurb =>
      'Kata sandi saat cadangan ini disimpan.';

  @override
  String get backupPasswordShort => 'Minimal 6 karakter';

  @override
  String get backupPasswordMismatch => 'Keduanya tidak sama';

  @override
  String get backupOpen => 'Buka';

  @override
  String get backupReplaceTitle => 'Ganti rencana ini?';

  @override
  String get backupReplaceBlurb =>
      'Semua di ponsel ini diganti dengan isi cadangan. Ini tidak bisa dibatalkan.';

  @override
  String get backupReplace => 'Ganti';

  @override
  String get backupRestored => 'Cadangan dipulihkan';

  @override
  String get backupWrongPassword =>
      'Kata sandi itu tidak membuka cadangan ini.';

  @override
  String get backupNotABackup => 'File itu bukan cadangan Upino.';

  @override
  String get backupUnreadable =>
      'Cadangan ini dibuat oleh versi Upino yang lebih baru. Perbarui aplikasi lalu coba lagi.';

  @override
  String get inflationTitle => 'Inflasi';

  @override
  String get inflationNotSet =>
      'Belum diatur. Tambahkan laju tahunan di tempatmu untuk melihat biaya tujuan sebenarnya.';

  @override
  String inflationRate(String rate) {
    return '$rate% per tahun';
  }

  @override
  String get inflationDialogTitle => 'Inflasi tahunan';

  @override
  String get inflationDialogBlurb =>
      'Harga naik, jadi tujuan dengan uang hari ini akan lebih mahal saat tanggalnya. Masukkan laju yang kamu perkirakan. Kosongkan untuk mematikan.';

  @override
  String goalsInflated(String rate, String amount) {
    return 'Dengan $rate% per tahun, nanti biayanya sekitar $amount.';
  }

  @override
  String get holdingsTitle => 'Aset lain';

  @override
  String get holdingsBlurb =>
      'Dolar, emas, koin. Ditampilkan di samping rencanamu dan tidak pernah dihitung sebagai yang bisa dibelanjakan.';

  @override
  String get holdingsAdd => 'Tambah aset';

  @override
  String get holdingsAddSub => 'Tidak dihitung sebagai yang bisa dibelanjakan';

  @override
  String get holdingsTotal => 'Total';

  @override
  String holdingSummary(String quantity, String price, String date) {
    return '$quantity × $price · harga $date';
  }

  @override
  String get holdingEditNew => 'Aset baru';

  @override
  String get holdingEditExisting => 'Ubah aset';

  @override
  String get holdingName => 'Apa itu?';

  @override
  String get holdingNameHint => 'Dolar AS, emas…';

  @override
  String get holdingUsd => 'Dolar AS';

  @override
  String get holdingEur => 'Euro';

  @override
  String get holdingGold => 'Emas (gram)';

  @override
  String get holdingCoin => 'Koin emas';

  @override
  String get holdingQuantity => 'Berapa banyak';

  @override
  String get holdingUnitPrice => 'Nilai satu hari ini';

  @override
  String holdingWorth(String amount) {
    return 'Totalnya bernilai $amount';
  }

  @override
  String get holdingDelete => 'Hapus aset ini';

  @override
  String get fasterTitle => 'Catat lebih cepat';

  @override
  String get smsTitle => 'Baca SMS bank';

  @override
  String get smsDetail =>
      'Pengeluaran yang diberitahukan bank lewat SMS ditawarkan untuk dicatat dengan satu ketukan. Pesan hanya dibaca di ponsel ini dan tidak dikirim ke mana pun.';

  @override
  String get smsDenied =>
      'Upino tidak diizinkan membaca pesan. Kamu bisa mengizinkannya di pengaturan ponsel.';

  @override
  String smsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pesan bank untuk ditinjau',
      one: '1 pesan bank untuk ditinjau',
    );
    return '$_temp0';
  }

  @override
  String get smsWaitingSub =>
      'Catat masing-masing dengan satu ketukan, atau lewati';

  @override
  String get smsReviewTitle => 'Dari bankmu';

  @override
  String get smsReviewBlurb =>
      'Tidak ada yang dicatat sampai kamu mengetuk Catat. Cocokkan jumlahnya dengan pesan.';

  @override
  String get smsReviewDone => 'Semua sudah ditinjau.';

  @override
  String get smsRecord => 'Catat';

  @override
  String get smsSkip => 'Lewati';

  @override
  String get reminderTitleSetting => 'Pengingat malam';

  @override
  String get reminderDetail => 'Jam 9 malam, hanya di hari tanpa catatan.';

  @override
  String get reminderDenied =>
      'Upino tidak diizinkan menampilkan notifikasi. Kamu bisa mengizinkannya di pengaturan ponsel.';

  @override
  String get reminderTitle => 'Ada belanja hari ini?';

  @override
  String get reminderBody =>
      'Catat dalam beberapa detik supaya angka besok benar.';

  @override
  String get reminderChannel => 'Pengingat malam';

  @override
  String get widgetSpend => '+ Belanja';

  @override
  String get widgetAdd => 'Tambahkan ke layar utama';

  @override
  String get widgetAddSub =>
      'Yang bisa kamu belanjakan dan tombol untuk mencatat, tanpa membuka aplikasi';

  @override
  String get voiceListening => 'Mendengarkan… sebutkan jumlah dan untuk apa.';

  @override
  String voiceHeard(String text) {
    return 'Terdengar: “$text”. Periksa jumlahnya, lalu simpan.';
  }

  @override
  String get voiceNothing => 'Tidak terdengar jumlah. Coba lagi, atau ketik.';

  @override
  String get voicePrivacy =>
      'Ponselmu mengubah ucapan jadi teks. Di ponsel tanpa pengenalan suara offline, itu lewat layanan suara ponsel.';

  @override
  String get voiceButton => 'Ucapkan';

  @override
  String get voiceUnavailable =>
      'Ponsel ini tidak punya pengenalan suara yang bisa dipakai. Ketik jumlahnya saja.';

  @override
  String get voiceNoPermission =>
      'Upino tidak diizinkan memakai mikrofon. Kamu bisa mengizinkannya di pengaturan ponsel.';

  @override
  String get voiceNetwork =>
      'Pengenalan suara di ponsel ini perlu internet dan tidak bisa terhubung.';

  @override
  String voiceNoAmount(String text) {
    return 'Terdengar “$text”, tapi tidak ada jumlahnya. Coba lagi, atau ketik.';
  }

  @override
  String get yes => 'Ya';

  @override
  String get no => 'Tidak';

  @override
  String get navAsk => 'Tanya';

  @override
  String get alertsTitle => 'Perlu kamu';

  @override
  String get alertsEmpty =>
      'Saat ini tidak ada yang perlu kamu. Rencana sudah terbaru.';

  @override
  String alertUnfunded(String label, String amount) {
    return '$label kurang $amount';
  }

  @override
  String get alertUnfundedDetail =>
      'Ada yang wajib dibayar yang belum tertutup uangmu.';

  @override
  String alertIncomeLate(String date) {
    return 'Gajimu diharapkan masuk pada $date';
  }

  @override
  String get alertIncomeLateDetail =>
      'Belum dihitung sampai masuk. Ubah tanggalnya di Rencana kalau bergeser.';

  @override
  String alertGoalBehind(String name, String amount) {
    return '$name tertinggal $amount periode ini';
  }

  @override
  String get alertGoalBehindDetail =>
      'Uangmu belum mencapai bagian tujuan untuk periode ini.';

  @override
  String get chatHint => 'Tanya apa saja, atau ketik harga';

  @override
  String get chatSuggestSafe => 'Berapa yang bisa kubelanjakan?';

  @override
  String get chatSuggestPay => 'Kapan gajian berikutnya?';

  @override
  String get chatSuggestWhere => 'Ke mana uangku pergi?';

  @override
  String get chatSuggestAside => 'Apa yang disisihkan?';

  @override
  String chatSafe(String amount, String date) {
    return 'Kamu bisa membelanjakan $amount sampai $date.';
  }

  @override
  String get chatSafeStale =>
      'Satu hal: saldomu perlu dikonfirmasi, jadi anggap ini perkiraan.';

  @override
  String chatPay(String amount, String date) {
    return 'Gaji berikutnya $amount, diperkirakan pada $date.';
  }

  @override
  String get chatPayNone =>
      'Aku belum tahu gaji berikutnya. Tambahkan di Rencana dan akan kupantau.';

  @override
  String get chatWhere => 'Ini ke mana saja uangmu 30 hari terakhir:';

  @override
  String get chatWhereNone =>
      'Tidak ada pengeluaran 30 hari terakhir. Mungkin bulan yang sepi, atau belum dicatat.';

  @override
  String chatAside(String amount) {
    return '$amount disisihkan sebelum ada yang dihitung bisa dibelanjakan:';
  }

  @override
  String chatPurchase(String amount) {
    return 'Mari lihat dampak $amount.';
  }

  @override
  String get chatHelp =>
      'Hmm, aku kurang paham. Aku bisa memberi tahu berapa yang bisa kamu belanjakan, kapan gajian, ke mana uangmu, apa yang disisihkan, atau cara berhemat. Atau ketik harga, misalnya “HP 3 juta”, dan akan kutunjukkan dampaknya kalau dibeli.';

  @override
  String get chatHelloNew =>
      'Hai! Aku Upino. Kamu baru di sini, jadi aku baru tahu dasar-dasarnya: saldomu, gajimu, dan yang kamu sisihkan. Itu sudah cukup untuk memberi tahu berapa yang bisa kamu belanjakan dan dampak suatu pembelian. Terus catat pengeluaranmu, dan setelah sekitar satu musim aku akan cukup kenal kebiasaanmu untuk jadi penasihat keuanganmu sendiri.';

  @override
  String chatHelloLearning(int days, int spends, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari',
      one: '1 hari',
    );
    String _temp1 = intl.Intl.pluralLogic(
      spends,
      locale: localeName,
      other: '$spends pengeluaran',
      one: '1 pengeluaran',
    );
    return 'Selamat datang kembali! Sejauh ini aku belajar dari $_temp0 dan $_temp1. Sekitar $remaining hari lagi dan aku punya data satu musim penuh.';
  }

  @override
  String chatHelloFamiliar(int days) {
    return 'Selamat datang kembali! Aku sudah melihat $days hari keuanganmu, jadi tanya apa saja, termasuk cara berhemat.';
  }

  @override
  String chatHelloAlerts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ada $count hal yang perlu kamu',
      one: 'ada satu hal yang perlu kamu',
    );
    return 'Omong-omong, $_temp0: lihat di lonceng.';
  }

  @override
  String chatPurchaseFits(String left) {
    return 'Kalau dibeli hari ini, semua yang wajib dibayar tetap tertutup, dengan sisa $left.';
  }

  @override
  String chatPurchaseWait(String date) {
    return 'Kalau dibeli hari ini, ada yang wajib dibayar jadi kurang. Kalau menunggu sampai $date, semuanya tertutup.';
  }

  @override
  String chatPurchaseStillShort(String date) {
    return 'Perhatian: bahkan setelah gajian pada $date, ini membuat ada yang wajib dibayar jadi kurang.';
  }

  @override
  String get chatPurchaseShort =>
      'Kalau dibeli hari ini, ada yang wajib dibayar jadi kurang.';

  @override
  String chatSafeNothing(String date) {
    return 'Saat ini tidak ada sisa sampai $date: semua uangmu sudah untuk yang wajib dibayar.';
  }

  @override
  String chatPayIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari lagi',
      one: 'sehari lagi',
    );
    return 'Itu $_temp0.';
  }

  @override
  String get chatPayLate =>
      'Terlambat, jadi belum dihitung sampai kamu konfirmasi sudah masuk.';

  @override
  String get chatPayRange =>
      'Rencanamu memakai angka terendah, jadi bulan yang bagus adalah bonus, bukan lubang.';

  @override
  String chatWhereSoFar(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari',
      one: '1 hari',
    );
    return 'Aku baru melihat $_temp0, jadi ini gambaran awal:';
  }

  @override
  String chatWhereTop(String category, int share) {
    return '$category paling besar: $share% dari totalnya.';
  }

  @override
  String get chatWhereTooSoon =>
      'Masih agak cepat: aku hampir belum melihat pengeluaran. Catat beberapa dan tanya lagi minggu depan.';

  @override
  String get chatAdviceTooSoon =>
      'Aku ingin membantu, tapi jujur aku belum cukup kenal pengeluaranmu, dan saran tanpa itu hanya tebakan. Catat pengeluaranmu (memilah kategori sangat membantu) dan tanya lagi beberapa minggu lagi.';

  @override
  String chatAdviceBiggest(String category, String amount, String tenth) {
    return 'Pengeluaran terbesarmu 30 hari terakhir adalah $category, sebesar $amount. Menguranginya sepersepuluh akan membebaskan sekitar $tenth sebulan.';
  }

  @override
  String get chatAdviceSort =>
      'Aku bisa lihat jumlah belanjamu, tapi tidak untuk apa. Beri kategori saat mencatat, dan aku bisa bilang di mana bisa berhemat.';

  @override
  String chatAdviceMore(String amount) {
    return 'Kamu membelanjakan $amount lebih banyak dari bulan sebelumnya.';
  }

  @override
  String chatAdviceLess(String amount) {
    return 'Bagus: itu $amount lebih sedikit dari bulan sebelumnya.';
  }

  @override
  String get chatAdviceLearning =>
      'Aku masih belajar kebiasaanmu, jadi anggap ini petunjuk awal, bukan gambaran lengkap.';

  @override
  String get chatSmallHello =>
      'Hai! Apa yang ingin kamu ketahui tentang uangmu?';

  @override
  String get chatSmallThanks =>
      'Kapan saja! Aku di sini setiap kali kamu mau belanja.';

  @override
  String get chatSmallWho =>
      'Aku asisten Upino. Aku hanya tahu isi rencanamu, dan setiap angka langsung dari sana; apa pun yang kamu katakan tidak keluar dari ponsel ini. Aku tidak akan bilang ya atau tidak, tapi akan menunjukkan sisa dari tiap pilihan.';

  @override
  String get chatSuggestAdvice => 'Bagaimana cara berhemat?';

  @override
  String get chatTitle => 'Upino';

  @override
  String get chatNew => 'Obrolan baru';

  @override
  String get chatResumed => 'Jawaban di sini dihitung dari rencanamu hari ini.';

  @override
  String get chatWhy => 'Begini angkanya didapat:';

  @override
  String get chatWhyHave => 'Yang kamu punya';

  @override
  String get chatWhySetAside => 'Disisihkan dulu';

  @override
  String get chatWhyLeft => 'Aman dibelanjakan';

  @override
  String get chatSmallHowAreYou =>
      'Aku baik, terima kasih sudah tanya! Uangmu masih di tempatnya. Apa yang ingin kamu ketahui?';

  @override
  String get chatSmallBye =>
      'Dah! Kembali lagi sebelum belanja besar berikutnya.';

  @override
  String get chatSmallOkay => 'Ada lagi yang ingin kamu cek?';

  @override
  String get askHubTitle => 'Ngobrol dengan Upino';

  @override
  String get askHubNew =>
      'Tanya berapa yang bisa kamu belanjakan, dampak suatu pembelian, atau kapan gajian. Aku masih mengenalmu, jadi akan makin berguna seiring kamu mencatat.';

  @override
  String askHubLearning(int days) {
    return 'Aku sedang mempelajari kebiasaanmu: sekitar $days hari lagi dan aku punya satu musim penuh untuk memberi saran.';
  }

  @override
  String get askHubFamiliar =>
      'Sekarang aku kenal keuanganmu dengan baik. Tanya apa saja, termasuk cara berhemat.';

  @override
  String get askHubStart => 'Mulai obrolan';

  @override
  String get askHubCommon => 'Pertanyaan umum';

  @override
  String get askHubHistory => 'Obrolanmu';

  @override
  String askHubTurns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pertanyaan',
      one: '1 pertanyaan',
    );
    return '$_temp0';
  }

  @override
  String askHubAsidePreview(String amount, int count) {
    return '$amount disisihkan untuk $count kewajiban';
  }

  @override
  String get askHubDeleteTitle => 'Hapus obrolan ini?';

  @override
  String get askHubDeleteBlurb =>
      'Hanya obrolannya yang hilang. Rencanamu tidak berubah.';

  @override
  String get chatSmallHi => 'Hai!';

  @override
  String get chatSmallHiFine => 'Hai! Aku baik, terima kasih.';

  @override
  String chatSafeLasts(int days) {
    return 'Itu harus cukup untuk $days hari, sampai gajian.';
  }

  @override
  String homeSpokenFor(String amount, String date) {
    return '$amount uangmu sudah punya tujuan sampai $date.';
  }

  @override
  String askGoalLater(String goal, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari',
      one: 'satu hari',
    );
    return '$goal · sekitar $_temp0 lebih lambat';
  }

  @override
  String get askGoalsTitle => 'Tujuan jadi mundur';

  @override
  String get askGoalsNote => 'Kira-kira, dengan laju menabung tiap tujuan.';

  @override
  String chatPurchaseGoal(String goal, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari',
      one: 'satu hari',
    );
    return 'Ini akan memundurkan $goal sekitar $_temp0.';
  }

  @override
  String get monthTitle => 'Bulanmu';

  @override
  String get monthWindow => '30 hari terakhir, dibandingkan 30 hari sebelumnya';

  @override
  String monthTooSoon(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari lagi',
      one: 'sehari lagi',
    );
    return 'Ulasan bulanan butuh satu bulan pengeluaran. Punyamu siap $_temp0.';
  }

  @override
  String monthSpent(String amount) {
    return 'Dalam 30 hari terakhir, $amount keluar.';
  }

  @override
  String get monthNothing => 'Tidak ada yang dicatat dalam 30 hari terakhir.';

  @override
  String monthMore(String amount) {
    return 'Itu $amount lebih banyak dari 30 hari sebelumnya.';
  }

  @override
  String monthLess(String amount) {
    return 'Itu $amount lebih sedikit dari 30 hari sebelumnya.';
  }

  @override
  String get monthSame => 'Kurang lebih sama dengan 30 hari sebelumnya.';

  @override
  String monthUp(String category, String amount) {
    return 'Naik paling banyak: $category, sebesar $amount.';
  }

  @override
  String monthDown(String category, String amount) {
    return 'Turun paling banyak: $category, sebesar $amount.';
  }

  @override
  String monthGoals(int onTrack, int total) {
    return 'Tujuan sesuai jalur: $onTrack dari $total.';
  }

  @override
  String get chatSuggestMonth => 'Bagaimana bulanku?';

  @override
  String get timelineTitle => 'Uangmu ke depan';

  @override
  String get timelineToday => 'Hari ini';

  @override
  String get timelineNow => 'Sekarang';

  @override
  String get timelineProjected => 'Proyeksi';

  @override
  String get timelineRecorded => 'Tercatat';

  @override
  String get timelineFree => 'Bebas dibelanjakan';

  @override
  String get timelineHad => 'Kamu punya';

  @override
  String timelineBalance(String amount) {
    return 'Saldo $amount';
  }

  @override
  String timelineSetAside(String amount) {
    return 'Disisihkan $amount';
  }

  @override
  String timelinePayMark(String amount) {
    return 'Gaji $amount';
  }

  @override
  String timelineShort(String amount) {
    return 'Kurang $amount untuk yang wajib dibayar';
  }

  @override
  String timelineWithout(String amount) {
    return 'Tanpa itu: $amount';
  }

  @override
  String get timelineBuyAfterPay => 'Beli setelah gajian';

  @override
  String get timelineBalanceLegend => 'Saldo';

  @override
  String get timelineWithPurchase => 'Dengan pembelian';

  @override
  String get timelinePay => 'Hari gajian';

  @override
  String get timelineAssumptions =>
      'Ke depan adalah proyeksi: gaji pada tanggalnya, tagihan pada tanggalnya, uang hidup dibelanjakan merata, dan tidak ada yang lain. Geser di grafik untuk melihat hari mana pun.';

  @override
  String get timelineSemantics =>
      'Grafik saldo dan yang bebas dibelanjakan, per hari';

  @override
  String goalChartSemantics(String goal) {
    return 'Grafik bagaimana $goal mencapai targetnya';
  }

  @override
  String goalChartTarget(String amount, String date) {
    return 'Target $amount pada $date';
  }

  @override
  String goalPaceLabel(String amount) {
    return 'Sisihkan tiap periode gaji: $amount';
  }

  @override
  String goalOnTrack(String date) {
    return 'Sesuai jalur: tercapai pada $date.';
  }

  @override
  String goalLate(String date, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari',
      one: 'satu hari',
    );
    return 'Dengan laju ini tercapai pada $date, $_temp0 setelah tanggalnya.';
  }

  @override
  String get goalNotMoving =>
      'Saat ini tidak ada yang masuk, jadi belum mendekat.';

  @override
  String goalUsePace(String date) {
    return 'Pindahkan tanggal target ke $date';
  }

  @override
  String get goalPaceNote =>
      'Hanya simulasi: tidak ada yang berubah sampai kamu memilih.';

  @override
  String get goalShowPath => 'Lihat jalannya';

  @override
  String get goalHidePath => 'Sembunyikan';

  @override
  String get billsTitle => 'Tagihan dan langganan';

  @override
  String get billAdd => 'Tambah tagihan atau langganan';

  @override
  String get billAddSub =>
      'Pulsa, internet, asuransi, streaming… masing-masing disisihkan sebelum tanggalnya.';

  @override
  String get billEditNew => 'Tagihan baru';

  @override
  String get billEditExisting => 'Ubah tagihan ini';

  @override
  String get billName => 'Apa itu?';

  @override
  String get billNameHint => 'mis. Internet';

  @override
  String get billAmount => 'Tiap pembayaran';

  @override
  String get billEvery => 'Seberapa sering';

  @override
  String get billEveryWeek => 'Mingguan';

  @override
  String get billEveryMonth => 'Bulanan';

  @override
  String get billEveryQuarter => 'Tiga bulanan';

  @override
  String get billEveryYear => 'Tahunan';

  @override
  String get billNext => 'Pembayaran berikutnya';

  @override
  String get billKind => 'Jenisnya';

  @override
  String get billKindBill => 'Tagihan';

  @override
  String get billKindSubscription => 'Langganan';

  @override
  String get billRepays => 'Membayar';

  @override
  String get billRepaysNothing => 'Tidak ada, ini biaya';

  @override
  String get billAddThis => 'Tambahkan tagihan ini';

  @override
  String get billDelete => 'Hapus tagihan ini';

  @override
  String billRow(String every, String date) {
    return '$every · berikutnya $date';
  }

  @override
  String billOverdue(String date) {
    return 'Jatuh tempo $date';
  }

  @override
  String get billPay => 'Tandai sudah dibayar';

  @override
  String get billEdit => 'Ubah';

  @override
  String get dayToday => 'Hari ini';

  @override
  String dayIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari lagi',
      one: 'Sehari lagi',
    );
    return '$_temp0';
  }

  @override
  String dayAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari lalu',
      one: 'Sehari lalu',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'Akan datang';

  @override
  String homeComingUpTotal(String amount) {
    return '$amount tagihan jatuh tempo dalam 30 hari ke depan.';
  }

  @override
  String payDueTitle(String date) {
    return 'Gajimu seharusnya masuk $date. Sudah masuk?';
  }

  @override
  String get payDueSub =>
      'Isi yang masuk, dan gaji berikutnya diperkirakan satu periode kemudian.';

  @override
  String get payArrived => 'Sudah masuk';

  @override
  String get payArrivedTitle => 'Berapa yang masuk?';

  @override
  String get planRecordPay => 'Gaji masuk';

  @override
  String get planRecordPaySub => 'Catat, dan gaji berikutnya maju satu periode';

  @override
  String get accountsTitle => 'Rekening';

  @override
  String get accountMain => 'Rekening utama';

  @override
  String get accountKindBank => 'Rekening bank';

  @override
  String get accountKindCash => 'Tunai';

  @override
  String get accountKindSavings => 'Tabungan';

  @override
  String get accountKindCard => 'Kartu kredit';

  @override
  String get accountKindLoan => 'Pinjaman';

  @override
  String get accountAdd => 'Tambah rekening';

  @override
  String get accountAddSub =>
      'Tunai, tabungan, kartu, atau pinjaman. Tanpa perlu terhubung ke bank.';

  @override
  String get accountEditNew => 'Rekening baru';

  @override
  String get accountNameHint => 'mis. Dompet';

  @override
  String get accountHolds => 'Isinya sekarang';

  @override
  String get accountOwes => 'Utangnya sekarang';

  @override
  String get accountCounted => 'Hitung dalam rencana';

  @override
  String get accountCountedSub => 'Uang di sini bisa dibelanjakan bulan ini.';

  @override
  String accountOwed(String amount) {
    return 'Utang $amount';
  }

  @override
  String get accountNotCounted => 'Tidak dihitung dalam rencana';

  @override
  String get accountConfirm => 'Isi jumlah sebenarnya';

  @override
  String get accountMove => 'Pindahkan uang';

  @override
  String accountMoveTo(String name) {
    return 'Pindah ke $name';
  }

  @override
  String get accountMoveBlurb =>
      'Memindahkan uang antar rekeningmu sendiri bukan pengeluaran maupun pemasukan.';

  @override
  String get accountPayCard => 'Bayar sebagian';

  @override
  String get accountPayBlurb =>
      'Dibayar dari rekening utama. Ini melunasi utang, bukan pengeluaran kedua.';

  @override
  String get accountRemove => 'Hapus rekening ini';

  @override
  String get accountInUse =>
      'Rekening ini punya riwayat, jadi tetap ada. Kamu bisa berhenti menghitungnya.';

  @override
  String get paidFrom => 'Dibayar dari';

  @override
  String get categorySuggested =>
      'Disarankan dari pengeluaranmu sebelumnya. Ketuk yang lain untuk mengubah.';

  @override
  String get recoverTitle => 'Uang yang kembali';

  @override
  String recoverTotal(String amount) {
    return '$amount mungkin kembali. Belum dihitung sampai masuk.';
  }

  @override
  String get recoverReturnable => 'Bisa dikembalikan';

  @override
  String get recoverExpect => 'Dikembalikan, menunggu refund';

  @override
  String get recoverArrived => 'Refund masuk';

  @override
  String get recoverKept => 'Disimpan';

  @override
  String get recoverPending => 'Refund dalam proses';

  @override
  String get recoverRefunded => 'Sudah di-refund';

  @override
  String get recoverPrompt => 'Uang kembali';

  @override
  String recoverWhere(String amount) {
    return '$amount kembali. Mau ke mana?';
  }

  @override
  String recoverToGoal(String goal) {
    return 'Untuk $goal';
  }

  @override
  String get recoverToBuffer => 'Ke dana darurat';

  @override
  String get recoverLeave => 'Biarkan bebas dibelanjakan';

  @override
  String get accountStopCounting => 'Berhenti menghitung dalam rencana';

  @override
  String get moveTitle => 'Langkah terbaik';

  @override
  String get moveTagMove => 'Pindah';

  @override
  String get moveTagWait => 'Tunggu';

  @override
  String get moveTagSave => 'Tabung';

  @override
  String get moveTagSpend => 'Belanja';

  @override
  String moveMove(String amount, String account) {
    return 'Pindahkan $amount dari $account untuk menutup yang wajib dibayar.';
  }

  @override
  String moveMoveWhy(String claim) {
    return '$claim kurang, dan uang ini ada di luar rencana.';
  }

  @override
  String get moveDoIt => 'Pindahkan';

  @override
  String moveWaitGap(String date, String amount) {
    return 'Tahan dulu belanja tambahan: pada $date, yang wajib dibayar akan kurang $amount.';
  }

  @override
  String get moveWaitGapWhy =>
      'Proyeksi menghitung gaji, tagihan, dan biaya hidup sampai hari itu.';

  @override
  String moveWaitPay(int days, String now, String later) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari',
      one: 'satu hari',
    );
    return 'Gajian tinggal $_temp0 lagi. Menunggu mengubah ruang $now jadi $later.';
  }

  @override
  String get moveWaitPayWhy =>
      'Hanya kalau yang kamu inginkan bisa menunggu. Tidak ada yang berisiko.';

  @override
  String moveSave(String amount, String account, String goal) {
    return 'Pindahkan $amount ke $account untuk $goal.';
  }

  @override
  String moveSaveWhy(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari',
      one: 'satu hari',
    );
    return 'Tercapai sekitar $_temp0 lebih cepat, dan sisa yang bebas tetap dua kali bulan biasamu.';
  }

  @override
  String moveSpend(String amount, String date) {
    return 'Kamu aman sampai $date: $amount bebas dipakai.';
  }

  @override
  String get moveSpendWhy =>
      'Tagihan dan tujuan sudah disisihkan, tidak ada yang kurang ke depan, dan ini jauh di atas pengeluaran biasamu.';

  @override
  String get moveNotNow => 'Nanti saja';

  @override
  String get moveNone =>
      'Belum ada langkah yang perlu disarankan. Rencanamu sudah baik.';

  @override
  String monthIncome(String amount) {
    return 'Gaji yang masuk: $amount.';
  }

  @override
  String monthToGoals(String amount) {
    return 'Untuk tujuan: $amount.';
  }

  @override
  String monthNow(String free, String aside) {
    return 'Sekarang: $free bebas dibelanjakan, $aside disisihkan.';
  }

  @override
  String get monthAheadTitle => '30 hari ke depan';

  @override
  String monthAheadBills(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tagihan sebesar $amount.',
      one: 'Satu tagihan sebesar $amount.',
    );
    return '$_temp0';
  }

  @override
  String monthAheadPay(String date) {
    return 'Gaji berikutnya diperkirakan $date.';
  }

  @override
  String monthAheadTightest(String date, String amount) {
    return 'Hari paling ketat $date, dengan $amount bebas.';
  }

  @override
  String monthAheadShort(String date, String amount) {
    return 'Pada $date, yang wajib dibayar akan kurang $amount.';
  }

  @override
  String get monthWorthKnowing => 'Perlu diketahui';

  @override
  String insightUp(String category, String amount) {
    return '$category naik $amount dari bulan sebelumnya.';
  }

  @override
  String insightGoal(int days, String goal) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days hari',
      one: 'satu hari',
    );
    return 'Kalau terus begini, itu sekitar $_temp0 dari $goal setiap bulan.';
  }

  @override
  String get chatSuggestMove => 'Apa yang sebaiknya kulakukan?';

  @override
  String get chatSuggestComing => 'Tagihan apa yang akan datang?';

  @override
  String get chatComingNone =>
      'Tidak ada tagihan dalam 30 hari ke depan. Tambahkan yang kamu bayar di Rencana dan akan kupantau.';

  @override
  String get quickAsk => 'Tanya';

  @override
  String get quickPay => 'Gaji masuk';

  @override
  String get quickBills => 'Tagihan';

  @override
  String get quickMonth => 'Bulanku';

  @override
  String get quickPayDue => 'Waktunya gajian. Beri tahu apakah sudah masuk.';

  @override
  String get chartAvg => 'Rata²';

  @override
  String get flowsTitle => 'Uang masuk dan keluar';

  @override
  String get flowsBlurb =>
      'Per minggu: gaji dan refund di atas garis, belanja dan cicilan di bawah.';

  @override
  String flowsWeek(String date) {
    return 'Minggu $date';
  }

  @override
  String flowsInOut(String moneyIn, String moneyOut) {
    return 'Masuk $moneyIn · Keluar $moneyOut';
  }

  @override
  String get balanceHistoryTitle => 'Saldomu dari waktu ke waktu';

  @override
  String rangeMonths(int count) {
    return '${count}B';
  }

  @override
  String get rangeYear => '1T';

  @override
  String get weekSpentTitle => '7 hari terakhir';

  @override
  String weekSpentTotal(String amount) {
    return '$amount dibelanjakan';
  }

  @override
  String get payGaugeTitle => 'Sampai gajian berikutnya';

  @override
  String payGaugeDaysLabel(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'hari lagi',
      one: 'hari lagi',
    );
    return '$_temp0';
  }

  @override
  String payGaugeAfter(String date, String amount) {
    return 'Setelah gajian $date: $amount bebas';
  }

  @override
  String payGaugeLasts(String amount) {
    return '$amount harus cukup sampai saat itu.';
  }

  @override
  String get goalsOverall => 'dari semua tujuanmu';

  @override
  String goalsThisMonth(String amount) {
    return '+$amount bulan ini';
  }

  @override
  String get goalsNothingThisMonth => 'Belum ada tambahan bulan ini';

  @override
  String get goalsAllOnTrack => 'Semua sesuai jalur';

  @override
  String goalsOnTrackCount(int onTrack, int total) {
    return '$onTrack dari $total sesuai jalur';
  }

  @override
  String goalsNextUp(String goal, String date) {
    return 'Berikutnya: $goal, $date';
  }

  @override
  String get goalsTips => 'Cara mencapainya lebih cepat';

  @override
  String get goalsTipsSub => 'Tanya Upino, dari pengeluaranmu sendiri';

  @override
  String get goalsDetailTitle => 'Tiap tujuan';

  @override
  String get demoTry => 'Coba dengan data contoh';

  @override
  String get demoTrySub =>
      'Empat tujuan, tagihan, dan riwayat tiga bulan, dalam salinan yang bukan milikmu dan tidak disimpan.';

  @override
  String get demoBanner => 'Data contoh: tidak ada yang milikmu atau disimpan.';

  @override
  String get demoExit => 'Keluar';

  @override
  String get demoGoalTrip => 'Liburan';

  @override
  String get demoGoalLaptop => 'Laptop';

  @override
  String get demoGoalEmergency => 'Darurat';

  @override
  String get demoGoalCar => 'Mobil';

  @override
  String get demoBillPhone => 'Pulsa';

  @override
  String get demoBillInternet => 'Internet';

  @override
  String get demoBillGym => 'Gym';

  @override
  String get voiceExample => 'Contoh: “dua puluh lima ribu, makan siang”';

  @override
  String get voiceTitleListening => 'Mendengarkan';

  @override
  String get voiceTitleHeard => 'Terdengar';

  @override
  String get voiceTitleFailed => 'Tidak terdengar';

  @override
  String get voiceStop => 'Berhenti';

  @override
  String get voiceRetry => 'Ulangi';

  @override
  String heroUntil(String date) {
    return 'Sampai $date';
  }

  @override
  String get goalIcon => 'Ikon';

  @override
  String get payGaugeToLast => 'Harus cukup';

  @override
  String get payGaugeNextPay => 'Gaji berikutnya';

  @override
  String get frSelected => 'Dipilih';

  @override
  String get frFromPhone => 'Dari ponselmu';

  @override
  String get frSuggested => 'Disarankan';

  @override
  String get frLangOnPhone => 'Bahasa di ponselmu';

  @override
  String get frLangNotHere => 'Bahasamu belum ada';

  @override
  String get frLangTitle => 'Mari bicara\ndengan bahasamu.';

  @override
  String get frOrChoose => 'Atau pilih';

  @override
  String frContinueIn(String language) {
    return 'Lanjut dalam $language';
  }

  @override
  String frUseCurrency(String currency) {
    return 'Pakai $currency';
  }

  @override
  String get frContinue => 'Lanjut';

  @override
  String get frNothingBeforePayday => 'Tidak ada sebelum gajian';

  @override
  String get frSkipForNow => 'Lewati dulu';

  @override
  String get frLooksLike => 'Sepertinya';

  @override
  String get frCurrencyTitle => 'Kamu dibayar\ndalam mata uang apa?';

  @override
  String get frMore => 'Lainnya';

  @override
  String get frIntentTitle => 'Upino perlu membantumu dalam hal apa?';

  @override
  String get frIntentSub =>
      'Pilih semua yang sesuai. Masing-masing cukup satu angka.';

  @override
  String get frIntentSafe => 'Tahu berapa yang aman kubelanjakan';

  @override
  String get frIntentShort => 'Berhenti kehabisan uang';

  @override
  String get frIntentSave => 'Menabung';

  @override
  String get frIntentDebt => 'Melunasi utang';

  @override
  String get frIntentIrregular => 'Bersiap untuk pengeluaran tak rutin';

  @override
  String get frIntentGoal => 'Mencapai tujuan';

  @override
  String get frIntentUnderstand => 'Lebih memahami uangku';

  @override
  String get frAskSafe => 'Berapa pengeluaranmu dalam sebulan biasa?';

  @override
  String get frAskSafeHint => 'Angka kira-kira sudah cukup.';

  @override
  String get frAskShort => 'Biasanya kurang berapa sebelum gajian?';

  @override
  String get frAskShortHint => 'Yang akhirnya kamu pinjam atau relakan.';

  @override
  String get frAskSave => 'Berapa yang ingin kamu tabung tiap bulan?';

  @override
  String get frAskSaveHint => 'Upino menyisihkannya sebelum kamu belanja.';

  @override
  String get frAskDebt => 'Berapa total utangmu?';

  @override
  String get frAskDebtHint =>
      'Kartu, pinjaman, apa pun yang sedang kamu cicil.';

  @override
  String get frAskIrregular => 'Berapa totalnya dalam setahun?';

  @override
  String get frAskIrregularHint => 'Asuransi, perbaikan, hadiah, biaya.';

  @override
  String get frAskGoal => 'Berapa biaya tujuanmu?';

  @override
  String get frAskGoalHint => 'Nama dan tanggalnya bisa diatur nanti.';

  @override
  String get frAskUnderstand => 'Menurutmu, berapa pengeluaranmu sebulan?';

  @override
  String get frAskUnderstandHint =>
      'Upino akan menunjukkan seberapa dekat tebakanmu.';

  @override
  String frPerMonth(String amount) {
    return '$amount sebulan';
  }

  @override
  String frShortPerMonth(String amount) {
    return 'kurang $amount sebulan';
  }

  @override
  String frOwed(String amount) {
    return 'utang $amount';
  }

  @override
  String frPerYear(String amount) {
    return '$amount setahun';
  }

  @override
  String frToReach(String amount) {
    return 'target $amount';
  }

  @override
  String frPerMonthGuess(String amount) {
    return '$amount sebulan, menurutmu';
  }

  @override
  String get frAdd => 'Tambah';

  @override
  String get frRemove => 'Hapus';

  @override
  String get frIncomeTitle => 'Ceritakan bagaimana uang masuk.';

  @override
  String get frIncomeSub =>
      'Kalau berubah-ubah, pakai yang bisa kamu andalkan.';

  @override
  String get frAddIncome => 'Tambah sumber pemasukan lain';

  @override
  String get frEvery2Weeks => 'Tiap 2 minggu';

  @override
  String get frTwiceMonth => 'Dua kali sebulan';

  @override
  String get frIrregular => 'Tidak tetap';

  @override
  String get frEachPay => 'Tiap pembayaran';

  @override
  String get frAnotherIncome => 'Pemasukan lain';

  @override
  String get frAvailTitle => 'Berapa uang yang tersedia sekarang?';

  @override
  String get frAvailSub =>
      'Uang tunai dan rekening yang kamu pakai belanja, digabung. Jangan hitung tabungan — rekening bisa ditambah satu per satu nanti.';

  @override
  String get frAvailLabel => 'Uang tersedia hari ini';

  @override
  String get frAvailNote => 'Ini akan jadi saldo terkonfirmasi hari ini.';

  @override
  String get frObRent => 'Sewa / KPR';

  @override
  String get frObUtilities => 'Listrik & air';

  @override
  String get frObInsurance => 'Asuransi';

  @override
  String get frObSubscriptions => 'Langganan';

  @override
  String get frSomethingElse => 'Lainnya';

  @override
  String get frObTitle =>
      'Apa yang harus dibayar sebelum pemasukan berikutnya?';

  @override
  String frObSub(String date) {
    return 'Hanya yang jatuh tempo sampai $date. Ketuk masing-masing.';
  }

  @override
  String get frAddAnother => 'Tambah lagi';

  @override
  String get frObNeedsName => 'Tambahkan nama dan jumlah';

  @override
  String get frTapToAdd => 'Ketuk untuk menambah';

  @override
  String get frAmount => 'Jumlah';

  @override
  String get frDue => 'Jatuh tempo';

  @override
  String get frEssTitle =>
      'Kira-kira butuh berapa untuk kebutuhan sehari-hari sampai pemasukan berikutnya?';

  @override
  String frEssSub(String date) {
    return 'Sampai $date. Angka kira-kira sudah cukup.';
  }

  @override
  String get frEssGroceries => 'Belanja dapur';

  @override
  String get frEssGettingAround => 'Transportasi';

  @override
  String get frEssHousehold => 'Rumah tangga';

  @override
  String get frEssEveryday => 'Kebutuhan harian';

  @override
  String get frHelpEstimate => 'Bantu aku memperkirakan';

  @override
  String get frEstimateTitle => 'Perkiraan cepat';

  @override
  String get frEstimateSub => 'Dua ketukan. Angkanya bisa diubah nanti.';

  @override
  String get frPeopleYouCover => 'Orang yang kamu tanggung';

  @override
  String get frWalkBike => 'Jalan kaki atau sepeda';

  @override
  String get frPublicTransport => 'Transportasi umum';

  @override
  String get frCar => 'Mobil';

  @override
  String frUntil(String date) {
    return 'sampai $date';
  }

  @override
  String get frUseThis => 'Pakai ini';

  @override
  String get frProtEmergency => 'Dana darurat';

  @override
  String get frProtTrip => 'Liburan';

  @override
  String get frProtHome => 'Rumah';

  @override
  String get frProtYearly => 'Pengeluaran tahunan';

  @override
  String frMonths(int count) {
    return '$count bulan';
  }

  @override
  String get frProtTitle => 'Ada yang ingin kamu lindungi dengan uangmu?';

  @override
  String get frProtSub =>
      'Opsional. Upino menyisihkan sedikit tiap pembayaran supaya siap tepat waktu.';

  @override
  String get frProtNameHint => 'mis. Asuransi mobil';

  @override
  String get frProtWhatFor => 'Untuk apa?';

  @override
  String get frProtYearlyAmount => 'Berapa, setahun sekali';

  @override
  String get frTarget => 'Target';

  @override
  String get frNextDueIn => 'Jatuh tempo berikutnya dalam';

  @override
  String get frAlreadySaved => 'Sudah terkumpul';

  @override
  String frDay(int n) {
    return 'Hari $n';
  }

  @override
  String get frMoment1Title => 'Hari gajian. Beres.';

  @override
  String get frMoment1Body =>
      'Sewa dan belanja dapur disisihkan begitu uang masuk. Sisanya bebas kamu pakai.';

  @override
  String get frMoment2Title => 'Tiap pengeluaran, 3 detik.';

  @override
  String get frMoment2Body =>
      'Catat, dan angkanya langsung diperbarui. Selalu sesuai hari ini.';

  @override
  String get frMoment3Title => 'Tanya sebelum membeli.';

  @override
  String get frMoment3Body =>
      'Lihat dampak sebuah pembelian ke tagihan dan tujuanmu sebelum bayar.';

  @override
  String get frMoment4Title => 'Tujuan yang terisi sendiri.';

  @override
  String get frMoment4Body =>
      'Sedikit disisihkan tiap pembayaran, dan bulan ditutup dengan ke mana semuanya pergi.';

  @override
  String get frGetStarted => 'Mulai';

  @override
  String frPayArrived(String amount) {
    return 'Gaji masuk  $amount';
  }

  @override
  String get frCoffee => 'Kopi';

  @override
  String get frRecordedNow => 'Baru dicatat';

  @override
  String frAskJacket(String amount) {
    return 'Boleh beli jaket seharga $amount?';
  }

  @override
  String frAskAnswer(String amount, String date) {
    return 'Boleh, dan sewa tetap aman. Kamu masih punya $amount sampai $date. Liburanmu mundur 4 hari.';
  }

  @override
  String get frIfBuyNow => 'Kalau beli sekarang';

  @override
  String frLeft(String amount) {
    return 'Sisa $amount';
  }

  @override
  String get frMonthClosed => 'Bulan ditutup: makan di luar 8% lebih hemat.';

  @override
  String get frOfAllGoals => 'dari semua tujuanmu';

  @override
  String get frWelcome => 'Selamat datang di Upino';

  @override
  String get frWelcomeSub => 'Baru atau kembali, langkahnya sama.';

  @override
  String get frWithApple => 'Lanjut dengan Apple';

  @override
  String get frWithGoogle => 'Lanjut dengan Google';

  @override
  String get frWithEmail => 'Lanjut dengan email';

  @override
  String get frOnDevice => 'Rencanamu dihitung di ponselmu.';

  @override
  String get frTermsPrivacy => 'Ketentuan · Privasi';

  @override
  String get frCheckEmail => 'Cek email-mu';

  @override
  String frCodeSent(String email) {
    return 'Kami mengirim kode 6 digit ke $email.';
  }

  @override
  String get frCodeWhy =>
      'Kami akan mengirim kode. Tak perlu mengingat kata sandi.';

  @override
  String get frSendCode => 'Kirim kode';

  @override
  String get frAvailableNow => 'Tersedia sekarang';

  @override
  String get frProtectedBills => 'Diamankan untuk tagihan & kebutuhan';

  @override
  String get frProtectedGoal => 'Diamankan untuk tujuanmu';

  @override
  String get frPlanReady => 'Rencana keuanganmu sudah siap';

  @override
  String frNotCovered(String amount) {
    return '$amount dari yang harus dibayar belum tertutup.';
  }

  @override
  String frUntilIncome(String date) {
    return 'Sampai pemasukan berikutnya yang diperkirakan pada $date';
  }

  @override
  String get frTakenCare => 'Sudah diurus';

  @override
  String frTakenCareBody(String name, String amount, String date) {
    return '$name, $amount jatuh tempo $date, sudah disisihkan sebelum ada yang bebas dibelanjakan.';
  }

  @override
  String get frBuiltFromAll => 'Disusun dari semua yang kamu ceritakan.';

  @override
  String frGoodEstimate(int count) {
    return 'Perkiraan awal yang bagus. Tambahkan $count detail lagi nanti agar lebih tepat.';
  }

  @override
  String get frGoToPlan => 'Ke rencanaku';

  @override
  String get frSafeToSpend => 'Aman dibelanjakan';

  @override
  String get frGapsTitle => 'Buat angka aman dibelanjakan lebih akurat';

  @override
  String get frGapEssentials => 'Tambah kebutuhan sehari-hari';

  @override
  String get frGapYearly => 'Tambah biaya tahunan, seperti asuransi';

  @override
  String get frGapBill => 'Tambah tagihan yang jatuh tempo sebelum gajian';

  @override
  String frSeconds(int count) {
    return '~$count dtk';
  }

  @override
  String get frEssentialsSheet => 'Kebutuhan sehari-hari sampai gajian';
}
