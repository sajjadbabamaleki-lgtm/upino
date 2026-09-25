/// The first-run setup, as answered so far.
///
/// This is onboarding state, not financial state: nothing here is read by the
/// engine. It is kept (and saved after every step) so the flow can resume
/// where it was left and going back never loses an answer. Only
/// [AppState.completeSetup] turns it into income, bills, claims and goals,
/// and it rebuilds them from scratch each time, so finishing twice never
/// duplicates anything.
library;

import '../engine/clock.dart';
import '../engine/money.dart';

/// What the person most wants help with. Personalisation only: it never
/// changes what the engine protects.
enum SetupIntent {
  safeToSpend,
  stopRunningOut,
  buildSavings,
  payOffDebt,
  irregularCosts,
  reachGoal,
  understand,
}

enum PayRhythm { weekly, fortnightly, twiceMonthly, monthly, irregular }

extension PayRhythmDays on PayRhythm {
  /// Days in one pay period, as the engine's pay cycle.
  int get days => switch (this) {
        PayRhythm.weekly => 7,
        PayRhythm.fortnightly => 14,
        PayRhythm.twiceMonthly => 15,
        PayRhythm.monthly => 30,
        // Irregular income is planned as if monthly, on the amount the person
        // can count on; the income lifecycle (late, missed) still applies.
        PayRhythm.irregular => 30,
      };
}

enum ObligationKind {
  rent,
  utilities,
  loan,
  creditCard,
  insurance,
  subscriptions,
  other,
}

enum ProtectKind { emergency, trip, car, home, debt, annual, custom }

class SetupIncome {
  SetupIncome({this.amount, this.rhythm = PayRhythm.monthly, this.next});

  Money? amount;
  PayRhythm rhythm;
  LocalDate? next;

  bool get isComplete => amount != null && amount!.minor > 0 && next != null;

  Map<String, Object?> toJson() => {
        if (amount != null) 'amount': amount!.minor,
        'rhythm': rhythm.name,
        if (next != null) 'next': next.toString(),
      };

  static SetupIncome fromJson(Map<String, Object?> j, String currency) =>
      SetupIncome(
        amount:
            j['amount'] == null ? null : Money(j['amount']! as int, currency),
        rhythm: PayRhythm.values.byName(j['rhythm']! as String),
        next: j['next'] == null ? null : LocalDate.parse(j['next']! as String),
      );
}

class SetupObligation {
  SetupObligation({required this.kind, this.name, this.amount, this.due});

  final ObligationKind kind;
  String? name;
  Money? amount;
  LocalDate? due;

  bool get isComplete => amount != null && amount!.minor > 0 && due != null;

  Map<String, Object?> toJson() => {
        'kind': kind.name,
        if (name != null) 'name': name,
        if (amount != null) 'amount': amount!.minor,
        if (due != null) 'due': due.toString(),
      };

  static SetupObligation fromJson(Map<String, Object?> j, String currency) =>
      SetupObligation(
        kind: ObligationKind.values.byName(j['kind']! as String),
        name: j['name'] as String?,
        amount:
            j['amount'] == null ? null : Money(j['amount']! as int, currency),
        due: j['due'] == null ? null : LocalDate.parse(j['due']! as String),
      );
}

class SetupProtect {
  SetupProtect(
      {required this.kind, this.name, this.target, this.date, this.saved,});

  final ProtectKind kind;
  String? name;
  Money? target;
  LocalDate? date;
  Money? saved;

  bool get isComplete =>
      target != null &&
      target!.minor > 0 &&
      date != null &&
      (kind != ProtectKind.custom || (name?.trim().isNotEmpty ?? false));

  Map<String, Object?> toJson() => {
        'kind': kind.name,
        if (name != null) 'name': name,
        if (target != null) 'target': target!.minor,
        if (date != null) 'date': date.toString(),
        if (saved != null) 'saved': saved!.minor,
      };

  static SetupProtect fromJson(Map<String, Object?> j, String currency) =>
      SetupProtect(
        kind: ProtectKind.values.byName(j['kind']! as String),
        name: j['name'] as String?,
        target:
            j['target'] == null ? null : Money(j['target']! as int, currency),
        date: j['date'] == null ? null : LocalDate.parse(j['date']! as String),
        saved: j['saved'] == null ? null : Money(j['saved']! as int, currency),
      );
}

class SetupDraft {
  SetupDraft({required this.currency});

  String currency;

  /// The currency was picked here rather than assumed.
  bool currencyChosen = false;

  /// The step the person is on, 0–5, so a closed app reopens there.
  int step = 0;

  /// The first thing picked, which leads the personalisation.
  SetupIntent? intent;

  /// Everything picked, each with the one number its sheet asked for.
  Map<SetupIntent, Money> intents = {};
  List<SetupIncome> incomes = [SetupIncome()];
  Money? available;
  List<SetupObligation> obligations = [];

  /// "Nothing else" was chosen, which is an answer, not a skip.
  bool obligationsDone = false;
  Money? essentials;
  bool essentialsSkipped = false;
  SetupProtect? protect;
  bool protectSkipped = false;

  bool get incomeComplete => incomes.isNotEmpty && incomes.first.isComplete;

  Map<String, Object?> toJson() => {
        'currency': currency,
        'step': step,
        'currencyChosen': currencyChosen,
        if (intent != null) 'intent': intent!.name,
        'intents': {for (final e in intents.entries) e.key.name: e.value.minor},
        'incomes': [for (final i in incomes) i.toJson()],
        if (available != null) 'available': available!.minor,
        'obligations': [for (final o in obligations) o.toJson()],
        'obligationsDone': obligationsDone,
        if (essentials != null) 'essentials': essentials!.minor,
        'essentialsSkipped': essentialsSkipped,
        if (protect != null) 'protect': protect!.toJson(),
        'protectSkipped': protectSkipped,
      };

  static SetupDraft fromJson(Map<String, Object?> j) {
    final currency = j['currency']! as String;
    Money? m(Object? v) => v == null ? null : Money(v as int, currency);
    return SetupDraft(currency: currency)
      ..step = j['step'] as int? ?? 0
      ..currencyChosen = j['currencyChosen'] as bool? ?? false
      ..intent = j['intent'] == null
          ? null
          : SetupIntent.values.byName(j['intent']! as String)
      ..intents = {
        for (final e in ((j['intents'] as Map?) ?? const {}).entries)
          SetupIntent.values.byName(e.key as String): Money(e.value as int, currency),
      }
      ..incomes = [
        for (final i in (j['incomes'] as List? ?? const []))
          SetupIncome.fromJson((i as Map).cast<String, Object?>(), currency),
      ]
      ..available = m(j['available'])
      ..obligations = [
        for (final o in (j['obligations'] as List? ?? const []))
          SetupObligation.fromJson(
              (o as Map).cast<String, Object?>(), currency,),
      ]
      ..obligationsDone = j['obligationsDone'] as bool? ?? false
      ..essentials = m(j['essentials'])
      ..essentialsSkipped = j['essentialsSkipped'] as bool? ?? false
      ..protect = j['protect'] == null
          ? null
          : SetupProtect.fromJson(
              (j['protect']! as Map).cast<String, Object?>(),
              currency,
            )
      ..protectSkipped = j['protectSkipped'] as bool? ?? false;
  }
}
