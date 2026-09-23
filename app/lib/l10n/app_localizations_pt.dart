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
}
