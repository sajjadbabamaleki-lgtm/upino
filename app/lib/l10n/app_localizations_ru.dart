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
  String get onboardingBalanceLabel => 'Сколько у вас сейчас?';

  @override
  String get onboardingBalanceHint => 'На счетах, с которых вы тратите';

  @override
  String get onboardingIncomeLabel => 'Каким будет следующий доход?';

  @override
  String get onboardingIncomeHint => 'Достаточно обычной суммы';

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
  String get onboardingFinish => 'Показать, сколько я могу потратить';

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
}
