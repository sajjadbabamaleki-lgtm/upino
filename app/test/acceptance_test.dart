// Acceptance Test Vectors, §24 of Upino Product Foundation v3.5.
//
// This is the same fixture table the TypeScript engine runs. Both
// implementations must agree on every row; the table is the contract.

import 'package:test/test.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/domain.dart';
import 'package:upino/engine/ledger.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/engine/plan.dart';

const eurCode = 'EUR';
const bank = 'bank';
const savings = 'savings';
const visa = 'visa';
const loan = 'loan';

/// 2026-10-01 12:00 local, Europe/Amsterdam (CEST, UTC+2).
final now = DateTime.utc(2026, 10, 1, 10);
const cest = Duration(hours: 2);

final today = LocalDate.parse('2026-10-01');
final tomorrow = LocalDate.parse('2026-10-02');
final dayAfter = LocalDate.parse('2026-10-03');
final yesterday = LocalDate.parse('2026-09-30');

Money eur(String v) => Money.parse(v, eurCode);

var _seq = 0;
String ev() => 'e${++_seq}';

Claim claim(
  String id,
  Priority priority,
  String amount, {
  LocalDate? dueDate,
  Reservation? reservation,
}) =>
    Claim(
      id: id,
      priority: priority,
      label: id,
      amount: eur(amount),
      dueDate: dueDate,
      reservation: reservation,
    );

Claim reservedClaim(String id, Priority priority, String amount) =>
    claim(id, priority, amount, reservation: Reservation(eur(amount)));

IncomeEvent income(String amount, LocalDate date, IncomeState state) => IncomeEvent(
      id: 'inc-$date-$state',
      expectedAmount: eur(amount),
      expectedDate: date,
      state: state,
    );

PlanSnapshot plan({
  Map<String, Money>? openingBalances,
  List<LedgerEvent> events = const [],
  List<Claim> claims = const [],
  List<IncomeEvent> incomeEvents = const [],
  List<CardTerms> cards = const [],
  List<String> includedAccounts = const [bank],
  DateTime? at,
  DateTime? oldestConfirmationAt,
  bool materialIntegrityIssue = false,
}) =>
    computePlan(PlanInput(
      currency: eurCode,
      now: at ?? now,
      utcOffset: cest,
      includedAccounts: includedAccounts,
      openingBalances: openingBalances,
      events: events,
      claims: claims,
      incomeEvents: incomeEvents,
      cards: cards,
      oldestConfirmationAt: oldestConfirmationAt,
      materialIntegrityIssue: materialIntegrityIssue,
    ),);

Money allocatedAt(PlanSnapshot s, Priority p) => Money.sum(
      s.allocations.where((a) => a.priority == p).map((a) => a.allocated),
      eurCode,
    );

Money shortfallAt(PlanSnapshot s, Priority p) => Money.sum(
      s.allocations.where((a) => a.priority == p).map((a) => a.shortfall),
      eurCode,
    );

Map<String, Money> opening(Map<String, String> m) =>
    m.map((k, v) => MapEntry(k, eur(v)));

