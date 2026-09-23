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
}
