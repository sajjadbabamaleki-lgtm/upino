// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get navHome => '首页';

  @override
  String get navPlan => '计划';

  @override
  String get navGoals => '目标';

  @override
  String get navActivity => '记录';

  @override
  String get navProfile => '我的';

  @override
  String get currencyTitle => '使用哪种货币？';

  @override
  String get currencyBlurb => '你的整个计划都以这一种货币记账。请选择你实际领薪的货币。';

  @override
  String get currencySearchHint => '搜索国家、货币或代码';

  @override
  String currencyNoMatch(String query) {
    return '没有与“$query”匹配的结果。试试国家名称或三位字母代码。';
  }

  @override
  String get onboardingBadge => '大约需要一分钟';

  @override
  String get onboardingTitle => '创建你的计划';

  @override
  String get onboardingBlurb => '两个答案就能开始，其余的可以稍后再说。';

  @override
  String get onboardingBalanceLabel => '你目前的存款';

  @override
  String get onboardingBalanceHint => '你真正可以动用的钱，而不是打算不碰的那部分。';

  @override
  String get onboardingIncomeLabel => '你每月收入是多少？';

  @override
  String get onboardingIncomeHint => '如果不固定，填一个区间。计划按区间的下限来做。';

  @override
  String get onboardingPayDay => '下次进账是什么时候？';

  @override
  String onboardingDays(int count) {
    return '$count 天';
  }

  @override
  String get onboardingCommitments => '添加你的固定支出';

  @override
  String get onboardingCommitmentsOpen => '房租、必要开销和一个目标';

  @override
  String get onboardingCommitmentsShut => '可选，之后再填也行';

  @override
  String get onboardingRentLabel => '房租和固定账单';

  @override
  String get onboardingRentHint => '在下次进账前到期';

  @override
  String get onboardingEssentialsLabel => '饮食和交通';

  @override
  String get onboardingEssentialsHint => '度过这段时间所需要的';

  @override
  String get onboardingGoalLabel => '为某个目标储蓄';

  @override
  String get onboardingGoalHint => '这段时间你想留出多少';

  @override
  String get onboardingFinish => '生成我的计划';

  @override
  String get onboardingIncomplete => '填好前两个答案才能继续';

  @override
  String get tapToType => '点击输入';

  @override
  String get heroSafeToSpend => '现在可以花的钱';

  @override
  String get heroNotUpToDate => '不是最新的';

  @override
  String get heroRecordSpend => '记一笔支出';

  @override
  String get heroSeeShort => '看看缺什么';

  @override
  String get heroConfirmBalance => '确认余额';

  @override
  String get heroReviewBlurb => '核对一下余额，这个数字才能重新可信。';

  @override
  String heroUntilSetAside(String date, String amount) {
    return '到 $date · 已留出 $amount';
  }

  @override
  String heroShort(String amount) {
    return '还差 $amount';
  }

  @override
  String heroUnfunded(String label, String amount) {
    return '$label · $amount 未覆盖';
  }

  @override
  String get heroBalanceNever => '余额尚未确认';

  @override
  String get heroBalanceToday => '余额今天已确认';

  @override
  String get heroBalanceYesterday => '余额昨天已确认';

  @override
  String heroBalanceDays(int count) {
    return '余额于 $count 天前确认';
  }

  @override
  String get confirm => '确认';

  @override
  String get homeTitle => '你的计划';

  @override
  String homeUntilTotal(String date, String amount) {
    return '到 $date · 共 $amount';
  }

  @override
  String homeRecorded(String amount) {
    return '已记录 $amount';
  }

  @override
  String get homeAttention => '需要你处理';

  @override
  String homeNotCovered(String amount) {
    return '$amount 未覆盖';
  }

  @override
  String get homeAfterNextPay => '下次进账之后';

  @override
  String homeOncePayArrives(String date) {
    return '当你的收入在 $date 到账后';
  }

  @override
  String get homeSetAsideFirst => '优先留出';

  @override
  String get homeProtectedBlurb => '在任何钱可花之前先被保护起来。';

  @override
  String get homeNothingSetAside => '还没有留出任何钱。你拥有的全部都可以花。';

  @override
  String get homeWhyThisNumber => '为什么是这个数';

  @override
  String get homeWhatIsShort => '缺什么';

  @override
  String get homeShortBlurb => '这里没有任何一项会替你挪动或延后。这些是你现有的钱覆盖不了的承诺。';

  @override
  String get askSpendTitle => '你花了多少？';

  @override
  String get askBalanceTitle => '你现在的余额是多少？';

  @override
  String get askBalanceBlurb => '任何差额都记为更正，绝不记为支出。';

  @override
  String get whyNoChange => '自上次计划以来没有变化。';

  @override
  String get whyPayArrived => '你的收入到账了，计划已更新。';

  @override
  String get whyBillPaid => '你已留钱的一笔账单被支付了。';

  @override
  String get whyHeldForBill => '为下次进账后不久到期的账单预留了钱。';

  @override
  String get whyOvercommitted => '你承诺的超过了你现在拥有的。';

  @override
  String get whyStale => '你的余额最近没有确认过。';

  @override
  String get whyCardLarger => '你的信用卡欠款大于你手头的钱。';

  @override
  String get whyPayLate => '预期的收入还没有到账。';

  @override
  String get whyOverdue => '有一项已经过了到期日。';

  @override
  String get whyBufferShort => '你的应急储备没有补满。';

  @override
  String get whyGoalShort => '你的储蓄目标现在无法完全满足。';

  @override
  String get whyFlexibleLess => '一个弹性目标拿到的比计划的少。';

  @override
  String get whyDuplicate => '重复的交易只计了一次。';

  @override
  String get planTitle => '计划';

  @override
  String get planBlurb => '在任何钱可花之前，你的钱已经许给了什么。';

  @override
  String get planMoneyAndIncome => '钱与收入';

  @override
  String get planMoneyYouHave => '你有的钱';

  @override
  String get planNextPay => '下次进账';

  @override
  String get planYourNextPay => '你的下次进账';

  @override
  String get planNotSet => '未设置';

  @override
  String get planExpectedBlurb => '这只是预期金额，因此不计入你现在能花的钱。';

  @override
  String get planSetAsideFirst => '优先留出';

  @override
  String get planNothingSetAside => '没有留出任何钱，所以你拥有的全部都可以花。';

  @override
  String get planAddToPlan => '添加到你的计划';

  @override
  String get planGoals => '目标';

  @override
  String get planSaveToward => '为某件事储蓄';

  @override
  String get planSaveTowardSub => '一次旅行、一笔押金、一台新笔记本';

  @override
  String get planAllGoals => '全部目标';

  @override
  String get planAllGoalsSub => '添加、编辑或存入金额';

  @override
  String get planHowMuchSetAside => '这一项你需要留出多少？';

  @override
  String get planChangeOrRemove => '修改金额，或将它从计划中移除。';

  @override
  String get planRemove => '从计划中移除';

  @override
  String planDue(String date) {
    return ' · $date 到期';
  }

  @override
  String get priorityMandatory => '必须支付 — 排在最前';

  @override
  String get priorityEssential => '日常所需';

  @override
  String get priorityBuffer => '留作应急';

  @override
  String get priorityCard => '已用信用卡花掉';

  @override
  String get prioritySinkingFund => '为一笔已知账单储蓄';

  @override
  String get priorityGoal => '你已承诺的目标';

  @override
  String get priorityDiscretionary => '有则更好 — 最先让路';

  @override
  String get goalsTitle => '目标';

  @override
  String get goalsBlurbEmpty => '还没有为任何事储蓄。';

  @override
  String get goalsBlurb => '每个目标在这个发薪周期里需要多少。';

  @override
  String get goalsEmptyCard =>
      '添加你正在为之储蓄的东西 — 一次旅行、一笔押金、一台新笔记本。Upino 会算出每个周期该留多少，好让它按时到位。';

  @override
  String get goalsNew => '新建目标';

  @override
  String get goalsNewSub => '你正在为之留钱的东西';

  @override
  String get goalsAddMoney => '存入金额';

  @override
  String goalsAddTo(String name) {
    return '存入「$name」';
  }

  @override
  String get goalsAddBlurb => '这会记录你已经留出的金额。不会花掉任何钱 — 只是让今后需要预留的变少。';

  @override
  String get goalsEachPeriod => '每个周期';

  @override
  String get goalsTargetDate => '目标日期';

  @override
  String goalsOf(String amount) {
    return '／$amount';
  }

  @override
  String goalsPeriodsToGo(int count) {
    return '还剩 $count 个发薪周期';
  }

  @override
  String get goalsDone => '已全部存满';

  @override
  String get goalsPausedStatus => '已暂停 — 不预留任何金额';

  @override
  String get goalsFlexibleStatus => '弹性 — 为任何必须支付的项目让路';

  @override
  String get goalEditNew => '你在为什么储蓄？';

  @override
  String get goalEditExisting => '编辑目标';

  @override
  String get goalName => '名称';

  @override
  String get goalNameHint => '一次旅行、一笔押金、一台笔记本';

  @override
  String get goalTotal => '总共多少';

  @override
  String get goalByWhen => '什么时候之前';

  @override
  String goalMonths(int count) {
    return '$count 个月';
  }

  @override
  String get goalOneYear => '1 年';

  @override
  String get goalTwoYears => '2 年';

  @override
  String get goalFirmness => '有多确定？';

  @override
  String get goalKindHard => '已承诺';

  @override
  String get goalKindHardSub => '在任何钱可花之前先预留';

  @override
  String get goalKindFlexible => '弹性';

  @override
  String get goalKindFlexibleSub => '为任何必须支付的项目让路';

  @override
  String get goalKindPaused => '已暂停';

  @override
  String get goalKindPausedSub => '仍然显示，但不预留任何金额';

  @override
  String get goalSaveChanges => '保存更改';

  @override
  String get goalAddThis => '添加这个目标';

  @override
  String get goalDelete => '删除这个目标';

  @override
  String get activityTitle => '记录';

  @override
  String get activityBlurb => '你记录的一切，最新的在前。';

  @override
  String get activityEmpty => '记下一笔支出后它会出现在这里，如果记错了可以移除。';

  @override
  String get activityRemoveIt => '移除';

  @override
  String get activityKeepIt => '保留';

  @override
  String get activitySpent => '支出';

  @override
  String get activityIncome => '收入';

  @override
  String get activityCorrection => '更正';

  @override
  String get activityRemoved => '已移除';

  @override
  String get profileTitle => '我的';

  @override
  String get profileConfirmBalance => '确认你的余额';

  @override
  String get profileTrustTitle => '这个数字有多可信？';

  @override
  String get profileTrustFresh => '是最新的。没有需要你处理的事。';

  @override
  String get profileTrustDegraded => '你的余额有一阵子没确认了。数字仍然显示，只是不那么确定。';

  @override
  String get profileTrustReview => '太旧或太不确定，不宜依赖。确认余额即可修正。';

  @override
  String get profileConfirmedNever => '尚未确认';

  @override
  String get profileConfirmedToday => '今天已确认';

  @override
  String get profileConfirmedYesterday => '昨天已确认';

  @override
  String profileConfirmedDays(int count) {
    return '$count 天前已确认';
  }

  @override
  String get profileAppearance => '外观';

  @override
  String get profileTheme => '主题';

  @override
  String get profileThemeBlurb => '默认跟随手机设置，不强加任何选择。';

  @override
  String get themePhone => '手机';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get profileLanguage => '语言';

  @override
  String get profileLanguageBlurb => '默认跟随手机设置，不强加任何选择。';

  @override
  String get languagePhone => '手机';

  @override
  String get profileCurrency => '货币';

  @override
  String currencyChangeTitle(String currency) {
    return '改用 $currency？';
  }

  @override
  String currencyChangeBlurb(String currency) {
    return '计划中的每个金额保持原有数字，今后以 $currency 显示。不会按汇率换算，此功能用于更正货币，而非兑换资金。';
  }

  @override
  String get currencyChangeConfirm => '更改';

  @override
  String get profileYourData => '你的数据';

  @override
  String get profileDelete => '删除我的计划';

  @override
  String get profileDeleteSub => '清除全部内容并回到初始设置';

  @override
  String get profileStartOver => '重新开始？';

  @override
  String get profileStartOverBlurb => '你的计划和你记录的一切都会被删除。此操作无法撤销。';

  @override
  String get profileDeleteEverything => '全部删除';

  @override
  String get profileKeepPlan => '保留我的计划';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String activityRemoveAmount(String amount) {
    return '移除 $amount？';
  }

  @override
  String get activityRemoveDetail =>
      '它会立即不再计入你的计划。这条记录仍留在列表中并标记为已移除，你的记录因此保持完整。';

  @override
  String get activityCardPurchase => '刷卡消费';

  @override
  String get activityCardPayment => '还卡';

  @override
  String get activityRefund => '退款';

  @override
  String get activityTransfer => '账户间转账';

  @override
  String get activityLoan => '收到借款';

  @override
  String get activityDebtPayment => '偿还债务';

  @override
  String get activityBalanceCorrected => '余额已更正';

  @override
  String get activityBlurbEmpty => '还没有任何记录。';

  @override
  String get profileStartAgain => '重新开始';

  @override
  String get claimRent => '房租和账单';

  @override
  String get claimCardMinimum => '信用卡最低还款';

  @override
  String get claimEssentials => '饮食和交通';

  @override
  String get claimBuffer => '应急储备';

  @override
  String get languageTitle => '使用哪种语言？';

  @override
  String get languageBlurb => '之后可以在「我的」里更改。';

  @override
  String get profileLedgerTitle => '记录完整吗？';

  @override
  String get ledgerComplete => '你花的每一笔都记下了。';

  @override
  String get ledgerPartial => '有一部分支出是在你确认余额时才发现的。';

  @override
  String get ledgerUnknown => 'Upino 无法判断漏了多少。确认余额即可知道。';

  @override
  String get askTitle => '花钱前先问';

  @override
  String get askBlurb => '把一笔消费放到你的计划里试试。不会记录任何东西，也不会改变任何东西。';

  @override
  String get askAmountLabel => '这笔要多少？';

  @override
  String get askRun => '看看会怎样';

  @override
  String get askDoNotBuy => '不买';

  @override
  String get askBuyNow => '今天就买';

  @override
  String askBuyAfter(String date) {
    return '$date 之后再买';
  }

  @override
  String get askUnchanged => '你的计划保持原样。';

  @override
  String get askStsAfter => '之后还能花多少';

  @override
  String get askBreaks => '这会让一笔必须支付的钱没有着落。';

  @override
  String get askSafe => '必须支付的项目都仍有着落。';

  @override
  String get askCosts => '什么会变少';

  @override
  String askCostLine(String label, String amount) {
    return '$label · 少 $amount';
  }

  @override
  String get askWaitingHelps => '等到收入到账再买，一切都能覆盖。';

  @override
  String get askNoIncome => '目前没有预期的收入，因此没有更晚的时间点可比较。';

  @override
  String askAssumption(String date) {
    return '假设你的收入按预期在 $date 到账。';
  }

  @override
  String get askNoVerdict => 'Upino 不说该或不该。取舍在你。';

  @override
  String get receipt => '票据';

  @override
  String get receiptAdd => '添加票据';

  @override
  String get receiptCamera => '拍照';

  @override
  String get receiptGallery => '选择照片';

  @override
  String get receiptAttached => '已附上票据';

  @override
  String get receiptRemove => '移除照片';

  @override
  String get onboardingIncomeFrom => '至少';

  @override
  String get onboardingIncomeTo => '最多';

  @override
  String get onboardingIncomeToOptional => '可不填';

  @override
  String incomeRange(String low, String high) {
    return '$low 至 $high';
  }

  @override
  String incomeRangeNote(String low) {
    return '计划建立在 $low 之上。高出的部分，到账时就是你的。';
  }

  @override
  String get categoryFood => '餐饮';

  @override
  String get categoryTransport => '交通';

  @override
  String get categoryBills => '账单';

  @override
  String get categoryShopping => '购物';

  @override
  String get categoryHealth => '医疗';

  @override
  String get categoryFun => '娱乐';

  @override
  String get categoryOther => '其他';

  @override
  String get categoryUnsorted => '未分类';

  @override
  String get categoryPrompt => '用在了哪里？';

  @override
  String get spendingTitle => '钱花在哪了';

  @override
  String get spendingWindow => '最近 30 天记录的支出';

  @override
  String get backupSection => '备份';

  @override
  String get backupSave => '保存备份';

  @override
  String get backupSaveSub => '用密码加密。请发送到安全的地方，例如云盘。';

  @override
  String get backupRestore => '从备份恢复';

  @override
  String get backupRestoreSub => '将替换此手机上的计划';

  @override
  String get backupPassword => '密码';

  @override
  String get backupPasswordRepeat => '再次输入密码';

  @override
  String get backupPasswordSaveBlurb => '恢复时需要此密码，忘记后无法找回。备份不包含收据照片。';

  @override
  String get backupPasswordOpenBlurb => '保存此备份时使用的密码。';

  @override
  String get backupPasswordShort => '至少 6 个字符';

  @override
  String get backupPasswordMismatch => '两次输入不一致';

  @override
  String get backupOpen => '打开';

  @override
  String get backupReplaceTitle => '替换当前计划？';

  @override
  String get backupReplaceBlurb => '此手机上的所有内容将被备份替换，且无法撤销。';

  @override
  String get backupReplace => '替换';

  @override
  String get backupRestored => '备份已恢复';

  @override
  String get backupWrongPassword => '该密码无法打开此备份。';

  @override
  String get backupNotABackup => '该文件不是 Upino 备份。';

  @override
  String get backupUnreadable => '此备份由更新版本的 Upino 创建。请更新应用后重试。';

  @override
  String get inflationTitle => '通货膨胀';

  @override
  String get inflationNotSet => '未设置。填写当地的年通胀率，查看目标的真实花费。';

  @override
  String inflationRate(String rate) {
    return '每年 $rate%';
  }

  @override
  String get inflationDialogTitle => '年通胀率';

  @override
  String get inflationDialogBlurb => '物价上涨，按今天的钱设定的目标到期时会更贵。输入你预计的通胀率，留空则关闭。';

  @override
  String goalsInflated(String rate, String amount) {
    return '按每年 $rate% 计算，届时约需 $amount。';
  }

  @override
  String get holdingsTitle => '其他资产';

  @override
  String get holdingsBlurb => '美元、黄金、金币。显示在计划旁，从不计入可花的钱。';

  @override
  String get holdingsAdd => '添加资产';

  @override
  String get holdingsAddSub => '不计入可花的钱';

  @override
  String get holdingsTotal => '合计';

  @override
  String holdingSummary(String quantity, String price, String date) {
    return '$quantity × $price · $date 价格';
  }

  @override
  String get holdingEditNew => '新资产';

  @override
  String get holdingEditExisting => '修改资产';

  @override
  String get holdingName => '是什么？';

  @override
  String get holdingNameHint => '美元、黄金…';

  @override
  String get holdingUsd => '美元';

  @override
  String get holdingEur => '欧元';

  @override
  String get holdingGold => '黄金（克）';

  @override
  String get holdingCoin => '金币';

  @override
  String get holdingQuantity => '数量';

  @override
  String get holdingUnitPrice => '今天每单位价值';

  @override
  String holdingWorth(String amount) {
    return '合计价值 $amount';
  }

  @override
  String get holdingDelete => '移除此资产';

  @override
  String get fasterTitle => '更快记录';

  @override
  String get smsTitle => '读取银行短信';

  @override
  String get smsDetail => '银行短信通知的支出会被提议一键记录。短信只在本机读取，绝不外传。';

  @override
  String get smsDenied => 'Upino 未获读取短信的权限，可在手机设置中开启。';

  @override
  String smsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条银行短信待确认',
    );
    return '$_temp0';
  }

  @override
  String get smsWaitingSub => '一键记录或跳过';

  @override
  String get smsReviewTitle => '来自银行';

  @override
  String get smsReviewBlurb => '点“记录”前不会记录任何内容。请对照短信核对金额。';

  @override
  String get smsReviewDone => '已全部处理。';

  @override
  String get smsRecord => '记录';

  @override
  String get smsSkip => '跳过';

  @override
  String get reminderTitleSetting => '晚间提醒';

  @override
  String get reminderDetail => '晚上 9 点，仅在当天没有记录时提醒。';

  @override
  String get reminderDenied => 'Upino 未获通知权限，可在手机设置中开启。';

  @override
  String get reminderTitle => '今天有花钱吗？';

  @override
  String get reminderBody => '几秒钟记下来，明天的数字才准确。';

  @override
  String get reminderChannel => '晚间提醒';

  @override
  String get widgetSpend => '+ 支出';

  @override
  String get widgetAdd => '添加到主屏幕';

  @override
  String get widgetAddSub => '无需打开应用即可查看可花金额并记录支出';

  @override
  String get voiceListening => '正在聆听…请说出金额和用途。';

  @override
  String voiceHeard(String text) {
    return '听到：“$text”。请核对金额后保存。';
  }

  @override
  String get voiceNothing => '没有听到金额，请重试或手动输入。';

  @override
  String get voicePrivacy => '手机会把语音转成文字。若不支持离线识别，将通过手机的语音服务处理。';

  @override
  String get voiceButton => '说出来';

  @override
  String get voiceUnavailable => '此手机没有可用的语音识别，请手动输入金额。';

  @override
  String get voiceNoPermission => 'Upino 未获麦克风权限，可在手机设置中开启。';

  @override
  String get voiceNetwork => '此手机的语音识别需要联网，但无法连接。';

  @override
  String voiceNoAmount(String text) {
    return '听到“$text”，但没有金额。请重试或手动输入。';
  }

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get navAsk => '提问';

  @override
  String get alertsTitle => '需要处理';

  @override
  String get alertsEmpty => '目前没有需要处理的事项，计划是最新的。';

  @override
  String alertUnfunded(String label, String amount) {
    return '$label还差 $amount';
  }

  @override
  String get alertUnfundedDetail => '一项必须支付的款项目前资金不足。';

  @override
  String alertIncomeLate(String date) {
    return '工资原定于 $date 到账';
  }

  @override
  String get alertIncomeLateDetail => '到账前不计入。若日期有变，请在计划中修改。';

  @override
  String alertGoalBehind(String name, String amount) {
    return '$name本期落后 $amount';
  }

  @override
  String get alertGoalBehindDetail => '现有资金不足以完成本期份额。';

  @override
  String get chatHint => '随便问，或输入一个价格';

  @override
  String get chatSuggestSafe => '我还能花多少？';

  @override
  String get chatSuggestPay => '下次工资什么时候？';

  @override
  String get chatSuggestWhere => '钱花在哪了？';

  @override
  String get chatSuggestAside => '预留了什么？';

  @override
  String chatSafe(String amount, String date) {
    return '到 $date 前你可以花 $amount。';
  }

  @override
  String get chatSafeStale => '提醒一下：你的余额需要确认，这个数字仅供参考。';

  @override
  String chatPay(String amount, String date) {
    return '下次工资 $amount，预计 $date 到账。';
  }

  @override
  String get chatPayNone => '我还不知道你下次工资，在计划里加上吧，我会帮你盯着。';

  @override
  String get chatWhere => '最近 30 天钱花在了这些地方：';

  @override
  String get chatWhereNone => '最近 30 天没有支出，要么这个月很省，要么还没记录。';

  @override
  String chatAside(String amount) {
    return '在可花之前，先预留了 $amount：';
  }

  @override
  String chatPurchase(String amount) {
    return '来看看 $amount 会有什么影响。';
  }

  @override
  String get chatHelp =>
      '嗯，这个我没太明白。我可以告诉你还能花多少、工资什么时候到、钱花在哪、预留了什么，或怎么少花点。也可以输入一个价格，我给你看买下会怎样。';

  @override
  String get chatHelloNew =>
      '你好！我是 Upino。你刚来，所以我目前只知道基本情况：余额、工资和预留的钱。这已经足够告诉你还能花多少、买东西会有什么影响。继续记录支出，大约一个季度后，我就能足够了解你的习惯，当你的私人理财顾问。';

  @override
  String chatHelloLearning(int days, int spends, int remaining) {
    return '欢迎回来！我已经从 $days 天、$spends 笔支出中学习。再过大约 $remaining 天，我就有一整个季度的数据了。';
  }

  @override
  String chatHelloFamiliar(int days) {
    return '欢迎回来！我已经了解你 $days 天的财务情况，随便问吧，包括怎么少花点。';
  }

  @override
  String chatHelloAlerts(int count) {
    return '对了，有 $count 件事需要你处理，在铃铛里。';
  }

  @override
  String chatPurchaseFits(String left) {
    return '今天买的话，所有必须支付的都有保障，还剩 $left 可用。';
  }

  @override
  String chatPurchaseWait(String date) {
    return '今天买会让某项必须支付的款项不够。等到 $date 再买，就都能覆盖。';
  }

  @override
  String chatPurchaseStillShort(String date) {
    return '注意：即使 $date 发了工资，也会有必须支付的款项不够。';
  }

  @override
  String get chatPurchaseShort => '今天买会让某项必须支付的款项不够。';

  @override
  String chatSafeNothing(String date) {
    return '目前到 $date 前没有余钱：现有的钱都已留给必须支付的项目。';
  }

  @override
  String chatPayIn(int days) {
    return '也就是 $days 天后。';
  }

  @override
  String get chatPayLate => '工资晚了，确认到账前不会计入。';

  @override
  String get chatPayRange => '计划按下限计算，所以收入好的月份是额外收获，而不是缺口。';

  @override
  String chatWhereSoFar(int days) {
    return '目前我只看了 $days 天，先大致看看：';
  }

  @override
  String chatWhereTop(String category, int share) {
    return '$category占比最大：$share%。';
  }

  @override
  String get chatWhereTooSoon => '现在问还有点早：我几乎还没看到支出。记几笔，下周再问我吧。';

  @override
  String get chatAdviceTooSoon =>
      '我很想帮忙，但说实话我还不够了解你的支出，没有这些的建议只是瞎猜。记录支出（分类很有帮助），过几周再问我吧。';

  @override
  String chatAdviceBiggest(String category, String amount, String tenth) {
    return '最近 30 天你最大的支出是$category，$amount。削减十分之一，每月大约能省出 $tenth。';
  }

  @override
  String get chatAdviceSort => '我能看到你花了多少，但不知道花在哪。记录时加上分类，我就能告诉你该在哪里省。';

  @override
  String chatAdviceMore(String amount) {
    return '比上个月多花了 $amount。';
  }

  @override
  String chatAdviceLess(String amount) {
    return '不错：比上个月少花了 $amount。';
  }

  @override
  String get chatAdviceLearning => '我还在了解你的习惯，这只是初步提示，不是全貌。';

  @override
  String get chatSmallHello => '你好！想了解你的钱的哪些情况？';

  @override
  String get chatSmallThanks => '随时效劳！准备花钱时我都在。';

  @override
  String get chatSmallWho =>
      '我是 Upino 的助手。我只了解你的计划，给出的每个数字都直接来自它，任何信息都不会离开这部手机。我不会替你说买或不买，但会告诉你每种选择会留下什么。';

  @override
  String get chatSuggestAdvice => '怎么少花点？';

  @override
  String get chatTitle => 'Upino';

  @override
  String get chatNew => '新对话';

  @override
  String get chatResumed => '这里的回答按你今天的计划重新计算。';

  @override
  String get chatWhy => '这个数字是这样算出来的：';

  @override
  String get chatWhyHave => '你现有的钱';

  @override
  String get chatWhySetAside => '先预留的';

  @override
  String get chatWhyLeft => '可放心花';

  @override
  String get chatSmallHowAreYou => '我很好，谢谢关心！你的钱都还在原处。想了解什么？';

  @override
  String get chatSmallBye => '再见！下次大笔花钱前再来找我。';

  @override
  String get chatSmallOkay => '还有别的想看看吗？';

  @override
  String get askHubTitle => '和 Upino 聊聊';

  @override
  String get askHubNew => '问问还能花多少、买东西的影响或工资何时到。我还在了解你，记录越多，我越有用。';

  @override
  String askHubLearning(int days) {
    return '我在学习你的习惯：再过大约 $days 天，就有一整个季度可以给建议了。';
  }

  @override
  String get askHubFamiliar => '我现在很了解你的财务了，随便问吧，包括怎么少花点。';

  @override
  String get askHubStart => '开始对话';

  @override
  String get askHubCommon => '常见问题';

  @override
  String get askHubHistory => '你的对话';

  @override
  String askHubTurns(int count) {
    return '$count 个问题';
  }

  @override
  String askHubAsidePreview(String amount, int count) {
    return '为 $count 项承诺预留了 $amount';
  }

  @override
  String get askHubDeleteTitle => '删除这段对话？';

  @override
  String get askHubDeleteBlurb => '只删除对话，你的计划不会改变。';

  @override
  String get chatSmallHi => '你好！';

  @override
  String get chatSmallHiFine => '你好！我很好，谢谢。';

  @override
  String chatSafeLasts(int days) {
    return '这笔钱要撑 $days 天，直到发工资。';
  }

  @override
  String homeSpokenFor(String amount, String date) {
    return '到 $date 为止，你已有 $amount 的钱有了去处。';
  }

  @override
  String askGoalLater(String goal, int days) {
    return '$goal · 大约推迟 $days 天';
  }

  @override
  String get askGoalsTitle => '目标会推迟';

  @override
  String get askGoalsNote => '按每个目标当前的储蓄速度粗略估算。';

  @override
  String chatPurchaseGoal(String goal, int days) {
    return '这会让$goal推迟大约 $days 天。';
  }

  @override
  String get monthTitle => '你的这个月';

  @override
  String get monthWindow => '最近 30 天，对比之前的 30 天';

  @override
  String monthTooSoon(int days) {
    return '月度回顾需要一个月的支出记录。你的将在 $days 天后准备好。';
  }

  @override
  String monthSpent(String amount) {
    return '最近 30 天共支出 $amount。';
  }

  @override
  String get monthNothing => '最近 30 天没有任何记录。';

  @override
  String monthMore(String amount) {
    return '比之前 30 天多了 $amount。';
  }

  @override
  String monthLess(String amount) {
    return '比之前 30 天少了 $amount。';
  }

  @override
  String get monthSame => '与之前 30 天大致相同。';

  @override
  String monthUp(String category, String amount) {
    return '增长最多：$category，多了 $amount。';
  }

  @override
  String monthDown(String category, String amount) {
    return '减少最多：$category，少了 $amount。';
  }

  @override
  String monthGoals(int onTrack, int total) {
    return '按计划进行的目标：$onTrack / $total。';
  }

  @override
  String get chatSuggestMonth => '我这个月过得怎么样？';

  @override
  String get timelineTitle => '你接下来的钱';

  @override
  String get timelineToday => '今天';

  @override
  String get timelineNow => '现在';

  @override
  String get timelineProjected => '预测';

  @override
  String get timelineRecorded => '已记录';

  @override
  String get timelineFree => '可自由支配';

  @override
  String get timelineHad => '当时余额';

  @override
  String timelineBalance(String amount) {
    return '余额 $amount';
  }

  @override
  String timelineSetAside(String amount) {
    return '已预留 $amount';
  }

  @override
  String timelinePayMark(String amount) {
    return '工资 $amount';
  }

  @override
  String timelineShort(String amount) {
    return '必须支付的款项还差 $amount';
  }

  @override
  String timelineWithout(String amount) {
    return '不买：$amount';
  }

  @override
  String get timelineBuyAfterPay => '发工资后买';

  @override
  String get timelineBalanceLegend => '余额';

  @override
  String get timelineWithPurchase => '买了之后';

  @override
  String get timelinePay => '发薪日';

  @override
  String get timelineAssumptions =>
      '未来部分是预测：工资按时到账、账单按期支付、生活预留平均花掉，此外不花别的。在图上滑动可查看任意一天。';

  @override
  String get timelineSemantics => '逐日显示余额和可支配金额的图表';

  @override
  String goalChartSemantics(String goal) {
    return '$goal达成目标的图表';
  }

  @override
  String goalChartTarget(String amount, String date) {
    return '目标 $amount，截止 $date';
  }

  @override
  String goalPaceLabel(String amount) {
    return '每个发薪周期存入：$amount';
  }

  @override
  String goalOnTrack(String date) {
    return '进度正常：$date 前达成。';
  }

  @override
  String goalLate(String date, int days) {
    return '按这个速度将在 $date 达成，比目标日期晚 $days 天。';
  }

  @override
  String get goalNotMoving => '目前没有钱投入，所以没有进展。';

  @override
  String goalUsePace(String date) {
    return '把目标日期改为 $date';
  }

  @override
  String get goalPaceNote => '只是假设：在你确认之前什么都不会改变。';

  @override
  String get goalShowPath => '查看达成路径';

  @override
  String get goalHidePath => '收起';

  @override
  String get billsTitle => '账单和订阅';

  @override
  String get billAdd => '添加账单或订阅';

  @override
  String get billAddSub => '电话、网络、保险、流媒体……每项都会在到期前预留。';

  @override
  String get billEditNew => '新账单';

  @override
  String get billEditExisting => '修改账单';

  @override
  String get billName => '是什么？';

  @override
  String get billNameHint => '例如：网络';

  @override
  String get billAmount => '每次金额';

  @override
  String get billEvery => '多久一次';

  @override
  String get billEveryWeek => '每周';

  @override
  String get billEveryMonth => '每月';

  @override
  String get billEveryQuarter => '每季度';

  @override
  String get billEveryYear => '每年';

  @override
  String get billNext => '下次付款';

  @override
  String get billKind => '类型';

  @override
  String get billKindBill => '账单';

  @override
  String get billKindSubscription => '订阅';

  @override
  String get billRepays => '偿还';

  @override
  String get billRepaysNothing => '不偿还，是开支';

  @override
  String get billAddThis => '添加账单';

  @override
  String get billDelete => '删除账单';

  @override
  String billRow(String every, String date) {
    return '$every · 下次 $date';
  }

  @override
  String billOverdue(String date) {
    return '已于 $date 到期';
  }

  @override
  String get billPay => '标记为已付';

  @override
  String get billEdit => '修改';

  @override
  String get dayToday => '今天';

  @override
  String dayIn(int days) {
    return '$days 天后';
  }

  @override
  String dayAgo(int days) {
    return '$days 天前';
  }

  @override
  String get homeComingUp => '即将到来';

  @override
  String homeComingUpTotal(String amount) {
    return '未来 30 天有 $amount 的账单到期。';
  }

  @override
  String payDueTitle(String date) {
    return '你的工资应于 $date 到账。到了吗？';
  }

  @override
  String get payDueSub => '告诉我们到账多少，下次工资将在一个周期后预期到账。';

  @override
  String get payArrived => '已到账';

  @override
  String get payArrivedTitle => '到账多少？';

  @override
  String get planRecordPay => '工资已到账';

  @override
  String get planRecordPaySub => '记录后下次工资顺延一个周期';

  @override
  String get accountsTitle => '账户';

  @override
  String get accountMain => '主账户';

  @override
  String get accountKindBank => '银行账户';

  @override
  String get accountKindCash => '现金';

  @override
  String get accountKindSavings => '储蓄';

  @override
  String get accountKindCard => '信用卡';

  @override
  String get accountKindLoan => '贷款';

  @override
  String get accountAdd => '添加账户';

  @override
  String get accountAddSub => '现金、储蓄、信用卡或贷款，无需连接银行。';

  @override
  String get accountEditNew => '新账户';

  @override
  String get accountNameHint => '例如：钱包';

  @override
  String get accountHolds => '当前余额';

  @override
  String get accountOwes => '当前欠款';

  @override
  String get accountCounted => '计入计划';

  @override
  String get accountCountedSub => '这里的钱本月可以花。';

  @override
  String accountOwed(String amount) {
    return '欠 $amount';
  }

  @override
  String get accountNotCounted => '不计入计划';

  @override
  String get accountConfirm => '填写实际余额';

  @override
  String get accountMove => '转账';

  @override
  String accountMoveTo(String name) {
    return '转到 $name';
  }

  @override
  String get accountMoveBlurb => '在自己账户之间转账既不是支出也不是收入。';

  @override
  String get accountPayCard => '还一部分';

  @override
  String get accountPayBlurb => '从主账户支付。这是还款，不算第二次支出。';

  @override
  String get accountRemove => '删除此账户';

  @override
  String get accountInUse => '它有历史记录，所以保留。你可以改为不计入计划。';

  @override
  String get paidFrom => '支付方式';

  @override
  String get categorySuggested => '根据你过去的支出推荐。点其他类别可更改。';

  @override
  String get recoverTitle => '待退回的钱';

  @override
  String recoverTotal(String amount) {
    return '可能退回 $amount，到账前不计入。';
  }

  @override
  String get recoverReturnable => '可退货';

  @override
  String get recoverExpect => '已退货，等待退款';

  @override
  String get recoverArrived => '退款已到账';

  @override
  String get recoverKept => '留着了';

  @override
  String get recoverPending => '退款处理中';

  @override
  String get recoverRefunded => '已退款';

  @override
  String get recoverPrompt => '退款';

  @override
  String recoverWhere(String amount) {
    return '退回了 $amount，放到哪里？';
  }

  @override
  String recoverToGoal(String goal) {
    return '用于$goal';
  }

  @override
  String get recoverToBuffer => '放入应急备用金';

  @override
  String get recoverLeave => '留作可支配';

  @override
  String get accountStopCounting => '不再计入计划';

  @override
  String get moveTitle => '最佳一步';

  @override
  String get moveTagMove => '转移';

  @override
  String get moveTagWait => '等待';

  @override
  String get moveTagSave => '储蓄';

  @override
  String get moveTagSpend => '可花';

  @override
  String moveMove(String amount, String account) {
    return '从 $account 转 $amount 来支付必须支付的款项。';
  }

  @override
  String moveMoveWhy(String claim) {
    return '$claim资金不足，而这笔钱在计划之外闲置。';
  }

  @override
  String get moveDoIt => '转移';

  @override
  String moveWaitGap(String date, String amount) {
    return '先别额外花钱：$date 时必须支付的款项会差 $amount。';
  }

  @override
  String get moveWaitGapWhy => '预测计入了到那天为止的工资、账单和生活开支。';

  @override
  String moveWaitPay(int days, String now, String later) {
    return '还有 $days 天发工资。等到那时，可支配金额会从 $now 变成 $later。';
  }

  @override
  String get moveWaitPayWhy => '前提是你想买的东西能等。无论如何都没有风险。';

  @override
  String moveSave(String amount, String account, String goal) {
    return '把 $amount 转到 $account，用于$goal。';
  }

  @override
  String moveSaveWhy(int days) {
    return '大约提前 $days 天达成，剩下的可支配金额仍是你平常一个月开支的两倍。';
  }

  @override
  String moveSpend(String amount, String date) {
    return '到 $date 为止都有保障：$amount 可自由使用。';
  }

  @override
  String get moveSpendWhy => '账单和目标都已预留，未来没有缺口，而且这远高于你平常的开支。';

  @override
  String get moveNotNow => '暂不';

  @override
  String get moveNone => '目前没有值得建议的操作，你的计划保持现状即可。';

  @override
  String monthIncome(String amount) {
    return '到账工资：$amount。';
  }

  @override
  String monthToGoals(String amount) {
    return '投入目标：$amount。';
  }

  @override
  String monthNow(String free, String aside) {
    return '目前：可支配 $free，已预留 $aside。';
  }

  @override
  String get monthAheadTitle => '未来 30 天';

  @override
  String monthAheadBills(int count, String amount) {
    return '$count 笔账单，共 $amount。';
  }

  @override
  String monthAheadPay(String date) {
    return '下次工资预计 $date 到账。';
  }

  @override
  String monthAheadTightest(String date, String amount) {
    return '最紧的一天是 $date，可支配 $amount。';
  }

  @override
  String monthAheadShort(String date, String amount) {
    return '$date 时必须支付的款项会差 $amount。';
  }

  @override
  String get monthWorthKnowing => '值得了解';

  @override
  String insightUp(String category, String amount) {
    return '$category比上个月多了 $amount。';
  }

  @override
  String insightGoal(int days, String goal) {
    return '如果持续下去，每个月大约相当于$goal的 $days 天进度。';
  }

  @override
  String get chatSuggestMove => '我接下来该做什么？';

  @override
  String get chatSuggestComing => '接下来有哪些账单？';

  @override
  String get chatComingNone => '未来 30 天没有账单到期。在“计划”中添加你的账单，我会帮你跟踪。';
}
