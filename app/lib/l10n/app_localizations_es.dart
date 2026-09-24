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

  @override
  String get chatTitle => 'Upino';

  @override
  String get chatNew => 'Nuevo chat';

  @override
  String get chatResumed =>
      'Las respuestas se calculan con tu plan tal como está hoy.';

  @override
  String get chatWhy => 'Así sale la cifra:';

  @override
  String get chatWhyHave => 'Lo que tienes';

  @override
  String get chatWhySetAside => 'Apartado primero';

  @override
  String get chatWhyLeft => 'Para gastar';

  @override
  String get chatSmallHowAreYou =>
      '¡Bien, gracias por preguntar! Tu dinero sigue donde lo dejamos. ¿Qué quieres saber?';

  @override
  String get chatSmallBye => '¡Adiós! Vuelve antes de tu próximo gran gasto.';

  @override
  String get chatSmallOkay => '¿Algo más que quieras ver?';

  @override
  String get askHubTitle => 'Habla con Upino';

  @override
  String get askHubNew =>
      'Pregunta cuánto puedes gastar, qué haría una compra o cuándo cobras. Aún te estoy conociendo; cuanto más anotes, más útil seré.';

  @override
  String askHubLearning(int days) {
    return 'Estoy aprendiendo tus hábitos: en unos $days días tendré una temporada completa para aconsejarte.';
  }

  @override
  String get askHubFamiliar =>
      'Ya conozco bien tu dinero. Pregúntame lo que quieras, incluso cómo gastar menos.';

  @override
  String get askHubStart => 'Empezar a hablar';

  @override
  String get askHubCommon => 'Preguntas frecuentes';

  @override
  String get askHubHistory => 'Tus conversaciones';

  @override
  String askHubTurns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count preguntas',
      one: '1 pregunta',
    );
    return '$_temp0';
  }

  @override
  String askHubAsidePreview(String amount, int count) {
    return '$amount apartados en $count compromisos';
  }

  @override
  String get askHubDeleteTitle => '¿Borrar esta conversación?';

  @override
  String get askHubDeleteBlurb =>
      'Solo se borra la conversación. Tu plan no cambia.';

  @override
  String get chatSmallHi => '¡Hola!';

  @override
  String get chatSmallHiFine => '¡Hola! Bien, gracias.';

  @override
  String chatSafeLasts(int days) {
    return 'Tiene que durarte $days días, hasta que cobres.';
  }

  @override
  String homeSpokenFor(String amount, String date) {
    return '$amount de tu dinero ya tiene destino hasta el $date.';
  }

  @override
  String askGoalLater(String goal, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: 'un día',
    );
    return '$goal · unos $_temp0 más tarde';
  }

  @override
  String get askGoalsTitle => 'Las metas se retrasan';

  @override
  String get askGoalsNote =>
      'Aproximado, al ritmo al que se ahorra para cada meta.';

  @override
  String chatPurchaseGoal(String goal, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: 'un día',
    );
    return 'Retrasaría $goal unos $_temp0.';
  }

  @override
  String get monthTitle => 'Tu mes';

  @override
  String get monthWindow => 'Los últimos 30 días frente a los 30 anteriores';

  @override
  String monthTooSoon(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: 'un día',
    );
    return 'El resumen del mes necesita un mes de gastos. El tuyo estará listo en $_temp0.';
  }

  @override
  String monthSpent(String amount) {
    return 'En los últimos 30 días salieron $amount.';
  }

  @override
  String get monthNothing => 'No se registró nada en los últimos 30 días.';

  @override
  String monthMore(String amount) {
    return 'Son $amount más que en los 30 días anteriores.';
  }

  @override
  String monthLess(String amount) {
    return 'Son $amount menos que en los 30 días anteriores.';
  }

  @override
  String get monthSame => 'Más o menos lo mismo que en los 30 días anteriores.';

  @override
  String monthUp(String category, String amount) {
    return 'Lo que más subió: $category, $amount.';
  }

  @override
  String monthDown(String category, String amount) {
    return 'Lo que más bajó: $category, $amount.';
  }

  @override
  String monthGoals(int onTrack, int total) {
    return 'Metas al día: $onTrack de $total.';
  }

  @override
  String get chatSuggestMonth => '¿Cómo fue mi mes?';

  @override
  String get timelineTitle => 'Tu dinero en los próximos días';

  @override
  String get timelineToday => 'Hoy';

  @override
  String get timelineNow => 'Ahora';

  @override
  String get timelineProjected => 'Proyección';

  @override
  String get timelineRecorded => 'Registrado';

  @override
  String get timelineFree => 'Libre para gastar';

  @override
  String get timelineHad => 'Tenías';

  @override
  String timelineBalance(String amount) {
    return 'Saldo $amount';
  }

  @override
  String timelineSetAside(String amount) {
    return 'Apartado $amount';
  }

  @override
  String timelinePayMark(String amount) {
    return 'Pago $amount';
  }

  @override
  String timelineShort(String amount) {
    return 'Faltan $amount para algo que hay que pagar';
  }

  @override
  String timelineWithout(String amount) {
    return 'Sin ello: $amount';
  }

  @override
  String get timelineBuyAfterPay => 'Comprar tras el pago';

  @override
  String get timelineBalanceLegend => 'Saldo';

  @override
  String get timelineWithPurchase => 'Con la compra';

  @override
  String get timelinePay => 'Día de pago';

  @override
  String get timelineAssumptions =>
      'Lo que viene es una proyección: tu pago en su fecha, las facturas en las suyas, lo apartado para vivir gastado de forma pareja y nada más. Desliza sobre el gráfico para ver cualquier día.';

  @override
  String get timelineSemantics =>
      'Gráfico de tu saldo y lo libre para gastar, día a día';

  @override
  String goalChartSemantics(String goal) {
    return 'Gráfico de cómo $goal llega a su meta';
  }

  @override
  String goalChartTarget(String amount, String date) {
    return 'Meta $amount para el $date';
  }

  @override
  String goalPaceLabel(String amount) {
    return 'Apartar cada periodo: $amount';
  }

  @override
  String goalOnTrack(String date) {
    return 'Al día: se alcanza el $date.';
  }

  @override
  String goalLate(String date, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: 'un día',
    );
    return 'A este ritmo se alcanza el $date, $_temp0 después de su fecha.';
  }

  @override
  String get goalNotMoving =>
      'Ahora mismo no va nada a esta meta, así que no se acerca.';

  @override
  String goalUsePace(String date) {
    return 'Cambiar la fecha a $date';
  }

  @override
  String get goalPaceNote =>
      'Solo una simulación: nada cambia hasta que elijas.';

  @override
  String get goalShowPath => 'Ver cómo llega';

  @override
  String get goalHidePath => 'Ocultar';

  @override
  String get billsTitle => 'Facturas y suscripciones';

  @override
  String get billAdd => 'Añadir factura o suscripción';

  @override
  String get billAddSub =>
      'Teléfono, internet, seguro, streaming… cada uno se aparta antes de su fecha.';

  @override
  String get billEditNew => 'Nueva factura';

  @override
  String get billEditExisting => 'Cambiar factura';

  @override
  String get billName => '¿Qué es?';

  @override
  String get billNameHint => 'p. ej. Internet';

  @override
  String get billAmount => 'Cada pago';

  @override
  String get billEvery => 'Cada cuánto';

  @override
  String get billEveryWeek => 'Semanal';

  @override
  String get billEveryMonth => 'Mensual';

  @override
  String get billEveryQuarter => 'Trimestral';

  @override
  String get billEveryYear => 'Anual';

  @override
  String get billNext => 'Próximo pago';

  @override
  String get billKind => 'Es';

  @override
  String get billKindBill => 'Factura';

  @override
  String get billKindSubscription => 'Suscripción';

  @override
  String get billRepays => 'Paga';

  @override
  String get billRepaysNothing => 'Nada, es un gasto';

  @override
  String get billAddThis => 'Añadir factura';

  @override
  String get billDelete => 'Eliminar factura';

  @override
  String billRow(String every, String date) {
    return '$every · próximo $date';
  }

  @override
  String billOverdue(String date) {
    return 'Vencía el $date';
  }

  @override
  String get billPay => 'Marcar como pagada';

  @override
  String get billEdit => 'Cambiar';

  @override
  String get dayToday => 'Hoy';

  @override
  String dayIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'En $days días',
      one: 'En un día',
    );
    return '$_temp0';
  }

  @override
  String dayAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Hace $days días',
      one: 'Hace un día',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'Próximos pagos';

  @override
  String homeComingUpTotal(String amount) {
    return '$amount en facturas vencen en los próximos 30 días.';
  }

  @override
  String payDueTitle(String date) {
    return 'Tu pago vencía el $date. ¿Ha llegado?';
  }

  @override
  String get payDueSub =>
      'Di cuánto llegó y el siguiente se espera un periodo después.';

  @override
  String get payArrived => 'Llegó';

  @override
  String get payArrivedTitle => '¿Cuánto llegó?';

  @override
  String get planRecordPay => 'Llegó el pago';

  @override
  String get planRecordPaySub =>
      'Regístralo y el siguiente se mueve un periodo';

  @override
  String get accountsTitle => 'Cuentas';

  @override
  String get accountMain => 'Cuenta principal';

  @override
  String get accountKindBank => 'Cuenta bancaria';

  @override
  String get accountKindCash => 'Efectivo';

  @override
  String get accountKindSavings => 'Ahorros';

  @override
  String get accountKindCard => 'Tarjeta de crédito';

  @override
  String get accountKindLoan => 'Préstamo';

  @override
  String get accountAdd => 'Añadir cuenta';

  @override
  String get accountAddSub =>
      'Efectivo, ahorros, una tarjeta o un préstamo. Sin conectar el banco.';

  @override
  String get accountEditNew => 'Nueva cuenta';

  @override
  String get accountNameHint => 'p. ej. Cartera';

  @override
  String get accountHolds => 'Lo que tiene ahora';

  @override
  String get accountOwes => 'Lo que se debe ahora';

  @override
  String get accountCounted => 'Contarla en el plan';

  @override
  String get accountCountedSub => 'Este dinero se puede gastar este mes.';

  @override
  String accountOwed(String amount) {
    return 'Debe $amount';
  }

  @override
  String get accountNotCounted => 'No cuenta en el plan';

  @override
  String get accountConfirm => 'Decir el saldo real';

  @override
  String get accountMove => 'Mover dinero';

  @override
  String accountMoveTo(String name) {
    return 'Mover a $name';
  }

  @override
  String get accountMoveBlurb =>
      'Mover dinero entre tus cuentas no es gasto ni ingreso.';

  @override
  String get accountPayCard => 'Pagar una parte';

  @override
  String get accountPayBlurb =>
      'Se paga desde la cuenta principal. Salda lo debido; no es un segundo gasto.';

  @override
  String get accountRemove => 'Quitar esta cuenta';

  @override
  String get accountInUse =>
      'Tiene historial, así que se queda. Puedes dejar de contarla.';

  @override
  String get paidFrom => 'Pagado con';

  @override
  String get categorySuggested =>
      'Sugerido por tus gastos anteriores. Toca otro para cambiarlo.';

  @override
  String get recoverTitle => 'Dinero por volver';

  @override
  String recoverTotal(String amount) {
    return 'Pueden volver $amount. No cuenta hasta que llegue.';
  }

  @override
  String get recoverReturnable => 'Se puede devolver';

  @override
  String get recoverExpect => 'Devuelto, reembolso pendiente';

  @override
  String get recoverArrived => 'Llegó el reembolso';

  @override
  String get recoverKept => 'Me lo quedé';

  @override
  String get recoverPending => 'Reembolso en camino';

  @override
  String get recoverRefunded => 'Reembolsado';

  @override
  String get recoverPrompt => 'Recuperar dinero';

  @override
  String recoverWhere(String amount) {
    return 'Volvieron $amount. ¿A dónde van?';
  }

  @override
  String recoverToGoal(String goal) {
    return 'Para $goal';
  }

  @override
  String get recoverToBuffer => 'Al colchón de emergencia';

  @override
  String get recoverLeave => 'Dejarlo libre para gastar';

  @override
  String get accountStopCounting => 'Dejar de contarla en el plan';

  @override
  String get moveTitle => 'Mejor jugada';

  @override
  String get moveTagMove => 'Mover';

  @override
  String get moveTagWait => 'Esperar';

  @override
  String get moveTagSave => 'Ahorrar';

  @override
  String get moveTagSpend => 'Gastar';

  @override
  String moveMove(String amount, String account) {
    return 'Mueve $amount de $account para cubrir lo que hay que pagar.';
  }

  @override
  String moveMoveWhy(String claim) {
    return 'A $claim le falta dinero, y este está fuera del plan.';
  }

  @override
  String get moveDoIt => 'Moverlo';

  @override
  String moveWaitGap(String date, String amount) {
    return 'Frena los extras: el $date faltarían $amount para algo que hay que pagar.';
  }

  @override
  String get moveWaitGapWhy =>
      'La proyección cuenta tu pago, facturas y gastos de vida hasta ese día.';

  @override
  String moveWaitPay(int days, String now, String later) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: 'un día',
    );
    return 'Tu pago llega en $_temp0. Esperar convierte $now de margen en $later.';
  }

  @override
  String get moveWaitPayWhy =>
      'Solo si lo que tienes en mente puede esperar. No hay riesgo en ningún caso.';

  @override
  String moveSave(String amount, String account, String goal) {
    return 'Mueve $amount a $account para $goal.';
  }

  @override
  String moveSaveWhy(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: 'un día',
    );
    return 'Llega unos $_temp0 antes, y lo libre sigue siendo el doble de tu mes habitual.';
  }

  @override
  String moveSpend(String amount, String date) {
    return 'Estás cubierto hasta el $date: $amount están libres para usar.';
  }

  @override
  String get moveSpendWhy =>
      'Facturas y metas ya están apartadas, no falta nada más adelante y esto supera con creces tu gasto habitual.';

  @override
  String get moveNotNow => 'Ahora no';

  @override
  String get moveNone =>
      'Ahora mismo no hay ninguna jugada que valga la pena sugerir. Tu plan sigue como está.';

  @override
  String monthIncome(String amount) {
    return 'Pago recibido: $amount.';
  }

  @override
  String monthToGoals(String amount) {
    return 'Destinado a metas: $amount.';
  }

  @override
  String monthNow(String free, String aside) {
    return 'Ahora: $free libres, $aside apartados.';
  }

  @override
  String get monthAheadTitle => 'Los próximos 30 días';

  @override
  String monthAheadBills(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count facturas suman $amount.',
      one: 'Una factura suma $amount.',
    );
    return '$_temp0';
  }

  @override
  String monthAheadPay(String date) {
    return 'Tu próximo pago se espera el $date.';
  }

  @override
  String monthAheadTightest(String date, String amount) {
    return 'El día más justo es el $date, con $amount libres.';
  }

  @override
  String monthAheadShort(String date, String amount) {
    return 'El $date faltarían $amount para algo que hay que pagar.';
  }

  @override
  String get monthWorthKnowing => 'Vale la pena saber';

  @override
  String insightUp(String category, String amount) {
    return '$category sube $amount respecto al mes anterior.';
  }

  @override
  String insightGoal(int days, String goal) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: 'un día',
    );
    return 'Si sigue así, son unos $_temp0 de $goal cada mes.';
  }

  @override
  String get chatSuggestMove => '¿Qué hago ahora?';

  @override
  String get chatSuggestComing => '¿Qué facturas vienen?';

  @override
  String get chatComingNone =>
      'No vence ninguna factura en los próximos 30 días. Añade las tuyas en Plan y las seguiré.';

  @override
  String get quickAsk => 'Preguntar';

  @override
  String get quickPay => 'Llegó el pago';

  @override
  String get quickBills => 'Facturas';

  @override
  String get quickMonth => 'Mi mes';

  @override
  String get quickPayDue => 'Tu pago vence. Di si llegó.';

  @override
  String get chartAvg => 'Media';

  @override
  String get flowsTitle => 'Dinero que entra y sale';

  @override
  String get flowsBlurb =>
      'Semana a semana: pagos y reembolsos arriba, gastos y cuotas abajo.';

  @override
  String flowsWeek(String date) {
    return 'Semana del $date';
  }

  @override
  String flowsInOut(String moneyIn, String moneyOut) {
    return 'Entra $moneyIn · Sale $moneyOut';
  }

  @override
  String get balanceHistoryTitle => 'Tu saldo en el tiempo';

  @override
  String rangeMonths(int count) {
    return '$count m';
  }

  @override
  String get rangeYear => '1 a';

  @override
  String get weekSpentTitle => 'Últimos 7 días';

  @override
  String weekSpentTotal(String amount) {
    return '$amount gastados';
  }

  @override
  String get payGaugeTitle => 'Hasta tu próximo pago';

  @override
  String payGaugeDaysLabel(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'días restantes',
      one: 'día restante',
    );
    return '$_temp0';
  }

  @override
  String payGaugeAfter(String date, String amount) {
    return 'Tras tu pago del $date: $amount libres';
  }

  @override
  String payGaugeLasts(String amount) {
    return '$amount tienen que durar hasta entonces.';
  }

  @override
  String get goalsOverall => 'de todas tus metas';

  @override
  String goalsThisMonth(String amount) {
    return '+$amount este mes';
  }

  @override
  String get goalsNothingThisMonth => 'Nada añadido este mes';

  @override
  String get goalsAllOnTrack => 'Todo al día';

  @override
  String goalsOnTrackCount(int onTrack, int total) {
    return '$onTrack de $total al día';
  }

  @override
  String goalsNextUp(String goal, String date) {
    return 'Próxima: $goal, $date';
  }

  @override
  String get goalsTips => 'Formas de llegar antes';

  @override
  String get goalsTipsSub => 'Pregunta a Upino, según tus gastos';

  @override
  String get goalsDetailTitle => 'Cada meta';
}
