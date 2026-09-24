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
  String get onboardingBalanceLabel => 'Tus ahorros hoy';

  @override
  String get onboardingBalanceHint =>
      'Dinero del que realmente podrías gastar, no el que piensas no tocar.';

  @override
  String get onboardingIncomeLabel => '¿Cuánto ingresas al mes?';

  @override
  String get onboardingIncomeHint =>
      'Si varía, indica el rango. Tu plan se construye sobre el extremo inferior.';

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
  String get onboardingFinish => 'Crear mi plan';

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
  String currencyChangeTitle(String currency) {
    return '¿Cambiar a $currency?';
  }

  @override
  String currencyChangeBlurb(String currency) {
    return 'Cada importe de tu plan conserva su número y se mostrará en $currency desde ahora. No se convierte nada con un tipo de cambio: úsalo para corregir la moneda, no para convertir tu dinero.';
  }

  @override
  String get currencyChangeConfirm => 'Cambiar';

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

  @override
  String get profileLedgerTitle => '¿El registro está completo?';

  @override
  String get ledgerComplete => 'Todo lo que has gastado está registrado.';

  @override
  String get ledgerPartial =>
      'Parte del gasto solo apareció al confirmar tu saldo.';

  @override
  String get ledgerUnknown =>
      'Upino no puede saber cuánto falta. Confirma tu saldo para averiguarlo.';

  @override
  String get askTitle => 'Pregunta antes de gastar';

  @override
  String get askBlurb =>
      'Prueba una compra contra tu plan. No se registra nada y nada cambia.';

  @override
  String get askAmountLabel => '¿Cuánto sería?';

  @override
  String get askRun => 'Ver qué pasaría';

  @override
  String get askDoNotBuy => 'No comprar';

  @override
  String get askBuyNow => 'Comprarlo hoy';

  @override
  String askBuyAfter(String date) {
    return 'Comprarlo después del $date';
  }

  @override
  String get askUnchanged => 'Tu plan queda igual.';

  @override
  String get askStsAfter => 'Lo que podrías gastar después';

  @override
  String get askBreaks => 'Esto deja sin cubrir algo que tienes que pagar.';

  @override
  String get askSafe => 'Nada de lo que tienes que pagar queda sin cubrir.';

  @override
  String get askCosts => 'Qué recibe menos';

  @override
  String askCostLine(String label, String amount) {
    return '$label · $amount menos';
  }

  @override
  String get askWaitingHelps =>
      'Esperar a que llegue tu ingreso lo cubre todo.';

  @override
  String get askNoIncome =>
      'Aún no se espera ningún ingreso, así que no hay un momento posterior con el que comparar.';

  @override
  String askAssumption(String date) {
    return 'Supone que tu ingreso llega como se espera el $date.';
  }

  @override
  String get askNoVerdict => 'Upino no dice sí ni no. La decisión es tuya.';

  @override
  String get receipt => 'Recibo';

  @override
  String get receiptAdd => 'Añadir un recibo';

  @override
  String get receiptCamera => 'Hacer una foto';

  @override
  String get receiptGallery => 'Elegir una foto';

  @override
  String get receiptAttached => 'Recibo adjuntado';

  @override
  String get receiptRemove => 'Quitar la foto';

  @override
  String get onboardingIncomeFrom => 'Al menos';

  @override
  String get onboardingIncomeTo => 'Hasta';

  @override
  String get onboardingIncomeToOptional => 'Opcional';

  @override
  String incomeRange(String low, String high) {
    return '$low a $high';
  }

  @override
  String incomeRangeNote(String low) {
    return 'Tu plan se construye sobre $low. Lo que venga por encima es tuyo cuando llegue.';
  }

  @override
  String get categoryFood => 'Comida';

  @override
  String get categoryTransport => 'Transporte';

  @override
  String get categoryBills => 'Facturas';

  @override
  String get categoryShopping => 'Compras';

  @override
  String get categoryHealth => 'Salud';

  @override
  String get categoryFun => 'Ocio';

  @override
  String get categoryOther => 'Otros';

  @override
  String get categoryUnsorted => 'Sin clasificar';

  @override
  String get categoryPrompt => '¿En qué fue?';

  @override
  String get spendingTitle => 'En qué se fue';

  @override
  String get spendingWindow => 'Gastos registrados en los últimos 30 días';

  @override
  String get backupSection => 'Copia de seguridad';

  @override
  String get backupSave => 'Guardar una copia';

  @override
  String get backupSaveSub =>
      'Protegida con contraseña. Envíala a un lugar seguro, como tu nube.';

  @override
  String get backupRestore => 'Restaurar una copia';

  @override
  String get backupRestoreSub => 'Sustituye el plan de este teléfono';

  @override
  String get backupPassword => 'Contraseña';

  @override
  String get backupPasswordRepeat => 'Repite la contraseña';

  @override
  String get backupPasswordSaveBlurb =>
      'Necesitarás esta contraseña para restaurar. Si la olvidas no se puede recuperar. Las fotos de recibos no se incluyen.';

  @override
  String get backupPasswordOpenBlurb =>
      'La contraseña con la que se guardó esta copia.';

  @override
  String get backupPasswordShort => 'Al menos 6 caracteres';

  @override
  String get backupPasswordMismatch => 'No coinciden';

  @override
  String get backupOpen => 'Abrir';

  @override
  String get backupReplaceTitle => '¿Sustituir este plan?';

  @override
  String get backupReplaceBlurb =>
      'Todo lo de este teléfono se sustituye por la copia. No se puede deshacer.';

  @override
  String get backupReplace => 'Sustituir';

  @override
  String get backupRestored => 'Copia restaurada';

  @override
  String get backupWrongPassword => 'Esa contraseña no abre esta copia.';

  @override
  String get backupNotABackup => 'Ese archivo no es una copia de Upino.';

  @override
  String get backupUnreadable =>
      'Esta copia es de una versión más nueva de Upino. Actualiza la app e inténtalo de nuevo.';

  @override
  String get inflationTitle => 'Inflación';

  @override
  String get inflationNotSet =>
      'Sin definir. Añade la tasa anual de tu país para ver lo que costarán de verdad tus metas.';

  @override
  String inflationRate(String rate) {
    return '$rate % al año';
  }

  @override
  String get inflationDialogTitle => 'Inflación anual';

  @override
  String get inflationDialogBlurb =>
      'Los precios suben, así que una meta fijada con el dinero de hoy costará más en su fecha. Indica la tasa que esperas; déjalo vacío para desactivarlo.';

  @override
  String goalsInflated(String rate, String amount) {
    return 'Al $rate % anual, costará unos $amount para entonces.';
  }

  @override
  String get holdingsTitle => 'Otros ahorros';

  @override
  String get holdingsBlurb =>
      'Dólares, oro, monedas. Se muestran junto al plan y nunca cuentan en lo que puedes gastar.';

  @override
  String get holdingsAdd => 'Añadir un ahorro';

  @override
  String get holdingsAddSub => 'No cuenta en lo que puedes gastar';

  @override
  String get holdingsTotal => 'En total';

  @override
  String holdingSummary(String quantity, String price, String date) {
    return '$quantity × $price · precio del $date';
  }

  @override
  String get holdingEditNew => 'Nuevo ahorro';

  @override
  String get holdingEditExisting => 'Cambiar ahorro';

  @override
  String get holdingName => '¿Qué es?';

  @override
  String get holdingNameHint => 'Dólar, oro…';

  @override
  String get holdingUsd => 'Dólar';

  @override
  String get holdingEur => 'Euro';

  @override
  String get holdingGold => 'Oro (gramo)';

  @override
  String get holdingCoin => 'Moneda de oro';

  @override
  String get holdingQuantity => 'Cuántos';

  @override
  String get holdingUnitPrice => 'Cuánto vale uno hoy';

  @override
  String holdingWorth(String amount) {
    return 'Vale $amount en total';
  }

  @override
  String get holdingDelete => 'Quitar este ahorro';

  @override
  String get fasterTitle => 'Registro más rápido';

  @override
  String get smsTitle => 'Leer mensajes del banco';

  @override
  String get smsDetail =>
      'Los gastos que te avisa el banco se ofrecen para registrar con un toque. Los mensajes se leen solo en este teléfono y no se envían a ningún sitio.';

  @override
  String get smsDenied =>
      'Upino no tiene permiso para leer mensajes. Puedes darlo en los ajustes del teléfono.';

  @override
  String smsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mensajes del banco por revisar',
      one: '1 mensaje del banco por revisar',
    );
    return '$_temp0';
  }

  @override
  String get smsWaitingSub => 'Registra cada uno con un toque o sáltalo';

  @override
  String get smsReviewTitle => 'De tu banco';

  @override
  String get smsReviewBlurb =>
      'No se registra nada hasta que pulses Registrar. Comprueba el importe con el mensaje.';

  @override
  String get smsReviewDone => 'Todo al día.';

  @override
  String get smsRecord => 'Registrar';

  @override
  String get smsSkip => 'Saltar';

  @override
  String get reminderTitleSetting => 'Recordatorio por la noche';

  @override
  String get reminderDetail =>
      'A las 9 de la noche, solo los días sin nada registrado.';

  @override
  String get reminderDenied =>
      'Upino no tiene permiso para mostrar notificaciones. Puedes darlo en los ajustes.';

  @override
  String get reminderTitle => '¿Has gastado algo hoy?';

  @override
  String get reminderBody =>
      'Regístralo en segundos para que la cifra de mañana sea correcta.';

  @override
  String get reminderChannel => 'Recordatorio por la noche';

  @override
  String get widgetSpend => '+ Gasto';

  @override
  String get widgetAdd => 'Añadir a la pantalla de inicio';

  @override
  String get widgetAddSub =>
      'Lo que puedes gastar y un botón para registrar, sin abrir la app';

  @override
  String get voiceListening => 'Escuchando… di el importe y en qué fue.';

  @override
  String voiceHeard(String text) {
    return 'Oído: «$text». Revisa el importe y guarda.';
  }

  @override
  String get voiceNothing =>
      'No se oyó ningún importe. Inténtalo de nuevo o escríbelo.';

  @override
  String get voicePrivacy =>
      'Tu teléfono convierte la voz en texto. Sin reconocimiento sin conexión, pasa por el servicio de voz del teléfono.';

  @override
  String get voiceButton => 'Dilo';

  @override
  String get voiceUnavailable =>
      'Este teléfono no tiene reconocimiento de voz que la app pueda usar. Escribe el importe.';

  @override
  String get voiceNoPermission =>
      'Upino no tiene permiso para usar el micrófono. Puedes darlo en los ajustes.';

  @override
  String get voiceNetwork =>
      'El reconocimiento de voz de este teléfono necesita internet y no pudo conectarse.';

  @override
  String voiceNoAmount(String text) {
    return 'Se oyó «$text», pero sin importe. Inténtalo de nuevo o escríbelo.';
  }

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get navAsk => 'Preguntar';

  @override
  String get alertsTitle => 'Te necesita';

  @override
  String get alertsEmpty => 'Nada te necesita ahora. El plan está al día.';

  @override
  String alertUnfunded(String label, String amount) {
    return 'A $label le faltan $amount';
  }

  @override
  String get alertUnfundedDetail =>
      'Algo que debes pagar no está cubierto con lo que tienes.';

  @override
  String alertIncomeLate(String date) {
    return 'Tu sueldo se esperaba el $date';
  }

  @override
  String get alertIncomeLateDetail =>
      'No cuenta hasta que llegue. Cambia la fecha en Plan si se movió.';

  @override
  String alertGoalBehind(String name, String amount) {
    return '$name va $amount por detrás este periodo';
  }

  @override
  String get alertGoalBehindDetail =>
      'Lo que tienes no llega a la parte de este periodo.';

  @override
  String get chatHint => 'Pregúntame o escribe un precio';

  @override
  String get chatSuggestSafe => '¿Cuánto puedo gastar?';

  @override
  String get chatSuggestPay => '¿Cuándo cobro?';

  @override
  String get chatSuggestWhere => '¿En qué se fue mi dinero?';

  @override
  String get chatSuggestAside => '¿Qué está apartado?';

  @override
  String chatSafe(String amount, String date) {
    return 'Puedes gastar $amount hasta el $date.';
  }

  @override
  String get chatSafeStale =>
      'Un detalle: tu saldo necesita confirmarse, así que tómalo como estimación.';

  @override
  String chatPay(String amount, String date) {
    return 'Tu próximo sueldo es de $amount, previsto el $date.';
  }

  @override
  String get chatPayNone =>
      'Aún no sé cuándo cobras. Añádelo en Plan y lo tendré en cuenta.';

  @override
  String get chatWhere => 'Esto es en lo que se fue en los últimos 30 días:';

  @override
  String get chatWhereNone =>
      'No hay gastos en los últimos 30 días. O ha sido un mes tranquilo o no se han anotado.';

  @override
  String chatAside(String amount) {
    return 'Se apartan $amount antes de que nada cuente como gastable:';
  }

  @override
  String chatPurchase(String amount) {
    return 'Veamos qué harían $amount.';
  }

  @override
  String get chatHelp =>
      'Mmm, no lo he entendido del todo. Puedo decirte cuánto puedes gastar, cuándo cobras, en qué se fue el dinero, qué está apartado o cómo gastar menos. O escribe un precio y te enseño qué haría comprarlo.';

  @override
  String get chatHelloNew =>
      '¡Hola! Soy Upino. Eres nuevo, así que de momento solo sé lo básico: tu saldo, tu sueldo y lo que apartas. Con eso ya puedo decirte cuánto puedes gastar y qué haría una compra. Sigue anotando tus gastos y, en una temporada, conoceré tus hábitos lo bastante para ser tu asesor personal.';

  @override
  String chatHelloLearning(int days, int spends, int remaining) {
    return '¡Hola de nuevo! Llevo $days días y $spends gastos aprendiendo. En unos $remaining días tendré una temporada completa.';
  }

  @override
  String chatHelloFamiliar(int days) {
    return '¡Hola de nuevo! Ya he visto $days días de tu dinero, así que pregúntame lo que quieras, incluso cómo gastar menos.';
  }

  @override
  String chatHelloAlerts(int count) {
    return 'Por cierto, hay $count cosas que te necesitan: están en la campana.';
  }

  @override
  String chatPurchaseFits(String left) {
    return 'Comprarlo hoy deja cubierto todo lo que debes pagar y aún te quedan $left.';
  }

  @override
  String chatPurchaseWait(String date) {
    return 'Comprarlo hoy dejaría algo que debes pagar sin cubrir. Si esperas al $date, todo queda cubierto.';
  }

  @override
  String chatPurchaseStillShort(String date) {
    return 'Ojo: incluso después de cobrar el $date, dejaría algo que debes pagar sin cubrir.';
  }

  @override
  String get chatPurchaseShort =>
      'Comprarlo hoy dejaría algo que debes pagar sin cubrir.';

  @override
  String chatSafePerDay(String perDay, int days) {
    return 'Repartido en $days días, son unos $perDay al día.';
  }

  @override
  String chatSafeNothing(String date) {
    return 'Ahora mismo no sobra nada hasta el $date: todo lo que tienes ya está comprometido.';
  }

  @override
  String chatPayIn(int days) {
    return 'Es decir, dentro de $days días.';
  }

  @override
  String get chatPayLate =>
      'Va con retraso, así que no cuenta hasta que confirmes que llegó.';

  @override
  String get chatPayRange =>
      'El plan cuenta con el mínimo, así que un buen mes es un extra, no un agujero.';

  @override
  String chatWhereSoFar(int days) {
    return 'Solo he visto $days días, así que es un primer vistazo:';
  }

  @override
  String chatWhereTop(String category, int share) {
    return '$category es lo mayor: el $share % del total.';
  }

  @override
  String get chatWhereTooSoon =>
      'Es un poco pronto: casi no he visto gastos todavía. Anota algunos y pregúntame la semana que viene.';

  @override
  String get chatAdviceTooSoon =>
      'Me encantaría ayudarte, pero sinceramente aún no conozco bien tus gastos, y un consejo sin eso sería adivinar. Anota tus gastos (clasificarlos ayuda mucho) y pregúntame en unas semanas.';

  @override
  String chatAdviceBiggest(String category, String amount, String tenth) {
    return 'Tu mayor gasto en los últimos 30 días fue $category: $amount. Recortarlo una décima parte liberaría unos $tenth al mes.';
  }

  @override
  String get chatAdviceSort =>
      'Veo cuánto gastas pero no en qué. Ponles categoría al anotarlos y te diré dónde recortar.';

  @override
  String chatAdviceMore(String amount) {
    return 'Gastaste $amount más que el mes anterior.';
  }

  @override
  String chatAdviceLess(String amount) {
    return 'Bien: son $amount menos que el mes anterior.';
  }

  @override
  String get chatAdviceLearning =>
      'Aún estoy aprendiendo tus hábitos, así que tómalo como una primera pista.';

  @override
  String get chatSmallHello => '¡Hola! ¿Qué quieres saber de tu dinero?';

  @override
  String get chatSmallThanks =>
      '¡Cuando quieras! Aquí estoy cada vez que vayas a gastar.';

  @override
  String get chatSmallWho =>
      'Soy el asistente de Upino. Solo sé lo que hay en tu plan y cada cifra sale de ahí; nada sale de este teléfono. No te diré sí o no, pero te enseñaré qué te deja cada opción.';

  @override
  String get chatSuggestAdvice => '¿Cómo gasto menos?';
}
