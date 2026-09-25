// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get navHome => 'ホーム';

  @override
  String get navPlan => 'プラン';

  @override
  String get navGoals => '目標';

  @override
  String get navActivity => '履歴';

  @override
  String get navProfile => 'プロフィール';

  @override
  String get currencyTitle => 'どの通貨ですか？';

  @override
  String get currencyBlurb => 'プランのすべてがこの通貨で管理されます。実際に給料を受け取る通貨を選んでください。';

  @override
  String get currencySearchHint => '国名・通貨名・コードで検索';

  @override
  String currencyNoMatch(String query) {
    return '「$query」に一致するものはありません。国名か3文字のコードで試してください。';
  }

  @override
  String get onboardingBadge => '約1分で完了';

  @override
  String get onboardingTitle => 'プランを作成';

  @override
  String get onboardingBlurb => '始めるには2つの答えで十分です。ほかは後でかまいません。';

  @override
  String get onboardingBalanceLabel => '今日の残高';

  @override
  String get onboardingBalanceHint => '実際に使えるお金。手をつけないつもりのお金は含めません。';

  @override
  String get onboardingIncomeLabel => '月の収入はいくらですか？';

  @override
  String get onboardingIncomeHint => '変動する場合は幅で入力してください。プランは低いほうの額で組まれます。';

  @override
  String get onboardingPayDay => '次の給料日はいつですか？';

  @override
  String onboardingDays(int count) {
    return '$count日';
  }

  @override
  String get onboardingCommitments => '固定の支出を追加';

  @override
  String get onboardingCommitmentsOpen => '家賃、生活費、目標';

  @override
  String get onboardingCommitmentsShut => '任意です。後でもできます';

  @override
  String get onboardingRentLabel => '家賃と固定の請求';

  @override
  String get onboardingRentHint => '次の給料日より前が期限';

  @override
  String get onboardingEssentialsLabel => '食費と交通費';

  @override
  String get onboardingEssentialsHint => 'この期間を乗り切るのに必要な額';

  @override
  String get onboardingGoalLabel => '目標のための貯金';

  @override
  String get onboardingGoalHint => 'この期間に取っておきたい額';

  @override
  String get onboardingFinish => 'プランを作成';

  @override
  String get onboardingIncomplete => '続けるには最初の2つに答えてください';

  @override
  String get tapToType => 'タップして入力';

  @override
  String get heroSafeToSpend => '今使っても安心な額';

  @override
  String get heroNotUpToDate => '最新ではありません';

  @override
  String get heroRecordSpend => '支出を記録';

  @override
  String get heroSeeShort => '不足を見る';

  @override
  String get heroConfirmBalance => '残高を確認';

  @override
  String get heroReviewBlurb => 'この数字を再び信頼できるよう、残高を確認してください。';

  @override
  String heroUntilSetAside(String date, String amount) {
    return '$dateまで · $amountを確保済み';
  }

  @override
  String heroShort(String amount) {
    return '$amount不足';
  }

  @override
  String heroUnfunded(String label, String amount) {
    return '$label · $amount未確保';
  }

  @override
  String get heroBalanceNever => '残高はまだ確認されていません';

  @override
  String get heroBalanceToday => '残高は今日確認済み';

  @override
  String get heroBalanceYesterday => '残高は昨日確認済み';

  @override
  String heroBalanceDays(int count) {
    return '残高は$count日前に確認';
  }

  @override
  String get confirm => '確認';

  @override
  String get homeTitle => 'あなたのプラン';

  @override
  String homeUntilTotal(String date, String amount) {
    return '$dateまで · 合計$amount';
  }

  @override
  String homeRecorded(String amount) {
    return '$amountを記録しました';
  }

  @override
  String get homeAttention => '確認が必要です';

  @override
  String homeNotCovered(String amount) {
    return '$amountが不足';
  }

  @override
  String get homeAfterNextPay => '次の給料日の後';

  @override
  String homeOncePayArrives(String date) {
    return '$dateに給料が入ったら';
  }

  @override
  String get homeSetAsideFirst => '先に確保';

  @override
  String get homeProtectedBlurb => '使えるお金より先に守られます。';

  @override
  String get homeNothingSetAside => 'まだ何も確保されていません。持っているお金はすべて使えます。';

  @override
  String get homeWhyThisNumber => 'この数字の理由';

  @override
  String get homeWhatIsShort => '不足しているもの';

  @override
  String get homeShortBlurb => 'ここでは何も動かしたり延期したりしません。今のお金ではまかなえない支払いです。';

  @override
  String get askSpendTitle => 'いくら使いましたか？';

  @override
  String get askBalanceTitle => '今の残高はいくらですか？';

  @override
  String get askBalanceBlurb => '差額は支出ではなく、修正として記録されます。';

  @override
  String get whyNoChange => '前回のプランから何も変わっていません。';

  @override
  String get whyPayArrived => '給料が入ったので、プランを更新しました。';

  @override
  String get whyBillPaid => 'お金を確保していた請求が支払われました。';

  @override
  String get whyHeldForBill => '次の給料日の直後が期限の請求のため、お金を確保しています。';

  @override
  String get whyOvercommitted => '今あるお金より多くの支払いを約束しています。';

  @override
  String get whyStale => '残高が最近確認されていません。';

  @override
  String get whyCardLarger => 'カードの残高が手元のお金より多くなっています。';

  @override
  String get whyPayLate => '予定の給料がまだ入っていません。';

  @override
  String get whyOverdue => '期限を過ぎたものがあります。';

  @override
  String get whyBufferShort => '予備資金が満額になっていません。';

  @override
  String get whyGoalShort => '貯金目標を今は満額確保できません。';

  @override
  String get whyFlexibleLess => '柔軟な目標への配分が予定より少なくなりました。';

  @override
  String get whyDuplicate => '重複した取引は1回だけ数えました。';

  @override
  String get planTitle => 'プラン';

  @override
  String get planBlurb => '使えるお金になる前に、決まっている使い道。';

  @override
  String get planMoneyAndIncome => 'お金と収入';

  @override
  String get planMoneyYouHave => '手元のお金';

  @override
  String get planNextPay => '次の給料';

  @override
  String get planYourNextPay => '次の給料';

  @override
  String get planNotSet => '未設定';

  @override
  String get planExpectedBlurb => 'まだ予定なので、今使えるお金には含めません。';

  @override
  String get planSetAsideFirst => '先に確保';

  @override
  String get planNothingSetAside => '何も確保されていないので、すべて使えます。';

  @override
  String get planAddToPlan => 'プランに追加';

  @override
  String get planGoals => '目標';

  @override
  String get planSaveToward => '何かのために貯める';

  @override
  String get planSaveTowardSub => '旅行、敷金、新しいノートPC';

  @override
  String get planAllGoals => 'すべての目標';

  @override
  String get planAllGoalsSub => '追加・編集・お金を取っておく';

  @override
  String get planHowMuchSetAside => 'これにいくら確保する必要がありますか？';

  @override
  String get planChangeOrRemove => '金額を変えるか、プランから外します。';

  @override
  String get planRemove => 'プランから外す';

  @override
  String planDue(String date) {
    return ' · 期限 $date';
  }

  @override
  String get priorityMandatory => '必ず払うもの — 最優先';

  @override
  String get priorityEssential => '日々の必需品';

  @override
  String get priorityBuffer => '緊急用に確保';

  @override
  String get priorityCard => 'カードで使用済み';

  @override
  String get prioritySinkingFund => '決まった請求のための積立';

  @override
  String get priorityGoal => '約束した目標';

  @override
  String get priorityDiscretionary => 'あると嬉しいもの — 最初に譲る';

  @override
  String get goalsTitle => '目標';

  @override
  String get goalsBlurbEmpty => 'まだ貯めているものはありません。';

  @override
  String get goalsBlurb => '各目標がこの給料期間に必要な額。';

  @override
  String get goalsEmptyCard =>
      '旅行、敷金、新しいノートPCなど、貯めているものを追加しましょう。Upinoが毎回の給料からいくら確保すれば間に合うかを計算します。';

  @override
  String get goalsNew => '新しい目標';

  @override
  String get goalsNewSub => 'お金を取っておきたいもの';

  @override
  String get goalsAddMoney => 'お金を追加';

  @override
  String goalsAddTo(String name) {
    return '$nameに追加';
  }

  @override
  String get goalsAddBlurb => '取っておいた額を記録します。お金は使われません — これから確保する額が減ります。';

  @override
  String get goalsEachPeriod => '給料期間ごと';

  @override
  String get goalsTargetDate => '目標日';

  @override
  String goalsOf(String amount) {
    return '$amount中';
  }

  @override
  String goalsPeriodsToGo(int count) {
    return 'あと$count回の給料期間';
  }

  @override
  String get goalsDone => '満額達成';

  @override
  String get goalsPausedStatus => '一時停止 — 確保なし';

  @override
  String get goalsFlexibleStatus => '柔軟 — 必ず払うものを優先';

  @override
  String get goalEditNew => '何のために貯めますか？';

  @override
  String get goalEditExisting => '目標を編集';

  @override
  String get goalName => '名前';

  @override
  String get goalNameHint => '旅行、敷金、ノートPC';

  @override
  String get goalTotal => '合計でいくら';

  @override
  String get goalByWhen => 'いつまでに';

  @override
  String goalMonths(int count) {
    return '$countか月';
  }

  @override
  String get goalOneYear => '1年';

  @override
  String get goalTwoYears => '2年';

  @override
  String get goalFirmness => 'どのくらい確実に？';

  @override
  String get goalKindHard => '確定';

  @override
  String get goalKindHardSub => '使えるお金より先に確保';

  @override
  String get goalKindFlexible => '柔軟';

  @override
  String get goalKindFlexibleSub => '必ず払うものを優先';

  @override
  String get goalKindPaused => '一時停止';

  @override
  String get goalKindPausedSub => '表示は残り、確保はしない';

  @override
  String get goalSaveChanges => '変更を保存';

  @override
  String get goalAddThis => 'この目標を追加';

  @override
  String get goalDelete => 'この目標を削除';

  @override
  String get activityTitle => '履歴';

  @override
  String get activityBlurb => '記録したすべて、新しい順。';

  @override
  String get activityEmpty => '支出を記録するとここに表示されます。間違えた場合は削除できます。';

  @override
  String get activityRemoveIt => '削除する';

  @override
  String get activityKeepIt => '残す';

  @override
  String get activitySpent => '支出';

  @override
  String get activityIncome => '給料';

  @override
  String get activityCorrection => '修正';

  @override
  String get activityRemoved => '削除済み';

  @override
  String get profileTitle => 'プロフィール';

  @override
  String get profileConfirmBalance => '残高を確認';

  @override
  String get profileTrustTitle => 'この数字はどのくらい確かですか？';

  @override
  String get profileTrustFresh => '最新です。対応が必要なものはありません。';

  @override
  String get profileTrustDegraded => 'しばらく残高が確認されていません。数字は表示されますが、確実性は下がっています。';

  @override
  String get profileTrustReview => '古すぎるか不確かすぎて頼れません。残高を確認して直してください。';

  @override
  String get profileConfirmedNever => 'まだ確認されていません';

  @override
  String get profileConfirmedToday => '今日確認済み';

  @override
  String get profileConfirmedYesterday => '昨日確認済み';

  @override
  String profileConfirmedDays(int count) {
    return '$count日前に確認';
  }

  @override
  String get profileAppearance => '表示';

  @override
  String get profileTheme => 'テーマ';

  @override
  String get profileThemeBlurb => '標準では端末の設定に従うので、何も押し付けません。';

  @override
  String get themePhone => '端末';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get profileLanguage => '言語';

  @override
  String get profileLanguageBlurb => '標準では端末の設定に従うので、何も押し付けません。';

  @override
  String get languagePhone => '端末';

  @override
  String get profileCurrency => '通貨';

  @override
  String currencyChangeTitle(String currency) {
    return '$currencyに切り替えますか？';
  }

  @override
  String currencyChangeBlurb(String currency) {
    return 'プランのすべての金額は数値はそのままで、今後は$currencyで表示されます。為替レートでの換算はしないので、通貨の訂正に使ってください。お金の換算用ではありません。';
  }

  @override
  String get currencyChangeConfirm => '切り替える';

  @override
  String get profileYourData => 'あなたのデータ';

  @override
  String get profileDelete => 'プランを削除';

  @override
  String get profileDeleteSub => 'すべて消去して設定に戻ります';

  @override
  String get profileStartOver => '最初からやり直しますか？';

  @override
  String get profileStartOverBlurb => 'プランと記録したすべてが削除されます。元に戻せません。';

  @override
  String get profileDeleteEverything => 'すべて削除';

  @override
  String get profileKeepPlan => 'プランを残す';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String activityRemoveAmount(String amount) {
    return '$amountを削除しますか？';
  }

  @override
  String get activityRemoveDetail =>
      'すぐにプランの計算から外れます。記録が完全に残るよう、この一覧には削除済みとして残ります。';

  @override
  String get activityCardPurchase => 'カード払い';

  @override
  String get activityCardPayment => 'カードの支払い';

  @override
  String get activityRefund => '返金';

  @override
  String get activityTransfer => '口座間の移動';

  @override
  String get activityLoan => '借入';

  @override
  String get activityDebtPayment => '返済';

  @override
  String get activityBalanceCorrected => '残高を修正';

  @override
  String get activityBlurbEmpty => 'まだ記録はありません。';

  @override
  String get profileStartAgain => '最初から';

  @override
  String get claimRent => '家賃と請求';

  @override
  String get claimCardMinimum => 'カードの最低支払額';

  @override
  String get claimEssentials => '食費と交通費';

  @override
  String get claimBuffer => '緊急用の予備';

  @override
  String get languageTitle => 'どの言語ですか？';

  @override
  String get languageBlurb => '後でプロフィールから変更できます。';

  @override
  String get profileLedgerTitle => '記録は揃っていますか？';

  @override
  String get ledgerComplete => '使ったお金はすべて記録されています。';

  @override
  String get ledgerPartial => '残高を確認したときに初めて見つかった支出があります。';

  @override
  String get ledgerUnknown => 'どれだけ抜けているか分かりません。残高を確認して確かめてください。';

  @override
  String get askTitle => '使う前に聞く';

  @override
  String get askBlurb => '買い物をプランに当てはめて試せます。何も記録されず、何も変わりません。';

  @override
  String get askAmountLabel => 'いくらですか？';

  @override
  String get askRun => '影響を見る';

  @override
  String get askDoNotBuy => '買わない';

  @override
  String get askBuyNow => '今日買う';

  @override
  String askBuyAfter(String date) {
    return '$date以降に買う';
  }

  @override
  String get askUnchanged => 'プランはそのままです。';

  @override
  String get askStsAfter => 'その後に使っても安心な額';

  @override
  String get askBreaks => '必ず払うものが不足します。';

  @override
  String get askSafe => '必ず払うものは不足しません。';

  @override
  String get askCosts => '減るもの';

  @override
  String askCostLine(String label, String amount) {
    return '$label · $amount減少';
  }

  @override
  String get askWaitingHelps => '給料まで待てば、すべてまかなえます。';

  @override
  String get askNoIncome => '給料の予定がまだないため、後と比べられません。';

  @override
  String askAssumption(String date) {
    return '給料が$dateに予定どおり入る前提です。';
  }

  @override
  String get askNoVerdict => 'Upinoは買う・買わないを決めません。判断はあなたのものです。';

  @override
  String get receipt => 'レシート';

  @override
  String get receiptAdd => 'レシートを追加';

  @override
  String get receiptCamera => '写真を撮る';

  @override
  String get receiptGallery => '写真を選ぶ';

  @override
  String get receiptAttached => 'レシート添付済み';

  @override
  String get receiptRemove => '写真を外す';

  @override
  String get onboardingIncomeFrom => '最低';

  @override
  String get onboardingIncomeTo => '最高';

  @override
  String get onboardingIncomeToOptional => '任意';

  @override
  String incomeRange(String low, String high) {
    return '$low〜$high';
  }

  @override
  String incomeRangeNote(String low) {
    return 'プランは$lowで組まれます。それを超えた分は、入ったときにあなたのものです。';
  }

  @override
  String get categoryFood => '食費';

  @override
  String get categoryTransport => '交通';

  @override
  String get categoryBills => '請求';

  @override
  String get categoryShopping => '買い物';

  @override
  String get categoryHealth => '健康';

  @override
  String get categoryFun => '外出';

  @override
  String get categoryOther => 'その他';

  @override
  String get categoryUnsorted => '未分類';

  @override
  String get categoryPrompt => '何に使いましたか？';

  @override
  String get spendingTitle => '使い道';

  @override
  String get spendingWindow => '過去30日に記録した支出';

  @override
  String get backupSection => 'バックアップ';

  @override
  String get backupSave => 'バックアップを保存';

  @override
  String get backupSaveSub => 'パスワードで保護されます。クラウドなど安全な場所に保存してください。';

  @override
  String get backupRestore => 'バックアップから復元';

  @override
  String get backupRestoreSub => 'この端末のプランを置き換えます';

  @override
  String get backupPassword => 'パスワード';

  @override
  String get backupPasswordRepeat => 'パスワードをもう一度';

  @override
  String get backupPasswordSaveBlurb =>
      '復元にはこのパスワードが必要です。忘れると取り戻せません。レシートの写真は含まれません。';

  @override
  String get backupPasswordOpenBlurb => 'このバックアップを保存したときのパスワード。';

  @override
  String get backupPasswordShort => '6文字以上';

  @override
  String get backupPasswordMismatch => '2つが一致しません';

  @override
  String get backupOpen => '開く';

  @override
  String get backupReplaceTitle => 'このプランを置き換えますか？';

  @override
  String get backupReplaceBlurb => 'この端末のすべてがバックアップの内容に置き換わります。元に戻せません。';

  @override
  String get backupReplace => '置き換える';

  @override
  String get backupRestored => 'バックアップを復元しました';

  @override
  String get backupWrongPassword => 'このパスワードでは開けません。';

  @override
  String get backupNotABackup => 'このファイルはUpinoのバックアップではありません。';

  @override
  String get backupUnreadable =>
      'このバックアップは新しいバージョンのUpinoで作られました。アプリを更新してもう一度お試しください。';

  @override
  String get inflationTitle => 'インフレ';

  @override
  String get inflationNotSet => '未設定です。お住まいの地域の年率を入れると、目標の実際の費用が分かります。';

  @override
  String inflationRate(String rate) {
    return '年$rate%';
  }

  @override
  String get inflationDialogTitle => '年間インフレ率';

  @override
  String get inflationDialogBlurb =>
      '物価が上がるため、今のお金で決めた目標は期日にはもっと高くなります。予想する率を入力してください。空欄にすると無効になります。';

  @override
  String goalsInflated(String rate, String amount) {
    return '年$rate%なら、その頃には約$amountかかります。';
  }

  @override
  String get holdingsTitle => 'その他の資産';

  @override
  String get holdingsBlurb => 'ドル、金、コイン。プランの横に表示され、使えるお金には決して含めません。';

  @override
  String get holdingsAdd => '資産を追加';

  @override
  String get holdingsAddSub => '使えるお金には含めません';

  @override
  String get holdingsTotal => '合計';

  @override
  String holdingSummary(String quantity, String price, String date) {
    return '$quantity × $price · $date時点';
  }

  @override
  String get holdingEditNew => '新しい資産';

  @override
  String get holdingEditExisting => '資産を変更';

  @override
  String get holdingName => '何ですか？';

  @override
  String get holdingNameHint => '米ドル、金…';

  @override
  String get holdingUsd => '米ドル';

  @override
  String get holdingEur => 'ユーロ';

  @override
  String get holdingGold => '金（グラム）';

  @override
  String get holdingCoin => '金貨';

  @override
  String get holdingQuantity => '数量';

  @override
  String get holdingUnitPrice => '今日の1つあたりの価値';

  @override
  String holdingWorth(String amount) {
    return '合計$amount相当';
  }

  @override
  String get holdingDelete => 'この資産を削除';

  @override
  String get fasterTitle => 'すばやく入力';

  @override
  String get smsTitle => '銀行のSMSを読む';

  @override
  String get smsDetail =>
      '銀行からSMSで届いた支出を、1タップで記録できるよう提案します。メッセージはこの端末でのみ読まれ、どこにも送られません。';

  @override
  String get smsDenied => 'Upinoはメッセージを読む許可がありません。端末の設定で許可できます。';

  @override
  String smsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '確認する銀行メッセージが$count件',
      one: '確認する銀行メッセージが1件',
    );
    return '$_temp0';
  }

  @override
  String get smsWaitingSub => '1タップで記録するか、スキップ';

  @override
  String get smsReviewTitle => '銀行から';

  @override
  String get smsReviewBlurb => '「記録」をタップするまで何も記録されません。金額をメッセージと照らし合わせてください。';

  @override
  String get smsReviewDone => 'すべて確認済みです。';

  @override
  String get smsRecord => '記録';

  @override
  String get smsSkip => 'スキップ';

  @override
  String get reminderTitleSetting => '夜のリマインダー';

  @override
  String get reminderDetail => '夜9時に、記録がなかった日だけ。';

  @override
  String get reminderDenied => 'Upinoは通知を表示する許可がありません。端末の設定で許可できます。';

  @override
  String get reminderTitle => '今日は何か使いましたか？';

  @override
  String get reminderBody => '数秒で記録して、明日の数字を正しく。';

  @override
  String get reminderChannel => '夜のリマインダー';

  @override
  String get widgetSpend => '+ 支出';

  @override
  String get widgetAdd => 'ホーム画面に追加';

  @override
  String get widgetAddSub => 'アプリを開かずに、使える額と支出の記録ボタン';

  @override
  String get voiceListening => '聞いています…金額と使い道を話してください。';

  @override
  String voiceHeard(String text) {
    return '聞き取り：「$text」。金額を確認して保存してください。';
  }

  @override
  String get voiceNothing => '金額が聞き取れませんでした。もう一度話すか、入力してください。';

  @override
  String get voicePrivacy =>
      '音声は端末でテキストに変換されます。オフライン音声認識のない端末では、端末の音声サービスを通ります。';

  @override
  String get voiceButton => '話す';

  @override
  String get voiceUnavailable => 'この端末には使える音声認識がありません。金額を入力してください。';

  @override
  String get voiceNoPermission => 'Upinoはマイクを使う許可がありません。端末の設定で許可できます。';

  @override
  String get voiceNetwork => 'この端末の音声認識にはインターネットが必要ですが、接続できませんでした。';

  @override
  String voiceNoAmount(String text) {
    return '「$text」と聞こえましたが、金額がありません。もう一度話すか、入力してください。';
  }

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get navAsk => '質問';

  @override
  String get alertsTitle => '対応が必要';

  @override
  String get alertsEmpty => '今は対応が必要なものはありません。プランは最新です。';

  @override
  String alertUnfunded(String label, String amount) {
    return '$labelが$amount不足';
  }

  @override
  String get alertUnfundedDetail => '必ず払うものが、手元のお金でまかなえていません。';

  @override
  String alertIncomeLate(String date) {
    return '給料は$dateの予定でした';
  }

  @override
  String get alertIncomeLateDetail => '入るまでは計算に含めません。日付が変わった場合はプランで変更してください。';

  @override
  String alertGoalBehind(String name, String amount) {
    return '$nameはこの期間$amount遅れています';
  }

  @override
  String get alertGoalBehindDetail => '手元のお金では、この期間の目標分に届きません。';

  @override
  String get chatHint => '何でも聞いてください。価格を入力してもOK';

  @override
  String get chatSuggestSafe => 'いくら使えますか？';

  @override
  String get chatSuggestPay => '次の給料はいつ？';

  @override
  String get chatSuggestWhere => 'お金はどこに消えた？';

  @override
  String get chatSuggestAside => '何が確保されていますか？';

  @override
  String chatSafe(String amount, String date) {
    return '$dateまで$amount使えます。';
  }

  @override
  String get chatSafeStale => 'ひとつだけ：残高の確認が必要なので、これは目安と考えてください。';

  @override
  String chatPay(String amount, String date) {
    return '次の給料は$amount、$dateの予定です。';
  }

  @override
  String get chatPayNone => '次の給料がまだ分かりません。プランで追加してくれれば見守ります。';

  @override
  String get chatWhere => '過去30日の使い道はこちら：';

  @override
  String get chatWhereNone => '過去30日の支出はありません。静かな月だったか、記録されていないかです。';

  @override
  String chatAside(String amount) {
    return '使えるお金になる前に$amountが確保されています：';
  }

  @override
  String chatPurchase(String amount) {
    return '$amountでどうなるか見てみましょう。';
  }

  @override
  String get chatHelp =>
      'うーん、よく分かりませんでした。使える額、給料日、お金の使い道、確保されているもの、節約の方法をお答えできます。「スマホ10万円」のように価格を入力すれば、買った場合の影響もお見せします。';

  @override
  String get chatHelloNew =>
      'こんにちは！Upinoです。はじめてなので、今は基本だけ知っています：残高、給料、確保しているもの。それだけでも使える額や買い物の影響はお伝えできます。支出を記録し続けてくれれば、ひと季節ほどで習慣が分かり、あなた専用のお金のアドバイザーになれます。';

  @override
  String chatHelloLearning(int days, int spends, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days日',
      one: '1日',
    );
    String _temp1 = intl.Intl.pluralLogic(
      spends,
      locale: localeName,
      other: '$spends件の支出',
      one: '1件の支出',
    );
    return 'おかえりなさい！ここまで$_temp0と$_temp1から学んでいます。あと約$remaining日でひと季節分になります。';
  }

  @override
  String chatHelloFamiliar(int days) {
    return 'おかえりなさい！もう$days日分のお金を見てきたので、節約の方法も含めて何でも聞いてください。';
  }

  @override
  String chatHelloAlerts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '対応が必要なものが$countつ',
      one: '対応が必要なものが1つ',
    );
    return 'ところで、$_temp0あります：ベルの中です。';
  }

  @override
  String chatPurchaseFits(String left) {
    return '今日買っても必ず払うものはすべてまかなえ、$leftの余裕が残ります。';
  }

  @override
  String chatPurchaseWait(String date) {
    return '今日買うと、必ず払うものが不足します。$dateまで待てば、すべてまかなえます。';
  }

  @override
  String chatPurchaseStillShort(String date) {
    return '注意：$dateの給料の後でも、必ず払うものが不足します。';
  }

  @override
  String get chatPurchaseShort => '今日買うと、必ず払うものが不足します。';

  @override
  String chatSafeNothing(String date) {
    return '今は$dateまで余裕がありません：手元のお金はすべて必ず払うものに回っています。';
  }

  @override
  String chatPayIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'あと$days日',
      one: 'あと1日',
    );
    return '$_temp0です。';
  }

  @override
  String get chatPayLate => '遅れているので、入ったと確認するまで計算に含めません。';

  @override
  String get chatPayRange => 'プランは低いほうの額で組んでいるので、良い月はボーナスで、穴にはなりません。';

  @override
  String chatWhereSoFar(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days日',
      one: '1日',
    );
    return 'まだ$_temp0分しか見ていないので、まずはざっくり：';
  }

  @override
  String chatWhereTop(String category, int share) {
    return '一番多いのは$category：全体の$share%です。';
  }

  @override
  String get chatWhereTooSoon =>
      'それには少し早いです：支出をほとんど見ていません。いくつか記録して、来週また聞いてください。';

  @override
  String get chatAdviceTooSoon =>
      'お手伝いしたいのですが、正直まだあなたの支出をよく知りません。それなしの助言はただの推測です。支出を記録して（分類すると大いに役立ちます）、数週間後にまた聞いてください。';

  @override
  String chatAdviceBiggest(String category, String amount, String tenth) {
    return '過去30日で一番大きかった支出は$categoryで$amountでした。1割減らせば月に約$tenth浮きます。';
  }

  @override
  String get chatAdviceSort =>
      '支出額は見えますが、何に使ったかは分かりません。記録するときに分類を付けてくれれば、どこを削れるかお伝えできます。';

  @override
  String chatAdviceMore(String amount) {
    return '前月より$amount多く使いました。';
  }

  @override
  String chatAdviceLess(String amount) {
    return 'いいですね：前月より$amount少ないです。';
  }

  @override
  String get chatAdviceLearning => 'まだ習慣を学んでいる途中なので、全体像ではなく最初のヒントとして受け取ってください。';

  @override
  String get chatSmallHello => 'こんにちは！お金について何を知りたいですか？';

  @override
  String get chatSmallThanks => 'いつでもどうぞ！使う前にはいつでも聞いてください。';

  @override
  String get chatSmallWho =>
      'Upinoのアシスタントです。プランにあることだけを知っていて、数字はすべてそこから出しています。話したことはこの端末から出ません。買う・買わないは言いませんが、それぞれの選択で何が残るかをお見せします。';

  @override
  String get chatSuggestAdvice => 'どうすれば節約できますか？';

  @override
  String get chatTitle => 'Upino';

  @override
  String get chatNew => '新しいチャット';

  @override
  String get chatResumed => 'ここでの答えは、今日のプランから計算しています。';

  @override
  String get chatWhy => '数字はこうして出ています：';

  @override
  String get chatWhyHave => '手元のお金';

  @override
  String get chatWhySetAside => '先に確保';

  @override
  String get chatWhyLeft => '使っても安心な額';

  @override
  String get chatSmallHowAreYou => '元気です、ありがとう！お金はそのままです。何を知りたいですか？';

  @override
  String get chatSmallBye => 'またね！次の大きな買い物の前にどうぞ。';

  @override
  String get chatSmallOkay => 'ほかに確認したいことはありますか？';

  @override
  String get askHubTitle => 'Upinoと話す';

  @override
  String get askHubNew =>
      '使える額、買い物の影響、給料日などを聞いてください。まだあなたを知る途中なので、記録するほど役立つようになります。';

  @override
  String askHubLearning(int days) {
    return '習慣を学んでいます：あと約$days日でひと季節分のデータになります。';
  }

  @override
  String get askHubFamiliar => 'もうあなたのお金をよく知っています。節約の方法も含めて何でも聞いてください。';

  @override
  String get askHubStart => '会話を始める';

  @override
  String get askHubCommon => 'よくある質問';

  @override
  String get askHubHistory => 'あなたの会話';

  @override
  String askHubTurns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countつの質問',
      one: '1つの質問',
    );
    return '$_temp0';
  }

  @override
  String askHubAsidePreview(String amount, int count) {
    return '$count件の支払いに$amountを確保';
  }

  @override
  String get askHubDeleteTitle => 'この会話を削除しますか？';

  @override
  String get askHubDeleteBlurb => '会話だけが消えます。プランは何も変わりません。';

  @override
  String get chatSmallHi => 'こんにちは！';

  @override
  String get chatSmallHiFine => 'こんにちは！元気です、ありがとう。';

  @override
  String chatSafeLasts(int days) {
    return 'これで給料まで$days日やりくりします。';
  }

  @override
  String homeSpokenFor(String amount, String date) {
    return '$dateまで、あなたのお金のうち$amountはすでに使い道が決まっています。';
  }

  @override
  String askGoalLater(String goal, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days日',
      one: '1日',
    );
    return '$goal · 約$_temp0遅れる';
  }

  @override
  String get askGoalsTitle => '目標が遅れます';

  @override
  String get askGoalsNote => '各目標の積立ペースでのおおよその目安です。';

  @override
  String chatPurchaseGoal(String goal, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days日',
      one: '1日',
    );
    return '$goalが約$_temp0遅れます。';
  }

  @override
  String get monthTitle => '今月の振り返り';

  @override
  String get monthWindow => '過去30日と、その前の30日の比較';

  @override
  String monthTooSoon(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'あと$days日',
      one: 'あと1日',
    );
    return '振り返りには1か月分の支出が必要です。$_temp0で準備できます。';
  }

  @override
  String monthSpent(String amount) {
    return '過去30日で$amountが出ていきました。';
  }

  @override
  String get monthNothing => '過去30日は何も記録されていません。';

  @override
  String monthMore(String amount) {
    return 'その前の30日より$amount多いです。';
  }

  @override
  String monthLess(String amount) {
    return 'その前の30日より$amount少ないです。';
  }

  @override
  String get monthSame => 'その前の30日とほぼ同じです。';

  @override
  String monthUp(String category, String amount) {
    return '一番増えたのは$categoryで、$amount増。';
  }

  @override
  String monthDown(String category, String amount) {
    return '一番減ったのは$categoryで、$amount減。';
  }

  @override
  String monthGoals(int onTrack, int total) {
    return '順調な目標：$total件中$onTrack件。';
  }

  @override
  String get chatSuggestMonth => '今月はどうだった？';

  @override
  String get timelineTitle => 'これからのお金';

  @override
  String get timelineToday => '今日';

  @override
  String get timelineNow => '今';

  @override
  String get timelineProjected => '予測';

  @override
  String get timelineRecorded => '記録';

  @override
  String get timelineFree => '使えるお金';

  @override
  String get timelineHad => 'あった額';

  @override
  String timelineBalance(String amount) {
    return '残高 $amount';
  }

  @override
  String timelineSetAside(String amount) {
    return '確保 $amount';
  }

  @override
  String timelinePayMark(String amount) {
    return '給料 $amount';
  }

  @override
  String timelineShort(String amount) {
    return '必ず払うものに$amount不足';
  }

  @override
  String timelineWithout(String amount) {
    return 'なしの場合：$amount';
  }

  @override
  String get timelineBuyAfterPay => '給料後に買う';

  @override
  String get timelineBalanceLegend => '残高';

  @override
  String get timelineWithPurchase => '購入した場合';

  @override
  String get timelinePay => '給料日';

  @override
  String get timelineAssumptions =>
      '先の部分は予測です：給料はその日に、請求はそれぞれの日に、生活費は均等に使うとし、それ以外は含みません。グラフをなぞるとどの日でも見られます。';

  @override
  String get timelineSemantics => '残高と使えるお金の日ごとのグラフ';

  @override
  String goalChartSemantics(String goal) {
    return '$goalが目標に届くまでのグラフ';
  }

  @override
  String goalChartTarget(String amount, String date) {
    return '目標 $dateまでに$amount';
  }

  @override
  String goalPaceLabel(String amount) {
    return '給料期間ごとに確保：$amount';
  }

  @override
  String goalOnTrack(String date) {
    return '順調：$dateまでに達成。';
  }

  @override
  String goalLate(String date, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days日',
      one: '1日',
    );
    return 'このペースだと$dateに達成、期日から$_temp0遅れます。';
  }

  @override
  String get goalNotMoving => '今は何も入っていないので、近づいていません。';

  @override
  String goalUsePace(String date) {
    return '目標日を$dateに変更';
  }

  @override
  String get goalPaceNote => '試算だけです：選ぶまで何も変わりません。';

  @override
  String get goalShowPath => '達成までの道のりを見る';

  @override
  String get goalHidePath => '閉じる';

  @override
  String get billsTitle => '請求とサブスク';

  @override
  String get billAdd => '請求やサブスクを追加';

  @override
  String get billAddSub => '携帯、ネット、保険、動画配信…それぞれ期日前に確保されます。';

  @override
  String get billEditNew => '新しい請求';

  @override
  String get billEditExisting => 'この請求を変更';

  @override
  String get billName => '何ですか？';

  @override
  String get billNameHint => '例：インターネット';

  @override
  String get billAmount => '1回の支払額';

  @override
  String get billEvery => '頻度';

  @override
  String get billEveryWeek => '毎週';

  @override
  String get billEveryMonth => '毎月';

  @override
  String get billEveryQuarter => '3か月ごと';

  @override
  String get billEveryYear => '毎年';

  @override
  String get billNext => '次の支払い';

  @override
  String get billKind => '種類';

  @override
  String get billKindBill => '請求';

  @override
  String get billKindSubscription => 'サブスク';

  @override
  String get billRepays => '返済先';

  @override
  String get billRepaysNothing => 'なし（費用）';

  @override
  String get billAddThis => 'この請求を追加';

  @override
  String get billDelete => 'この請求を削除';

  @override
  String billRow(String every, String date) {
    return '$every · 次回 $date';
  }

  @override
  String billOverdue(String date) {
    return '$dateが期限でした';
  }

  @override
  String get billPay => '支払い済みにする';

  @override
  String get billEdit => '変更';

  @override
  String get dayToday => '今日';

  @override
  String dayIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days日後',
      one: '1日後',
    );
    return '$_temp0';
  }

  @override
  String dayAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days日前',
      one: '1日前',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => '今後の予定';

  @override
  String homeComingUpTotal(String amount) {
    return '今後30日で$amountの請求があります。';
  }

  @override
  String payDueTitle(String date) {
    return '給料は$dateの予定でした。入りましたか？';
  }

  @override
  String get payDueSub => '入った額を入力すると、次の給料は1期間後に予定されます。';

  @override
  String get payArrived => '入った';

  @override
  String get payArrivedTitle => 'いくら入りましたか？';

  @override
  String get planRecordPay => '給料が入った';

  @override
  String get planRecordPaySub => '記録すると、次の給料が1期間先に進みます';

  @override
  String get accountsTitle => '口座';

  @override
  String get accountMain => 'メイン口座';

  @override
  String get accountKindBank => '銀行口座';

  @override
  String get accountKindCash => '現金';

  @override
  String get accountKindSavings => '貯金';

  @override
  String get accountKindCard => 'クレジットカード';

  @override
  String get accountKindLoan => 'ローン';

  @override
  String get accountAdd => '口座を追加';

  @override
  String get accountAddSub => '現金、貯金、カード、ローン。銀行連携は不要です。';

  @override
  String get accountEditNew => '新しい口座';

  @override
  String get accountNameHint => '例：財布';

  @override
  String get accountHolds => '今の残高';

  @override
  String get accountOwes => '今の借入額';

  @override
  String get accountCounted => 'プランに含める';

  @override
  String get accountCountedSub => 'ここのお金は今月使えます。';

  @override
  String accountOwed(String amount) {
    return '$amountの借入';
  }

  @override
  String get accountNotCounted => 'プランに含めていません';

  @override
  String get accountConfirm => '実際の残高を入力';

  @override
  String get accountMove => 'お金を移す';

  @override
  String accountMoveTo(String name) {
    return '$nameへ移す';
  }

  @override
  String get accountMoveBlurb => '自分の口座間の移動は、支出でも収入でもありません。';

  @override
  String get accountPayCard => '一部を返済';

  @override
  String get accountPayBlurb => 'メイン口座から支払います。借りている分の精算で、二重の支出ではありません。';

  @override
  String get accountRemove => 'この口座を削除';

  @override
  String get accountInUse => '履歴があるので残ります。代わりにプランから外せます。';

  @override
  String get paidFrom => '支払い元';

  @override
  String get categorySuggested => '過去の支出からの提案です。別のものをタップして変更できます。';

  @override
  String get recoverTitle => '戻ってくるお金';

  @override
  String recoverTotal(String amount) {
    return '$amountが戻る可能性があります。入るまで計算に含めません。';
  }

  @override
  String get recoverReturnable => '返品できる';

  @override
  String get recoverExpect => '返品済み、返金待ち';

  @override
  String get recoverArrived => '返金された';

  @override
  String get recoverKept => '手元に残した';

  @override
  String get recoverPending => '返金待ち';

  @override
  String get recoverRefunded => '返金済み';

  @override
  String get recoverPrompt => 'お金が戻る';

  @override
  String recoverWhere(String amount) {
    return '$amountが戻りました。どこに回しますか？';
  }

  @override
  String recoverToGoal(String goal) {
    return '$goalへ';
  }

  @override
  String get recoverToBuffer => '緊急用の予備へ';

  @override
  String get recoverLeave => '使えるお金のままにする';

  @override
  String get accountStopCounting => 'プランから外す';

  @override
  String get moveTitle => 'おすすめの一手';

  @override
  String get moveTagMove => '移す';

  @override
  String get moveTagWait => '待つ';

  @override
  String get moveTagSave => '貯める';

  @override
  String get moveTagSpend => '使う';

  @override
  String moveMove(String amount, String account) {
    return '必ず払うものをまかなうため、$accountから$amountを移しましょう。';
  }

  @override
  String moveMoveWhy(String claim) {
    return '$claimが不足していて、このお金はプランの外にあります。';
  }

  @override
  String get moveDoIt => '移す';

  @override
  String moveWaitGap(String date, String amount) {
    return '余分な出費は控えめに：$dateに、必ず払うものが$amount不足します。';
  }

  @override
  String get moveWaitGapWhy => '予測はその日までの給料、請求、生活費を計算しています。';

  @override
  String moveWaitPay(int days, String now, String later) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days日',
      one: '1日',
    );
    return '給料まであと$_temp0。待てば、使える額が$nowから$laterになります。';
  }

  @override
  String get moveWaitPayWhy => '考えているものが待てる場合だけ。どちらでも危険はありません。';

  @override
  String moveSave(String amount, String account, String goal) {
    return '$goalのために$amountを$accountへ移しましょう。';
  }

  @override
  String moveSaveWhy(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days日',
      one: '1日',
    );
    return '約$_temp0早く届き、残る自由なお金もいつもの月の2倍あります。';
  }

  @override
  String moveSpend(String amount, String date) {
    return '$dateまで安心です：$amountを自由に使えます。';
  }

  @override
  String get moveSpendWhy => '請求と目標はすでに確保され、先に不足もなく、いつもの支出を大きく上回っています。';

  @override
  String get moveNotNow => '今はしない';

  @override
  String get moveNone => '今おすすめする一手はありません。プランはこのままで大丈夫です。';

  @override
  String monthIncome(String amount) {
    return '入った給料：$amount。';
  }

  @override
  String monthToGoals(String amount) {
    return '目標に回した額：$amount。';
  }

  @override
  String monthNow(String free, String aside) {
    return '今：自由に使える$free、確保$aside。';
  }

  @override
  String get monthAheadTitle => '今後30日';

  @override
  String monthAheadBills(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '請求$count件、合計$amount。',
      one: '請求1件、$amount。',
    );
    return '$_temp0';
  }

  @override
  String monthAheadPay(String date) {
    return '次の給料は$dateの予定です。';
  }

  @override
  String monthAheadTightest(String date, String amount) {
    return '一番厳しい日は$dateで、自由なお金は$amount。';
  }

  @override
  String monthAheadShort(String date, String amount) {
    return '$dateに、必ず払うものが$amount不足します。';
  }

  @override
  String get monthWorthKnowing => '知っておきたいこと';

  @override
  String insightUp(String category, String amount) {
    return '$categoryは前月より$amount増えています。';
  }

  @override
  String insightGoal(int days, String goal) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days日',
      one: '1日',
    );
    return 'このままだと毎月、$goalの約$_temp0分に相当します。';
  }

  @override
  String get chatSuggestMove => '次に何をすべき？';

  @override
  String get chatSuggestComing => '近いうちの請求は？';

  @override
  String get chatComingNone => '今後30日に期限の請求はありません。支払っているものをプランに追加すれば見守ります。';

  @override
  String get quickAsk => '質問';

  @override
  String get quickPay => '給料入金';

  @override
  String get quickBills => '請求';

  @override
  String get quickMonth => '今月';

  @override
  String get quickPayDue => '給料日です。入ったか教えてください。';

  @override
  String get chartAvg => '平均';

  @override
  String get flowsTitle => '入ったお金と出たお金';

  @override
  String get flowsBlurb => '週ごと：給料と返金は線の上、支出と返済は線の下。';

  @override
  String flowsWeek(String date) {
    return '$dateの週';
  }

  @override
  String flowsInOut(String moneyIn, String moneyOut) {
    return '入 $moneyIn · 出 $moneyOut';
  }

  @override
  String get balanceHistoryTitle => '残高の推移';

  @override
  String rangeMonths(int count) {
    return '$countか月';
  }

  @override
  String get rangeYear => '1年';

  @override
  String get weekSpentTitle => '過去7日';

  @override
  String weekSpentTotal(String amount) {
    return '$amount使いました';
  }

  @override
  String get payGaugeTitle => '次の給料まで';

  @override
  String payGaugeDaysLabel(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '日',
      one: '日',
    );
    return '$_temp0';
  }

  @override
  String payGaugeAfter(String date, String amount) {
    return '$dateの給料後：自由なお金$amount';
  }

  @override
  String payGaugeLasts(String amount) {
    return 'それまで$amountでやりくりします。';
  }

  @override
  String get goalsOverall => 'すべての目標のうち';

  @override
  String goalsThisMonth(String amount) {
    return '今月 +$amount';
  }

  @override
  String get goalsNothingThisMonth => '今月の追加はありません';

  @override
  String get goalsAllOnTrack => 'すべて順調';

  @override
  String goalsOnTrackCount(int onTrack, int total) {
    return '$total件中$onTrack件が順調';
  }

  @override
  String goalsNextUp(String goal, String date) {
    return '次：$goal、$date';
  }

  @override
  String get goalsTips => '早く達成する方法';

  @override
  String get goalsTipsSub => 'あなたの支出をもとにUpinoに聞く';

  @override
  String get goalsDetailTitle => '各目標';

  @override
  String get demoTry => 'サンプルデータで試す';

  @override
  String get demoTrySub => '4つの目標、請求、3か月の履歴。あなたのものではなく、保存もされないコピーです。';

  @override
  String get demoBanner => 'サンプルデータ：あなたのものではなく、保存もされません。';

  @override
  String get demoExit => '終了';

  @override
  String get demoGoalTrip => '旅行';

  @override
  String get demoGoalLaptop => 'ノートPC';

  @override
  String get demoGoalEmergency => '緊急用';

  @override
  String get demoGoalCar => '車';

  @override
  String get demoBillPhone => '携帯';

  @override
  String get demoBillInternet => 'ネット';

  @override
  String get demoBillGym => 'ジム';

  @override
  String get voiceExample => '例：「ランチ 1200円」';

  @override
  String get voiceTitleListening => '聞いています';

  @override
  String get voiceTitleHeard => '聞き取りました';

  @override
  String get voiceTitleFailed => '聞き取れませんでした';

  @override
  String get voiceStop => '停止';

  @override
  String get voiceRetry => 'もう一度';

  @override
  String heroUntil(String date) {
    return '$dateまで';
  }

  @override
  String get goalIcon => 'アイコン';

  @override
  String get payGaugeToLast => 'やりくりする額';

  @override
  String get payGaugeNextPay => '次の給料';

  @override
  String get frSelected => '選択中';

  @override
  String get frFromPhone => 'スマホの設定から';

  @override
  String get frSuggested => 'おすすめ';

  @override
  String get frLangOnPhone => 'スマホの言語';

  @override
  String get frLangNotHere => 'あなたの言語はまだありません';

  @override
  String get frLangTitle => 'あなたの言葉で\n話しましょう。';

  @override
  String get frOrChoose => 'または選択';

  @override
  String frContinueIn(String language) {
    return '$languageで続ける';
  }

  @override
  String frUseCurrency(String currency) {
    return '$currencyを使う';
  }

  @override
  String get frContinue => '続ける';

  @override
  String get frNothingBeforePayday => '給料日までに払うものはない';

  @override
  String get frSkipForNow => '今はスキップ';

  @override
  String get frLooksLike => 'おそらく';

  @override
  String get frCurrencyTitle => '収入の通貨は\nどれですか？';

  @override
  String get frMore => 'その他';

  @override
  String get frIntentTitle => 'Upino に何を手伝ってほしいですか？';

  @override
  String get frIntentSub => '当てはまるものをすべて選んでください。それぞれ数字を一つ入れるだけです。';

  @override
  String get frIntentSafe => '安心して使える額を知りたい';

  @override
  String get frIntentShort => 'お金が足りなくなるのを防ぎたい';

  @override
  String get frIntentSave => '貯金したい';

  @override
  String get frIntentDebt => '借金を返したい';

  @override
  String get frIntentIrregular => '不定期の出費に備えたい';

  @override
  String get frIntentGoal => '目標を達成したい';

  @override
  String get frIntentUnderstand => 'お金をもっと理解したい';

  @override
  String get frAskSafe => '普段の月はいくら使いますか？';

  @override
  String get frAskSafeHint => 'だいたいの数字で大丈夫です。';

  @override
  String get frAskShort => '給料日前にいつもいくら足りなくなりますか？';

  @override
  String get frAskShortHint => '結局借りたり、我慢したりする分です。';

  @override
  String get frAskSave => '毎月いくら貯めたいですか？';

  @override
  String get frAskSaveHint => '使う前に Upino が取り分けます。';

  @override
  String get frAskDebt => '借金は合計いくらですか？';

  @override
  String get frAskDebtHint => 'カード、ローンなど返済中のものすべて。';

  @override
  String get frAskIrregular => '1年で合計いくらになりますか？';

  @override
  String get frAskIrregularHint => '保険、修理、贈り物、手数料など。';

  @override
  String get frAskGoal => '目標にはいくらかかりますか？';

  @override
  String get frAskGoalHint => '名前と日付はあとで決められます。';

  @override
  String get frAskUnderstand => '月にいくら使っていると思いますか？';

  @override
  String get frAskUnderstandHint => 'どれだけ近かったか Upino がお見せします。';

  @override
  String frPerMonth(String amount) {
    return '月 $amount';
  }

  @override
  String frShortPerMonth(String amount) {
    return '月 $amount 不足';
  }

  @override
  String frOwed(String amount) {
    return '借入 $amount';
  }

  @override
  String frPerYear(String amount) {
    return '年 $amount';
  }

  @override
  String frToReach(String amount) {
    return '目標 $amount';
  }

  @override
  String frPerMonthGuess(String amount) {
    return '月 $amount（あなたの予想）';
  }

  @override
  String get frAdd => '追加';

  @override
  String get frRemove => '削除';

  @override
  String get frIncomeTitle => 'お金の入り方を教えてください。';

  @override
  String get frIncomeSub => '変動する場合は、確実に見込める額を。';

  @override
  String get frAddIncome => '別の収入を追加';

  @override
  String get frEvery2Weeks => '2週間ごと';

  @override
  String get frTwiceMonth => '月2回';

  @override
  String get frIrregular => '不定期';

  @override
  String get frEachPay => '1回の収入';

  @override
  String get frAnotherIncome => '別の収入';

  @override
  String get frAvailTitle => '今、使えるお金はいくらありますか？';

  @override
  String get frAvailSub => '現金と普段使う口座の合計です。貯金は含めないでください。口座はあとで一つずつ追加できます。';

  @override
  String get frAvailLabel => '今日使えるお金';

  @override
  String get frAvailNote => 'これが今日の確定残高になります。';

  @override
  String get frObRent => '家賃 / 住宅ローン';

  @override
  String get frObUtilities => '光熱費';

  @override
  String get frObInsurance => '保険';

  @override
  String get frObSubscriptions => 'サブスク';

  @override
  String get frSomethingElse => 'その他';

  @override
  String get frObTitle => '次の収入までに払わなければならないものは？';

  @override
  String frObSub(String date) {
    return '$dateまでに支払うものだけ。それぞれタップしてください。';
  }

  @override
  String get frAddAnother => 'もう一つ追加';

  @override
  String get frObNeedsName => '名前と金額を入力';

  @override
  String get frTapToAdd => 'タップして追加';

  @override
  String get frAmount => '金額';

  @override
  String get frDue => '支払日';

  @override
  String get frEssTitle => '次の収入まで、日々の必需品にだいたいいくら必要ですか？';

  @override
  String frEssSub(String date) {
    return '$dateまで。だいたいの数字で大丈夫です。';
  }

  @override
  String get frEssGroceries => '食料品';

  @override
  String get frEssGettingAround => '交通';

  @override
  String get frEssHousehold => '日用品';

  @override
  String get frEssEveryday => '日々の必要';

  @override
  String get frHelpEstimate => '見積もりを手伝って';

  @override
  String get frEstimateTitle => 'かんたん見積もり';

  @override
  String get frEstimateSub => '2回タップするだけ。数字はあとで変えられます。';

  @override
  String get frPeopleYouCover => '養っている人数';

  @override
  String get frWalkBike => '徒歩か自転車';

  @override
  String get frPublicTransport => '公共交通機関';

  @override
  String get frCar => '車';

  @override
  String frUntil(String date) {
    return '$dateまで';
  }

  @override
  String get frUseThis => 'これを使う';

  @override
  String get frProtEmergency => '緊急資金';

  @override
  String get frProtTrip => '旅行';

  @override
  String get frProtHome => '住まい';

  @override
  String get frProtYearly => '年間の出費';

  @override
  String frMonths(int count) {
    return '$countか月';
  }

  @override
  String get frProtTitle => 'お金で守りたいものはありますか？';

  @override
  String get frProtSub => '任意です。Upino が収入のたびに少しずつ取り分け、期日に間に合わせます。';

  @override
  String get frProtNameHint => '例：自動車保険';

  @override
  String get frProtWhatFor => '何のためですか？';

  @override
  String get frProtYearlyAmount => '年1回、いくら';

  @override
  String get frTarget => '目標額';

  @override
  String get frNextDueIn => '次の支払いまで';

  @override
  String get frAlreadySaved => '貯まっている額';

  @override
  String frDay(int n) {
    return '$n日目';
  }

  @override
  String get frMoment1Title => '給料日。準備完了。';

  @override
  String get frMoment1Body => 'お金が入った瞬間に家賃と食費を取り分け。残りは自由に使えます。';

  @override
  String get frMoment2Title => '支出の記録は3秒。';

  @override
  String get frMoment2Body => '記録すれば数字がすぐ更新。いつも今日の本当の数字です。';

  @override
  String get frMoment3Title => '買う前に聞いてみる。';

  @override
  String get frMoment3Body => '支払う前に、その買い物が請求や目標にどう影響するか分かります。';

  @override
  String get frMoment4Title => '自然に貯まる目標。';

  @override
  String get frMoment4Body => '収入のたびに少しずつ取り分け、月末にはお金の行き先が分かります。';

  @override
  String get frGetStarted => 'はじめる';

  @override
  String frPayArrived(String amount) {
    return '給料が入金  $amount';
  }

  @override
  String get frCoffee => 'コーヒー';

  @override
  String get frRecordedNow => 'たった今記録';

  @override
  String frAskJacket(String amount) {
    return '$amountのジャケットを買っても大丈夫？';
  }

  @override
  String frAskAnswer(String amount, String date) {
    return 'はい、家賃もカバーされたままです。$dateまで$amount残ります。旅行は4日遅れます。';
  }

  @override
  String get frIfBuyNow => '今買うと';

  @override
  String frLeft(String amount) {
    return '残り $amount';
  }

  @override
  String get frMonthClosed => '月を締めました：外食が8%減。';

  @override
  String get frOfAllGoals => '目標全体の';

  @override
  String get frWelcome => 'Upino へようこそ';

  @override
  String get frWelcomeSub => 'はじめての方も、おかえりの方も、同じステップです。';

  @override
  String get frWithApple => 'Apple で続ける';

  @override
  String get frWithGoogle => 'Google で続ける';

  @override
  String get frWithEmail => 'メールで続ける';

  @override
  String get frOnDevice => 'プランはあなたのスマホで計算されます。';

  @override
  String get frTermsPrivacy => '利用規約 · プライバシー';

  @override
  String get frCheckEmail => 'メールを確認してください';

  @override
  String frCodeSent(String email) {
    return '$email に6桁のコードを送りました。';
  }

  @override
  String get frCodeWhy => 'コードをお送りします。パスワードを覚える必要はありません。';

  @override
  String get frSendCode => 'コードを送信';

  @override
  String get frAvailableNow => '今使えるお金';

  @override
  String get frProtectedBills => '請求と必需品のために確保';

  @override
  String get frProtectedGoal => '目標のために確保';

  @override
  String get frPlanReady => 'お金のプランができました';

  @override
  String frNotCovered(String amount) {
    return '支払うべき額のうち $amount がまだ足りていません。';
  }

  @override
  String frUntilIncome(String date) {
    return '$dateの次の収入予定まで';
  }

  @override
  String get frTakenCare => 'もう手配済み';

  @override
  String frTakenCareBody(String name, String amount, String date) {
    return '$name（$amount、$date支払い）は、自由に使えるお金より先に確保されています。';
  }

  @override
  String get frBuiltFromAll => '教えてくれたすべてから作りました。';

  @override
  String frGoodEstimate(int count) {
    return '良いスタートの見積もりです。あとで$count件の情報を追加するとさらに正確になります。';
  }

  @override
  String get frGoToPlan => 'プランを見る';

  @override
  String get frSafeToSpend => '安心して使える額';

  @override
  String get frGapsTitle => '安心して使える額をもっと正確に';

  @override
  String get frGapEssentials => '日々の必需品を追加';

  @override
  String get frGapYearly => '保険など年間の費用を追加';

  @override
  String get frGapBill => '給料日前の支払いを追加';

  @override
  String frSeconds(int count) {
    return '約$count秒';
  }

  @override
  String get frEssentialsSheet => '給料日までの日々の必需品';
}
