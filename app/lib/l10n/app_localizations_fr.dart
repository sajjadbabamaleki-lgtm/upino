// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get navHome => 'Accueil';

  @override
  String get navPlan => 'Plan';

  @override
  String get navGoals => 'Objectifs';

  @override
  String get navActivity => 'Activité';

  @override
  String get navProfile => 'Profil';

  @override
  String get currencyTitle => 'Quelle devise ?';

  @override
  String get currencyBlurb =>
      'Tout votre plan est tenu dans cette devise. Choisissez celle dans laquelle vous êtes réellement payé.';

  @override
  String get currencySearchHint => 'Rechercher un pays, une devise ou un code';

  @override
  String currencyNoMatch(String query) {
    return 'Rien ne correspond à « $query ». Essayez le pays ou le code à trois lettres.';
  }

  @override
  String get onboardingBadge => 'Environ une minute';

  @override
  String get onboardingTitle => 'Créez votre plan';

  @override
  String get onboardingBlurb =>
      'Deux réponses suffisent pour commencer. Le reste peut attendre.';

  @override
  String get onboardingBalanceLabel => 'Votre épargne aujourd’hui';

  @override
  String get onboardingBalanceHint =>
      'L’argent dans lequel vous pourriez réellement puiser, pas celui que vous comptez ne pas toucher.';

  @override
  String get onboardingIncomeLabel => 'Combien gagnez-vous par mois ?';

  @override
  String get onboardingIncomeHint =>
      'Si cela varie, donnez la fourchette. Votre plan repose sur le bas.';

  @override
  String get onboardingPayDay => 'Quand arrive votre prochain salaire ?';

  @override
  String onboardingDays(int count) {
    return '$count jours';
  }

  @override
  String get onboardingCommitments => 'Ajoutez vos engagements';

  @override
  String get onboardingCommitmentsOpen =>
      'Loyer, dépenses courantes et un objectif';

  @override
  String get onboardingCommitmentsShut =>
      'Facultatif, et vous pourrez le faire plus tard';

  @override
  String get onboardingRentLabel => 'Loyer et factures fixes';

  @override
  String get onboardingRentHint => 'À payer avant votre prochain salaire';

  @override
  String get onboardingEssentialsLabel => 'Nourriture et transport';

  @override
  String get onboardingEssentialsHint =>
      'Ce qu’il vous faut pour tenir la période';

  @override
  String get onboardingGoalLabel => 'Épargne pour un objectif';

  @override
  String get onboardingGoalHint =>
      'Ce que vous voulez mettre de côté cette période';

  @override
  String get onboardingFinish => 'Créer mon plan';

  @override
  String get onboardingIncomplete =>
      'Remplissez les deux premières réponses pour continuer';

  @override
  String get tapToType => 'Touchez pour saisir';

  @override
  String get heroSafeToSpend => 'Vous pouvez dépenser maintenant';

  @override
  String get heroNotUpToDate => 'Pas à jour';

  @override
  String get heroRecordSpend => 'Enregistrer une dépense';

  @override
  String get heroSeeShort => 'Voir ce qui manque';

  @override
  String get heroConfirmBalance => 'Confirmer le solde';

  @override
  String get heroReviewBlurb =>
      'Vérifiez votre solde pour que ce chiffre redevienne fiable.';

  @override
  String heroUntilSetAside(String date, String amount) {
    return 'Jusqu’au $date · $amount mis de côté';
  }

  @override
  String heroShort(String amount) {
    return 'Il manque $amount';
  }

  @override
  String heroUnfunded(String label, String amount) {
    return '$label · $amount non couvert';
  }

  @override
  String get heroBalanceNever => 'Solde pas encore confirmé';

  @override
  String get heroBalanceToday => 'Solde confirmé aujourd’hui';

  @override
  String get heroBalanceYesterday => 'Solde confirmé hier';

  @override
  String heroBalanceDays(int count) {
    return 'Solde confirmé il y a $count jours';
  }

  @override
  String get confirm => 'Confirmer';

  @override
  String get homeTitle => 'Votre plan';

  @override
  String homeUntilTotal(String date, String amount) {
    return 'Jusqu’au $date · $amount au total';
  }

  @override
  String homeRecorded(String amount) {
    return '$amount enregistré';
  }

  @override
  String get homeAttention => 'Demande votre attention';

  @override
  String homeNotCovered(String amount) {
    return '$amount non couvert';
  }

  @override
  String get homeAfterNextPay => 'Après votre prochain salaire';

  @override
  String homeOncePayArrives(String date) {
    return 'Une fois votre salaire versé le $date';
  }

  @override
  String get homeSetAsideFirst => 'Mis de côté d’abord';

  @override
  String get homeProtectedBlurb =>
      'Protégé avant que quoi que ce soit ne devienne dépensable.';

  @override
  String get homeNothingSetAside =>
      'Rien n’est encore mis de côté. Tout ce que vous avez est dépensable.';

  @override
  String get homeWhyThisNumber => 'Pourquoi ce chiffre';

  @override
  String get homeWhatIsShort => 'Ce qui manque';

  @override
  String get homeShortBlurb =>
      'Rien ici n’est déplacé ni reporté à votre place. Ce sont des engagements que votre argent actuel ne couvre pas.';

  @override
  String get askSpendTitle => 'Combien avez-vous dépensé ?';

  @override
  String get askBalanceTitle => 'Quel est votre solde maintenant ?';

  @override
  String get askBalanceBlurb =>
      'Tout écart est consigné comme correction, jamais comme dépense.';

  @override
  String get whyNoChange => 'Rien n’a changé depuis votre plan précédent.';

  @override
  String get whyPayArrived =>
      'Votre salaire est arrivé, le plan a donc été actualisé.';

  @override
  String get whyBillPaid =>
      'Une facture pour laquelle vous aviez mis de l’argent de côté a été payée.';

  @override
  String get whyHeldForBill =>
      'De l’argent est retenu pour une facture qui échoit juste après votre prochain salaire.';

  @override
  String get whyOvercommitted =>
      'Vous vous êtes engagé au-delà de ce que vous avez.';

  @override
  String get whyStale => 'Votre solde n’a pas été confirmé récemment.';

  @override
  String get whyCardLarger =>
      'Le solde de votre carte dépasse l’argent dont vous disposez.';

  @override
  String get whyPayLate => 'Le salaire attendu n’est pas encore arrivé.';

  @override
  String get whyOverdue => 'Quelque chose a dépassé son échéance.';

  @override
  String get whyBufferShort =>
      'Votre réserve d’urgence n’est pas entièrement constituée.';

  @override
  String get whyGoalShort =>
      'Votre objectif d’épargne ne peut pas être entièrement financé pour l’instant.';

  @override
  String get whyFlexibleLess => 'Un objectif souple a reçu moins que prévu.';

  @override
  String get whyDuplicate =>
      'Une opération répétée n’a été comptée qu’une fois.';

  @override
  String get planTitle => 'Plan';

  @override
  String get planBlurb =>
      'Ce à quoi votre argent est promis, avant que quoi que ce soit ne devienne dépensable.';

  @override
  String get planMoneyAndIncome => 'Argent et revenus';

  @override
  String get planMoneyYouHave => 'Argent dont vous disposez';

  @override
  String get planNextPay => 'Prochain salaire';

  @override
  String get planYourNextPay => 'Votre prochain salaire';

  @override
  String get planNotSet => 'Non défini';

  @override
  String get planExpectedBlurb =>
      'Ce montant n’est qu’attendu : il reste hors de ce que vous pouvez dépenser maintenant.';

  @override
  String get planSetAsideFirst => 'Mis de côté d’abord';

  @override
  String get planNothingSetAside =>
      'Rien n’est mis de côté, donc tout ce que vous avez est dépensable.';

  @override
  String get planAddToPlan => 'Ajouter à votre plan';

  @override
  String get planGoals => 'Objectifs';

  @override
  String get planSaveToward => 'Épargner pour quelque chose';

  @override
  String get planSaveTowardSub =>
      'Un voyage, une caution, un ordinateur portable';

  @override
  String get planAllGoals => 'Tous les objectifs';

  @override
  String get planAllGoalsSub =>
      'Ajouter, modifier ou mettre de l’argent de côté';

  @override
  String get planHowMuchSetAside =>
      'Combien devez-vous mettre de côté pour cela ?';

  @override
  String get planChangeOrRemove =>
      'Modifiez le montant, ou retirez-le de votre plan.';

  @override
  String get planRemove => 'Retirer du plan';

  @override
  String planDue(String date) {
    return ' · échéance le $date';
  }

  @override
  String get priorityMandatory => 'À payer — passe en premier';

  @override
  String get priorityEssential => 'Besoins du quotidien';

  @override
  String get priorityBuffer => 'Gardé pour les imprévus';

  @override
  String get priorityCard => 'Déjà dépensé par carte';

  @override
  String get prioritySinkingFund => 'Épargne pour une facture connue';

  @override
  String get priorityGoal => 'Un objectif que vous vous êtes fixé';

  @override
  String get priorityDiscretionary => 'Agréable à avoir — cède en premier';

  @override
  String get goalsTitle => 'Objectifs';

  @override
  String get goalsBlurbEmpty => 'Vous n’épargnez encore pour rien.';

  @override
  String get goalsBlurb =>
      'Ce que chaque objectif demande à cette période de paie.';

  @override
  String get goalsEmptyCard =>
      'Ajoutez ce pour quoi vous épargnez : un voyage, une caution, un ordinateur portable. Upino calcule ce qu’il faut retenir à chaque paie pour que ce soit prêt à temps.';

  @override
  String get goalsNew => 'Nouvel objectif';

  @override
  String get goalsNewSub =>
      'Quelque chose pour quoi vous mettez de l’argent de côté';

  @override
  String get goalsAddMoney => 'Ajouter de l’argent';

  @override
  String goalsAddTo(String name) {
    return 'Ajouter à $name';
  }

  @override
  String get goalsAddBlurb =>
      'Ceci enregistre ce que vous avez mis de côté. Rien n’est dépensé : cela réduit ce qu’il faudra retenir désormais.';

  @override
  String get goalsEachPeriod => 'Chaque période';

  @override
  String get goalsTargetDate => 'Date cible';

  @override
  String goalsOf(String amount) {
    return 'sur $amount';
  }

  @override
  String goalsPeriodsToGo(int count) {
    return 'Encore $count périodes de paie';
  }

  @override
  String get goalsDone => 'Entièrement épargné';

  @override
  String get goalsPausedStatus => 'En pause — rien n’est retenu';

  @override
  String get goalsFlexibleStatus =>
      'Souple — cède devant tout paiement obligatoire';

  @override
  String get goalEditNew => 'Pour quoi épargnez-vous ?';

  @override
  String get goalEditExisting => 'Modifier l’objectif';

  @override
  String get goalName => 'Nom';

  @override
  String get goalNameHint => 'Un voyage, une caution, un ordinateur';

  @override
  String get goalTotal => 'Combien au total';

  @override
  String get goalByWhen => 'Pour quand';

  @override
  String goalMonths(int count) {
    return '$count mois';
  }

  @override
  String get goalOneYear => '1 an';

  @override
  String get goalTwoYears => '2 ans';

  @override
  String get goalFirmness => 'À quel point est-ce ferme ?';

  @override
  String get goalKindHard => 'Engagé';

  @override
  String get goalKindHardSub =>
      'Retenu avant que quoi que ce soit ne devienne dépensable';

  @override
  String get goalKindFlexible => 'Souple';

  @override
  String get goalKindFlexibleSub => 'Cède devant tout paiement obligatoire';

  @override
  String get goalKindPaused => 'En pause';

  @override
  String get goalKindPausedSub => 'Reste visible, rien n’est retenu';

  @override
  String get goalSaveChanges => 'Enregistrer les modifications';

  @override
  String get goalAddThis => 'Ajouter cet objectif';

  @override
  String get goalDelete => 'Supprimer cet objectif';

  @override
  String get activityTitle => 'Activité';

  @override
  String get activityBlurb =>
      'Tout ce que vous avez enregistré, du plus récent au plus ancien.';

  @override
  String get activityEmpty =>
      'Quand vous enregistrez une dépense, elle apparaît ici, et vous pouvez la retirer en cas d’erreur.';

  @override
  String get activityRemoveIt => 'La retirer';

  @override
  String get activityKeepIt => 'La garder';

  @override
  String get activitySpent => 'Dépense';

  @override
  String get activityIncome => 'Salaire';

  @override
  String get activityCorrection => 'Correction';

  @override
  String get activityRemoved => 'Retirée';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileConfirmBalance => 'Confirmez votre solde';

  @override
  String get profileTrustTitle => 'Quelle confiance accorder au chiffre ?';

  @override
  String get profileTrustFresh => 'À jour. Rien ne demande votre attention.';

  @override
  String get profileTrustDegraded =>
      'Votre solde n’a pas été confirmé depuis un moment. Le chiffre reste affiché, simplement moins certain.';

  @override
  String get profileTrustReview =>
      'Trop ancien ou trop incertain pour s’y fier. Confirmez votre solde pour y remédier.';

  @override
  String get profileConfirmedNever => 'Pas encore confirmé';

  @override
  String get profileConfirmedToday => 'Confirmé aujourd’hui';

  @override
  String get profileConfirmedYesterday => 'Confirmé hier';

  @override
  String profileConfirmedDays(int count) {
    return 'Confirmé il y a $count jours';
  }

  @override
  String get profileAppearance => 'Apparence';

  @override
  String get profileTheme => 'Thème';

  @override
  String get profileThemeBlurb =>
      'Suivre le téléphone est le réglage par défaut : rien n’est imposé.';

  @override
  String get themePhone => 'Téléphone';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get profileLanguage => 'Langue';

  @override
  String get profileLanguageBlurb =>
      'Suivre le téléphone est le réglage par défaut : rien n’est imposé.';

  @override
  String get languagePhone => 'Téléphone';

  @override
  String get profileCurrency => 'Devise';

  @override
  String currencyChangeTitle(String currency) {
    return 'Passer en $currency ?';
  }

  @override
  String currencyChangeBlurb(String currency) {
    return 'Chaque montant de votre plan garde son nombre et s’affiche désormais en $currency. Rien n’est converti au taux de change : utilisez ceci pour corriger la devise, pas pour convertir votre argent.';
  }

  @override
  String get currencyChangeConfirm => 'Changer';

  @override
  String get profileYourData => 'Vos données';

  @override
  String get profileDelete => 'Supprimer mon plan';

  @override
  String get profileDeleteSub => 'Efface tout et revient à la configuration';

  @override
  String get profileStartOver => 'Tout recommencer ?';

  @override
  String get profileStartOverBlurb =>
      'Votre plan et tout ce que vous avez enregistré seront supprimés. C’est irréversible.';

  @override
  String get profileDeleteEverything => 'Tout supprimer';

  @override
  String get profileKeepPlan => 'Garder mon plan';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String activityRemoveAmount(String amount) {
    return 'Retirer $amount ?';
  }

  @override
  String get activityRemoveDetail =>
      'Il cesse immédiatement de compter dans votre plan. L’entrée reste dans cette liste, marquée comme retirée, afin que votre historique reste complet.';

  @override
  String get activityCardPurchase => 'Achat par carte';

  @override
  String get activityCardPayment => 'Paiement de carte';

  @override
  String get activityRefund => 'Remboursement';

  @override
  String get activityTransfer => 'Transfert entre comptes';

  @override
  String get activityLoan => 'Prêt reçu';

  @override
  String get activityDebtPayment => 'Remboursement de dette';

  @override
  String get activityBalanceCorrected => 'Solde corrigé';

  @override
  String get activityBlurbEmpty => 'Rien d’enregistré pour l’instant.';

  @override
  String get profileStartAgain => 'Recommencer';

  @override
  String get claimRent => 'Loyer et factures';

  @override
  String get claimCardMinimum => 'Minimum dû sur la carte';

  @override
  String get claimEssentials => 'Nourriture et transport';

  @override
  String get claimBuffer => 'Réserve d’urgence';

  @override
  String get languageTitle => 'Quelle langue ?';

  @override
  String get languageBlurb => 'Vous pourrez la changer plus tard dans Profil.';

  @override
  String get profileLedgerTitle => 'L’historique est-il complet ?';

  @override
  String get ledgerComplete => 'Tout ce que vous avez dépensé est enregistré.';

  @override
  String get ledgerPartial =>
      'Une partie des dépenses n’est apparue qu’à la confirmation de votre solde.';

  @override
  String get ledgerUnknown =>
      'Upino ne peut pas dire ce qui manque. Confirmez votre solde pour le savoir.';

  @override
  String get askTitle => 'Demandez avant de dépenser';

  @override
  String get askBlurb =>
      'Testez un achat sur votre plan. Rien n’est enregistré et rien ne change.';

  @override
  String get askAmountLabel => 'Ce serait combien ?';

  @override
  String get askRun => 'Voir ce que cela ferait';

  @override
  String get askDoNotBuy => 'Ne pas acheter';

  @override
  String get askBuyNow => 'L’acheter aujourd’hui';

  @override
  String askBuyAfter(String date) {
    return 'L’acheter après le $date';
  }

  @override
  String get askUnchanged => 'Votre plan reste tel quel.';

  @override
  String get askStsAfter => 'Ce que vous pourriez dépenser ensuite';

  @override
  String get askBreaks =>
      'Cela laisse à découvert quelque chose que vous devez payer.';

  @override
  String get askSafe => 'Rien de ce que vous devez payer ne reste à découvert.';

  @override
  String get askCosts => 'Ce qui reçoit moins';

  @override
  String askCostLine(String label, String amount) {
    return '$label · $amount de moins';
  }

  @override
  String get askWaitingHelps => 'Attendre votre salaire couvre tout.';

  @override
  String get askNoIncome =>
      'Aucun salaire n’est attendu, il n’y a donc pas de moment ultérieur à comparer.';

  @override
  String askAssumption(String date) {
    return 'En supposant que votre salaire arrive comme prévu le $date.';
  }

  @override
  String get askNoVerdict =>
      'Upino ne dit ni oui ni non. L’arbitrage vous revient.';

  @override
  String get receipt => 'Reçu';

  @override
  String get receiptAdd => 'Ajouter un reçu';

  @override
  String get receiptCamera => 'Prendre une photo';

  @override
  String get receiptGallery => 'Choisir une photo';

  @override
  String get receiptAttached => 'Reçu joint';

  @override
  String get receiptRemove => 'Retirer la photo';

  @override
  String get onboardingIncomeFrom => 'Au moins';

  @override
  String get onboardingIncomeTo => 'Jusqu’à';

  @override
  String get onboardingIncomeToOptional => 'Facultatif';

  @override
  String incomeRange(String low, String high) {
    return '$low à $high';
  }

  @override
  String incomeRangeNote(String low) {
    return 'Votre plan repose sur $low. Tout ce qui vient au-dessus est à vous quand il arrive.';
  }

  @override
  String get categoryFood => 'Alimentation';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryBills => 'Factures';

  @override
  String get categoryShopping => 'Achats';

  @override
  String get categoryHealth => 'Santé';

  @override
  String get categoryFun => 'Loisirs';

  @override
  String get categoryOther => 'Autre';

  @override
  String get categoryUnsorted => 'Non classé';

  @override
  String get categoryPrompt => 'C’était pour quoi ?';

  @override
  String get spendingTitle => 'Où est-il passé';

  @override
  String get spendingWindow => 'Dépenses notées ces 30 derniers jours';

  @override
  String get backupSection => 'Sauvegarde';

  @override
  String get backupSave => 'Enregistrer une sauvegarde';

  @override
  String get backupSaveSub =>
      'Protégée par un mot de passe. Envoyez-la en lieu sûr, comme votre cloud.';

  @override
  String get backupRestore => 'Restaurer une sauvegarde';

  @override
  String get backupRestoreSub => 'Remplace le plan de ce téléphone';

  @override
  String get backupPassword => 'Mot de passe';

  @override
  String get backupPasswordRepeat => 'Répétez le mot de passe';

  @override
  String get backupPasswordSaveBlurb =>
      'Ce mot de passe sera nécessaire pour restaurer. Il est irrécupérable en cas d’oubli. Les photos de reçus ne sont pas incluses.';

  @override
  String get backupPasswordOpenBlurb =>
      'Le mot de passe utilisé pour cette sauvegarde.';

  @override
  String get backupPasswordShort => 'Au moins 6 caractères';

  @override
  String get backupPasswordMismatch => 'Les deux ne correspondent pas';

  @override
  String get backupOpen => 'Ouvrir';

  @override
  String get backupReplaceTitle => 'Remplacer ce plan ?';

  @override
  String get backupReplaceBlurb =>
      'Tout ce qui est sur ce téléphone est remplacé par la sauvegarde. C’est irréversible.';

  @override
  String get backupReplace => 'Remplacer';

  @override
  String get backupRestored => 'Sauvegarde restaurée';

  @override
  String get backupWrongPassword =>
      'Ce mot de passe n’ouvre pas cette sauvegarde.';

  @override
  String get backupNotABackup => 'Ce fichier n’est pas une sauvegarde Upino.';

  @override
  String get backupUnreadable =>
      'Cette sauvegarde vient d’une version plus récente d’Upino. Mettez l’app à jour et réessayez.';

  @override
  String get inflationTitle => 'Inflation';

  @override
  String get inflationNotSet =>
      'Non défini. Ajoutez le taux annuel de votre pays pour voir le vrai coût de vos objectifs.';

  @override
  String inflationRate(String rate) {
    return '$rate % par an';
  }

  @override
  String get inflationDialogTitle => 'Inflation annuelle';

  @override
  String get inflationDialogBlurb =>
      'Les prix montent : un objectif fixé en argent d’aujourd’hui coûtera plus à son échéance. Indiquez le taux attendu ; laissez vide pour désactiver.';

  @override
  String goalsInflated(String rate, String amount) {
    return 'À $rate % par an, cela coûtera environ $amount à l’échéance.';
  }
}
