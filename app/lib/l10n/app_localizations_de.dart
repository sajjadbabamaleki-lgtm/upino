// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get navHome => 'Start';

  @override
  String get navPlan => 'Plan';

  @override
  String get navGoals => 'Ziele';

  @override
  String get navActivity => 'Aktivität';

  @override
  String get navProfile => 'Profil';

  @override
  String get currencyTitle => 'Welche Währung?';

  @override
  String get currencyBlurb =>
      'Dein ganzer Plan wird in dieser Währung geführt. Wähle die, in der du tatsächlich bezahlt wirst.';

  @override
  String get currencySearchHint => 'Land, Währung oder Code suchen';

  @override
  String currencyNoMatch(String query) {
    return 'Nichts passt zu „$query“. Versuch es mit dem Land oder dem dreistelligen Code.';
  }

  @override
  String get onboardingBadge => 'Dauert etwa eine Minute';

  @override
  String get onboardingTitle => 'Richte deinen Plan ein';

  @override
  String get onboardingBlurb =>
      'Zwei Antworten reichen für den Anfang. Alles andere kann warten.';

  @override
  String get onboardingBalanceLabel => 'Dein Guthaben heute';

  @override
  String get onboardingBalanceHint =>
      'Geld, von dem du wirklich ausgeben könntest – nicht das, was unangetastet bleiben soll.';

  @override
  String get onboardingIncomeLabel => 'Was verdienst du im Monat?';

  @override
  String get onboardingIncomeHint =>
      'Wenn es schwankt, gib eine Spanne an. Dein Plan baut auf dem unteren Wert auf.';

  @override
  String get onboardingPayDay => 'Wann kommt dein nächstes Gehalt?';

  @override
  String onboardingDays(int count) {
    return '$count Tage';
  }

  @override
  String get onboardingCommitments => 'Deine Verpflichtungen hinzufügen';

  @override
  String get onboardingCommitmentsOpen => 'Miete, Lebenshaltung und ein Ziel';

  @override
  String get onboardingCommitmentsShut => 'Optional, geht auch später';

  @override
  String get onboardingRentLabel => 'Miete und feste Rechnungen';

  @override
  String get onboardingRentHint => 'Fällig vor deinem nächsten Gehalt';

  @override
  String get onboardingEssentialsLabel => 'Essen und Fahrten';

  @override
  String get onboardingEssentialsHint =>
      'Was du brauchst, um über den Zeitraum zu kommen';

  @override
  String get onboardingGoalLabel => 'Sparen für ein Ziel';

  @override
  String get onboardingGoalHint =>
      'Was du in diesem Zeitraum zurücklegen willst';

  @override
  String get onboardingFinish => 'Meinen Plan erstellen';

  @override
  String get onboardingIncomplete =>
      'Beantworte die ersten zwei Fragen, um weiterzumachen';

  @override
  String get tapToType => 'Tippen zum Eingeben';

  @override
  String get heroSafeToSpend => 'Sicher ausgeben';

  @override
  String get heroNotUpToDate => 'Nicht aktuell';

  @override
  String get heroRecordSpend => 'Ausgabe erfassen';

  @override
  String get heroSeeShort => 'Sehen, was fehlt';

  @override
  String get heroConfirmBalance => 'Kontostand bestätigen';

  @override
  String get heroReviewBlurb =>
      'Prüfe deinen Kontostand, damit man dieser Zahl wieder trauen kann.';

  @override
  String heroUntilSetAside(String date, String amount) {
    return 'Bis $date · $amount zurückgelegt';
  }

  @override
  String heroShort(String amount) {
    return '$amount fehlen';
  }

  @override
  String heroUnfunded(String label, String amount) {
    return '$label · $amount nicht gedeckt';
  }

  @override
  String get heroBalanceNever => 'Kontostand noch nicht bestätigt';

  @override
  String get heroBalanceToday => 'Kontostand heute bestätigt';

  @override
  String get heroBalanceYesterday => 'Kontostand gestern bestätigt';

  @override
  String heroBalanceDays(int count) {
    return 'Kontostand vor $count Tagen bestätigt';
  }

  @override
  String get confirm => 'Bestätigen';

  @override
  String get homeTitle => 'Dein Plan';

  @override
  String homeUntilTotal(String date, String amount) {
    return 'Bis $date · $amount insgesamt';
  }

  @override
  String homeRecorded(String amount) {
    return '$amount erfasst';
  }

  @override
  String get homeAttention => 'Braucht deine Aufmerksamkeit';

  @override
  String homeNotCovered(String amount) {
    return '$amount nicht gedeckt';
  }

  @override
  String get homeAfterNextPay => 'Nach deinem nächsten Gehalt';

  @override
  String homeOncePayArrives(String date) {
    return 'Sobald dein Gehalt am $date eingeht';
  }

  @override
  String get homeSetAsideFirst => 'Zuerst zurückgelegt';

  @override
  String get homeProtectedBlurb =>
      'Geschützt, bevor irgendetwas ausgegeben werden kann.';

  @override
  String get homeNothingSetAside =>
      'Noch ist nichts zurückgelegt. Alles, was du hast, kannst du ausgeben.';

  @override
  String get homeWhyThisNumber => 'Warum diese Zahl';

  @override
  String get homeWhatIsShort => 'Was fehlt';

  @override
  String get homeShortBlurb =>
      'Hier wird nichts für dich verschoben oder aufgeschoben. Das sind die Verpflichtungen, die dein aktuelles Geld nicht deckt.';

  @override
  String get askSpendTitle => 'Wie viel hast du ausgegeben?';

  @override
  String get askBalanceTitle => 'Wie hoch ist dein Kontostand jetzt?';

  @override
  String get askBalanceBlurb =>
      'Jede Abweichung wird als Korrektur erfasst, nie als Ausgabe.';

  @override
  String get whyNoChange =>
      'Seit deinem letzten Plan hat sich nichts geändert.';

  @override
  String get whyPayArrived =>
      'Dein Gehalt ist eingegangen, daher wurde der Plan aktualisiert.';

  @override
  String get whyBillPaid =>
      'Eine Rechnung, für die du Geld zurückgelegt hattest, wurde bezahlt.';

  @override
  String get whyHeldForBill =>
      'Geld wird für eine Rechnung zurückgehalten, die kurz nach deinem nächsten Gehalt fällig ist.';

  @override
  String get whyOvercommitted =>
      'Du hast dich zu mehr verpflichtet, als du gerade hast.';

  @override
  String get whyStale => 'Dein Kontostand wurde länger nicht bestätigt.';

  @override
  String get whyCardLarger =>
      'Dein Kartensaldo ist höher als das Geld, das du hast.';

  @override
  String get whyPayLate => 'Dein erwartetes Gehalt ist noch nicht eingegangen.';

  @override
  String get whyOverdue => 'Etwas ist überfällig.';

  @override
  String get whyBufferShort => 'Dein Notgroschen ist nicht ganz aufgefüllt.';

  @override
  String get whyGoalShort =>
      'Dein Sparziel kann gerade nicht voll finanziert werden.';

  @override
  String get whyFlexibleLess =>
      'Ein flexibles Ziel hat weniger bekommen als geplant.';

  @override
  String get whyDuplicate => 'Eine doppelte Buchung wurde nur einmal gezählt.';

  @override
  String get planTitle => 'Plan';

  @override
  String get planBlurb =>
      'Wofür dein Geld verplant ist, bevor irgendetwas ausgegeben werden kann.';

  @override
  String get planMoneyAndIncome => 'Geld und Einkommen';

  @override
  String get planMoneyYouHave => 'Dein Geld';

  @override
  String get planNextPay => 'Nächstes Gehalt';

  @override
  String get planYourNextPay => 'Dein nächstes Gehalt';

  @override
  String get planNotSet => 'Nicht festgelegt';

  @override
  String get planExpectedBlurb =>
      'Das ist nur erwartet und zählt daher nicht zu dem, was du jetzt ausgeben kannst.';

  @override
  String get planSetAsideFirst => 'Zuerst zurückgelegt';

  @override
  String get planNothingSetAside =>
      'Nichts ist zurückgelegt, also kannst du alles ausgeben.';

  @override
  String get planAddToPlan => 'Zum Plan hinzufügen';

  @override
  String get planGoals => 'Ziele';

  @override
  String get planSaveToward => 'Auf etwas sparen';

  @override
  String get planSaveTowardSub => 'Eine Reise, eine Kaution, ein neuer Laptop';

  @override
  String get planAllGoals => 'Alle Ziele';

  @override
  String get planAllGoalsSub => 'Hinzufügen, bearbeiten oder Geld zurücklegen';

  @override
  String get planHowMuchSetAside => 'Wie viel musst du dafür zurücklegen?';

  @override
  String get planChangeOrRemove => 'Betrag ändern oder aus dem Plan entfernen.';

  @override
  String get planRemove => 'Aus dem Plan entfernen';

  @override
  String planDue(String date) {
    return ' · fällig am $date';
  }

  @override
  String get priorityMandatory => 'Muss bezahlt werden – kommt zuerst';

  @override
  String get priorityEssential => 'Alltägliche Bedürfnisse';

  @override
  String get priorityBuffer => 'Für Notfälle zurückgehalten';

  @override
  String get priorityCard => 'Schon mit Karte ausgegeben';

  @override
  String get prioritySinkingFund => 'Sparen für eine bekannte Rechnung';

  @override
  String get priorityGoal => 'Ein Ziel, zu dem du dich verpflichtet hast';

  @override
  String get priorityDiscretionary => 'Schön zu haben – gibt zuerst nach';

  @override
  String get goalsTitle => 'Ziele';

  @override
  String get goalsBlurbEmpty => 'Noch nichts, auf das du sparst.';

  @override
  String get goalsBlurb => 'Was jedes Ziel aus diesem Gehaltszeitraum braucht.';

  @override
  String get goalsEmptyCard =>
      'Füge etwas hinzu, auf das du sparst – eine Reise, eine Kaution, einen neuen Laptop. Upino rechnet aus, was jeden Gehaltszeitraum zurückgehalten werden muss, damit es rechtzeitig da ist.';

  @override
  String get goalsNew => 'Neues Ziel';

  @override
  String get goalsNewSub => 'Etwas, wofür du Geld zurücklegst';

  @override
  String get goalsAddMoney => 'Geld hinzufügen';

  @override
  String goalsAddTo(String name) {
    return 'Zu $name hinzufügen';
  }

  @override
  String get goalsAddBlurb =>
      'Das erfasst, was du zurückgelegt hast. Es wird nichts ausgegeben – es senkt, was von jetzt an zurückgehalten werden muss.';

  @override
  String get goalsEachPeriod => 'Pro Gehaltszeitraum';

  @override
  String get goalsTargetDate => 'Zieldatum';

  @override
  String goalsOf(String amount) {
    return 'von $amount';
  }

  @override
  String goalsPeriodsToGo(int count) {
    return 'Noch $count Gehaltszeiträume';
  }

  @override
  String get goalsDone => 'Vollständig angespart';

  @override
  String get goalsPausedStatus => 'Pausiert – nichts zurückgehalten';

  @override
  String get goalsFlexibleStatus =>
      'Flexibel – weicht allem, was du bezahlen musst';

  @override
  String get goalEditNew => 'Worauf sparst du?';

  @override
  String get goalEditExisting => 'Ziel bearbeiten';

  @override
  String get goalName => 'Name';

  @override
  String get goalNameHint => 'Eine Reise, eine Kaution, ein Laptop';

  @override
  String get goalTotal => 'Wie viel insgesamt';

  @override
  String get goalByWhen => 'Bis wann';

  @override
  String goalMonths(int count) {
    return '$count Mon.';
  }

  @override
  String get goalOneYear => '1 Jahr';

  @override
  String get goalTwoYears => '2 Jahre';

  @override
  String get goalFirmness => 'Wie fest ist es?';

  @override
  String get goalKindHard => 'Verbindlich';

  @override
  String get goalKindHardSub =>
      'Zurückgehalten, bevor etwas ausgegeben werden kann';

  @override
  String get goalKindFlexible => 'Flexibel';

  @override
  String get goalKindFlexibleSub => 'Weicht allem, was du bezahlen musst';

  @override
  String get goalKindPaused => 'Pausiert';

  @override
  String get goalKindPausedSub => 'Bleibt sichtbar, nichts zurückgehalten';

  @override
  String get goalSaveChanges => 'Änderungen speichern';

  @override
  String get goalAddThis => 'Dieses Ziel hinzufügen';

  @override
  String get goalDelete => 'Dieses Ziel löschen';

  @override
  String get activityTitle => 'Aktivität';

  @override
  String get activityBlurb => 'Alles, was du erfasst hast, das Neueste zuerst.';

  @override
  String get activityEmpty =>
      'Wenn du eine Ausgabe erfasst, erscheint sie hier – und du kannst sie entfernen, falls sie falsch war.';

  @override
  String get activityRemoveIt => 'Entfernen';

  @override
  String get activityKeepIt => 'Behalten';

  @override
  String get activitySpent => 'Ausgegeben';

  @override
  String get activityIncome => 'Gehalt';

  @override
  String get activityCorrection => 'Korrektur';

  @override
  String get activityRemoved => 'Entfernt';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileConfirmBalance => 'Kontostand bestätigen';

  @override
  String get profileTrustTitle => 'Wie verlässlich ist die Zahl?';

  @override
  String get profileTrustFresh =>
      'Aktuell. Nichts braucht deine Aufmerksamkeit.';

  @override
  String get profileTrustDegraded =>
      'Dein Kontostand wurde eine Weile nicht bestätigt. Die Zahl wird weiter angezeigt, ist aber unsicherer.';

  @override
  String get profileTrustReview =>
      'Zu alt oder zu unsicher, um sich darauf zu verlassen. Bestätige deinen Kontostand, um das zu beheben.';

  @override
  String get profileConfirmedNever => 'Noch nicht bestätigt';

  @override
  String get profileConfirmedToday => 'Heute bestätigt';

  @override
  String get profileConfirmedYesterday => 'Gestern bestätigt';

  @override
  String profileConfirmedDays(int count) {
    return 'Vor $count Tagen bestätigt';
  }

  @override
  String get profileAppearance => 'Darstellung';

  @override
  String get profileTheme => 'Design';

  @override
  String get profileThemeBlurb =>
      'Standardmäßig wie dein Telefon, damit nichts aufgezwungen wird.';

  @override
  String get themePhone => 'Telefon';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get profileLanguage => 'Sprache';

  @override
  String get profileLanguageBlurb =>
      'Standardmäßig wie dein Telefon, damit nichts aufgezwungen wird.';

  @override
  String get languagePhone => 'Telefon';

  @override
  String get profileCurrency => 'Währung';

  @override
  String currencyChangeTitle(String currency) {
    return 'Zu $currency wechseln?';
  }

  @override
  String currencyChangeBlurb(String currency) {
    return 'Jeder Betrag in deinem Plan behält seine Zahl und wird ab jetzt in $currency angezeigt. Es wird nichts zu einem Wechselkurs umgerechnet – nutze das, um die Währung zu korrigieren, nicht um dein Geld umzurechnen.';
  }

  @override
  String get currencyChangeConfirm => 'Wechseln';

  @override
  String get profileYourData => 'Deine Daten';

  @override
  String get profileDelete => 'Meinen Plan löschen';

  @override
  String get profileDeleteSub =>
      'Löscht alles und kehrt zur Einrichtung zurück';

  @override
  String get profileStartOver => 'Neu anfangen?';

  @override
  String get profileStartOverBlurb =>
      'Dein Plan und alles, was du erfasst hast, werden gelöscht. Das kann nicht rückgängig gemacht werden.';

  @override
  String get profileDeleteEverything => 'Alles löschen';

  @override
  String get profileKeepPlan => 'Plan behalten';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String activityRemoveAmount(String amount) {
    return '$amount entfernen?';
  }

  @override
  String get activityRemoveDetail =>
      'Es zählt sofort nicht mehr für deinen Plan. Der Eintrag bleibt als entfernt markiert in dieser Liste, damit deine Aufzeichnung vollständig bleibt.';

  @override
  String get activityCardPurchase => 'Kartenzahlung';

  @override
  String get activityCardPayment => 'Kartenabrechnung';

  @override
  String get activityRefund => 'Erstattung';

  @override
  String get activityTransfer => 'Zwischen Konten verschoben';

  @override
  String get activityLoan => 'Kredit erhalten';

  @override
  String get activityDebtPayment => 'Schuldentilgung';

  @override
  String get activityBalanceCorrected => 'Kontostand korrigiert';

  @override
  String get activityBlurbEmpty => 'Noch nichts erfasst.';

  @override
  String get profileStartAgain => 'Neu beginnen';

  @override
  String get claimRent => 'Miete und Rechnungen';

  @override
  String get claimCardMinimum => 'Mindestzahlung Karte';

  @override
  String get claimEssentials => 'Essen und Fahrten';

  @override
  String get claimBuffer => 'Notgroschen';

  @override
  String get languageTitle => 'Welche Sprache?';

  @override
  String get languageBlurb => 'Du kannst das später im Profil ändern.';

  @override
  String get profileLedgerTitle => 'Sind die Einträge vollständig?';

  @override
  String get ledgerComplete => 'Alles, was du ausgegeben hast, ist erfasst.';

  @override
  String get ledgerPartial =>
      'Einige Ausgaben wurden erst beim Bestätigen deines Kontostands entdeckt.';

  @override
  String get ledgerUnknown =>
      'Upino kann nicht sagen, wie viel fehlt. Bestätige deinen Kontostand, um es herauszufinden.';

  @override
  String get askTitle => 'Frag, bevor du ausgibst';

  @override
  String get askBlurb =>
      'Probier einen Kauf gegen deinen Plan aus. Nichts wird erfasst und nichts ändert sich.';

  @override
  String get askAmountLabel => 'Wie viel würde es kosten?';

  @override
  String get askRun => 'Zeigen, was es bewirkt';

  @override
  String get askDoNotBuy => 'Nicht kaufen';

  @override
  String get askBuyNow => 'Heute kaufen';

  @override
  String askBuyAfter(String date) {
    return 'Nach dem $date kaufen';
  }

  @override
  String get askUnchanged => 'Dein Plan bleibt, wie er ist.';

  @override
  String get askStsAfter => 'Danach sicher ausgeben';

  @override
  String get askBreaks =>
      'Damit bleibt etwas, das du bezahlen musst, ungedeckt.';

  @override
  String get askSafe => 'Nichts, was du bezahlen musst, bleibt ungedeckt.';

  @override
  String get askCosts => 'Was weniger bekommt';

  @override
  String askCostLine(String label, String amount) {
    return '$label · $amount weniger';
  }

  @override
  String get askWaitingHelps =>
      'Wenn du bis zum Gehalt wartest, ist alles gedeckt.';

  @override
  String get askNoIncome =>
      'Es ist noch kein Gehalt erwartet, also gibt es keinen späteren Vergleich.';

  @override
  String askAssumption(String date) {
    return 'Angenommen, dein Gehalt kommt wie erwartet am $date.';
  }

  @override
  String get askNoVerdict =>
      'Upino sagt nicht ja oder nein. Die Abwägung liegt bei dir.';

  @override
  String get receipt => 'Beleg';

  @override
  String get receiptAdd => 'Beleg hinzufügen';

  @override
  String get receiptCamera => 'Foto aufnehmen';

  @override
  String get receiptGallery => 'Foto auswählen';

  @override
  String get receiptAttached => 'Beleg angehängt';

  @override
  String get receiptRemove => 'Foto entfernen';

  @override
  String get onboardingIncomeFrom => 'Mindestens';

  @override
  String get onboardingIncomeTo => 'Bis zu';

  @override
  String get onboardingIncomeToOptional => 'Optional';

  @override
  String incomeRange(String low, String high) {
    return '$low bis $high';
  }

  @override
  String incomeRangeNote(String low) {
    return 'Dein Plan baut auf $low auf. Alles darüber gehört dir, wenn es kommt.';
  }

  @override
  String get categoryFood => 'Essen';

  @override
  String get categoryTransport => 'Fahrten';

  @override
  String get categoryBills => 'Rechnungen';

  @override
  String get categoryShopping => 'Einkaufen';

  @override
  String get categoryHealth => 'Gesundheit';

  @override
  String get categoryFun => 'Ausgehen';

  @override
  String get categoryOther => 'Sonstiges';

  @override
  String get categoryUnsorted => 'Nicht zugeordnet';

  @override
  String get categoryPrompt => 'Wofür war es?';

  @override
  String get spendingTitle => 'Wohin es ging';

  @override
  String get spendingWindow => 'In den letzten 30 Tagen erfasste Ausgaben';

  @override
  String get backupSection => 'Sicherung';

  @override
  String get backupSave => 'Sicherung speichern';

  @override
  String get backupSaveSub =>
      'Mit Passwort geschützt. Leg sie an einem sicheren Ort ab, etwa in deiner Cloud.';

  @override
  String get backupRestore => 'Aus Sicherung wiederherstellen';

  @override
  String get backupRestoreSub => 'Ersetzt den Plan auf diesem Telefon';

  @override
  String get backupPassword => 'Passwort';

  @override
  String get backupPasswordRepeat => 'Passwort wiederholen';

  @override
  String get backupPasswordSaveBlurb =>
      'Du brauchst dieses Passwort zum Wiederherstellen. Vergisst du es, lässt es sich nicht zurückholen. Belegfotos sind nicht enthalten.';

  @override
  String get backupPasswordOpenBlurb =>
      'Das Passwort, mit dem diese Sicherung gespeichert wurde.';

  @override
  String get backupPasswordShort => 'Mindestens 6 Zeichen';

  @override
  String get backupPasswordMismatch => 'Die beiden stimmen nicht überein';

  @override
  String get backupOpen => 'Öffnen';

  @override
  String get backupReplaceTitle => 'Diesen Plan ersetzen?';

  @override
  String get backupReplaceBlurb =>
      'Alles auf diesem Telefon wird durch den Inhalt der Sicherung ersetzt. Das kann nicht rückgängig gemacht werden.';

  @override
  String get backupReplace => 'Ersetzen';

  @override
  String get backupRestored => 'Sicherung wiederhergestellt';

  @override
  String get backupWrongPassword =>
      'Mit diesem Passwort lässt sich die Sicherung nicht öffnen.';

  @override
  String get backupNotABackup => 'Diese Datei ist keine Upino-Sicherung.';

  @override
  String get backupUnreadable =>
      'Diese Sicherung stammt aus einer neueren Upino-Version. Aktualisiere die App und versuch es erneut.';

  @override
  String get inflationTitle => 'Inflation';

  @override
  String get inflationNotSet =>
      'Nicht festgelegt. Gib die jährliche Rate bei dir an, um zu sehen, was Ziele wirklich kosten.';

  @override
  String inflationRate(String rate) {
    return '$rate % pro Jahr';
  }

  @override
  String get inflationDialogTitle => 'Jährliche Inflation';

  @override
  String get inflationDialogBlurb =>
      'Preise steigen, also kostet ein Ziel in heutigem Geld zum Zieldatum mehr. Gib die erwartete Rate ein. Leer lassen, um das auszuschalten.';

  @override
  String goalsInflated(String rate, String amount) {
    return 'Bei $rate % pro Jahr kostet das bis dahin etwa $amount.';
  }

  @override
  String get holdingsTitle => 'Weitere Werte';

  @override
  String get holdingsBlurb =>
      'Dollar, Gold, Münzen. Neben deinem Plan angezeigt und nie zu dem gezählt, was du ausgeben kannst.';

  @override
  String get holdingsAdd => 'Wert hinzufügen';

  @override
  String get holdingsAddSub => 'Zählt nicht zu dem, was du ausgeben kannst';

  @override
  String get holdingsTotal => 'Zusammen';

  @override
  String holdingSummary(String quantity, String price, String date) {
    return '$quantity × $price · Preis vom $date';
  }

  @override
  String get holdingEditNew => 'Neuer Wert';

  @override
  String get holdingEditExisting => 'Wert ändern';

  @override
  String get holdingName => 'Was ist es?';

  @override
  String get holdingNameHint => 'US-Dollar, Gold …';

  @override
  String get holdingUsd => 'US-Dollar';

  @override
  String get holdingEur => 'Euro';

  @override
  String get holdingGold => 'Gold (Gramm)';

  @override
  String get holdingCoin => 'Goldmünze';

  @override
  String get holdingQuantity => 'Wie viele';

  @override
  String get holdingUnitPrice => 'Was eins heute wert ist';

  @override
  String holdingWorth(String amount) {
    return 'Zusammen $amount wert';
  }

  @override
  String get holdingDelete => 'Diesen Wert entfernen';

  @override
  String get fasterTitle => 'Schneller erfassen';

  @override
  String get smsTitle => 'Bank-SMS lesen';

  @override
  String get smsDetail =>
      'Ausgaben, über die deine Bank dich per SMS informiert, kannst du mit einem Tipp erfassen. Nachrichten werden nur auf diesem Telefon gelesen und nirgendwohin gesendet.';

  @override
  String get smsDenied =>
      'Upino durfte keine Nachrichten lesen. Du kannst es in den Telefoneinstellungen erlauben.';

  @override
  String smsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bank-Nachrichten zu prüfen',
      one: '1 Bank-Nachricht zu prüfen',
    );
    return '$_temp0';
  }

  @override
  String get smsWaitingSub => 'Jede mit einem Tipp erfassen oder überspringen';

  @override
  String get smsReviewTitle => 'Von deiner Bank';

  @override
  String get smsReviewBlurb =>
      'Nichts wird erfasst, bevor du auf Erfassen tippst. Vergleiche den Betrag mit der Nachricht.';

  @override
  String get smsReviewDone => 'Alles erledigt.';

  @override
  String get smsRecord => 'Erfassen';

  @override
  String get smsSkip => 'Überspringen';

  @override
  String get reminderTitleSetting => 'Abenderinnerung';

  @override
  String get reminderDetail => 'Um 21 Uhr, nur an Tagen ohne Eintrag.';

  @override
  String get reminderDenied =>
      'Upino durfte keine Benachrichtigungen zeigen. Du kannst es in den Telefoneinstellungen erlauben.';

  @override
  String get reminderTitle => 'Heute etwas ausgegeben?';

  @override
  String get reminderBody =>
      'In ein paar Sekunden erfasst, damit die Zahl morgen stimmt.';

  @override
  String get reminderChannel => 'Abenderinnerung';

  @override
  String get widgetSpend => '+ Ausgabe';

  @override
  String get widgetAdd => 'Zum Startbildschirm hinzufügen';

  @override
  String get widgetAddSub =>
      'Was du ausgeben kannst und ein Knopf zum Erfassen, ohne die App zu öffnen';

  @override
  String get voiceListening => 'Ich höre zu … sag den Betrag und wofür.';

  @override
  String voiceHeard(String text) {
    return 'Gehört: „$text“. Prüf den Betrag, dann speichern.';
  }

  @override
  String get voiceNothing =>
      'Kein Betrag gehört. Versuch es noch mal oder tipp ihn ein.';

  @override
  String get voicePrivacy =>
      'Dein Telefon wandelt Sprache in Text um. Auf Telefonen ohne Offline-Erkennung läuft das über den Sprachdienst des Telefons.';

  @override
  String get voiceButton => 'Sprechen';

  @override
  String get voiceUnavailable =>
      'Dieses Telefon hat keine nutzbare Spracherkennung. Tipp den Betrag stattdessen ein.';

  @override
  String get voiceNoPermission =>
      'Upino durfte das Mikrofon nicht nutzen. Du kannst es in den Telefoneinstellungen erlauben.';

  @override
  String get voiceNetwork =>
      'Die Spracherkennung braucht hier Internet und konnte es nicht erreichen.';

  @override
  String voiceNoAmount(String text) {
    return '„$text“ gehört, aber kein Betrag darin. Versuch es noch mal oder tipp ihn ein.';
  }

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get navAsk => 'Fragen';

  @override
  String get alertsTitle => 'Braucht dich';

  @override
  String get alertsEmpty => 'Gerade braucht dich nichts. Der Plan ist aktuell.';

  @override
  String alertUnfunded(String label, String amount) {
    return '$label fehlen $amount';
  }

  @override
  String get alertUnfundedDetail =>
      'Etwas, das du bezahlen musst, ist durch dein Geld nicht gedeckt.';

  @override
  String alertIncomeLate(String date) {
    return 'Dein Gehalt wurde am $date erwartet';
  }

  @override
  String get alertIncomeLateDetail =>
      'Es zählt erst, wenn es eingeht. Ändere das Datum im Plan, falls es sich verschoben hat.';

  @override
  String alertGoalBehind(String name, String amount) {
    return '$name liegt in diesem Zeitraum $amount zurück';
  }

  @override
  String get alertGoalBehindDetail =>
      'Dein Geld reicht nicht für den Anteil dieses Zeitraums am Ziel.';

  @override
  String get chatHint => 'Frag mich etwas oder gib einen Preis ein';

  @override
  String get chatSuggestSafe => 'Wie viel kann ich ausgeben?';

  @override
  String get chatSuggestPay => 'Wann kommt mein nächstes Gehalt?';

  @override
  String get chatSuggestWhere => 'Wohin ist mein Geld gegangen?';

  @override
  String get chatSuggestAside => 'Was ist zurückgelegt?';

  @override
  String chatSafe(String amount, String date) {
    return 'Du kannst bis $date $amount ausgeben.';
  }

  @override
  String get chatSafeStale =>
      'Eine Sache: Dein Kontostand muss bestätigt werden, nimm das also als Schätzung.';

  @override
  String chatPay(String amount, String date) {
    return 'Dein nächstes Gehalt beträgt $amount, erwartet am $date.';
  }

  @override
  String get chatPayNone =>
      'Ich kenne dein nächstes Gehalt noch nicht. Trag es im Plan ein, dann behalte ich es im Blick.';

  @override
  String get chatWhere => 'So hat es sich in den letzten 30 Tagen verteilt:';

  @override
  String get chatWhereNone =>
      'Keine Ausgaben in den letzten 30 Tagen. Entweder war es ein ruhiger Monat oder sie wurden nicht erfasst.';

  @override
  String chatAside(String amount) {
    return '$amount sind zurückgelegt, bevor etwas als ausgebbar zählt:';
  }

  @override
  String chatPurchase(String amount) {
    return 'Schauen wir, was $amount bewirken würde.';
  }

  @override
  String get chatHelp =>
      'Hm, das habe ich nicht ganz verstanden. Ich kann dir sagen, wie viel du ausgeben kannst, wann dein Gehalt kommt, wohin dein Geld ging, was zurückgelegt ist oder wie du weniger ausgibst. Oder gib einen Preis ein, etwa „ein Handy für 800 Euro“, und ich zeige dir, was der Kauf bewirken würde.';

  @override
  String get chatHelloNew =>
      'Hallo! Ich bin Upino. Du bist neu hier, also kenne ich bisher nur die Grundlagen: deinen Kontostand, dein Gehalt und was du zurücklegst. Das reicht schon, um dir zu sagen, was du ausgeben kannst und was ein Kauf bewirkt. Erfasse weiter deine Ausgaben, und nach etwa einer Saison kenne ich deine Gewohnheiten gut genug, um dein eigener Geldberater zu sein.';

  @override
  String chatHelloLearning(int days, int spends, int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tagen',
      one: '1 Tag',
    );
    String _temp1 = intl.Intl.pluralLogic(
      spends,
      locale: localeName,
      other: '$spends Ausgaben',
      one: '1 Ausgabe',
    );
    return 'Willkommen zurück! Ich lerne bisher aus $_temp0 und $_temp1. Noch etwa $remaining Tage, dann habe ich eine ganze Saison.';
  }

  @override
  String chatHelloFamiliar(int days) {
    return 'Willkommen zurück! Ich habe jetzt $days Tage deines Geldes gesehen, also frag mich alles – auch, wie du weniger ausgibst.';
  }

  @override
  String chatHelloAlerts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dinge brauchen dich',
      one: 'eine Sache braucht dich',
    );
    return 'Übrigens: $_temp0 – unter der Glocke.';
  }

  @override
  String chatPurchaseFits(String left) {
    return 'Wenn du es heute kaufst, bleibt alles gedeckt, was du bezahlen musst, und $left bleiben übrig.';
  }

  @override
  String chatPurchaseWait(String date) {
    return 'Heute gekauft, würde etwas fehlen, das du bezahlen musst. Wartest du bis $date, ist alles gedeckt.';
  }

  @override
  String chatPurchaseStillShort(String date) {
    return 'Achtung: Selbst nach deinem Gehalt am $date würde etwas fehlen, das du bezahlen musst.';
  }

  @override
  String get chatPurchaseShort =>
      'Heute gekauft, würde etwas fehlen, das du bezahlen musst.';

  @override
  String chatSafeNothing(String date) {
    return 'Gerade ist bis $date nichts übrig: Alles, was du hast, ist schon für etwas verplant, das du bezahlen musst.';
  }

  @override
  String chatPayIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'in $days Tagen',
      one: 'in einem Tag',
    );
    return 'Das ist $_temp0.';
  }

  @override
  String get chatPayLate =>
      'Es ist spät dran, also zählt es erst, wenn du bestätigst, dass es da ist.';

  @override
  String get chatPayRange =>
      'Dein Plan rechnet mit dem unteren Wert, ein guter Monat ist also ein Bonus, kein Loch.';

  @override
  String chatWhereSoFar(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: '1 Tag',
    );
    return 'Ich habe bisher erst $_temp0 gesehen, also ein erster Blick:';
  }

  @override
  String chatWhereTop(String category, int share) {
    return '$category ist am größten: $share % davon.';
  }

  @override
  String get chatWhereTooSoon =>
      'Dafür ist es noch etwas früh: Ich habe kaum Ausgaben gesehen. Erfasse ein paar und frag mich nächste Woche noch mal.';

  @override
  String get chatAdviceTooSoon =>
      'Dabei helfe ich gern, aber ehrlich gesagt kenne ich deine Ausgaben noch nicht gut genug, und Rat ohne das wäre nur geraten. Erfasse deine Ausgaben (Kategorien helfen sehr) und frag mich in ein paar Wochen noch mal.';

  @override
  String chatAdviceBiggest(String category, String amount, String tenth) {
    return 'Dein größter Posten in den letzten 30 Tagen war $category mit $amount. Ein Zehntel weniger würde etwa $tenth im Monat freimachen.';
  }

  @override
  String get chatAdviceSort =>
      'Ich sehe, was du ausgibst, aber nicht wofür. Gib deinen Ausgaben beim Erfassen eine Kategorie, dann sage ich dir, wo du sparen kannst.';

  @override
  String chatAdviceMore(String amount) {
    return 'Du hast $amount mehr ausgegeben als im Vormonat.';
  }

  @override
  String chatAdviceLess(String amount) {
    return 'Schön: Das sind $amount weniger als im Vormonat.';
  }

  @override
  String get chatAdviceLearning =>
      'Ich lerne deine Gewohnheiten noch, nimm das als ersten Hinweis, nicht als ganzes Bild.';

  @override
  String get chatSmallHello => 'Hallo! Was möchtest du über dein Geld wissen?';

  @override
  String get chatSmallThanks =>
      'Jederzeit! Ich bin da, wann immer du etwas ausgeben willst.';

  @override
  String get chatSmallWho =>
      'Ich bin Upinos Assistent. Ich kenne nur, was in deinem Plan steht, und jede Zahl kommt direkt daraus; nichts, was du mir sagst, verlässt dieses Telefon. Ich sage nicht ja oder nein, aber ich zeige dir, was jede Wahl übrig lässt.';

  @override
  String get chatSuggestAdvice => 'Wie kann ich weniger ausgeben?';

  @override
  String get chatTitle => 'Upino';

  @override
  String get chatNew => 'Neuer Chat';

  @override
  String get chatResumed =>
      'Die Antworten hier werden aus deinem heutigen Plan berechnet.';

  @override
  String get chatWhy => 'So kommt die Zahl zustande:';

  @override
  String get chatWhyHave => 'Was du hast';

  @override
  String get chatWhySetAside => 'Zuerst zurückgelegt';

  @override
  String get chatWhyLeft => 'Sicher ausgeben';

  @override
  String get chatSmallHowAreYou =>
      'Mir geht\'s gut, danke der Nachfrage! Dein Geld ist da, wo ich es gelassen habe. Was möchtest du wissen?';

  @override
  String get chatSmallBye =>
      'Tschüss! Komm vor deiner nächsten großen Ausgabe wieder.';

  @override
  String get chatSmallOkay => 'Möchtest du noch etwas prüfen?';

  @override
  String get askHubTitle => 'Sprich mit Upino';

  @override
  String get askHubNew =>
      'Frag, was du ausgeben kannst, was ein Kauf bewirkt oder wann dein Gehalt kommt. Ich lerne dich noch kennen, also werde ich nützlicher, je mehr du erfasst.';

  @override
  String askHubLearning(int days) {
    return 'Ich lerne deine Gewohnheiten: noch etwa $days Tage, dann kann ich auf eine ganze Saison zurückgreifen.';
  }

  @override
  String get askHubFamiliar =>
      'Ich kenne dein Geld jetzt gut. Frag mich alles, auch wie du weniger ausgibst.';

  @override
  String get askHubStart => 'Gespräch beginnen';

  @override
  String get askHubCommon => 'Häufige Fragen';

  @override
  String get askHubHistory => 'Deine Gespräche';

  @override
  String askHubTurns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fragen',
      one: '1 Frage',
    );
    return '$_temp0';
  }

  @override
  String askHubAsidePreview(String amount, int count) {
    return '$amount zurückgelegt für $count Verpflichtungen';
  }

  @override
  String get askHubDeleteTitle => 'Dieses Gespräch löschen?';

  @override
  String get askHubDeleteBlurb =>
      'Nur das Gespräch wird gelöscht. An deinem Plan ändert sich nichts.';

  @override
  String get chatSmallHi => 'Hallo!';

  @override
  String get chatSmallHiFine => 'Hallo! Mir geht\'s gut, danke.';

  @override
  String chatSafeLasts(int days) {
    return 'Das muss $days Tage reichen, bis zu deinem Gehalt.';
  }

  @override
  String homeSpokenFor(String amount, String date) {
    return '$amount deines Geldes sind bis $date schon verplant.';
  }

  @override
  String askGoalLater(String goal, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: 'einen Tag',
    );
    return '$goal · etwa $_temp0 später';
  }

  @override
  String get askGoalsTitle => 'Ziele verschieben sich';

  @override
  String get askGoalsNote =>
      'Ungefähr, beim Tempo, in dem jedes Ziel angespart wird.';

  @override
  String chatPurchaseGoal(String goal, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: 'einen Tag',
    );
    return 'Es würde $goal um etwa $_temp0 nach hinten schieben.';
  }

  @override
  String get monthTitle => 'Dein Monat';

  @override
  String get monthWindow => 'Die letzten 30 Tage, verglichen mit den 30 davor';

  @override
  String monthTooSoon(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'in $days Tagen',
      one: 'in einem Tag',
    );
    return 'Ein Monatsrückblick braucht einen Monat Ausgaben. Deiner ist $_temp0 bereit.';
  }

  @override
  String monthSpent(String amount) {
    return 'In den letzten 30 Tagen gingen $amount raus.';
  }

  @override
  String get monthNothing => 'In den letzten 30 Tagen wurde nichts erfasst.';

  @override
  String monthMore(String amount) {
    return 'Das sind $amount mehr als in den 30 Tagen davor.';
  }

  @override
  String monthLess(String amount) {
    return 'Das sind $amount weniger als in den 30 Tagen davor.';
  }

  @override
  String get monthSame => 'Etwa gleich wie in den 30 Tagen davor.';

  @override
  String monthUp(String category, String amount) {
    return 'Am stärksten gestiegen: $category, um $amount.';
  }

  @override
  String monthDown(String category, String amount) {
    return 'Am stärksten gesunken: $category, um $amount.';
  }

  @override
  String monthGoals(int onTrack, int total) {
    return 'Ziele im Plan: $onTrack von $total.';
  }

  @override
  String get chatSuggestMonth => 'Wie war mein Monat?';

  @override
  String get timelineTitle => 'Dein Geld in Zukunft';

  @override
  String get timelineToday => 'Heute';

  @override
  String get timelineNow => 'Jetzt';

  @override
  String get timelineProjected => 'Prognose';

  @override
  String get timelineRecorded => 'Erfasst';

  @override
  String get timelineFree => 'Frei auszugeben';

  @override
  String get timelineHad => 'Du hattest';

  @override
  String timelineBalance(String amount) {
    return 'Kontostand $amount';
  }

  @override
  String timelineSetAside(String amount) {
    return 'Zurückgelegt $amount';
  }

  @override
  String timelinePayMark(String amount) {
    return 'Gehalt $amount';
  }

  @override
  String timelineShort(String amount) {
    return '$amount fehlen für etwas, das bezahlt werden muss';
  }

  @override
  String timelineWithout(String amount) {
    return 'Ohne: $amount';
  }

  @override
  String get timelineBuyAfterPay => 'Nach dem Gehalt kaufen';

  @override
  String get timelineBalanceLegend => 'Kontostand';

  @override
  String get timelineWithPurchase => 'Mit dem Kauf';

  @override
  String get timelinePay => 'Zahltag';

  @override
  String get timelineAssumptions =>
      'Die Zukunft ist eine Prognose: dein Gehalt an seinem Datum, Rechnungen an ihren, das Geld fürs Leben gleichmäßig ausgegeben, sonst nichts. Zieh über das Diagramm, um jeden Tag zu sehen.';

  @override
  String get timelineSemantics =>
      'Diagramm deines Kontostands und dessen, was frei auszugeben ist, Tag für Tag';

  @override
  String goalChartSemantics(String goal) {
    return 'Diagramm, wie $goal sein Ziel erreicht';
  }

  @override
  String goalChartTarget(String amount, String date) {
    return 'Ziel $amount bis $date';
  }

  @override
  String goalPaceLabel(String amount) {
    return 'Pro Gehaltszeitraum zurücklegen: $amount';
  }

  @override
  String goalOnTrack(String date) {
    return 'Im Plan: erreicht bis $date.';
  }

  @override
  String goalLate(String date, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: 'einen Tag',
    );
    return 'Bei diesem Tempo erreicht am $date, $_temp0 nach dem Datum.';
  }

  @override
  String get goalNotMoving =>
      'Gerade fließt nichts hinein, also kommt es nicht näher.';

  @override
  String goalUsePace(String date) {
    return 'Zieldatum auf $date verschieben';
  }

  @override
  String get goalPaceNote =>
      'Nur ein Was-wäre-wenn: Nichts ändert sich, bis du dich entscheidest.';

  @override
  String get goalShowPath => 'Sehen, wie es dorthin kommt';

  @override
  String get goalHidePath => 'Ausblenden';

  @override
  String get billsTitle => 'Rechnungen und Abos';

  @override
  String get billAdd => 'Rechnung oder Abo hinzufügen';

  @override
  String get billAddSub =>
      'Handy, Internet, Versicherung, Streaming … jedes wird vor seinem Datum zurückgelegt.';

  @override
  String get billEditNew => 'Neue Rechnung';

  @override
  String get billEditExisting => 'Diese Rechnung ändern';

  @override
  String get billName => 'Was ist es?';

  @override
  String get billNameHint => 'z. B. Internet';

  @override
  String get billAmount => 'Jede Zahlung';

  @override
  String get billEvery => 'Wie oft';

  @override
  String get billEveryWeek => 'Wöchentlich';

  @override
  String get billEveryMonth => 'Monatlich';

  @override
  String get billEveryQuarter => 'Vierteljährlich';

  @override
  String get billEveryYear => 'Jährlich';

  @override
  String get billNext => 'Nächste Zahlung';

  @override
  String get billKind => 'Es ist ein(e)';

  @override
  String get billKindBill => 'Rechnung';

  @override
  String get billKindSubscription => 'Abo';

  @override
  String get billRepays => 'Tilgt';

  @override
  String get billRepaysNothing => 'Nichts, es sind Kosten';

  @override
  String get billAddThis => 'Diese Rechnung hinzufügen';

  @override
  String get billDelete => 'Diese Rechnung löschen';

  @override
  String billRow(String every, String date) {
    return '$every · nächste am $date';
  }

  @override
  String billOverdue(String date) {
    return 'War fällig am $date';
  }

  @override
  String get billPay => 'Als bezahlt markieren';

  @override
  String get billEdit => 'Ändern';

  @override
  String get dayToday => 'Heute';

  @override
  String dayIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'In $days Tagen',
      one: 'In einem Tag',
    );
    return '$_temp0';
  }

  @override
  String dayAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Vor $days Tagen',
      one: 'Vor einem Tag',
    );
    return '$_temp0';
  }

  @override
  String get homeComingUp => 'Demnächst';

  @override
  String homeComingUpTotal(String amount) {
    return '$amount an Rechnungen in den nächsten 30 Tagen fällig.';
  }

  @override
  String payDueTitle(String date) {
    return 'Dein Gehalt war am $date fällig. Ist es da?';
  }

  @override
  String get payDueSub =>
      'Gib an, was eingegangen ist; das nächste Gehalt wird einen Zeitraum später erwartet.';

  @override
  String get payArrived => 'Es ist da';

  @override
  String get payArrivedTitle => 'Wie viel ist eingegangen?';

  @override
  String get planRecordPay => 'Gehalt eingegangen';

  @override
  String get planRecordPaySub =>
      'Erfassen, dann rückt das nächste einen Zeitraum weiter';

  @override
  String get accountsTitle => 'Konten';

  @override
  String get accountMain => 'Hauptkonto';

  @override
  String get accountKindBank => 'Bankkonto';

  @override
  String get accountKindCash => 'Bargeld';

  @override
  String get accountKindSavings => 'Ersparnisse';

  @override
  String get accountKindCard => 'Kreditkarte';

  @override
  String get accountKindLoan => 'Kredit';

  @override
  String get accountAdd => 'Konto hinzufügen';

  @override
  String get accountAddSub =>
      'Bargeld, Ersparnisse, eine Karte oder ein Kredit. Keine Bankverbindung nötig.';

  @override
  String get accountEditNew => 'Neues Konto';

  @override
  String get accountNameHint => 'z. B. Geldbörse';

  @override
  String get accountHolds => 'Was es jetzt enthält';

  @override
  String get accountOwes => 'Was jetzt geschuldet wird';

  @override
  String get accountCounted => 'Im Plan mitzählen';

  @override
  String get accountCountedSub =>
      'Dieses Geld kann diesen Monat ausgegeben werden.';

  @override
  String accountOwed(String amount) {
    return '$amount geschuldet';
  }

  @override
  String get accountNotCounted => 'Nicht im Plan gezählt';

  @override
  String get accountConfirm => 'Sagen, was es wirklich enthält';

  @override
  String get accountMove => 'Geld verschieben';

  @override
  String accountMoveTo(String name) {
    return 'Nach $name verschieben';
  }

  @override
  String get accountMoveBlurb =>
      'Geld zwischen deinen eigenen Konten zu verschieben ist weder Ausgabe noch Einnahme.';

  @override
  String get accountPayCard => 'Einen Teil abbezahlen';

  @override
  String get accountPayBlurb =>
      'Vom Hauptkonto bezahlt. Es begleicht, was geschuldet wird; es ist keine zweite Ausgabe.';

  @override
  String get accountRemove => 'Dieses Konto entfernen';

  @override
  String get accountInUse =>
      'Es hat einen Verlauf und bleibt daher. Du kannst stattdessen aufhören, es mitzuzählen.';

  @override
  String get paidFrom => 'Bezahlt von';

  @override
  String get categorySuggested =>
      'Vorgeschlagen aus deinen früheren Ausgaben. Tippe eine andere an, um sie zu ändern.';

  @override
  String get recoverTitle => 'Geld, das zurückkommt';

  @override
  String recoverTotal(String amount) {
    return '$amount kommen vielleicht zurück. Es zählt erst, wenn es eingeht.';
  }

  @override
  String get recoverReturnable => 'Kann zurückgegeben werden';

  @override
  String get recoverExpect => 'Zurückgegeben, Erstattung erwartet';

  @override
  String get recoverArrived => 'Erstattung eingegangen';

  @override
  String get recoverKept => 'Behalten';

  @override
  String get recoverPending => 'Erstattung unterwegs';

  @override
  String get recoverRefunded => 'Erstattet';

  @override
  String get recoverPrompt => 'Geld zurückbekommen';

  @override
  String recoverWhere(String amount) {
    return '$amount kamen zurück. Wohin damit?';
  }

  @override
  String recoverToGoal(String goal) {
    return 'Für $goal';
  }

  @override
  String get recoverToBuffer => 'In den Notgroschen';

  @override
  String get recoverLeave => 'Frei zum Ausgeben lassen';

  @override
  String get accountStopCounting => 'Nicht mehr im Plan zählen';

  @override
  String get moveTitle => 'Bester Schritt';

  @override
  String get moveTagMove => 'Verschieben';

  @override
  String get moveTagWait => 'Warten';

  @override
  String get moveTagSave => 'Sparen';

  @override
  String get moveTagSpend => 'Ausgeben';

  @override
  String moveMove(String amount, String account) {
    return 'Verschieb $amount von $account, um zu decken, was bezahlt werden muss.';
  }

  @override
  String moveMoveWhy(String claim) {
    return '$claim fehlt Geld, und dieses Geld liegt außerhalb des Plans.';
  }

  @override
  String get moveDoIt => 'Verschieben';

  @override
  String moveWaitGap(String date, String amount) {
    return 'Halte dich mit Extras zurück: Am $date würden $amount für etwas fehlen, das bezahlt werden muss.';
  }

  @override
  String get moveWaitGapWhy =>
      'Die Prognose rechnet dein Gehalt, Rechnungen und Lebenshaltung bis zu diesem Tag.';

  @override
  String moveWaitPay(int days, String now, String later) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tagen',
      one: 'einem Tag',
    );
    return 'Dein Gehalt kommt in $_temp0. Wenn du wartest, werden aus $now Spielraum $later.';
  }

  @override
  String get moveWaitPayWhy =>
      'Nur wenn das, was du vorhast, warten kann. So oder so ist nichts in Gefahr.';

  @override
  String moveSave(String amount, String account, String goal) {
    return 'Verschieb $amount auf $account für $goal.';
  }

  @override
  String moveSaveWhy(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: 'einen Tag',
    );
    return 'Es ist dann etwa $_temp0 früher da, und was frei bleibt, ist immer noch das Doppelte deines üblichen Monats.';
  }

  @override
  String moveSpend(String amount, String date) {
    return 'Du bist bis $date abgesichert: $amount sind frei verfügbar.';
  }

  @override
  String get moveSpendWhy =>
      'Rechnungen und Ziele sind schon zurückgelegt, nichts Kommendes fällt zu knapp aus, und das liegt deutlich über deinen üblichen Ausgaben.';

  @override
  String get moveNotNow => 'Nicht jetzt';

  @override
  String get moveNone =>
      'Gerade gibt es keinen Schritt, der sich lohnt. Dein Plan bleibt, wie er ist.';

  @override
  String monthIncome(String amount) {
    return 'Eingegangenes Gehalt: $amount.';
  }

  @override
  String monthToGoals(String amount) {
    return 'Für Ziele zurückgelegt: $amount.';
  }

  @override
  String monthNow(String free, String aside) {
    return 'Jetzt: $free frei auszugeben, $aside zurückgelegt.';
  }

  @override
  String get monthAheadTitle => 'Die nächsten 30 Tage';

  @override
  String monthAheadBills(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Rechnungen über $amount.',
      one: 'Eine Rechnung über $amount.',
    );
    return '$_temp0';
  }

  @override
  String monthAheadPay(String date) {
    return 'Dein nächstes Gehalt wird am $date erwartet.';
  }

  @override
  String monthAheadTightest(String date, String amount) {
    return 'Der knappste Tag ist der $date, mit $amount frei.';
  }

  @override
  String monthAheadShort(String date, String amount) {
    return 'Am $date würden $amount für etwas fehlen, das bezahlt werden muss.';
  }

  @override
  String get monthWorthKnowing => 'Gut zu wissen';

  @override
  String insightUp(String category, String amount) {
    return '$category liegt $amount über dem Vormonat.';
  }

  @override
  String insightGoal(int days, String goal) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: 'ein Tag',
    );
    return 'Bleibt es so, sind das jeden Monat etwa $_temp0 von $goal.';
  }

  @override
  String get chatSuggestMove => 'Was soll ich als Nächstes tun?';

  @override
  String get chatSuggestComing => 'Welche Rechnungen kommen?';

  @override
  String get chatComingNone =>
      'In den nächsten 30 Tagen sind keine Rechnungen fällig. Trag deine im Plan ein, dann behalte ich sie im Blick.';

  @override
  String get quickAsk => 'Fragen';

  @override
  String get quickPay => 'Gehalt da';

  @override
  String get quickBills => 'Rechnungen';

  @override
  String get quickMonth => 'Mein Monat';

  @override
  String get quickPayDue => 'Dein Gehalt ist fällig. Sag, ob es da ist.';

  @override
  String get chartAvg => 'Ø';

  @override
  String get flowsTitle => 'Geld rein und raus';

  @override
  String get flowsBlurb =>
      'Woche für Woche: Gehalt und Erstattungen über der Linie, Ausgaben und Tilgungen darunter.';

  @override
  String flowsWeek(String date) {
    return 'Woche vom $date';
  }

  @override
  String flowsInOut(String moneyIn, String moneyOut) {
    return 'Rein $moneyIn · Raus $moneyOut';
  }

  @override
  String get balanceHistoryTitle => 'Dein Kontostand im Verlauf';

  @override
  String rangeMonths(int count) {
    return '$count M';
  }

  @override
  String get rangeYear => '1 J';

  @override
  String get weekSpentTitle => 'Letzte 7 Tage';

  @override
  String weekSpentTotal(String amount) {
    return '$amount ausgegeben';
  }

  @override
  String get payGaugeTitle => 'Bis zu deinem nächsten Gehalt';

  @override
  String payGaugeDaysLabel(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Tage noch',
      one: 'Tag noch',
    );
    return '$_temp0';
  }

  @override
  String payGaugeAfter(String date, String amount) {
    return 'Nach deinem Gehalt am $date: $amount frei';
  }

  @override
  String payGaugeLasts(String amount) {
    return '$amount müssen bis dahin reichen.';
  }

  @override
  String get goalsOverall => 'all deiner Ziele';

  @override
  String goalsThisMonth(String amount) {
    return '+$amount diesen Monat';
  }

  @override
  String get goalsNothingThisMonth => 'Diesen Monat nichts hinzugefügt';

  @override
  String get goalsAllOnTrack => 'Alles im Plan';

  @override
  String goalsOnTrackCount(int onTrack, int total) {
    return '$onTrack von $total im Plan';
  }

  @override
  String goalsNextUp(String goal, String date) {
    return 'Als Nächstes: $goal, $date';
  }

  @override
  String get goalsTips => 'Wege, schneller ans Ziel zu kommen';

  @override
  String get goalsTipsSub => 'Frag Upino, aus deinen eigenen Ausgaben';

  @override
  String get goalsDetailTitle => 'Jedes Ziel';

  @override
  String get demoTry => 'Mit Beispieldaten ausprobieren';

  @override
  String get demoTrySub =>
      'Vier Ziele, Rechnungen und drei Monate Verlauf, in einer Kopie, die nicht deine ist und nicht gespeichert wird.';

  @override
  String get demoBanner =>
      'Beispieldaten: Nichts hier gehört dir oder wird gespeichert.';

  @override
  String get demoExit => 'Beenden';

  @override
  String get demoGoalTrip => 'Reise';

  @override
  String get demoGoalLaptop => 'Laptop';

  @override
  String get demoGoalEmergency => 'Notfall';

  @override
  String get demoGoalCar => 'Auto';

  @override
  String get demoBillPhone => 'Handy';

  @override
  String get demoBillInternet => 'Internet';

  @override
  String get demoBillGym => 'Fitnessstudio';

  @override
  String get voiceExample => 'Zum Beispiel: „zwölf fünfzig, Mittagessen“';

  @override
  String get voiceTitleListening => 'Ich höre zu';

  @override
  String get voiceTitleHeard => 'Verstanden';

  @override
  String get voiceTitleFailed => 'Nicht verstanden';

  @override
  String get voiceStop => 'Stopp';

  @override
  String get voiceRetry => 'Nochmal';

  @override
  String heroUntil(String date) {
    return 'Bis $date';
  }

  @override
  String get goalIcon => 'Symbol';

  @override
  String get payGaugeToLast => 'Muss reichen';

  @override
  String get payGaugeNextPay => 'Nächstes Gehalt';
}
