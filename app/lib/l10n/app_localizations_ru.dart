// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get navHome => 'Главная';

  @override
  String get navPlan => 'План';

  @override
  String get navGoals => 'Цели';

  @override
  String get navActivity => 'События';

  @override
  String get navProfile => 'Профиль';

  @override
  String get currencyTitle => 'Какая валюта?';

  @override
  String get currencyBlurb =>
      'Весь ваш план ведётся в одной валюте. Выберите ту, в которой вы действительно получаете доход.';

  @override
  String get currencySearchHint => 'Поиск по стране, валюте или коду';

  @override
  String currencyNoMatch(String query) {
    return 'По запросу «$query» ничего нет. Попробуйте название страны или трёхбуквенный код.';
  }

  @override
  String get onboardingBadge => 'Займёт около минуты';

  @override
  String get onboardingTitle => 'Создайте свой план';

  @override
  String get onboardingBlurb =>
      'Для начала хватит двух ответов. Остальное может подождать.';

  @override
  String get onboardingBalanceLabel => 'Ваши сбережения сегодня';

  @override
  String get onboardingBalanceHint =>
      'Деньги, из которых вы действительно можете тратить, а не те, что решили не трогать.';

  @override
  String get onboardingIncomeLabel => 'Сколько вы зарабатываете в месяц?';

  @override
  String get onboardingIncomeHint =>
      'Если по-разному, укажите диапазон. План строится по нижней границе.';

  @override
  String get onboardingPayDay => 'Когда придёт следующий доход?';

  @override
  String onboardingDays(int count) {
    return '$count дн.';
  }

  @override
  String get onboardingCommitments => 'Добавьте обязательства';

  @override
  String get onboardingCommitmentsOpen => 'Аренда, необходимое и цель';

  @override
  String get onboardingCommitmentsShut => 'Необязательно, можно сделать позже';

  @override
  String get onboardingRentLabel => 'Аренда и постоянные счета';

  @override
  String get onboardingRentHint => 'Оплатить до следующего дохода';

  @override
  String get onboardingEssentialsLabel => 'Еда и транспорт';

  @override
  String get onboardingEssentialsHint => 'То, что нужно, чтобы прожить период';

  @override
  String get onboardingGoalLabel => 'Накопление на цель';

  @override
  String get onboardingGoalHint => 'Сколько хотите отложить за этот период';

  @override
  String get onboardingFinish => 'Составить план';

  @override
  String get onboardingIncomplete =>
      'Заполните первые два ответа, чтобы продолжить';

  @override
  String get tapToType => 'Нажмите и введите';

  @override
  String get heroSafeToSpend => 'Можно потратить сейчас';

  @override
  String get heroNotUpToDate => 'Не актуально';

  @override
  String get heroRecordSpend => 'Записать трату';

  @override
  String get heroSeeShort => 'Посмотреть, чего не хватает';

  @override
  String get heroConfirmBalance => 'Подтвердить баланс';

  @override
  String get heroReviewBlurb =>
      'Проверьте баланс, чтобы этой цифре снова можно было доверять.';

  @override
  String heroUntilSetAside(String date, String amount) {
    return 'До $date · $amount отложено';
  }

  @override
  String heroShort(String amount) {
    return 'Не хватает $amount';
  }

  @override
  String heroUnfunded(String label, String amount) {
    return '$label · $amount не покрыто';
  }

  @override
  String get heroBalanceNever => 'Баланс ещё не подтверждён';

  @override
  String get heroBalanceToday => 'Баланс подтверждён сегодня';

  @override
  String get heroBalanceYesterday => 'Баланс подтверждён вчера';

  @override
  String heroBalanceDays(int count) {
    return 'Баланс подтверждён $count дн. назад';
  }

  @override
  String get confirm => 'Подтвердить';

  @override
  String get homeTitle => 'Ваш план';

  @override
  String homeUntilTotal(String date, String amount) {
    return 'До $date · $amount всего';
  }

  @override
  String homeRecorded(String amount) {
    return '$amount записано';
  }

  @override
  String get homeAttention => 'Требует внимания';

  @override
  String homeNotCovered(String amount) {
    return '$amount не покрыто';
  }

  @override
  String get homeAfterNextPay => 'После следующего дохода';

  @override
  String homeOncePayArrives(String date) {
    return 'Когда доход придёт $date';
  }

  @override
  String get homeSetAsideFirst => 'Откладывается в первую очередь';

  @override
  String get homeProtectedBlurb =>
      'Защищено прежде, чем что-либо станет доступным для трат.';

  @override
  String get homeNothingSetAside =>
      'Пока ничего не отложено. Всё, что у вас есть, можно тратить.';

  @override
  String get homeWhyThisNumber => 'Почему такая цифра';

  @override
  String get homeWhatIsShort => 'Чего не хватает';

  @override
  String get homeShortBlurb =>
      'Здесь ничто не переносится и не откладывается за вас. Это обязательства, которые ваши текущие деньги не покрывают.';

  @override
  String get askSpendTitle => 'Сколько вы потратили?';

  @override
  String get askBalanceTitle => 'Какой у вас сейчас баланс?';

  @override
  String get askBalanceBlurb =>
      'Любое расхождение записывается как исправление, а не как трата.';

  @override
  String get whyNoChange => 'С прошлого плана ничего не изменилось.';

  @override
  String get whyPayArrived => 'Доход пришёл, поэтому план обновился.';

  @override
  String get whyBillPaid => 'Оплачен счёт, на который вы откладывали.';

  @override
  String get whyHeldForBill =>
      'Деньги удержаны на счёт, срок которого наступает сразу после следующего дохода.';

  @override
  String get whyOvercommitted =>
      'Вы взяли на себя больше, чем у вас сейчас есть.';

  @override
  String get whyStale => 'Ваш баланс давно не подтверждался.';

  @override
  String get whyCardLarger => 'Долг по карте больше, чем имеющиеся деньги.';

  @override
  String get whyPayLate => 'Ожидаемый доход ещё не пришёл.';

  @override
  String get whyOverdue => 'Что-то просрочено.';

  @override
  String get whyBufferShort =>
      'Ваш резерв на непредвиденное пополнен не полностью.';

  @override
  String get whyGoalShort =>
      'Цель накопления сейчас не может быть обеспечена полностью.';

  @override
  String get whyFlexibleLess =>
      'Гибкая цель получила меньше, чем планировалось.';

  @override
  String get whyDuplicate => 'Повторная операция учтена только один раз.';

  @override
  String get planTitle => 'План';

  @override
  String get planBlurb =>
      'Чему обещаны ваши деньги, прежде чем что-либо станет доступным для трат.';

  @override
  String get planMoneyAndIncome => 'Деньги и доход';

  @override
  String get planMoneyYouHave => 'Деньги, которые у вас есть';

  @override
  String get planNextPay => 'Следующий доход';

  @override
  String get planYourNextPay => 'Ваш следующий доход';

  @override
  String get planNotSet => 'Не задано';

  @override
  String get planExpectedBlurb =>
      'Это лишь ожидаемая сумма, поэтому она не входит в то, что можно потратить сейчас.';

  @override
  String get planSetAsideFirst => 'Откладывается в первую очередь';

  @override
  String get planNothingSetAside =>
      'Ничего не отложено, поэтому всё, что у вас есть, можно тратить.';

  @override
  String get planAddToPlan => 'Добавить в план';

  @override
  String get planGoals => 'Цели';

  @override
  String get planSaveToward => 'Копить на что-нибудь';

  @override
  String get planSaveTowardSub => 'Поездка, залог, новый ноутбук';

  @override
  String get planAllGoals => 'Все цели';

  @override
  String get planAllGoalsSub => 'Добавить, изменить или отложить деньги';

  @override
  String get planHowMuchSetAside => 'Сколько нужно отложить на это?';

  @override
  String get planChangeOrRemove => 'Измените сумму или уберите из плана.';

  @override
  String get planRemove => 'Убрать из плана';

  @override
  String planDue(String date) {
    return ' · срок $date';
  }

  @override
  String get priorityMandatory => 'Обязательно к оплате — идёт первым';

  @override
  String get priorityEssential => 'Повседневные нужды';

  @override
  String get priorityBuffer => 'Отложено на непредвиденное';

  @override
  String get priorityCard => 'Уже потрачено по карте';

  @override
  String get prioritySinkingFund => 'Накопление на известный счёт';

  @override
  String get priorityGoal => 'Цель, которую вы себе поставили';

  @override
  String get priorityDiscretionary => 'Приятно иметь — уступает первым';

  @override
  String get goalsTitle => 'Цели';

  @override
  String get goalsBlurbEmpty => 'Пока ни на что не копится.';

  @override
  String get goalsBlurb => 'Что каждая цель требует от этого периода.';

  @override
  String get goalsEmptyCard =>
      'Добавьте то, на что копите: поездку, залог, новый ноутбук. Upino посчитает, сколько удерживать каждый период, чтобы всё пришло вовремя.';

  @override
  String get goalsNew => 'Новая цель';

  @override
  String get goalsNewSub => 'То, на что вы откладываете деньги';

  @override
  String get goalsAddMoney => 'Добавить деньги';

  @override
  String goalsAddTo(String name) {
    return 'Добавить в «$name»';
  }

  @override
  String get goalsAddBlurb =>
      'Это записывает то, что вы отложили. Ничего не тратится — просто с этого момента удерживать нужно меньше.';

  @override
  String get goalsEachPeriod => 'Каждый период';

  @override
  String get goalsTargetDate => 'Целевая дата';

  @override
  String goalsOf(String amount) {
    return 'из $amount';
  }

  @override
  String goalsPeriodsToGo(int count) {
    return 'Осталось периодов: $count';
  }

  @override
  String get goalsDone => 'Накоплено полностью';

  @override
  String get goalsPausedStatus => 'Приостановлено — ничего не удерживается';

  @override
  String get goalsFlexibleStatus => 'Гибкая — уступает всему обязательному';

  @override
  String get goalEditNew => 'На что копите?';

  @override
  String get goalEditExisting => 'Изменить цель';

  @override
  String get goalName => 'Название';

  @override
  String get goalNameHint => 'Поездка, залог, ноутбук';

  @override
  String get goalTotal => 'Сколько всего';

  @override
  String get goalByWhen => 'К какому сроку';

  @override
  String goalMonths(int count) {
    return '$count мес.';
  }

  @override
  String get goalOneYear => '1 год';

  @override
  String get goalTwoYears => '2 года';

  @override
  String get goalFirmness => 'Насколько это твёрдо?';

  @override
  String get goalKindHard => 'Обязательная';

  @override
  String get goalKindHardSub =>
      'Удерживается прежде, чем что-либо станет доступным для трат';

  @override
  String get goalKindFlexible => 'Гибкая';

  @override
  String get goalKindFlexibleSub => 'Уступает всему обязательному';

  @override
  String get goalKindPaused => 'Приостановлена';

  @override
  String get goalKindPausedSub => 'Остаётся видимой, ничего не удерживается';

  @override
  String get goalSaveChanges => 'Сохранить изменения';

  @override
  String get goalAddThis => 'Добавить эту цель';

  @override
  String get goalDelete => 'Удалить эту цель';

  @override
  String get activityTitle => 'События';

  @override
  String get activityBlurb => 'Всё, что вы записали, сначала новое.';

  @override
  String get activityEmpty =>
      'Когда вы запишете трату, она появится здесь, и её можно убрать, если вы ошиблись.';

  @override
  String get activityRemoveIt => 'Убрать';

  @override
  String get activityKeepIt => 'Оставить';

  @override
  String get activitySpent => 'Трата';

  @override
  String get activityIncome => 'Доход';

  @override
  String get activityCorrection => 'Исправление';

  @override
  String get activityRemoved => 'Убрано';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileConfirmBalance => 'Подтвердите баланс';

  @override
  String get profileTrustTitle => 'Насколько можно доверять цифре?';

  @override
  String get profileTrustFresh =>
      'Актуально. Ничего не требует вашего внимания.';

  @override
  String get profileTrustDegraded =>
      'Баланс давно не подтверждался. Цифра по-прежнему показана, просто она менее надёжна.';

  @override
  String get profileTrustReview =>
      'Слишком старая или неопределённая, чтобы на неё полагаться. Подтвердите баланс, чтобы это исправить.';

  @override
  String get profileConfirmedNever => 'Ещё не подтверждён';

  @override
  String get profileConfirmedToday => 'Подтверждён сегодня';

  @override
  String get profileConfirmedYesterday => 'Подтверждён вчера';

  @override
  String profileConfirmedDays(int count) {
    return 'Подтверждён $count дн. назад';
  }

  @override
  String get profileAppearance => 'Оформление';

  @override
  String get profileTheme => 'Тема';

  @override
  String get profileThemeBlurb =>
      'По умолчанию следует настройке телефона, так что ничего не навязывается.';

  @override
  String get themePhone => 'Телефон';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get profileLanguage => 'Язык';

  @override
  String get profileLanguageBlurb =>
      'По умолчанию следует настройке телефона, так что ничего не навязывается.';

  @override
  String get languagePhone => 'Телефон';

  @override
  String get profileCurrency => 'Валюта';

  @override
  String currencyChangeTitle(String currency) {
    return 'Перейти на $currency?';
  }

  @override
  String currencyChangeBlurb(String currency) {
    return 'Каждая сумма в плане сохраняет своё число и теперь показывается в $currency. Ничего не пересчитывается по курсу: это для исправления валюты, а не для обмена денег.';
  }

  @override
  String get currencyChangeConfirm => 'Перейти';

  @override
  String get profileYourData => 'Ваши данные';

  @override
  String get profileDelete => 'Удалить мой план';

  @override
  String get profileDeleteSub => 'Очищает всё и возвращает к настройке';

  @override
  String get profileStartOver => 'Начать заново?';

  @override
  String get profileStartOverBlurb =>
      'Ваш план и всё, что вы записали, будут удалены. Это нельзя отменить.';

  @override
  String get profileDeleteEverything => 'Удалить всё';

  @override
  String get profileKeepPlan => 'Оставить мой план';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String activityRemoveAmount(String amount) {
    return 'Убрать $amount?';
  }

  @override
  String get activityRemoveDetail =>
      'Она сразу перестаёт учитываться в плане. Запись остаётся в списке с пометкой «убрано», так что история остаётся полной.';

  @override
  String get activityCardPurchase => 'Покупка по карте';

  @override
  String get activityCardPayment => 'Платёж по карте';

  @override
  String get activityRefund => 'Возврат';

  @override
  String get activityTransfer => 'Перевод между счетами';

  @override
  String get activityLoan => 'Получен заём';

  @override
  String get activityDebtPayment => 'Погашение долга';

  @override
  String get activityBalanceCorrected => 'Баланс исправлен';

  @override
  String get activityBlurbEmpty => 'Пока ничего не записано.';

  @override
  String get profileStartAgain => 'Начать заново';

  @override
  String get claimRent => 'Аренда и счета';

  @override
  String get claimCardMinimum => 'Минимальный платёж по карте';

  @override
  String get claimEssentials => 'Еда и транспорт';

  @override
  String get claimBuffer => 'Резерв на непредвиденное';

  @override
  String get languageTitle => 'Какой язык?';

  @override
  String get languageBlurb => 'Это можно изменить позже в профиле.';

  @override
  String get profileLedgerTitle => 'Запись полная?';

  @override
  String get ledgerComplete => 'Всё, что вы потратили, записано.';

  @override
  String get ledgerPartial =>
      'Часть трат обнаружилась только при подтверждении баланса.';

  @override
  String get ledgerUnknown =>
      'Upino не знает, сколько пропущено. Подтвердите баланс, чтобы выяснить.';

  @override
  String get askTitle => 'Спросите перед тратой';

  @override
  String get askBlurb =>
      'Проверьте покупку на своём плане. Ничего не записывается и ничего не меняется.';

  @override
  String get askAmountLabel => 'Сколько это будет?';

  @override
  String get askRun => 'Показать, что изменится';

  @override
  String get askDoNotBuy => 'Не покупать';

  @override
  String get askBuyNow => 'Купить сегодня';

  @override
  String askBuyAfter(String date) {
    return 'Купить после $date';
  }

  @override
  String get askUnchanged => 'Ваш план остаётся прежним.';

  @override
  String get askStsAfter => 'Сколько можно будет потратить после';

  @override
  String get askBreaks => 'Это оставляет непокрытым то, что нужно оплатить.';

  @override
  String get askSafe => 'Ничего обязательного не остаётся непокрытым.';

  @override
  String get askCosts => 'Что получит меньше';

  @override
  String askCostLine(String label, String amount) {
    return '$label · на $amount меньше';
  }

  @override
  String get askWaitingHelps => 'Если дождаться дохода, покрывается всё.';

  @override
  String get askNoIncome =>
      'Дохода пока не ожидается, поэтому не с чем сравнивать позже.';

  @override
  String askAssumption(String date) {
    return 'Предполагается, что доход придёт как ожидается $date.';
  }

  @override
  String get askNoVerdict => 'Upino не говорит «да» или «нет». Выбор за вами.';

  @override
  String get receipt => 'Чек';

  @override
  String get receiptAdd => 'Добавить чек';

  @override
  String get receiptCamera => 'Сделать фото';

  @override
  String get receiptGallery => 'Выбрать фото';

  @override
  String get receiptAttached => 'Чек прикреплён';

  @override
  String get receiptRemove => 'Убрать фото';

  @override
  String get onboardingIncomeFrom => 'Не меньше';

  @override
  String get onboardingIncomeTo => 'До';

  @override
  String get onboardingIncomeToOptional => 'Необязательно';

  @override
  String incomeRange(String low, String high) {
    return 'от $low до $high';
  }

  @override
  String incomeRangeNote(String low) {
    return 'План построен на $low. Всё, что придёт сверх этого, ваше.';
  }

  @override
  String get categoryFood => 'Еда';

  @override
  String get categoryTransport => 'Транспорт';

  @override
  String get categoryBills => 'Счета';

  @override
  String get categoryShopping => 'Покупки';

  @override
  String get categoryHealth => 'Здоровье';

  @override
  String get categoryFun => 'Досуг';

  @override
  String get categoryOther => 'Другое';

  @override
  String get categoryUnsorted => 'Без категории';

  @override
  String get categoryPrompt => 'На что это было?';

  @override
  String get spendingTitle => 'Куда ушли деньги';

  @override
  String get spendingWindow => 'Траты за последние 30 дней';

  @override
  String get backupSection => 'Резервная копия';

  @override
  String get backupSave => 'Сохранить копию';

  @override
  String get backupSaveSub =>
      'Защищена паролем. Отправьте её в надёжное место, например в облако.';

  @override
  String get backupRestore => 'Восстановить из копии';

  @override
  String get backupRestoreSub => 'Заменяет план на этом телефоне';

  @override
  String get backupPassword => 'Пароль';

  @override
  String get backupPasswordRepeat => 'Повторите пароль';

  @override
  String get backupPasswordSaveBlurb =>
      'Этот пароль понадобится для восстановления. Если его забыть, восстановить нельзя. Фото чеков не входят.';

  @override
  String get backupPasswordOpenBlurb =>
      'Пароль, с которым была сохранена копия.';

  @override
  String get backupPasswordShort => 'Не меньше 6 символов';

  @override
  String get backupPasswordMismatch => 'Пароли не совпадают';

  @override
  String get backupOpen => 'Открыть';

  @override
  String get backupReplaceTitle => 'Заменить этот план?';

  @override
  String get backupReplaceBlurb =>
      'Всё на этом телефоне заменится содержимым копии. Отменить нельзя.';

  @override
  String get backupReplace => 'Заменить';

  @override
  String get backupRestored => 'Копия восстановлена';

  @override
  String get backupWrongPassword => 'Этот пароль не открывает копию.';

  @override
  String get backupNotABackup => 'Это не резервная копия Upino.';

  @override
  String get backupUnreadable =>
      'Копия создана более новой версией Upino. Обновите приложение и попробуйте снова.';

  @override
  String get inflationTitle => 'Инфляция';

  @override
  String get inflationNotSet =>
      'Не задано. Укажите годовую инфляцию, чтобы видеть реальную стоимость целей.';

  @override
  String inflationRate(String rate) {
    return '$rate% в год';
  }

  @override
  String get inflationDialogTitle => 'Годовая инфляция';

  @override
  String get inflationDialogBlurb =>
      'Цены растут, поэтому цель в сегодняшних деньгах к сроку обойдётся дороже. Укажите ожидаемую ставку; оставьте пустым, чтобы отключить.';

  @override
  String goalsInflated(String rate, String amount) {
    return 'При $rate% в год к сроку это будет стоить около $amount.';
  }

  @override
  String get holdingsTitle => 'Другие сбережения';

  @override
  String get holdingsBlurb =>
      'Доллары, золото, монеты. Показываются рядом с планом и не входят в то, что можно тратить.';

  @override
  String get holdingsAdd => 'Добавить сбережение';

  @override
  String get holdingsAddSub => 'Не входит в то, что можно тратить';

  @override
  String get holdingsTotal => 'Всего';

  @override
  String holdingSummary(String quantity, String price, String date) {
    return '$quantity × $price · цена на $date';
  }

  @override
  String get holdingEditNew => 'Новое сбережение';

  @override
  String get holdingEditExisting => 'Изменить сбережение';

  @override
  String get holdingName => 'Что это?';

  @override
  String get holdingNameHint => 'Доллар, золото…';

  @override
  String get holdingUsd => 'Доллар';

  @override
  String get holdingEur => 'Евро';

  @override
  String get holdingGold => 'Золото (грамм)';

  @override
  String get holdingCoin => 'Золотая монета';

  @override
  String get holdingQuantity => 'Сколько';

  @override
  String get holdingUnitPrice => 'Сколько стоит одна единица сегодня';

  @override
  String holdingWorth(String amount) {
    return 'Всего $amount';
  }

  @override
  String get holdingDelete => 'Удалить';

  @override
  String get fasterTitle => 'Быстрый ввод';

  @override
  String get smsTitle => 'Читать SMS банка';

  @override
  String get smsDetail =>
      'Траты из SMS банка предлагаются к записи одним касанием. Сообщения читаются только на этом телефоне и никуда не отправляются.';

  @override
  String get smsDenied =>
      'Upino не разрешено читать SMS. Разрешение можно дать в настройках телефона.';

  @override
  String smsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count SMS банка на проверку',
      many: '$count SMS банка на проверку',
      few: '$count SMS банка на проверку',
      one: '1 SMS банка на проверку',
    );
    return '$_temp0';
  }

  @override
  String get smsWaitingSub => 'Запишите каждое одним касанием или пропустите';

  @override
  String get smsReviewTitle => 'От вашего банка';

  @override
  String get smsReviewBlurb =>
      'Ничего не записывается, пока вы не нажмёте «Записать». Сверьте сумму с сообщением.';

  @override
  String get smsReviewDone => 'Всё просмотрено.';

  @override
  String get smsRecord => 'Записать';

  @override
  String get smsSkip => 'Пропустить';

  @override
  String get reminderTitleSetting => 'Вечернее напоминание';

  @override
  String get reminderDetail => 'В 21:00, только в дни без записей.';

  @override
  String get reminderDenied =>
      'Upino не разрешено показывать уведомления. Разрешение можно дать в настройках.';

  @override
  String get reminderTitle => 'Были траты сегодня?';

  @override
  String get reminderBody =>
      'Запишите за пару секунд, чтобы завтрашняя цифра была верной.';

  @override
  String get reminderChannel => 'Вечернее напоминание';

  @override
  String get widgetSpend => '+ Трата';

  @override
  String get widgetAdd => 'Добавить на главный экран';

  @override
  String get widgetAddSub =>
      'Сколько можно тратить и кнопка записи — без открытия приложения';

  @override
  String get voiceListening => 'Слушаю… назовите сумму и на что.';

  @override
  String voiceHeard(String text) {
    return 'Услышано: «$text». Проверьте сумму и сохраните.';
  }

  @override
  String get voiceNothing =>
      'Сумма не распознана. Попробуйте ещё раз или введите.';

  @override
  String get voicePrivacy =>
      'Телефон превращает речь в текст. Без офлайн-распознавания это идёт через речевой сервис телефона.';

  @override
  String get voiceButton => 'Сказать';

  @override
  String get voiceUnavailable =>
      'На этом телефоне нет доступного распознавания речи. Введите сумму.';

  @override
  String get voiceNoPermission =>
      'Upino не разрешено использовать микрофон. Разрешение можно дать в настройках.';

  @override
  String get voiceNetwork =>
      'Распознаванию речи на этом телефоне нужен интернет, а подключиться не удалось.';

  @override
  String voiceNoAmount(String text) {
    return 'Услышано «$text», но суммы нет. Попробуйте ещё раз или введите.';
  }

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get navAsk => 'Спросить';

  @override
  String get alertsTitle => 'Требует внимания';

  @override
  String get alertsEmpty => 'Сейчас ничего не требует внимания. План актуален.';

  @override
  String alertUnfunded(String label, String amount) {
    return 'На «$label» не хватает $amount';
  }

  @override
  String get alertUnfundedDetail =>
      'Обязательный платёж не покрыт имеющимися деньгами.';

  @override
  String alertIncomeLate(String date) {
    return 'Зарплата ожидалась $date';
  }

  @override
  String get alertIncomeLateDetail =>
      'Не учитывается, пока не придёт. Если дата сдвинулась, измените её в Плане.';

  @override
  String alertGoalBehind(String name, String amount) {
    return '«$name» отстаёт на $amount в этом периоде';
  }

  @override
  String get alertGoalBehindDetail =>
      'Имеющихся денег не хватает на долю этого периода.';

  @override
  String get chatHint => 'Спросите что угодно или введите цену';

  @override
  String get chatSuggestSafe => 'Сколько можно потратить?';

  @override
  String get chatSuggestPay => 'Когда зарплата?';

  @override
  String get chatSuggestWhere => 'Куда ушли деньги?';

  @override
  String get chatSuggestAside => 'Что отложено?';

  @override
  String chatSafe(String amount, String date) {
    return 'До $date можно потратить $amount.';
  }

  @override
  String get chatSafeStale =>
      'Одно но: баланс нужно подтвердить, так что это оценка.';

  @override
  String chatPay(String amount, String date) {
    return 'Следующая зарплата — $amount, ожидается $date.';
  }

  @override
  String get chatPayNone =>
      'Я пока не знаю следующую зарплату. Добавьте её в Плане, и я буду следить.';

  @override
  String get chatWhere => 'Вот куда ушли деньги за последние 30 дней:';

  @override
  String get chatWhereNone =>
      'За 30 дней трат нет. Либо месяц был тихим, либо их не записали.';

  @override
  String chatAside(String amount) {
    return 'Прежде чем что-то можно тратить, отложено $amount:';
  }

  @override
  String chatPurchase(String amount) {
    return 'Посмотрим, что изменят $amount.';
  }

  @override
  String get chatHelp =>
      'Хм, не совсем понял. Я могу сказать, сколько можно тратить, когда зарплата, куда ушли деньги, что отложено или как тратить меньше. Или введите цену — покажу, что изменит покупка.';

  @override
  String get chatHelloNew =>
      'Привет! Я Upino. Вы здесь недавно, поэтому пока я знаю только основное: баланс, зарплату и то, что отложено. Этого уже хватает, чтобы сказать, сколько можно тратить и что будет после покупки. Записывайте траты, и примерно через сезон я узнаю ваши привычки достаточно, чтобы стать вашим личным советником.';

  @override
  String chatHelloLearning(int days, int spends, int remaining) {
    return 'С возвращением! Я уже учусь на $days днях и $spends тратах. Ещё примерно $remaining дней — и у меня будет полный сезон.';
  }

  @override
  String chatHelloFamiliar(int days) {
    return 'С возвращением! Я видел уже $days дней ваших финансов — спрашивайте что угодно, даже как тратить меньше.';
  }

  @override
  String chatHelloAlerts(int count) {
    return 'Кстати, $count дел ждут вас — они под колокольчиком.';
  }

  @override
  String chatPurchaseFits(String left) {
    return 'Если купить сегодня, все обязательные платежи покрыты, и останется $left.';
  }

  @override
  String chatPurchaseWait(String date) {
    return 'Покупка сегодня оставит обязательный платёж без покрытия. Если подождать до $date, всё будет покрыто.';
  }

  @override
  String chatPurchaseStillShort(String date) {
    return 'Внимание: даже после зарплаты $date обязательный платёж останется без покрытия.';
  }

  @override
  String get chatPurchaseShort =>
      'Покупка сегодня оставит обязательный платёж без покрытия.';

  @override
  String chatSafeNothing(String date) {
    return 'Сейчас до $date ничего свободного нет: всё уже отложено на обязательные платежи.';
  }

  @override
  String chatPayIn(int days) {
    return 'То есть через $days дн.';
  }

  @override
  String get chatPayLate =>
      'Она задерживается, поэтому не учитывается, пока вы не подтвердите поступление.';

  @override
  String get chatPayRange =>
      'План рассчитан на нижнюю границу, так что хороший месяц — это бонус, а не дыра.';

  @override
  String chatWhereSoFar(int days) {
    return 'Я видел пока только $days дн., так что это первый взгляд:';
  }

  @override
  String chatWhereTop(String category, int share) {
    return 'Больше всего — $category: $share% от всего.';
  }

  @override
  String get chatWhereTooSoon =>
      'Пока рановато: я почти не видел трат. Запишите несколько и спросите через неделю.';

  @override
  String get chatAdviceTooSoon =>
      'Я бы с радостью помог, но честно — я пока плохо знаю ваши траты, а совет без этого был бы догадкой. Записывайте траты (категории очень помогают) и спросите через пару недель.';

  @override
  String chatAdviceBiggest(String category, String amount, String tenth) {
    return 'Больше всего за 30 дней ушло на «$category» — $amount. Если сократить на десятую часть, освободится около $tenth в месяц.';
  }

  @override
  String get chatAdviceSort =>
      'Я вижу, сколько вы тратите, но не на что. Указывайте категорию при записи — и я подскажу, где сократить.';

  @override
  String chatAdviceMore(String amount) {
    return 'Это на $amount больше, чем месяцем раньше.';
  }

  @override
  String chatAdviceLess(String amount) {
    return 'Отлично: это на $amount меньше, чем месяцем раньше.';
  }

  @override
  String get chatAdviceLearning =>
      'Я ещё изучаю ваши привычки, так что это первая подсказка, а не полная картина.';

  @override
  String get chatSmallHello => 'Привет! Что хотите узнать о своих деньгах?';

  @override
  String get chatSmallThanks =>
      'Всегда пожалуйста! Я рядом, когда соберётесь потратить.';

  @override
  String get chatSmallWho =>
      'Я помощник Upino. Я знаю только ваш план, и каждая цифра — прямо из него; ничего не покидает телефон. Я не скажу «да» или «нет», но покажу, что оставит каждый вариант.';

  @override
  String get chatSuggestAdvice => 'Как тратить меньше?';

  @override
  String get chatTitle => 'Upino';

  @override
  String get chatNew => 'Новый чат';

  @override
  String get chatResumed =>
      'Ответы здесь посчитаны по вашему плану на сегодня.';

  @override
  String get chatWhy => 'Вот как получается эта цифра:';

  @override
  String get chatWhyHave => 'Что у вас есть';

  @override
  String get chatWhySetAside => 'Отложено в первую очередь';

  @override
  String get chatWhyLeft => 'Можно тратить';

  @override
  String get chatSmallHowAreYou =>
      'Всё хорошо, спасибо! Ваши деньги на месте. Что хотите узнать?';

  @override
  String get chatSmallBye =>
      'Пока! Заглядывайте перед следующей крупной тратой.';

  @override
  String get chatSmallOkay => 'Хотите проверить что-то ещё?';

  @override
  String get askHubTitle => 'Поговорите с Upino';

  @override
  String get askHubNew =>
      'Спросите, сколько можно тратить, что изменит покупка или когда зарплата. Я ещё знакомлюсь с вами — чем больше записей, тем полезнее я буду.';

  @override
  String askHubLearning(int days) {
    return 'Изучаю ваши привычки: примерно через $days дней у меня будет полный сезон для советов.';
  }

  @override
  String get askHubFamiliar =>
      'Теперь я хорошо знаю ваши финансы. Спрашивайте что угодно, даже как тратить меньше.';

  @override
  String get askHubStart => 'Начать разговор';

  @override
  String get askHubCommon => 'Частые вопросы';

  @override
  String get askHubHistory => 'Ваши разговоры';

  @override
  String askHubTurns(int count) {
    return 'Вопросов: $count';
  }

  @override
  String askHubAsidePreview(String amount, int count) {
    return '$amount отложено на $count обязательств';
  }

  @override
  String get askHubDeleteTitle => 'Удалить этот разговор?';

  @override
  String get askHubDeleteBlurb =>
      'Удалится только разговор. План не изменится.';

  @override
  String get chatSmallHi => 'Привет!';

  @override
  String get chatSmallHiFine => 'Привет! Всё хорошо, спасибо.';

  @override
  String chatSafeLasts(int days) {
    return 'Этого должно хватить на $days дн., до зарплаты.';
  }

  @override
  String homeSpokenFor(String amount, String date) {
    return '$amount ваших денег уже распределены до $date.';
  }

  @override
  String askGoalLater(String goal, int days) {
    return '$goal · примерно на $days дн. позже';
  }

  @override
  String get askGoalsTitle => 'Цели сдвигаются';

  @override
  String get askGoalsNote =>
      'Примерно, при текущем темпе накоплений на каждую цель.';

  @override
  String chatPurchaseGoal(String goal, int days) {
    return 'Это отодвинет цель «$goal» примерно на $days дн.';
  }

  @override
  String get monthTitle => 'Ваш месяц';

  @override
  String get monthWindow => 'Последние 30 дней против 30 дней до них';

  @override
  String monthTooSoon(int days) {
    return 'Для итогов месяца нужен месяц расходов. Ваши будут готовы через $days дн.';
  }

  @override
  String monthSpent(String amount) {
    return 'За последние 30 дней потрачено $amount.';
  }

  @override
  String get monthNothing => 'За последние 30 дней ничего не записано.';

  @override
  String monthMore(String amount) {
    return 'Это на $amount больше, чем за 30 дней до этого.';
  }

  @override
  String monthLess(String amount) {
    return 'Это на $amount меньше, чем за 30 дней до этого.';
  }

  @override
  String get monthSame => 'Примерно столько же, сколько за 30 дней до этого.';

  @override
  String monthUp(String category, String amount) {
    return 'Больше всего выросло: $category, на $amount.';
  }

  @override
  String monthDown(String category, String amount) {
    return 'Больше всего снизилось: $category, на $amount.';
  }

  @override
  String monthGoals(int onTrack, int total) {
    return 'Цели по плану: $onTrack из $total.';
  }

  @override
  String get chatSuggestMonth => 'Как прошёл мой месяц?';

  @override
  String get timelineTitle => 'Ваши деньги впереди';

  @override
  String get timelineToday => 'Сегодня';

  @override
  String get timelineNow => 'Сейчас';

  @override
  String get timelineProjected => 'Прогноз';

  @override
  String get timelineRecorded => 'Записано';

  @override
  String get timelineFree => 'Можно тратить';

  @override
  String get timelineHad => 'У вас было';

  @override
  String timelineBalance(String amount) {
    return 'Баланс $amount';
  }

  @override
  String timelineSetAside(String amount) {
    return 'Отложено $amount';
  }

  @override
  String timelinePayMark(String amount) {
    return 'Зарплата $amount';
  }

  @override
  String timelineShort(String amount) {
    return 'Не хватает $amount на обязательный платёж';
  }

  @override
  String timelineWithout(String amount) {
    return 'Без покупки: $amount';
  }

  @override
  String get timelineBuyAfterPay => 'Купить после зарплаты';

  @override
  String get timelineBalanceLegend => 'Баланс';

  @override
  String get timelineWithPurchase => 'С покупкой';

  @override
  String get timelinePay => 'День зарплаты';

  @override
  String get timelineAssumptions =>
      'Будущее — это прогноз: зарплата в свой день, счета в свои, деньги на жизнь тратятся равномерно, и больше ничего. Проведите по графику, чтобы увидеть любой день.';

  @override
  String get timelineSemantics => 'График баланса и доступных денег по дням';

  @override
  String goalChartSemantics(String goal) {
    return 'График того, как «$goal» достигает цели';
  }

  @override
  String goalChartTarget(String amount, String date) {
    return 'Цель $amount к $date';
  }

  @override
  String goalPaceLabel(String amount) {
    return 'Откладывать за период: $amount';
  }

  @override
  String goalOnTrack(String date) {
    return 'По плану: будет достигнута к $date.';
  }

  @override
  String goalLate(String date, int days) {
    return 'В таком темпе цель будет достигнута $date, на $days дн. позже срока.';
  }

  @override
  String get goalNotMoving =>
      'Сейчас на цель ничего не идёт, поэтому она не приближается.';

  @override
  String goalUsePace(String date) {
    return 'Перенести срок на $date';
  }

  @override
  String get goalPaceNote =>
      'Это только «что если»: ничего не меняется, пока вы не выберете.';

  @override
  String get goalShowPath => 'Посмотреть путь к цели';

  @override
  String get goalHidePath => 'Скрыть';

  @override
  String get billsTitle => 'Счета и подписки';

  @override
  String get billAdd => 'Добавить счёт или подписку';

  @override
  String get billAddSub =>
      'Телефон, интернет, страховка, стриминг… каждое откладывается до срока.';

  @override
  String get billEditNew => 'Новый счёт';

  @override
  String get billEditExisting => 'Изменить счёт';

  @override
  String get billName => 'Что это?';

  @override
  String get billNameHint => 'например, интернет';

  @override
  String get billAmount => 'Каждый платёж';

  @override
  String get billEvery => 'Как часто';

  @override
  String get billEveryWeek => 'Еженедельно';

  @override
  String get billEveryMonth => 'Ежемесячно';

  @override
  String get billEveryQuarter => 'Раз в квартал';

  @override
  String get billEveryYear => 'Ежегодно';

  @override
  String get billNext => 'Следующий платёж';

  @override
  String get billKind => 'Это';

  @override
  String get billKindBill => 'Счёт';

  @override
  String get billKindSubscription => 'Подписка';

  @override
  String get billRepays => 'Погашает';

  @override
  String get billRepaysNothing => 'Ничего, это расход';

  @override
  String get billAddThis => 'Добавить счёт';

  @override
  String get billDelete => 'Удалить счёт';

  @override
  String billRow(String every, String date) {
    return '$every · следующий $date';
  }

  @override
  String billOverdue(String date) {
    return 'Срок был $date';
  }

  @override
  String get billPay => 'Отметить оплаченным';

  @override
  String get billEdit => 'Изменить';

  @override
  String get dayToday => 'Сегодня';

  @override
  String dayIn(int days) {
    return 'Через $days дн.';
  }

  @override
  String dayAgo(int days) {
    return '$days дн. назад';
  }

  @override
  String get homeComingUp => 'Скоро';

  @override
  String homeComingUpTotal(String amount) {
    return '$amount по счетам в ближайшие 30 дней.';
  }

  @override
  String payDueTitle(String date) {
    return 'Зарплата ожидалась $date. Пришла?';
  }

  @override
  String get payDueSub =>
      'Укажите, сколько пришло, — следующая ожидается через период.';

  @override
  String get payArrived => 'Пришла';

  @override
  String get payArrivedTitle => 'Сколько пришло?';

  @override
  String get planRecordPay => 'Зарплата пришла';

  @override
  String get planRecordPaySub => 'Запишите — следующая сдвинется на период';

  @override
  String get accountsTitle => 'Счета';

  @override
  String get accountMain => 'Основной счёт';

  @override
  String get accountKindBank => 'Банковский счёт';

  @override
  String get accountKindCash => 'Наличные';

  @override
  String get accountKindSavings => 'Сбережения';

  @override
  String get accountKindCard => 'Кредитная карта';

  @override
  String get accountKindLoan => 'Кредит';

  @override
  String get accountAdd => 'Добавить счёт';

  @override
  String get accountAddSub =>
      'Наличные, сбережения, карта или кредит. Без подключения банка.';

  @override
  String get accountEditNew => 'Новый счёт';

  @override
  String get accountNameHint => 'например, кошелёк';

  @override
  String get accountHolds => 'Сколько там сейчас';

  @override
  String get accountOwes => 'Сколько должны сейчас';

  @override
  String get accountCounted => 'Учитывать в плане';

  @override
  String get accountCountedSub => 'Эти деньги можно тратить в этом месяце.';

  @override
  String accountOwed(String amount) {
    return 'Долг $amount';
  }

  @override
  String get accountNotCounted => 'Не учитывается';

  @override
  String get accountConfirm => 'Указать реальный остаток';

  @override
  String get accountMove => 'Перевести деньги';

  @override
  String accountMoveTo(String name) {
    return 'Перевести на «$name»';
  }

  @override
  String get accountMoveBlurb =>
      'Перевод между своими счетами — не расход и не доход.';

  @override
  String get accountPayCard => 'Погасить часть';

  @override
  String get accountPayBlurb =>
      'Оплата с основного счёта. Это погашение долга, а не вторая трата.';

  @override
  String get accountRemove => 'Удалить счёт';

  @override
  String get accountInUse =>
      'У счёта есть история, он останется. Можно исключить его из плана.';

  @override
  String get paidFrom => 'Оплачено с';

  @override
  String get categorySuggested =>
      'Подсказано по прошлым тратам. Нажмите другую, чтобы сменить.';

  @override
  String get recoverTitle => 'Деньги к возврату';

  @override
  String recoverTotal(String amount) {
    return 'Может вернуться $amount. Не учитывается, пока не придёт.';
  }

  @override
  String get recoverReturnable => 'Можно вернуть';

  @override
  String get recoverExpect => 'Возвращено, жду возврат денег';

  @override
  String get recoverArrived => 'Деньги вернулись';

  @override
  String get recoverKept => 'Оставил себе';

  @override
  String get recoverPending => 'Возврат в пути';

  @override
  String get recoverRefunded => 'Возвращено';

  @override
  String get recoverPrompt => 'Возврат денег';

  @override
  String recoverWhere(String amount) {
    return 'Вернулось $amount. Куда их направить?';
  }

  @override
  String recoverToGoal(String goal) {
    return 'На цель «$goal»';
  }

  @override
  String get recoverToBuffer => 'В резерв на непредвиденное';

  @override
  String get recoverLeave => 'Оставить свободными';

  @override
  String get accountStopCounting => 'Не учитывать в плане';

  @override
  String get moveTitle => 'Лучший шаг';

  @override
  String get moveTagMove => 'Перевести';

  @override
  String get moveTagWait => 'Подождать';

  @override
  String get moveTagSave => 'Отложить';

  @override
  String get moveTagSpend => 'Тратить';

  @override
  String moveMove(String amount, String account) {
    return 'Переведите $amount с «$account», чтобы покрыть обязательный платёж.';
  }

  @override
  String moveMoveWhy(String claim) {
    return 'На «$claim» не хватает, а эти деньги лежат вне плана.';
  }

  @override
  String get moveDoIt => 'Перевести';

  @override
  String moveWaitGap(String date, String amount) {
    return 'Повремените с лишним: $date на обязательный платёж не хватит $amount.';
  }

  @override
  String get moveWaitGapWhy =>
      'Прогноз учитывает зарплату, счета и траты на жизнь до этого дня.';

  @override
  String moveWaitPay(int days, String now, String later) {
    return 'До зарплаты $days дн. Если подождать, свободных денег станет не $now, а $later.';
  }

  @override
  String get moveWaitPayWhy =>
      'Только если задуманное может подождать. Риска нет в любом случае.';

  @override
  String moveSave(String amount, String account, String goal) {
    return 'Переведите $amount на «$account» для цели «$goal».';
  }

  @override
  String moveSaveWhy(int days) {
    return 'Цель будет достигнута примерно на $days дн. раньше, а свободных денег останется вдвое больше обычного месяца.';
  }

  @override
  String moveSpend(String amount, String date) {
    return 'До $date всё покрыто: $amount свободны.';
  }

  @override
  String get moveSpendWhy =>
      'Счета и цели уже отложены, впереди ничего не проседает, и это заметно больше ваших обычных трат.';

  @override
  String get moveNotNow => 'Не сейчас';

  @override
  String get moveNone => 'Сейчас нечего посоветовать. План в порядке как есть.';

  @override
  String monthIncome(String amount) {
    return 'Поступила зарплата: $amount.';
  }

  @override
  String monthToGoals(String amount) {
    return 'Отложено на цели: $amount.';
  }

  @override
  String monthNow(String free, String aside) {
    return 'Сейчас: свободно $free, отложено $aside.';
  }

  @override
  String get monthAheadTitle => 'Следующие 30 дней';

  @override
  String monthAheadBills(int count, String amount) {
    return 'Счетов: $count, на $amount.';
  }

  @override
  String monthAheadPay(String date) {
    return 'Следующая зарплата ожидается $date.';
  }

  @override
  String monthAheadTightest(String date, String amount) {
    return 'Самый напряжённый день — $date, свободно $amount.';
  }

  @override
  String monthAheadShort(String date, String amount) {
    return '$date на обязательный платёж не хватит $amount.';
  }

  @override
  String get monthWorthKnowing => 'Стоит знать';

  @override
  String insightUp(String category, String amount) {
    return '«$category» выросло на $amount к прошлому месяцу.';
  }

  @override
  String insightGoal(int days, String goal) {
    return 'Если так пойдёт, это около $days дн. цели «$goal» каждый месяц.';
  }

  @override
  String get chatSuggestMove => 'Что мне сейчас лучше сделать?';

  @override
  String get chatSuggestComing => 'Какие счета впереди?';

  @override
  String get chatComingNone =>
      'В ближайшие 30 дней счетов нет. Добавьте свои в «План», и я буду за ними следить.';

  @override
  String get quickAsk => 'Спросить';

  @override
  String get quickPay => 'Зарплата';

  @override
  String get quickBills => 'Счета';

  @override
  String get quickMonth => 'Мой месяц';

  @override
  String get quickPayDue => 'Пора зарплаты. Отметьте, пришла ли она.';

  @override
  String get chartAvg => 'Сред.';

  @override
  String get flowsTitle => 'Приход и расход';

  @override
  String get flowsBlurb =>
      'По неделям: зарплата и возвраты над линией, траты и платежи по долгам под ней.';

  @override
  String flowsWeek(String date) {
    return 'Неделя с $date';
  }

  @override
  String flowsInOut(String moneyIn, String moneyOut) {
    return 'Приход $moneyIn · Расход $moneyOut';
  }

  @override
  String get balanceHistoryTitle => 'Баланс во времени';

  @override
  String rangeMonths(int count) {
    return '$count мес';
  }

  @override
  String get rangeYear => '1 год';

  @override
  String get weekSpentTitle => 'Последние 7 дней';

  @override
  String weekSpentTotal(String amount) {
    return 'Потрачено $amount';
  }

  @override
  String get payGaugeTitle => 'До следующей зарплаты';

  @override
  String payGaugeDaysLabel(int days) {
    return 'дн. осталось';
  }

  @override
  String payGaugeAfter(String date, String amount) {
    return 'После зарплаты $date: свободно $amount';
  }

  @override
  String payGaugeLasts(String amount) {
    return '$amount должно хватить до этого дня.';
  }

  @override
  String get goalsOverall => 'от всех целей';

  @override
  String goalsThisMonth(String amount) {
    return '+$amount за месяц';
  }

  @override
  String get goalsNothingThisMonth => 'В этом месяце ничего';

  @override
  String get goalsAllOnTrack => 'Всё по плану';

  @override
  String goalsOnTrackCount(int onTrack, int total) {
    return '$onTrack из $total по плану';
  }

  @override
  String goalsNextUp(String goal, String date) {
    return 'Ближайшая: «$goal», $date';
  }

  @override
  String get goalsTips => 'Как прийти к цели быстрее';

  @override
  String get goalsTipsSub => 'Спросите Upino — по вашим тратам';

  @override
  String get goalsDetailTitle => 'Каждая цель';

  @override
  String get demoTry => 'Попробовать на примере';

  @override
  String get demoTrySub =>
      'Четыре цели, счета и три месяца истории — в копии, которая не ваша и не сохраняется.';

  @override
  String get demoBanner => 'Пример: здесь ничего не ваше и не сохраняется.';

  @override
  String get demoExit => 'Выйти';

  @override
  String get demoGoalTrip => 'Поездка';

  @override
  String get demoGoalLaptop => 'Ноутбук';

  @override
  String get demoGoalEmergency => 'Запас';

  @override
  String get demoGoalCar => 'Машина';

  @override
  String get demoBillPhone => 'Телефон';

  @override
  String get demoBillInternet => 'Интернет';

  @override
  String get demoBillGym => 'Спортзал';
}
