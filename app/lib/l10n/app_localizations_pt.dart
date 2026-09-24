// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get navHome => 'Início';

  @override
  String get navPlan => 'Plano';

  @override
  String get navGoals => 'Metas';

  @override
  String get navActivity => 'Atividade';

  @override
  String get navProfile => 'Perfil';

  @override
  String get currencyTitle => 'Qual moeda?';

  @override
  String get currencyBlurb =>
      'Todo o seu plano é mantido nesta moeda. Escolha aquela em que você realmente recebe.';

  @override
  String get currencySearchHint => 'Buscar país, moeda ou código';

  @override
  String currencyNoMatch(String query) {
    return 'Nada corresponde a “$query”. Tente o país ou o código de três letras.';
  }

  @override
  String get onboardingBadge => 'Leva cerca de um minuto';

  @override
  String get onboardingTitle => 'Monte seu plano';

  @override
  String get onboardingBlurb =>
      'Duas respostas bastam para começar. O resto pode esperar.';

  @override
  String get onboardingBalanceLabel => 'Sua reserva hoje';

  @override
  String get onboardingBalanceHint =>
      'Dinheiro do qual você poderia realmente gastar, não o que pretende deixar intocado.';

  @override
  String get onboardingIncomeLabel => 'Quanto você ganha por mês?';

  @override
  String get onboardingIncomeHint =>
      'Se varia, informe a faixa. Seu plano é construído sobre o limite inferior.';

  @override
  String get onboardingPayDay => 'Quando chega o próximo pagamento?';

  @override
  String onboardingDays(int count) {
    return '$count dias';
  }

  @override
  String get onboardingCommitments => 'Adicione seus compromissos';

  @override
  String get onboardingCommitmentsOpen =>
      'Aluguel, despesas básicas e uma meta';

  @override
  String get onboardingCommitmentsShut => 'É opcional, e dá para fazer depois';

  @override
  String get onboardingRentLabel => 'Aluguel e contas fixas';

  @override
  String get onboardingRentHint => 'Vencem antes do próximo pagamento';

  @override
  String get onboardingEssentialsLabel => 'Comida e transporte';

  @override
  String get onboardingEssentialsHint =>
      'O que você precisa para atravessar o período';

  @override
  String get onboardingGoalLabel => 'Poupança para uma meta';

  @override
  String get onboardingGoalHint => 'Quanto quer separar neste período';

  @override
  String get onboardingFinish => 'Criar meu plano';

  @override
  String get onboardingIncomplete =>
      'Preencha as duas primeiras respostas para continuar';

  @override
  String get tapToType => 'Toque para digitar';

  @override
  String get heroSafeToSpend => 'Você pode gastar agora';

  @override
  String get heroNotUpToDate => 'Desatualizado';

  @override
  String get heroRecordSpend => 'Registrar um gasto';

  @override
  String get heroSeeShort => 'Ver o que está faltando';

  @override
  String get heroConfirmBalance => 'Confirmar saldo';

  @override
  String get heroReviewBlurb =>
      'Verifique seu saldo para que este número volte a ser confiável.';

  @override
  String heroUntilSetAside(String date, String amount) {
    return 'Até $date · $amount separado';
  }

  @override
  String heroShort(String amount) {
    return 'Faltam $amount';
  }

  @override
  String heroUnfunded(String label, String amount) {
    return '$label · $amount não coberto';
  }

  @override
  String get heroBalanceNever => 'Saldo ainda não confirmado';

  @override
  String get heroBalanceToday => 'Saldo confirmado hoje';

  @override
  String get heroBalanceYesterday => 'Saldo confirmado ontem';

  @override
  String heroBalanceDays(int count) {
    return 'Saldo confirmado há $count dias';
  }

  @override
  String get confirm => 'Confirmar';

  @override
  String get homeTitle => 'Seu plano';

  @override
  String homeUntilTotal(String date, String amount) {
    return 'Até $date · $amount no total';
  }

  @override
  String homeRecorded(String amount) {
    return '$amount registrado';
  }

  @override
  String get homeAttention => 'Precisa da sua atenção';

  @override
  String homeNotCovered(String amount) {
    return '$amount não coberto';
  }

  @override
  String get homeAfterNextPay => 'Depois do próximo pagamento';

  @override
  String homeOncePayArrives(String date) {
    return 'Quando seu pagamento chegar em $date';
  }

  @override
  String get homeSetAsideFirst => 'Separado primeiro';

  @override
  String get homeProtectedBlurb =>
      'Protegido antes que qualquer coisa fique disponível para gastar.';

  @override
  String get homeNothingSetAside =>
      'Nada foi separado ainda. Tudo o que você tem está disponível.';

  @override
  String get homeWhyThisNumber => 'Por que este número';

  @override
  String get homeWhatIsShort => 'O que está faltando';

  @override
  String get homeShortBlurb =>
      'Nada aqui é movido ou adiado por você. São compromissos que o seu dinheiro atual não cobre.';

  @override
  String get askSpendTitle => 'Quanto você gastou?';

  @override
  String get askBalanceTitle => 'Qual é o seu saldo agora?';

  @override
  String get askBalanceBlurb =>
      'Qualquer diferença é registrada como correção, nunca como gasto.';

  @override
  String get whyNoChange => 'Nada mudou desde o seu plano anterior.';

  @override
  String get whyPayArrived =>
      'Seu pagamento chegou, então o plano foi atualizado.';

  @override
  String get whyBillPaid =>
      'Uma conta para a qual você havia separado dinheiro foi paga.';

  @override
  String get whyHeldForBill =>
      'Há dinheiro retido para uma conta que vence logo após o próximo pagamento.';

  @override
  String get whyOvercommitted =>
      'Você se comprometeu com mais do que tem agora.';

  @override
  String get whyStale => 'Seu saldo não é confirmado há algum tempo.';

  @override
  String get whyCardLarger =>
      'O saldo do seu cartão é maior que o dinheiro que você tem.';

  @override
  String get whyPayLate => 'O pagamento esperado ainda não chegou.';

  @override
  String get whyOverdue => 'Algo passou da data de vencimento.';

  @override
  String get whyBufferShort => 'Sua reserva de emergência não está completa.';

  @override
  String get whyGoalShort =>
      'Sua meta de poupança não pode ser totalmente financiada agora.';

  @override
  String get whyFlexibleLess =>
      'Uma meta flexível recebeu menos do que o planejado.';

  @override
  String get whyDuplicate =>
      'Uma transação repetida foi contada apenas uma vez.';

  @override
  String get planTitle => 'Plano';

  @override
  String get planBlurb =>
      'A que o seu dinheiro está prometido, antes que algo fique disponível para gastar.';

  @override
  String get planMoneyAndIncome => 'Dinheiro e renda';

  @override
  String get planMoneyYouHave => 'Dinheiro que você tem';

  @override
  String get planNextPay => 'Próximo pagamento';

  @override
  String get planYourNextPay => 'Seu próximo pagamento';

  @override
  String get planNotSet => 'Não definido';

  @override
  String get planExpectedBlurb =>
      'Isto é apenas esperado, então fica fora do que você pode gastar agora.';

  @override
  String get planSetAsideFirst => 'Separado primeiro';

  @override
  String get planNothingSetAside =>
      'Nada foi separado, então tudo o que você tem está disponível.';

  @override
  String get planAddToPlan => 'Adicionar ao seu plano';

  @override
  String get planGoals => 'Metas';

  @override
  String get planSaveToward => 'Poupar para algo';

  @override
  String get planSaveTowardSub => 'Uma viagem, um depósito, um notebook novo';

  @override
  String get planAllGoals => 'Todas as metas';

  @override
  String get planAllGoalsSub => 'Adicione, edite ou separe dinheiro';

  @override
  String get planHowMuchSetAside => 'Quanto você precisa separar para isto?';

  @override
  String get planChangeOrRemove => 'Mude o valor, ou remova-o do seu plano.';

  @override
  String get planRemove => 'Remover do plano';

  @override
  String planDue(String date) {
    return ' · vence em $date';
  }

  @override
  String get priorityMandatory => 'Precisa ser pago — vem primeiro';

  @override
  String get priorityEssential => 'Necessidades do dia a dia';

  @override
  String get priorityBuffer => 'Guardado para emergências';

  @override
  String get priorityCard => 'Já gasto no cartão';

  @override
  String get prioritySinkingFund => 'Poupança para uma conta conhecida';

  @override
  String get priorityGoal => 'Uma meta com a qual você se comprometeu';

  @override
  String get priorityDiscretionary => 'Bom ter — cede primeiro';

  @override
  String get goalsTitle => 'Metas';

  @override
  String get goalsBlurbEmpty => 'Você ainda não está poupando para nada.';

  @override
  String get goalsBlurb =>
      'O que cada meta precisa deste período de pagamento.';

  @override
  String get goalsEmptyCard =>
      'Adicione algo para o que esteja poupando: uma viagem, um depósito, um notebook novo. O Upino calcula quanto reter a cada período para que chegue a tempo.';

  @override
  String get goalsNew => 'Nova meta';

  @override
  String get goalsNewSub => 'Algo para o qual você separa dinheiro';

  @override
  String get goalsAddMoney => 'Adicionar dinheiro';

  @override
  String goalsAddTo(String name) {
    return 'Adicionar a $name';
  }

  @override
  String get goalsAddBlurb =>
      'Isto registra o que você separou. Nada é gasto — apenas reduz o que precisa ser retido daqui em diante.';

  @override
  String get goalsEachPeriod => 'Cada período';

  @override
  String get goalsTargetDate => 'Data alvo';

  @override
  String goalsOf(String amount) {
    return 'de $amount';
  }

  @override
  String goalsPeriodsToGo(int count) {
    return 'Faltam $count períodos de pagamento';
  }

  @override
  String get goalsDone => 'Totalmente poupado';

  @override
  String get goalsPausedStatus => 'Pausada — nada é retido';

  @override
  String get goalsFlexibleStatus =>
      'Flexível — cede a qualquer pagamento obrigatório';

  @override
  String get goalEditNew => 'Para o que você está poupando?';

  @override
  String get goalEditExisting => 'Editar meta';

  @override
  String get goalName => 'Nome';

  @override
  String get goalNameHint => 'Uma viagem, um depósito, um notebook';

  @override
  String get goalTotal => 'Quanto no total';

  @override
  String get goalByWhen => 'Para quando';

  @override
  String goalMonths(int count) {
    return '$count meses';
  }

  @override
  String get goalOneYear => '1 ano';

  @override
  String get goalTwoYears => '2 anos';

  @override
  String get goalFirmness => 'Quão firme é?';

  @override
  String get goalKindHard => 'Comprometida';

  @override
  String get goalKindHardSub =>
      'Retida antes que algo fique disponível para gastar';

  @override
  String get goalKindFlexible => 'Flexível';

  @override
  String get goalKindFlexibleSub => 'Cede a qualquer pagamento obrigatório';

  @override
  String get goalKindPaused => 'Pausada';

  @override
  String get goalKindPausedSub => 'Continua visível, nada é retido';

  @override
  String get goalSaveChanges => 'Salvar alterações';

  @override
  String get goalAddThis => 'Adicionar esta meta';

  @override
  String get goalDelete => 'Excluir esta meta';

  @override
  String get activityTitle => 'Atividade';

  @override
  String get activityBlurb =>
      'Tudo o que você registrou, do mais recente ao mais antigo.';

  @override
  String get activityEmpty =>
      'Quando você registrar um gasto ele aparecerá aqui, e poderá removê-lo se errar.';

  @override
  String get activityRemoveIt => 'Remover';

  @override
  String get activityKeepIt => 'Manter';

  @override
  String get activitySpent => 'Gasto';

  @override
  String get activityIncome => 'Pagamento';

  @override
  String get activityCorrection => 'Correção';

  @override
  String get activityRemoved => 'Removido';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileConfirmBalance => 'Confirme seu saldo';

  @override
  String get profileTrustTitle => 'Quanto dá para confiar no número?';

  @override
  String get profileTrustFresh => 'Atualizado. Nada precisa da sua atenção.';

  @override
  String get profileTrustDegraded =>
      'Seu saldo não é confirmado há um tempo. O número continua aparecendo, apenas com menos certeza.';

  @override
  String get profileTrustReview =>
      'Antigo ou incerto demais para se confiar. Confirme seu saldo para corrigir.';

  @override
  String get profileConfirmedNever => 'Ainda não confirmado';

  @override
  String get profileConfirmedToday => 'Confirmado hoje';

  @override
  String get profileConfirmedYesterday => 'Confirmado ontem';

  @override
  String profileConfirmedDays(int count) {
    return 'Confirmado há $count dias';
  }

  @override
  String get profileAppearance => 'Aparência';

  @override
  String get profileTheme => 'Tema';

  @override
  String get profileThemeBlurb =>
      'Seguir o telefone é o padrão, então nada é imposto.';

  @override
  String get themePhone => 'Telefone';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get profileLanguage => 'Idioma';

  @override
  String get profileLanguageBlurb =>
      'Seguir o telefone é o padrão, então nada é imposto.';

  @override
  String get languagePhone => 'Telefone';

  @override
  String get profileCurrency => 'Moeda';

  @override
  String currencyChangeTitle(String currency) {
    return 'Mudar para $currency?';
  }

  @override
  String currencyChangeBlurb(String currency) {
    return 'Cada valor do seu plano mantém o seu número e passa a aparecer em $currency. Nada é convertido por taxa de câmbio: use isto para corrigir a moeda, não para converter o seu dinheiro.';
  }

  @override
  String get currencyChangeConfirm => 'Mudar';

  @override
  String get profileYourData => 'Seus dados';

  @override
  String get profileDelete => 'Excluir meu plano';

  @override
  String get profileDeleteSub => 'Limpa tudo e volta à configuração';

  @override
  String get profileStartOver => 'Começar de novo?';

  @override
  String get profileStartOverBlurb =>
      'Seu plano e tudo o que você registrou serão excluídos. Isto não pode ser desfeito.';

  @override
  String get profileDeleteEverything => 'Excluir tudo';

  @override
  String get profileKeepPlan => 'Manter meu plano';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String activityRemoveAmount(String amount) {
    return 'Remover $amount?';
  }

  @override
  String get activityRemoveDetail =>
      'Deixa de contar no seu plano imediatamente. O lançamento permanece nesta lista marcado como removido, então seu registro continua completo.';

  @override
  String get activityCardPurchase => 'Compra no cartão';

  @override
  String get activityCardPayment => 'Pagamento do cartão';

  @override
  String get activityRefund => 'Reembolso';

  @override
  String get activityTransfer => 'Transferido entre contas';

  @override
  String get activityLoan => 'Empréstimo recebido';

  @override
  String get activityDebtPayment => 'Pagamento de dívida';

  @override
  String get activityBalanceCorrected => 'Saldo corrigido';

  @override
  String get activityBlurbEmpty => 'Nada registrado ainda.';

  @override
  String get profileStartAgain => 'Começar de novo';

  @override
  String get claimRent => 'Aluguel e contas';

  @override
  String get claimCardMinimum => 'Pagamento mínimo do cartão';

  @override
  String get claimEssentials => 'Comida e transporte';

  @override
  String get claimBuffer => 'Reserva de emergência';

  @override
  String get languageTitle => 'Qual idioma?';

  @override
  String get languageBlurb => 'Você pode mudar isso depois em Perfil.';

  @override
  String get profileLedgerTitle => 'O registro está completo?';

  @override
  String get ledgerComplete => 'Tudo o que você gastou está registrado.';

  @override
  String get ledgerPartial =>
      'Parte dos gastos só apareceu quando você confirmou o saldo.';

  @override
  String get ledgerUnknown =>
      'O Upino não sabe quanto está faltando. Confirme seu saldo para descobrir.';

  @override
  String get askTitle => 'Pergunte antes de gastar';

  @override
  String get askBlurb =>
      'Teste uma compra contra o seu plano. Nada é registrado e nada muda.';

  @override
  String get askAmountLabel => 'Quanto seria?';

  @override
  String get askRun => 'Ver o que aconteceria';

  @override
  String get askDoNotBuy => 'Não comprar';

  @override
  String get askBuyNow => 'Comprar hoje';

  @override
  String askBuyAfter(String date) {
    return 'Comprar depois de $date';
  }

  @override
  String get askUnchanged => 'Seu plano continua como está.';

  @override
  String get askStsAfter => 'O que você poderia gastar depois';

  @override
  String get askBreaks =>
      'Isso deixa sem cobertura algo que você precisa pagar.';

  @override
  String get askSafe => 'Nada do que você precisa pagar fica sem cobertura.';

  @override
  String get askCosts => 'O que recebe menos';

  @override
  String askCostLine(String label, String amount) {
    return '$label · $amount a menos';
  }

  @override
  String get askWaitingHelps => 'Esperar seu pagamento chegar cobre tudo.';

  @override
  String get askNoIncome =>
      'Nenhum pagamento é esperado ainda, então não há um momento posterior para comparar.';

  @override
  String askAssumption(String date) {
    return 'Supõe que seu pagamento chegue como esperado em $date.';
  }

  @override
  String get askNoVerdict => 'O Upino não diz sim nem não. A escolha é sua.';

  @override
  String get receipt => 'Recibo';

  @override
  String get receiptAdd => 'Adicionar um recibo';

  @override
  String get receiptCamera => 'Tirar uma foto';

  @override
  String get receiptGallery => 'Escolher uma foto';

  @override
  String get receiptAttached => 'Recibo anexado';

  @override
  String get receiptRemove => 'Remover a foto';

  @override
  String get onboardingIncomeFrom => 'Pelo menos';

  @override
  String get onboardingIncomeTo => 'Até';

  @override
  String get onboardingIncomeToOptional => 'Opcional';

  @override
  String incomeRange(String low, String high) {
    return '$low a $high';
  }

  @override
  String incomeRangeNote(String low) {
    return 'Seu plano é construído sobre $low. O que vier acima é seu quando chegar.';
  }

  @override
  String get categoryFood => 'Alimentação';

  @override
  String get categoryTransport => 'Transporte';

  @override
  String get categoryBills => 'Contas';

  @override
  String get categoryShopping => 'Compras';

  @override
  String get categoryHealth => 'Saúde';

  @override
  String get categoryFun => 'Lazer';

  @override
  String get categoryOther => 'Outros';

  @override
  String get categoryUnsorted => 'Sem categoria';

  @override
  String get categoryPrompt => 'Foi para quê?';

  @override
  String get spendingTitle => 'Para onde foi';

  @override
  String get spendingWindow => 'Gastos registados nos últimos 30 dias';

  @override
  String get backupSection => 'Cópia de segurança';

  @override
  String get backupSave => 'Guardar uma cópia';

  @override
  String get backupSaveSub =>
      'Protegida por palavra-passe. Envie-a para um lugar seguro, como a sua nuvem.';

  @override
  String get backupRestore => 'Restaurar uma cópia';

  @override
  String get backupRestoreSub => 'Substitui o plano deste telemóvel';

  @override
  String get backupPassword => 'Palavra-passe';

  @override
  String get backupPasswordRepeat => 'Repita a palavra-passe';

  @override
  String get backupPasswordSaveBlurb =>
      'Vai precisar desta palavra-passe para restaurar. Não pode ser recuperada se a esquecer. As fotos de recibos não são incluídas.';

  @override
  String get backupPasswordOpenBlurb =>
      'A palavra-passe com que esta cópia foi guardada.';

  @override
  String get backupPasswordShort => 'Pelo menos 6 caracteres';

  @override
  String get backupPasswordMismatch => 'Não coincidem';

  @override
  String get backupOpen => 'Abrir';

  @override
  String get backupReplaceTitle => 'Substituir este plano?';

  @override
  String get backupReplaceBlurb =>
      'Tudo neste telemóvel é substituído pela cópia. Não pode ser desfeito.';

  @override
  String get backupReplace => 'Substituir';

  @override
  String get backupRestored => 'Cópia restaurada';

  @override
  String get backupWrongPassword => 'Essa palavra-passe não abre esta cópia.';

  @override
  String get backupNotABackup => 'Esse ficheiro não é uma cópia do Upino.';

  @override
  String get backupUnreadable =>
      'Esta cópia foi feita por uma versão mais recente do Upino. Atualize a app e tente de novo.';

  @override
  String get inflationTitle => 'Inflação';

  @override
  String get inflationNotSet =>
      'Não definido. Indique a taxa anual onde vive para ver quanto as metas vão realmente custar.';

  @override
  String inflationRate(String rate) {
    return '$rate% ao ano';
  }

  @override
  String get inflationDialogTitle => 'Inflação anual';

  @override
  String get inflationDialogBlurb =>
      'Os preços sobem, por isso uma meta definida no dinheiro de hoje custa mais na sua data. Indique a taxa que espera; deixe vazio para desligar.';

  @override
  String goalsInflated(String rate, String amount) {
    return 'A $rate% ao ano, vai custar cerca de $amount nessa altura.';
  }

  @override
  String get holdingsTitle => 'Outras reservas';

  @override
  String get holdingsBlurb =>
      'Dólares, ouro, moedas. Mostrados ao lado do plano e nunca contados no que pode gastar.';

  @override
  String get holdingsAdd => 'Adicionar uma reserva';

  @override
  String get holdingsAddSub => 'Não conta no que pode gastar';

  @override
  String get holdingsTotal => 'No total';

  @override
  String holdingSummary(String quantity, String price, String date) {
    return '$quantity × $price · preço de $date';
  }

  @override
  String get holdingEditNew => 'Nova reserva';

  @override
  String get holdingEditExisting => 'Alterar reserva';

  @override
  String get holdingName => 'O que é?';

  @override
  String get holdingNameHint => 'Dólar, ouro…';

  @override
  String get holdingUsd => 'Dólar';

  @override
  String get holdingEur => 'Euro';

  @override
  String get holdingGold => 'Ouro (grama)';

  @override
  String get holdingCoin => 'Moeda de ouro';

  @override
  String get holdingQuantity => 'Quantos';

  @override
  String get holdingUnitPrice => 'Quanto vale um hoje';

  @override
  String holdingWorth(String amount) {
    return 'Vale $amount no total';
  }

  @override
  String get holdingDelete => 'Remover esta reserva';

  @override
  String get fasterTitle => 'Registo mais rápido';

  @override
  String get smsTitle => 'Ler mensagens do banco';

  @override
  String get smsDetail =>
      'Os gastos que o banco lhe envia por SMS são sugeridos para registar com um toque. As mensagens são lidas só neste telemóvel e nunca enviadas.';

  @override
  String get smsDenied =>
      'O Upino não tem permissão para ler mensagens. Pode dá-la nas definições do telemóvel.';

  @override
  String smsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mensagens do banco por rever',
      one: '1 mensagem do banco por rever',
    );
    return '$_temp0';
  }

  @override
  String get smsWaitingSub => 'Registe cada uma com um toque, ou ignore';

  @override
  String get smsReviewTitle => 'Do seu banco';

  @override
  String get smsReviewBlurb =>
      'Nada é registado até tocar em Registar. Confira o valor com a mensagem.';

  @override
  String get smsReviewDone => 'Tudo em dia.';

  @override
  String get smsRecord => 'Registar';

  @override
  String get smsSkip => 'Ignorar';

  @override
  String get reminderTitleSetting => 'Lembrete ao fim do dia';

  @override
  String get reminderDetail => 'Às 21h, só nos dias em que nada foi registado.';

  @override
  String get reminderDenied =>
      'O Upino não tem permissão para mostrar notificações. Pode dá-la nas definições.';

  @override
  String get reminderTitle => 'Gastou alguma coisa hoje?';

  @override
  String get reminderBody =>
      'Registe em segundos para que o valor de amanhã esteja certo.';

  @override
  String get reminderChannel => 'Lembrete ao fim do dia';

  @override
  String get widgetSpend => '+ Gasto';

  @override
  String get widgetAdd => 'Adicionar ao ecrã principal';

  @override
  String get widgetAddSub =>
      'O que pode gastar e um botão para registar, sem abrir a app';

  @override
  String get voiceListening => 'A ouvir… diga o valor e para quê foi.';

  @override
  String voiceHeard(String text) {
    return 'Ouvido: “$text”. Confira o valor e guarde.';
  }

  @override
  String get voiceNothing => 'Nenhum valor ouvido. Tente de novo ou escreva-o.';

  @override
  String get voicePrivacy =>
      'O telemóvel converte voz em texto. Sem reconhecimento offline, passa pelo serviço de voz do telemóvel.';

  @override
  String get voiceButton => 'Diga';

  @override
  String get voiceUnavailable =>
      'Este telemóvel não tem reconhecimento de voz que a app possa usar. Escreva o valor.';

  @override
  String get voiceNoPermission =>
      'O Upino não tem permissão para usar o microfone. Pode dá-la nas definições.';

  @override
  String get voiceNetwork =>
      'O reconhecimento de voz deste telemóvel precisa de internet e não conseguiu ligar-se.';

  @override
  String voiceNoAmount(String text) {
    return 'Ouvido “$text”, mas sem valor. Tente de novo ou escreva-o.';
  }

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get navAsk => 'Perguntar';

  @override
  String get alertsTitle => 'Precisa de si';

  @override
  String get alertsEmpty => 'Nada precisa de si agora. O plano está em dia.';

  @override
  String alertUnfunded(String label, String amount) {
    return 'Faltam $amount para $label';
  }

  @override
  String get alertUnfundedDetail =>
      'Algo que tem de pagar não está coberto pelo que tem.';

  @override
  String alertIncomeLate(String date) {
    return 'O seu salário era esperado a $date';
  }

  @override
  String get alertIncomeLateDetail =>
      'Não conta até chegar. Mude a data no Plano se mudou.';

  @override
  String alertGoalBehind(String name, String amount) {
    return '$name está $amount atrasado este período';
  }

  @override
  String get alertGoalBehindDetail =>
      'O que tem não chega à parte deste período.';

  @override
  String get chatHint => 'Pergunte o que quiser ou escreva um preço';

  @override
  String get chatSuggestSafe => 'Quanto posso gastar?';

  @override
  String get chatSuggestPay => 'Quando recebo?';

  @override
  String get chatSuggestWhere => 'Para onde foi o dinheiro?';

  @override
  String get chatSuggestAside => 'O que está reservado?';

  @override
  String chatSafe(String amount, String date) {
    return 'Pode gastar $amount até $date.';
  }

  @override
  String get chatSafeStale =>
      'Só um detalhe: o saldo precisa de confirmação, veja isto como estimativa.';

  @override
  String chatPay(String amount, String date) {
    return 'O próximo salário é de $amount, previsto a $date.';
  }

  @override
  String get chatPayNone =>
      'Ainda não sei o próximo salário. Adicione-o no Plano e fico atento.';

  @override
  String get chatWhere => 'Foi para aqui nos últimos 30 dias:';

  @override
  String get chatWhereNone =>
      'Sem gastos nos últimos 30 dias. Ou foi um mês calmo ou não foram registados.';

  @override
  String chatAside(String amount) {
    return '$amount fica reservado antes de algo contar como gastável:';
  }

  @override
  String chatPurchase(String amount) {
    return 'Vamos ver o que $amount faria.';
  }

  @override
  String get chatHelp =>
      'Hmm, não percebi bem. Posso dizer quanto pode gastar, quando recebe, para onde foi o dinheiro, o que está reservado ou como gastar menos. Ou escreva um preço e mostro o efeito de comprar.';

  @override
  String get chatHelloNew =>
      'Olá! Sou o Upino. É novo por cá, por isso só sei o básico: o seu saldo, o seu salário e o que reservou. Já chega para dizer quanto pode gastar e o efeito de uma compra. Continue a registar os gastos e, daqui a uma estação, vou conhecer os seus hábitos o suficiente para ser o seu conselheiro pessoal.';

  @override
  String chatHelloLearning(int days, int spends, int remaining) {
    return 'Bem-vindo de volta! Já aprendi com $days dias e $spends gastos. Mais uns $remaining dias e terei uma estação completa.';
  }

  @override
  String chatHelloFamiliar(int days) {
    return 'Bem-vindo de volta! Já vi $days dias do seu dinheiro, por isso pergunte o que quiser, até como gastar menos.';
  }

  @override
  String chatHelloAlerts(int count) {
    return 'Já agora, há $count coisas à sua espera: estão no sino.';
  }

  @override
  String chatPurchaseFits(String left) {
    return 'Comprar hoje mantém coberto tudo o que tem de pagar, e ainda sobram $left.';
  }

  @override
  String chatPurchaseWait(String date) {
    return 'Comprar hoje deixaria algo que tem de pagar a descoberto. Se esperar até $date, fica tudo coberto.';
  }

  @override
  String chatPurchaseStillShort(String date) {
    return 'Atenção: mesmo depois do salário de $date, algo que tem de pagar ficaria a descoberto.';
  }

  @override
  String get chatPurchaseShort =>
      'Comprar hoje deixaria algo que tem de pagar a descoberto.';

  @override
  String chatSafeNothing(String date) {
    return 'Neste momento não sobra nada até $date: tudo o que tem já está comprometido.';
  }

  @override
  String chatPayIn(int days) {
    return 'Ou seja, daqui a $days dias.';
  }

  @override
  String get chatPayLate =>
      'Está atrasado, por isso só conta quando confirmar que chegou.';

  @override
  String get chatPayRange =>
      'O plano conta com o valor mais baixo, por isso um bom mês é um bónus, não um buraco.';

  @override
  String chatWhereSoFar(int days) {
    return 'Só vi $days dias até agora, por isso é uma primeira ideia:';
  }

  @override
  String chatWhereTop(String category, int share) {
    return '$category é o maior: $share% do total.';
  }

  @override
  String get chatWhereTooSoon =>
      'Ainda é cedo: quase não vi gastos. Registe alguns e pergunte-me para a semana.';

  @override
  String get chatAdviceTooSoon =>
      'Gostava de ajudar, mas sinceramente ainda não conheço bem os seus gastos, e um conselho sem isso seria um palpite. Registe os gastos (categorizá-los ajuda muito) e pergunte-me daqui a umas semanas.';

  @override
  String chatAdviceBiggest(String category, String amount, String tenth) {
    return 'O seu maior gasto nos últimos 30 dias foi $category: $amount. Cortar um décimo libertaria cerca de $tenth por mês.';
  }

  @override
  String get chatAdviceSort =>
      'Vejo quanto gasta, mas não em quê. Dê uma categoria aos gastos ao registá-los e digo-lhe onde cortar.';

  @override
  String chatAdviceMore(String amount) {
    return 'Gastou mais $amount do que no mês anterior.';
  }

  @override
  String chatAdviceLess(String amount) {
    return 'Boa: são menos $amount do que no mês anterior.';
  }

  @override
  String get chatAdviceLearning =>
      'Ainda estou a aprender os seus hábitos, veja isto como uma primeira pista.';

  @override
  String get chatSmallHello => 'Olá! O que quer saber sobre o seu dinheiro?';

  @override
  String get chatSmallThanks => 'Sempre! Estou aqui sempre que for gastar.';

  @override
  String get chatSmallWho =>
      'Sou o assistente do Upino. Só sei o que está no seu plano e cada número vem daí; nada sai deste telemóvel. Não digo sim nem não, mas mostro o que cada escolha lhe deixa.';

  @override
  String get chatSuggestAdvice => 'Como gasto menos?';

  @override
  String get chatTitle => 'Upino';

  @override
  String get chatNew => 'Nova conversa';

  @override
  String get chatResumed =>
      'As respostas são calculadas com o seu plano tal como está hoje.';

  @override
  String get chatWhy => 'É assim que o valor aparece:';

  @override
  String get chatWhyHave => 'O que tem';

  @override
  String get chatWhySetAside => 'Reservado primeiro';

  @override
  String get chatWhyLeft => 'Para gastar';

  @override
  String get chatSmallHowAreYou =>
      'Estou bem, obrigado por perguntar! O seu dinheiro está onde o deixámos. O que quer saber?';

  @override
  String get chatSmallBye => 'Adeus! Volte antes do próximo grande gasto.';

  @override
  String get chatSmallOkay => 'Mais alguma coisa que queira ver?';

  @override
  String get askHubTitle => 'Fale com o Upino';

  @override
  String get askHubNew =>
      'Pergunte quanto pode gastar, o efeito de uma compra ou quando recebe. Ainda o estou a conhecer; quanto mais registar, mais útil serei.';

  @override
  String askHubLearning(int days) {
    return 'Estou a aprender os seus hábitos: daqui a cerca de $days dias terei uma estação completa para aconselhar.';
  }

  @override
  String get askHubFamiliar =>
      'Já conheço bem o seu dinheiro. Pergunte o que quiser, até como gastar menos.';

  @override
  String get askHubStart => 'Começar a conversar';

  @override
  String get askHubCommon => 'Perguntas frequentes';

  @override
  String get askHubHistory => 'As suas conversas';

  @override
  String askHubTurns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perguntas',
      one: '1 pergunta',
    );
    return '$_temp0';
  }

  @override
  String askHubAsidePreview(String amount, int count) {
    return '$amount reservados em $count compromissos';
  }

  @override
  String get askHubDeleteTitle => 'Apagar esta conversa?';

  @override
  String get askHubDeleteBlurb => 'Só a conversa é apagada. O plano não muda.';

  @override
  String get chatSmallHi => 'Olá!';

  @override
  String get chatSmallHiFine => 'Olá! Estou bem, obrigado.';

  @override
  String chatSafeLasts(int days) {
    return 'Isto tem de durar $days dias, até ao salário.';
  }

  @override
  String homeSpokenFor(String amount, String date) {
    return '$amount do seu dinheiro já tem destino até $date.';
  }

  @override
  String askGoalLater(String goal, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: 'um dia',
    );
    return '$goal · cerca de $_temp0 depois';
  }

  @override
  String get askGoalsTitle => 'As metas atrasam';

  @override
  String get askGoalsNote =>
      'Aproximado, no ritmo em que cada meta está sendo poupada.';

  @override
  String chatPurchaseGoal(String goal, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: 'um dia',
    );
    return 'Isso atrasaria $goal em cerca de $_temp0.';
  }

  @override
  String get monthTitle => 'Seu mês';

  @override
  String get monthWindow => 'Os últimos 30 dias, comparados aos 30 anteriores';

  @override
  String monthTooSoon(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: 'um dia',
    );
    return 'O resumo do mês precisa de um mês de gastos. O seu fica pronto em $_temp0.';
  }

  @override
  String monthSpent(String amount) {
    return 'Nos últimos 30 dias, saíram $amount.';
  }

  @override
  String get monthNothing => 'Nada foi registrado nos últimos 30 dias.';

  @override
  String monthMore(String amount) {
    return 'São $amount a mais que nos 30 dias anteriores.';
  }

  @override
  String monthLess(String amount) {
    return 'São $amount a menos que nos 30 dias anteriores.';
  }

  @override
  String get monthSame => 'Mais ou menos o mesmo que nos 30 dias anteriores.';

  @override
  String monthUp(String category, String amount) {
    return 'O que mais subiu: $category, $amount.';
  }

  @override
  String monthDown(String category, String amount) {
    return 'O que mais caiu: $category, $amount.';
  }

  @override
  String monthGoals(int onTrack, int total) {
    return 'Metas em dia: $onTrack de $total.';
  }

  @override
  String get chatSuggestMonth => 'Como foi meu mês?';

  @override
  String get timelineTitle => 'Seu dinheiro nos próximos dias';

  @override
  String get timelineToday => 'Hoje';

  @override
  String get timelineNow => 'Agora';

  @override
  String get timelineProjected => 'Projeção';

  @override
  String get timelineRecorded => 'Registrado';

  @override
  String get timelineFree => 'Livre para gastar';

  @override
  String get timelineHad => 'Você tinha';

  @override
  String timelineBalance(String amount) {
    return 'Saldo $amount';
  }

  @override
  String timelineSetAside(String amount) {
    return 'Separado $amount';
  }

  @override
  String timelinePayMark(String amount) {
    return 'Pagamento $amount';
  }

  @override
  String timelineShort(String amount) {
    return 'Faltam $amount para algo que precisa ser pago';
  }

  @override
  String timelineWithout(String amount) {
    return 'Sem isso: $amount';
  }

  @override
  String get timelineBuyAfterPay => 'Comprar após o pagamento';

  @override
  String get timelineBalanceLegend => 'Saldo';

  @override
  String get timelineWithPurchase => 'Com a compra';

  @override
  String get timelinePay => 'Dia do pagamento';

  @override
  String get timelineAssumptions =>
      'O futuro é uma projeção: seu pagamento na data, as contas nas delas, o reservado para viver gasto por igual e nada mais. Deslize no gráfico para ver qualquer dia.';

  @override
  String get timelineSemantics =>
      'Gráfico do seu saldo e do que está livre para gastar, dia a dia';

  @override
  String goalChartSemantics(String goal) {
    return 'Gráfico de como $goal chega à meta';
  }

  @override
  String goalChartTarget(String amount, String date) {
    return 'Meta $amount até $date';
  }

  @override
  String goalPaceLabel(String amount) {
    return 'Separar por período: $amount';
  }

  @override
  String goalOnTrack(String date) {
    return 'Em dia: alcançada em $date.';
  }

  @override
  String goalLate(String date, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: 'um dia',
    );
    return 'Neste ritmo é alcançada em $date, $_temp0 depois da data.';
  }

  @override
  String get goalNotMoving =>
      'Nada está indo para ela agora, então não se aproxima.';

  @override
  String goalUsePace(String date) {
    return 'Mudar a data para $date';
  }

  @override
  String get goalPaceNote => 'Só uma simulação: nada muda até você escolher.';

  @override
  String get goalShowPath => 'Ver como chega lá';

  @override
  String get goalHidePath => 'Ocultar';

  @override
  String get billsTitle => 'Contas e assinaturas';

  @override
  String get billAdd => 'Adicionar conta ou assinatura';

  @override
  String get billAddSub =>
      'Telefone, internet, seguro, streaming… cada um é separado antes da data.';

  @override
  String get billEditNew => 'Nova conta';

  @override
  String get billEditExisting => 'Alterar conta';

  @override
  String get billName => 'O que é?';

  @override
  String get billNameHint => 'ex. Internet';

  @override
  String get billAmount => 'Cada pagamento';

  @override
  String get billEvery => 'Com que frequência';

  @override
  String get billEveryWeek => 'Semanal';

  @override
  String get billEveryMonth => 'Mensal';

  @override
  String get billEveryQuarter => 'Trimestral';

  @override
  String get billEveryYear => 'Anual';

  @override
  String get billNext => 'Próximo pagamento';

  @override
  String get billKind => 'É';

  @override
  String get billKindBill => 'Conta';

  @override
  String get billKindSubscription => 'Assinatura';

  @override
  String get billRepays => 'Quita';

  @override
  String get billRepaysNothing => 'Nada, é um custo';

  @override
  String get billAddThis => 'Adicionar conta';

  @override
  String get billDelete => 'Excluir conta';

  @override
  String billRow(String every, String date) {
    return '$every · próximo $date';
  }

  @override
  String billOverdue(String date) {
    return 'Venceu em $date';
  }

  @override
  String get billPay => 'Marcar como paga';

  @override
  String get billEdit => 'Alterar';

  @override
  String get dayToday => 'Hoje';

  @override
  String dayIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Em $days dias',
      one: 'Em um dia',
    );
    return '$_temp0';
  }

  @override
  String dayAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Há $days dias',
      one: 'Há um dia',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'Próximos';

  @override
  String homeComingUpTotal(String amount) {
    return '$amount em contas vencem nos próximos 30 dias.';
  }

  @override
  String payDueTitle(String date) {
    return 'Seu pagamento era para $date. Chegou?';
  }

  @override
  String get payDueSub =>
      'Diga quanto chegou e o próximo é esperado um período depois.';

  @override
  String get payArrived => 'Chegou';

  @override
  String get payArrivedTitle => 'Quanto chegou?';

  @override
  String get planRecordPay => 'Pagamento chegou';

  @override
  String get planRecordPaySub => 'Registre e o próximo avança um período';

  @override
  String get accountsTitle => 'Contas';

  @override
  String get accountMain => 'Conta principal';

  @override
  String get accountKindBank => 'Conta bancária';

  @override
  String get accountKindCash => 'Dinheiro';

  @override
  String get accountKindSavings => 'Poupança';

  @override
  String get accountKindCard => 'Cartão de crédito';

  @override
  String get accountKindLoan => 'Empréstimo';

  @override
  String get accountAdd => 'Adicionar conta';

  @override
  String get accountAddSub =>
      'Dinheiro, poupança, cartão ou empréstimo. Sem conectar o banco.';

  @override
  String get accountEditNew => 'Nova conta';

  @override
  String get accountNameHint => 'ex. Carteira';

  @override
  String get accountHolds => 'Quanto tem agora';

  @override
  String get accountOwes => 'Quanto se deve agora';

  @override
  String get accountCounted => 'Contar no plano';

  @override
  String get accountCountedSub => 'Esse dinheiro pode ser gasto este mês.';

  @override
  String accountOwed(String amount) {
    return 'Devido $amount';
  }

  @override
  String get accountNotCounted => 'Fora do plano';

  @override
  String get accountConfirm => 'Informar o saldo real';

  @override
  String get accountMove => 'Mover dinheiro';

  @override
  String accountMoveTo(String name) {
    return 'Mover para $name';
  }

  @override
  String get accountMoveBlurb =>
      'Mover dinheiro entre suas contas não é gasto nem renda.';

  @override
  String get accountPayCard => 'Pagar uma parte';

  @override
  String get accountPayBlurb =>
      'Pago da conta principal. Quita o que se deve; não é um segundo gasto.';

  @override
  String get accountRemove => 'Remover esta conta';

  @override
  String get accountInUse =>
      'Tem histórico, então fica. Você pode parar de contá-la.';

  @override
  String get paidFrom => 'Pago com';

  @override
  String get categorySuggested =>
      'Sugerido pelos seus gastos anteriores. Toque em outro para mudar.';

  @override
  String get recoverTitle => 'Dinheiro a receber de volta';

  @override
  String recoverTotal(String amount) {
    return '$amount podem voltar. Não conta até chegar.';
  }

  @override
  String get recoverReturnable => 'Pode ser devolvido';

  @override
  String get recoverExpect => 'Devolvido, reembolso esperado';

  @override
  String get recoverArrived => 'Reembolso chegou';

  @override
  String get recoverKept => 'Fiquei com ele';

  @override
  String get recoverPending => 'Reembolso a caminho';

  @override
  String get recoverRefunded => 'Reembolsado';

  @override
  String get recoverPrompt => 'Recuperar dinheiro';

  @override
  String recoverWhere(String amount) {
    return 'Voltaram $amount. Para onde vão?';
  }

  @override
  String recoverToGoal(String goal) {
    return 'Para $goal';
  }

  @override
  String get recoverToBuffer => 'Para a reserva de emergência';

  @override
  String get recoverLeave => 'Deixar livre para gastar';

  @override
  String get accountStopCounting => 'Parar de contar no plano';

  @override
  String get moveTitle => 'Melhor passo';

  @override
  String get moveTagMove => 'Mover';

  @override
  String get moveTagWait => 'Esperar';

  @override
  String get moveTagSave => 'Poupar';

  @override
  String get moveTagSpend => 'Gastar';

  @override
  String moveMove(String amount, String account) {
    return 'Mova $amount de $account para cobrir o que precisa ser pago.';
  }

  @override
  String moveMoveWhy(String claim) {
    return 'Falta para $claim, e este dinheiro está fora do plano.';
  }

  @override
  String get moveDoIt => 'Mover';

  @override
  String moveWaitGap(String date, String amount) {
    return 'Segure os extras: em $date faltariam $amount para algo que precisa ser pago.';
  }

  @override
  String get moveWaitGapWhy =>
      'A projeção conta seu pagamento, contas e custos de vida até esse dia.';

  @override
  String moveWaitPay(int days, String now, String later) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: 'um dia',
    );
    return 'Seu pagamento chega em $_temp0. Esperar transforma $now de folga em $later.';
  }

  @override
  String get moveWaitPayWhy =>
      'Só se o que você tem em mente puder esperar. Nada corre risco de qualquer forma.';

  @override
  String moveSave(String amount, String account, String goal) {
    return 'Mova $amount para $account para $goal.';
  }

  @override
  String moveSaveWhy(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: 'um dia',
    );
    return 'Chega cerca de $_temp0 antes, e o que fica livre ainda é o dobro do seu mês habitual.';
  }

  @override
  String moveSpend(String amount, String date) {
    return 'Você está coberto até $date: $amount estão livres para usar.';
  }

  @override
  String get moveSpendWhy =>
      'Contas e metas já estão separadas, nada adiante fica em falta e isso está bem acima do seu gasto habitual.';

  @override
  String get moveNotNow => 'Agora não';

  @override
  String get moveNone =>
      'Não há nenhum passo que valha sugerir agora. Seu plano segue como está.';

  @override
  String monthIncome(String amount) {
    return 'Pagamento recebido: $amount.';
  }

  @override
  String monthToGoals(String amount) {
    return 'Destinado às metas: $amount.';
  }

  @override
  String monthNow(String free, String aside) {
    return 'Agora: $free livres, $aside separados.';
  }

  @override
  String get monthAheadTitle => 'Os próximos 30 dias';

  @override
  String monthAheadBills(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contas somam $amount.',
      one: 'Uma conta soma $amount.',
    );
    return '$_temp0';
  }

  @override
  String monthAheadPay(String date) {
    return 'Seu próximo pagamento é esperado em $date.';
  }

  @override
  String monthAheadTightest(String date, String amount) {
    return 'O dia mais apertado é $date, com $amount livres.';
  }

  @override
  String monthAheadShort(String date, String amount) {
    return 'Em $date faltariam $amount para algo que precisa ser pago.';
  }

  @override
  String get monthWorthKnowing => 'Vale saber';

  @override
  String insightUp(String category, String amount) {
    return '$category subiu $amount em relação ao mês anterior.';
  }

  @override
  String insightGoal(int days, String goal) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: 'um dia',
    );
    return 'Se continuar, são cerca de $_temp0 de $goal por mês.';
  }

  @override
  String get chatSuggestMove => 'O que faço agora?';

  @override
  String get chatSuggestComing => 'Quais contas estão chegando?';

  @override
  String get chatComingNone =>
      'Nenhuma conta vence nos próximos 30 dias. Adicione as suas em Plano e eu acompanho.';

  @override
  String get quickAsk => 'Perguntar';

  @override
  String get quickPay => 'Pagamento';

  @override
  String get quickBills => 'Contas';

  @override
  String get quickMonth => 'Meu mês';

  @override
  String get quickPayDue => 'Seu pagamento venceu. Diga se chegou.';
}