void main() {
  group('§24 Acceptance Test Vectors', () {
    test('T01 — confirmed salary + rent', () {
      final s = plan(
        openingBalances: opening({bank: '3000.00'}),
        claims: [claim('rent', Priority.p2HardObligation, '1200.00')],
        incomeEvents: [income('3000.00', yesterday, IncomeState.confirmed)],
      );
      expect(allocatedAt(s, Priority.p2HardObligation).toString(), '1200.00 EUR');
      expect(s.safeToSpendNow.toString(), '1800.00 EUR');
      expect(s.mandatoryFundingGap.toString(), '0.00 EUR');
      expect(s.reasonCodes, contains(ReasonCode.incomeConfirmed));
    });

    test('T02 — expected income is excluded from the now figure', () {
      final s = plan(
        openingBalances: opening({bank: '400.00'}),
        incomeEvents: [income('3000.00', tomorrow, IncomeState.expected)],
      );
      expect(s.safeToSpendNow.toString(), '400.00 EUR');
      expect(s.projectedSafeToSpend.toString(), '3400.00 EUR');
      expect(s.mandatoryFundingGap.toString(), '0.00 EUR');
    });

    test('T03 — income late', () {
      final s = plan(
        openingBalances: opening({bank: '400.00'}),
        incomeEvents: [income('3000.00', yesterday, IncomeState.expected)],
      );
      expect(s.safeToSpendNow.toString(), '400.00 EUR');
      expect(s.reasonCodes, contains(ReasonCode.incomeLate));
    });

    test('T04 — short salary produces a mandatory gap', () {
      final s = plan(
        events: [IncomeConfirmedEvent(id: ev(), accountId: bank, amount: eur('2600.00'))],
        claims: [
          claim('rent', Priority.p2HardObligation, '1800.00'),
          claim('essentials', Priority.p4EssentialLiving, '600.00'),
          claim('catchup', Priority.p5SinkingCatchup, '400.00'),
        ],
      );
      expect(allocatedAt(s, Priority.p2HardObligation).toString(), '1800.00 EUR');
      expect(allocatedAt(s, Priority.p4EssentialLiving).toString(), '600.00 EUR');
      expect(allocatedAt(s, Priority.p5SinkingCatchup).toString(), '200.00 EUR');
      expect(s.safeToSpendNow.toString(), '0.00 EUR');
      expect(s.mandatoryFundingGap.toString(), '200.00 EUR');
      expect(s.reasonCodes, contains(ReasonCode.fundingGap));
    });

    test('T05 — higher salary follows the waterfall', () {
      final s = plan(
        events: [IncomeConfirmedEvent(id: ev(), accountId: bank, amount: eur('3300.00'))],
        claims: [
          claim('rent', Priority.p2HardObligation, '1800.00'),
          claim('essentials', Priority.p4EssentialLiving, '600.00'),
          claim('catchup', Priority.p5SinkingCatchup, '200.00'),
          claim('buffer', Priority.p6Buffer, '300.00'),
          claim('goal', Priority.p7HardGoal, '200.00'),
        ],
      );
      expect(allocatedAt(s, Priority.p6Buffer).toString(), '300.00 EUR');
      expect(allocatedAt(s, Priority.p7HardGoal).toString(), '200.00 EUR');
      expect(s.safeToSpendNow.toString(), '200.00 EUR');
      expect(s.mandatoryFundingGap.toString(), '0.00 EUR');
    });

    test('T06 — a reserved claim paid does not reduce Safe-to-Spend twice', () {
      final before = plan(
        openingBalances: opening({bank: '3000.00'}),
        claims: [reservedClaim('rent', Priority.p2HardObligation, '1200.00')],
      );
      expect(before.safeToSpendNow.toString(), '1800.00 EUR');

      final paid = Reservation(eur('1200.00')).settle(eur('1200.00'));
      expect(paid.state, ReservationState.paid);

      final after = plan(
        openingBalances: opening({bank: '3000.00'}),
        events: [ExpenseEvent(id: ev(), accountId: bank, amount: eur('1200.00'))],
        claims: [
          claim('rent', Priority.p2HardObligation, '1200.00', reservation: paid),
        ],
      );
      expect(after.trustedAllocatableLiquidity.toString(), '1800.00 EUR');
      expect(after.safeToSpendNow.toString(), '1800.00 EUR');
      expect(after.reasonCodes, contains(ReasonCode.reservationConsumed));
    });

    test('T07 — partial payment consumes the reservation proportionally', () {
      final partial = Reservation(eur('500.00')).settle(eur('300.00'));
      expect(partial.state, ReservationState.reserved);

      final s = plan(
        openingBalances: opening({bank: '1000.00'}),
        events: [ExpenseEvent(id: ev(), accountId: bank, amount: eur('300.00'))],
        claims: [
          claim('bill', Priority.p2HardObligation, '500.00', reservation: partial),
        ],
      );
      expect(s.trustedAllocatableLiquidity.toString(), '700.00 EUR');
      expect(allocatedAt(s, Priority.p2HardObligation).toString(), '200.00 EUR');
      expect(s.safeToSpendNow.toString(), '500.00 EUR');
    });

    test('T08 — cancelling a claim releases its reserve', () {
      final before = plan(
        openingBalances: opening({bank: '1000.00'}),
        claims: [reservedClaim('subscription', Priority.p2HardObligation, '200.00')],
      );
      expect(before.safeToSpendNow.toString(), '800.00 EUR');

      final after = plan(
        openingBalances: opening({bank: '1000.00'}),
        claims: [
          claim('subscription', Priority.p2HardObligation, '200.00',
              reservation: Reservation(eur('200.00')).release(),),
        ],
      );
      expect(after.safeToSpendNow.toString(), '1000.00 EUR');
    });

    test('T09 — a card purchase reserves its full outstanding amount', () {
      final s = plan(
        openingBalances: opening({bank: '1000.00'}),
        events: [CardPurchaseEvent(id: ev(), cardId: visa, amount: eur('100.00'))],
        cards: const [CardTerms(id: visa)],
      );
      expect(s.ledger.cardOutstanding[visa].toString(), '100.00 EUR');
      expect(s.ledger.cumulativeSpending.toString(), '100.00 EUR');
      expect(allocatedAt(s, Priority.p3CardSpendReserve).toString(), '100.00 EUR');
      expect(s.safeToSpendNow.toString(), '900.00 EUR');
    });

    test('T10 — settlement consumes the reserve and is not a second expense', () {
      final s = plan(
        openingBalances: opening({bank: '1000.00'}),
        events: [
          CardPurchaseEvent(id: ev(), cardId: visa, amount: eur('100.00')),
          CardSettlementEvent(
              id: ev(), accountId: bank, cardId: visa, amount: eur('100.00'),),
        ],
        cards: const [CardTerms(id: visa)],
      );
      expect(s.ledger.balances[bank].toString(), '900.00 EUR');
      expect(s.ledger.cardOutstanding[visa].toString(), '0.00 EUR');
      expect(s.ledger.cumulativeSpending.toString(), '100.00 EUR');
      expect(s.safeToSpendNow.toString(), '900.00 EUR');
    });

    test('T11 — protection reaches past payday for a hard claim income cannot cover', () {
      final s = plan(
        openingBalances: opening({bank: '500.00'}),
        incomeEvents: [income('1000.00', tomorrow, IncomeState.expected)],
        claims: [
          claim('bill', Priority.p2HardObligation, '1200.00', dueDate: dayAfter),
        ],
      );
      expect(allocatedAt(s, Priority.p2HardObligation).toString(), '200.00 EUR');
      expect(s.safeToSpendNow.toString(), '300.00 EUR');
      expect(s.decisionHorizonEnd, tomorrow);
      expect(s.protectionHorizonEnd, dayAfter);
      expect(s.reasonCodes, contains(ReasonCode.protectionHorizonExtended));
    });

    test('T12 — a due date turns overdue at local midnight, with no UTC drift', () {
      final dueOct1 = LocalDate.parse('2026-10-01');
      final claims = [
        claim('bill', Priority.p2HardObligation, '200.00', dueDate: dueOct1),
      ];

      // 23:59 local on 1 October, and 00:00 local on 2 October — which is
      // still 1 October in UTC.
      final justBefore = DateTime.utc(2026, 10, 1, 21, 59);
      final atMidnight = DateTime.utc(2026, 10, 1, 22);

      expect(LocalDate.at(justBefore, cest).toString(), '2026-10-01');
      expect(LocalDate.at(atMidnight, cest).toString(), '2026-10-02');
      expect(atMidnight.toIso8601String().substring(0, 10), '2026-10-01');

      final before = plan(
        openingBalances: opening({bank: '1000.00'}),
        claims: claims,
        at: justBefore,
      );
      expect(before.allocations.first.priority, Priority.p2HardObligation);
      expect(before.reasonCodes, isNot(contains(ReasonCode.overdueHardClaim)));

      final after = plan(
        openingBalances: opening({bank: '1000.00'}),
        claims: claims,
        at: atMidnight,
      );
      expect(after.allocations.first.priority, Priority.p1OverdueHard);
      expect(
        after.allocations.where((a) => a.priority == Priority.p1OverdueHard).length,
        1,
      );
      expect(after.reasonCodes, contains(ReasonCode.overdueHardClaim));
    });

    test('T13 — a contractual debt minimum is a P2 hard claim', () {
      final s = plan(
        openingBalances: opening({bank: '500.00'}),
        claims: [claim('card-minimum', Priority.p2HardObligation, '150.00')],
      );
      expect(s.safeToSpendNow.toString(), '350.00 EUR');
      expect(s.mandatoryFundingGap.toString(), '0.00 EUR');
    });

    test('T14 — an overdue hard claim is elevated to P1', () {
      final s = plan(
        openingBalances: opening({bank: '500.00'}),
        claims: [
          claim('installment', Priority.p2HardObligation, '150.00', dueDate: yesterday),
        ],
      );
      expect(allocatedAt(s, Priority.p1OverdueHard).toString(), '150.00 EUR');
      expect(s.safeToSpendNow.toString(), '350.00 EUR');
      expect(s.reasonCodes, contains(ReasonCode.overdueHardClaim));
    });

    test('T15 — loan principal raises cash and debt but is not income', () {
      final s = plan(
        openingBalances: opening({bank: '500.00'}),
        events: [
          LoanDrawdownEvent(
              id: ev(), accountId: bank, debtId: loan, amount: eur('2000.00'),),
        ],
      );
      expect(s.trustedAllocatableLiquidity.toString(), '2500.00 EUR');
      expect(s.ledger.debtPrincipal[loan].toString(), '2000.00 EUR');
      expect(s.ledger.cumulativeIncome.toString(), '0.00 EUR');
    });

    test('T16 — an own-account transfer moves liquidity without spending it', () {
      final s = plan(
        includedAccounts: const [bank, savings],
        openingBalances: opening({bank: '1000.00', savings: '500.00'}),
        events: [
          TransferEvent(
              id: ev(),
              fromAccountId: bank,
              toAccountId: savings,
              amount: eur('500.00'),),
        ],
      );
      expect(s.trustedAllocatableLiquidity.toString(), '1500.00 EUR');
      expect(s.ledger.cumulativeSpending.toString(), '0.00 EUR');
      expect(s.safeToSpendNow.toString(), '1500.00 EUR');
    });

    test('T17 — a linked refund reverses the economic expense', () {
      final purchase = ev();
      final s = plan(
        openingBalances: opening({bank: '1000.00'}),
        events: [
          ExpenseEvent(id: purchase, accountId: bank, amount: eur('80.00')),
          RefundEvent(
              id: ev(),
              accountId: bank,
              amount: eur('80.00'),
              linkedExpenseId: purchase,),
        ],
      );
      expect(s.trustedAllocatableLiquidity.toString(), '1000.00 EUR');
      expect(s.ledger.cumulativeSpending.toString(), '0.00 EUR');
    });

    test('T18 — a duplicate import affects the engine once', () {
      const canonical = 'merchant-42';
      final s = plan(
        openingBalances: opening({bank: '1000.00'}),
        events: [
          ExpenseEvent(
              id: ev(), accountId: bank, amount: eur('40.00'), canonicalId: canonical,),
          ExpenseEvent(
              id: ev(), accountId: bank, amount: eur('40.00'), canonicalId: canonical,),
        ],
      );
      expect(s.ledger.cumulativeSpending.toString(), '40.00 EUR');
      expect(s.safeToSpendNow.toString(), '960.00 EUR');
      expect(s.ledger.quarantined.length, 1);
      expect(s.reasonCodes, contains(ReasonCode.duplicateHold));
    });

    test('T19 — an annual fund requires an even contribution per cycle', () {
      expect(requiredContribution(eur('1200.00'), 12).toString(), '100.00 EUR');
    });

    test('T20 — a missed cycle re-spreads with the residual in the final cycle', () {
      final schedule = contributionSchedule(eur('1200.00'), 11);
      expect(schedule.length, 11);
      expect(
        schedule.take(10).map((m) => m.toString()).toList(),
        List.filled(10, '109.09 EUR'),
      );
      expect(schedule.last.toString(), '109.10 EUR');
      expect(
        schedule.fold<int>(0, (a, m) => a + m.minor),
        eur('1200.00').minor,
      );
    });

    test('T21 — essentials outrank the buffer; a buffer shortfall is not a gap', () {
      final s = plan(
        openingBalances: opening({bank: '700.00'}),
        claims: [
          claim('essentials', Priority.p4EssentialLiving, '500.00'),
          claim('buffer', Priority.p6Buffer, '500.00'),
        ],
      );
      expect(allocatedAt(s, Priority.p4EssentialLiving).toString(), '500.00 EUR');
      expect(allocatedAt(s, Priority.p6Buffer).toString(), '200.00 EUR');
      expect(s.safeToSpendNow.toString(), '0.00 EUR');
      expect(s.bufferShortfall.toString(), '300.00 EUR');
      expect(s.mandatoryFundingGap.toString(), '0.00 EUR');
    });

    test('T22 — a hard goal shortfall is mandatory and never silently moved', () {
      final s = plan(
        openingBalances: opening({bank: '900.00'}),
        claims: [
          claim('rent', Priority.p2HardObligation, '500.00'),
          claim('essentials', Priority.p4EssentialLiving, '300.00'),
          claim('goal', Priority.p7HardGoal, '300.00'),
        ],
      );
      expect(allocatedAt(s, Priority.p7HardGoal).toString(), '100.00 EUR');
      expect(s.safeToSpendNow.toString(), '0.00 EUR');
      expect(s.mandatoryFundingGap.toString(), '200.00 EUR');
      expect(s.reasonCodes, contains(ReasonCode.goalAtRisk));
    });

    test('T23 — a flexible goal yields without inflating the mandatory gap', () {
      final s = plan(
        openingBalances: opening({bank: '900.00'}),
        claims: [
          claim('rent', Priority.p2HardObligation, '500.00'),
          claim('essentials', Priority.p4EssentialLiving, '300.00'),
          claim('travel', Priority.p8Flexible, '300.00'),
        ],
      );
      expect(allocatedAt(s, Priority.p8Flexible).toString(), '100.00 EUR');
      expect(s.mandatoryFundingGap.toString(), '0.00 EUR');
      expect(s.flexibleShortfall.toString(), '200.00 EUR');
    });

    test('T24 — a disabled buffer claims nothing', () {
      final s = plan(openingBalances: opening({bank: '1000.00'}));
      expect(allocatedAt(s, Priority.p6Buffer).toString(), '0.00 EUR');
      expect(s.safeToSpendNow.toString(), '1000.00 EUR');
    });

    test('T25 — overspending squeezes essentials and surfaces the gap', () {
      final s = plan(
        openingBalances: opening({bank: '1000.00'}),
        events: [ExpenseEvent(id: ev(), accountId: bank, amount: eur('150.00'))],
        claims: [
          claim('rent', Priority.p2HardObligation, '600.00'),
          claim('essentials', Priority.p4EssentialLiving, '300.00'),
        ],
      );
      expect(s.trustedAllocatableLiquidity.toString(), '850.00 EUR');
      expect(allocatedAt(s, Priority.p4EssentialLiving).toString(), '250.00 EUR');
      expect(s.safeToSpendNow.toString(), '0.00 EUR');
      expect(s.mandatoryFundingGap.toString(), '50.00 EUR');
    });

    test('T26 — a foreign-currency expense keeps its original amount', () {
      // USD 100.00 at 0.90 → EUR 90.00, quantized half-even.
      final planningValue = Money(divideRoundHalfEven(10000 * 90, 100), eurCode);
      expect(planningValue.toString(), '90.00 EUR');
      expect(Money.parse('100.00', 'USD').toString(), '100.00 USD');

      final s = plan(
        openingBalances: opening({bank: '1000.00'}),
        events: [ExpenseEvent(id: ev(), accountId: bank, amount: planningValue)],
      );
      expect(s.trustedAllocatableLiquidity.toString(), '910.00 EUR');
    });

    test('T27 — an unlinked refund goes to review and degrades confidence', () {
      final s = plan(
        openingBalances: opening({bank: '900.00'}),
        events: [RefundEvent(id: ev(), accountId: bank, amount: eur('80.00'))],
      );
      expect(s.trustedAllocatableLiquidity.toString(), '900.00 EUR');
      expect(s.ledger.quarantined.first.reason, QuarantineReason.unlinkedRefund);
      expect(s.confidenceState, ConfidenceState.degraded);
    });

    test('T28 — a scenario never mutates live state', () {
      final claims = [claim('rent', Priority.p2HardObligation, '400.00')];
      final live = plan(openingBalances: opening({bank: '1000.00'}), claims: claims);
      expect(live.safeToSpendNow.toString(), '600.00 EUR');

      final scenario = plan(
        openingBalances: opening({bank: '1000.00'}),
        claims: claims,
        events: [ExpenseEvent(id: ev(), accountId: bank, amount: eur('500.00'))],
      );
      expect(scenario.safeToSpendNow.toString(), '100.00 EUR');

      final again = plan(openingBalances: opening({bank: '1000.00'}), claims: claims);
      expect(again.safeToSpendNow.toString(), '600.00 EUR');
    });

    test('T29 — a balance adjustment corrects liquidity without touching analytics', () {
      final s = plan(
        openingBalances: opening({bank: '2040.00'}),
        events: [
          BalanceAdjustmentEvent(
              id: ev(), accountId: bank, delta: eur('-200.00'), reason: 'observed',),
        ],
      );
      expect(s.trustedAllocatableLiquidity.toString(), '1840.00 EUR');
      expect(s.ledger.cumulativeSpending.toString(), '0.00 EUR');
    });

    test('T30 — balance freshness degrades after the trusted window', () {
      final s = plan(
        openingBalances: opening({bank: '1000.00'}),
        oldestConfirmationAt: now.subtract(const Duration(days: 8)),
      );
      expect(s.confidenceState, ConfidenceState.degraded);
      expect(s.safeToSpendNow.toString(), '1000.00 EUR');
    });

    test('T31 — stale balance evidence requires review', () {
      final s = plan(
        openingBalances: opening({bank: '1000.00'}),
        oldestConfirmationAt: now.subtract(const Duration(days: 22)),
      );
      expect(s.confidenceState, ConfidenceState.reviewRequired);
      expect(s.reasonCodes, contains(ReasonCode.balanceStale));
    });

    test('T32 — a discovered event supersedes its adjustment', () {
      final realPurchase = ev();
      final s = plan(
        openingBalances: opening({bank: '2040.00'}),
        events: [
          BalanceAdjustmentEvent(
            id: ev(),
            accountId: bank,
            delta: eur('-200.00'),
            reason: 'observed',
            supersededBy: realPurchase,
          ),
          ExpenseEvent(id: realPurchase, accountId: bank, amount: eur('200.00')),
        ],
      );
      expect(s.trustedAllocatableLiquidity.toString(), '1840.00 EUR');
      expect(s.ledger.cumulativeSpending.toString(), '200.00 EUR');
    });

    test('T33 — identical inputs and engine version produce identical output', () {
      PlanSnapshot build() => plan(
            openingBalances: opening({bank: '900.00'}),
            claims: [
              claim('rent', Priority.p2HardObligation, '500.00'),
              claim('essentials', Priority.p4EssentialLiving, '300.00'),
              claim('goal', Priority.p7HardGoal, '300.00'),
            ],
            incomeEvents: [income('2000.00', tomorrow, IncomeState.expected)],
          );
      final a = build();
      final b = build();
      expect(b.safeToSpendNow, a.safeToSpendNow);
      expect(b.mandatoryFundingGap, a.mandatoryFundingGap);
      expect(b.reasonCodes, a.reasonCodes);
      expect(b.confidenceState, a.confidenceState);
      expect(
        b.allocations.map((x) => '${x.claimId}:${x.allocated}').toList(),
        a.allocations.map((x) => '${x.claimId}:${x.allocated}').toList(),
      );
    });

    test('T34 — the card minimum overlapping the reserve is not reserved twice', () {
      final s = plan(
        openingBalances: opening({bank: '1000.00'}),
        events: [CardPurchaseEvent(id: ev(), cardId: visa, amount: eur('300.00'))],
        cards: [
          CardTerms(id: visa, minimumDue: eur('50.00'), paymentDueDate: tomorrow),
        ],
      );
      expect(allocatedAt(s, Priority.p3CardSpendReserve).toString(), '300.00 EUR');
      expect(allocatedAt(s, Priority.p2HardObligation).toString(), '0.00 EUR');
      expect(s.protectedTotal.toString(), '300.00 EUR');
      expect(s.safeToSpendNow.toString(), '700.00 EUR');
    });

    test('T35 — a card reserve larger than liquidity produces a mandatory gap', () {
      final s = plan(
        openingBalances: opening({bank: '200.00'}),
        events: [CardPurchaseEvent(id: ev(), cardId: visa, amount: eur('350.00'))],
        cards: const [CardTerms(id: visa)],
      );
      expect(allocatedAt(s, Priority.p3CardSpendReserve).toString(), '200.00 EUR');
      expect(shortfallAt(s, Priority.p3CardSpendReserve).toString(), '150.00 EUR');
      expect(s.safeToSpendNow.toString(), '0.00 EUR');
      expect(s.mandatoryFundingGap.toString(), '150.00 EUR');
      expect(s.reasonCodes, contains(ReasonCode.cardSpendFundingGap));
    });

    test('T36 — a funded buffer cannot hide an underfunded hard goal', () {
      final s = plan(
        openingBalances: opening({bank: '1000.00'}),
        claims: [
          claim('buffer', Priority.p6Buffer, '800.00'),
          claim('goal', Priority.p7HardGoal, '400.00'),
        ],
      );
      expect(allocatedAt(s, Priority.p6Buffer).toString(), '800.00 EUR');
      expect(allocatedAt(s, Priority.p7HardGoal).toString(), '200.00 EUR');
      expect(s.safeToSpendNow.toString(), '0.00 EUR');
      expect(s.mandatoryFundingGap.toString(), '200.00 EUR');
      expect(s.bufferShortfall.toString(), '0.00 EUR');
      expect(s.reasonCodes, contains(ReasonCode.goalAtRisk));
    });
  });
}
