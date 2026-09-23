// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get navHome => 'Inicio';

  @override
  String get navPlan => 'Plan';

  @override
  String get navGoals => 'Metas';

  @override
  String get navActivity => 'Actividad';

  @override
  String get navProfile => 'Perfil';

  @override
  String get currencyTitle => '¿Qué moneda?';

  @override
  String get currencyBlurb =>
      'Todo tu plan se guarda en esta moneda. Elige aquella en la que realmente cobras.';

  @override
  String get currencySearchHint => 'Busca país, moneda o código';

  @override
  String currencyNoMatch(String query) {
    return 'Nada coincide con «$query». Prueba con el país o el código de tres letras.';
  }

  @override
  String get onboardingBadge => 'Lleva cerca de un minuto';

  @override
  String get onboardingTitle => 'Crea tu plan';

  @override
  String get onboardingBlurb =>
      'Con dos respuestas basta para empezar. Lo demás puede esperar.';

  @override
  String get onboardingBalanceLabel => '¿Cuánto tienes ahora mismo?';

  @override
  String get onboardingBalanceHint =>
      'Sumando las cuentas desde las que gastas';

  @override
  String get onboardingIncomeLabel => '¿Cuánto será tu próximo ingreso?';

  @override
  String get onboardingIncomeHint => 'Con tu importe habitual basta';

  @override
  String get onboardingPayDay => '¿Cuándo llega tu próximo ingreso?';

  @override
  String onboardingDays(int count) {
    return '$count días';
  }

  @override
  String get onboardingCommitments => 'Añade tus compromisos';

  @override
  String get onboardingCommitmentsOpen => 'Alquiler, gastos básicos y una meta';

  @override
  String get onboardingCommitmentsShut => 'Es opcional, y puedes hacerlo luego';

  @override
  String get onboardingRentLabel => 'Alquiler y recibos fijos';

  @override
  String get onboardingRentHint => 'Vencen antes de tu próximo ingreso';

  @override
  String get onboardingEssentialsLabel => 'Comida y transporte';

  @override
  String get onboardingEssentialsHint =>
      'Lo que necesitas para pasar el periodo';

  @override
  String get onboardingGoalLabel => 'Ahorro para una meta';

  @override
  String get onboardingGoalHint => 'Lo que quieres apartar este periodo';

  @override
  String get onboardingFinish => 'Ver cuánto puedo gastar';

  @override
  String get onboardingIncomplete =>
      'Completa las dos primeras respuestas para continuar';

  @override
  String get tapToType => 'Toca para escribir';

  @override
  String get heroSafeToSpend => 'Puedes gastar ahora';

  @override
  String get heroNotUpToDate => 'No está al día';

  @override
  String get heroRecordSpend => 'Registrar un gasto';

  @override
  String get heroSeeShort => 'Ver qué falta';

  @override
  String get heroConfirmBalance => 'Confirmar saldo';

  @override
  String get heroReviewBlurb =>
      'Comprueba tu saldo para que esta cifra vuelva a ser fiable.';

  @override
  String heroUntilSetAside(String date, String amount) {
    return 'Hasta el $date · $amount apartado';
  }

  @override
  String heroShort(String amount) {
    return 'Faltan $amount';
  }

  @override
  String heroUnfunded(String label, String amount) {
    return '$label · $amount sin cubrir';
  }

  @override
  String get heroBalanceNever => 'El saldo aún no se ha confirmado';

  @override
  String get heroBalanceToday => 'Saldo confirmado hoy';

  @override
  String get heroBalanceYesterday => 'Saldo confirmado ayer';

  @override
  String heroBalanceDays(int count) {
    return 'Saldo confirmado hace $count días';
  }

  @override
  String get confirm => 'Confirmar';

  @override
  String get homeTitle => 'Tu plan';

  @override
  String homeUntilTotal(String date, String amount) {
    return 'Hasta el $date · $amount en total';
  }

  @override
  String homeRecorded(String amount) {
    return '$amount registrado';
  }

  @override
  String get homeAttention => 'Necesita tu atención';

  @override
  String homeNotCovered(String amount) {
    return '$amount sin cubrir';
  }

  @override
  String get homeAfterNextPay => 'Tras tu próximo ingreso';

  @override
  String homeOncePayArrives(String date) {
    return 'Cuando llegue tu ingreso el $date';
  }

  @override
  String get homeSetAsideFirst => 'Se aparta primero';

  @override
  String get homeProtectedBlurb => 'Protegido antes de que nada sea gastable.';

  @override
  String get homeNothingSetAside =>
      'Aún no hay nada apartado. Todo lo que tienes es gastable.';

  @override
  String get homeWhyThisNumber => 'Por qué esta cifra';

  @override
  String get homeWhatIsShort => 'Qué falta';

  @override
  String get homeShortBlurb =>
      'Aquí nada se mueve ni se aplaza por ti. Son compromisos que tu dinero actual no cubre.';

  @override
  String get askSpendTitle => '¿Cuánto has gastado?';

  @override
  String get askBalanceTitle => '¿Cuál es tu saldo ahora?';

  @override
  String get askBalanceBlurb =>
      'Cualquier diferencia se registra como corrección, nunca como gasto.';

  @override
  String get whyNoChange => 'Nada ha cambiado desde tu plan anterior.';

  @override
  String get whyPayArrived => 'Llegó tu ingreso, así que el plan se actualizó.';

  @override
  String get whyBillPaid =>
      'Se pagó un recibo para el que habías apartado dinero.';

  @override
  String get whyHeldForBill =>
      'Se retiene dinero para un recibo que vence justo después de tu próximo ingreso.';

  @override
  String get whyOvercommitted =>
      'Te has comprometido a más de lo que tienes ahora.';

  @override
  String get whyStale => 'Tu saldo no se ha confirmado recientemente.';

  @override
  String get whyCardLarger =>
      'El saldo de tu tarjeta supera el dinero que tienes.';

  @override
  String get whyPayLate => 'Tu ingreso previsto todavía no ha llegado.';

  @override
  String get whyOverdue => 'Algo ha pasado su fecha de vencimiento.';

  @override
  String get whyBufferShort => 'Tu colchón de emergencia no está completo.';

  @override
  String get whyGoalShort =>
      'Tu meta de ahorro no puede cubrirse del todo ahora.';

  @override
  String get whyFlexibleLess =>
      'Una meta flexible recibió menos de lo previsto.';

  @override
  String get whyDuplicate => 'Una operación repetida se contó una sola vez.';

  @override
  String get planTitle => 'Plan';

  @override
  String get planBlurb =>
      'A qué está comprometido tu dinero, antes de que nada sea gastable.';

  @override
  String get planMoneyAndIncome => 'Dinero e ingresos';

  @override
  String get planMoneyYouHave => 'Dinero que tienes';

  @override
  String get planNextPay => 'Próximo ingreso';

  @override
  String get planYourNextPay => 'Tu próximo ingreso';

  @override
  String get planNotSet => 'Sin definir';

  @override
  String get planExpectedBlurb =>
      'Esto solo está previsto, así que queda fuera de lo que puedes gastar ahora.';

  @override
  String get planSetAsideFirst => 'Se aparta primero';

  @override
  String get planNothingSetAside =>
      'No hay nada apartado, así que todo lo que tienes es gastable.';

  @override
  String get planAddToPlan => 'Añadir a tu plan';

  @override
  String get planGoals => 'Metas';

  @override
  String get planSaveToward => 'Ahorrar para algo';

  @override
  String get planSaveTowardSub => 'Un viaje, una fianza, un portátil nuevo';

  @override
  String get planAllGoals => 'Todas las metas';

  @override
  String get planAllGoalsSub => 'Añade, edita o aparta dinero';

  @override
  String get planHowMuchSetAside => '¿Cuánto necesitas apartar para esto?';

  @override
  String get planChangeOrRemove => 'Cambia el importe o quítalo de tu plan.';

  @override
  String get planRemove => 'Quitar del plan';

  @override
  String planDue(String date) {
    return ' · vence el $date';
  }

  @override
  String get priorityMandatory => 'Hay que pagarlo — va primero';

  @override
  String get priorityEssential => 'Necesidades del día a día';

  @override
  String get priorityBuffer => 'Reservado para imprevistos';

  @override
  String get priorityCard => 'Ya gastado con tarjeta';

  @override
  String get prioritySinkingFund => 'Ahorro para un recibo conocido';

  @override
  String get priorityGoal => 'Una meta a la que te comprometiste';

  @override
  String get priorityDiscretionary => 'Está bien tenerlo — cede primero';

  @override
  String get goalsTitle => 'Metas';

  @override
  String get goalsBlurbEmpty => 'Todavía no ahorras para nada.';

  @override
  String get goalsBlurb => 'Lo que cada meta necesita de este periodo.';

  @override
  String get goalsEmptyCard =>
      'Añade algo para lo que estés ahorrando: un viaje, una fianza, un portátil nuevo. Upino calcula cuánto retener en cada periodo para que llegue a tiempo.';

  @override
  String get goalsNew => 'Nueva meta';

  @override
  String get goalsNewSub => 'Algo para lo que apartas dinero';

  @override
  String get goalsAddMoney => 'Añadir dinero';

  @override
  String goalsAddTo(String name) {
    return 'Añadir a $name';
  }

  @override
  String get goalsAddBlurb =>
      'Esto registra lo que has apartado. No gasta nada: reduce lo que hay que retener de aquí en adelante.';

  @override
  String get goalsEachPeriod => 'Cada periodo';

  @override
  String get goalsTargetDate => 'Fecha objetivo';

  @override
  String goalsOf(String amount) {
    return 'de $amount';
  }

  @override
  String goalsPeriodsToGo(int count) {
    return 'Quedan $count periodos de cobro';
  }

  @override
  String get goalsDone => 'Ahorrado por completo';

  @override
  String get goalsPausedStatus => 'En pausa — no se retiene nada';

  @override
  String get goalsFlexibleStatus =>
      'Flexible — cede ante cualquier pago obligatorio';

  @override
  String get goalEditNew => '¿Para qué estás ahorrando?';

  @override
  String get goalEditExisting => 'Editar meta';

  @override
  String get goalName => 'Nombre';

  @override
  String get goalNameHint => 'Un viaje, una fianza, un portátil';

  @override
  String get goalTotal => 'Cuánto en total';

  @override
  String get goalByWhen => 'Para cuándo';

  @override
  String goalMonths(int count) {
    return '$count meses';
  }

  @override
  String get goalOneYear => '1 año';

  @override
  String get goalTwoYears => '2 años';

  @override
  String get goalFirmness => '¿Cómo de firme es?';

  @override
  String get goalKindHard => 'Comprometida';

  @override
  String get goalKindHardSub => 'Se retiene antes de que nada sea gastable';

  @override
  String get goalKindFlexible => 'Flexible';

  @override
  String get goalKindFlexibleSub => 'Cede ante cualquier pago obligatorio';

  @override
  String get goalKindPaused => 'En pausa';

  @override
  String get goalKindPausedSub => 'Sigue visible, no se retiene nada';

  @override
  String get goalSaveChanges => 'Guardar cambios';

  @override
  String get goalAddThis => 'Añadir esta meta';

  @override
  String get goalDelete => 'Eliminar esta meta';

  @override
  String get activityTitle => 'Actividad';

  @override
  String get activityBlurb =>
      'Todo lo que has registrado, lo más reciente primero.';

  @override
  String get activityEmpty =>
      'Cuando registres un gasto aparecerá aquí, y podrás quitarlo si te equivocaste.';

  @override
  String get activityRemoveIt => 'Quitarla';

  @override
  String get activityKeepIt => 'Dejarla';

  @override
  String get activitySpent => 'Gasto';

  @override
  String get activityIncome => 'Ingreso';

  @override
  String get activityCorrection => 'Corrección';

  @override
  String get activityRemoved => 'Quitada';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileConfirmBalance => 'Confirma tu saldo';

  @override
  String get profileTrustTitle => '¿Cuánto se puede fiar de la cifra?';

  @override
  String get profileTrustFresh => 'Al día. Nada necesita tu atención.';

  @override
  String get profileTrustDegraded =>
      'Hace tiempo que no confirmas tu saldo. La cifra se sigue mostrando, solo que con menos certeza.';

  @override
  String get profileTrustReview =>
      'Demasiado antigua o incierta para fiarse. Confirma tu saldo para arreglarlo.';

  @override
  String get profileConfirmedNever => 'Aún sin confirmar';

  @override
  String get profileConfirmedToday => 'Confirmado hoy';

  @override
  String get profileConfirmedYesterday => 'Confirmado ayer';

  @override
  String profileConfirmedDays(int count) {
    return 'Confirmado hace $count días';
  }

  @override
  String get profileAppearance => 'Apariencia';

  @override
  String get profileTheme => 'Tema';

  @override
  String get profileThemeBlurb =>
      'Seguir al teléfono es lo predeterminado, así no se impone nada.';

  @override
  String get themePhone => 'Teléfono';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get profileLanguage => 'Idioma';

  @override
  String get profileLanguageBlurb =>
      'Seguir al teléfono es lo predeterminado, así no se impone nada.';

  @override
  String get languagePhone => 'Teléfono';

  @override
  String get profileCurrency => 'Moneda';

  @override
  String get profileYourData => 'Tus datos';

  @override
  String get profileDelete => 'Eliminar mi plan';

  @override
  String get profileDeleteSub => 'Borra todo y vuelve a la configuración';

  @override
  String get profileStartOver => '¿Empezar de nuevo?';

  @override
  String get profileStartOverBlurb =>
      'Tu plan y todo lo que registraste se eliminan. Esto no se puede deshacer.';

  @override
  String get profileDeleteEverything => 'Eliminarlo todo';

  @override
  String get profileKeepPlan => 'Conservar mi plan';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String activityRemoveAmount(String amount) {
    return '¿Quitar $amount?';
  }

  @override
  String get activityRemoveDetail =>
      'Deja de contar en tu plan de inmediato. La entrada permanece en esta lista marcada como quitada, así tu registro sigue completo.';

  @override
  String get activityCardPurchase => 'Compra con tarjeta';

  @override
  String get activityCardPayment => 'Pago de tarjeta';

  @override
  String get activityRefund => 'Reembolso';

  @override
  String get activityTransfer => 'Movido entre cuentas';

  @override
  String get activityLoan => 'Préstamo recibido';

  @override
  String get activityDebtPayment => 'Pago de deuda';

  @override
  String get activityBalanceCorrected => 'Saldo corregido';

  @override
  String get activityBlurbEmpty => 'Aún no hay nada registrado.';

  @override
  String get profileStartAgain => 'Empezar de nuevo';

  @override
  String get claimRent => 'Alquiler y recibos';

  @override
  String get claimCardMinimum => 'Pago mínimo de tarjeta';

  @override
  String get claimEssentials => 'Comida y transporte';

  @override
  String get claimBuffer => 'Colchón de emergencia';

  @override
  String get languageTitle => '¿Qué idioma?';

  @override
  String get languageBlurb => 'Puedes cambiarlo luego en Perfil.';
}
