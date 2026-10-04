/// Adding and changing a bill or subscription (Strategy §11.1): what it is,
/// how much each time, how often, and when the next one falls.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/tokens.dart';
import '../domain/account.dart';
import '../domain/bill.dart';
import '../engine/clock.dart';
import '../engine/money.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../state/app_state.dart';
import 'form_parts.dart';

class BillDraft {
  const BillDraft({
    required this.name,
    required this.amount,
    required this.every,
    required this.nextDue,
    required this.kind,
    this.debtAccountId,
    this.deleted = false,
  });

  final String name;
  final Money amount;
  final BillEvery every;
  final LocalDate nextDue;
  final BillKind kind;
  final String? debtAccountId;
  final bool deleted;
}

String billEveryLabel(AppLocalizations l, BillEvery e) => switch (e) {
      BillEvery.week => l.billEveryWeek,
      BillEvery.month => l.billEveryMonth,
      BillEvery.quarter => l.billEveryQuarter,
      BillEvery.year => l.billEveryYear,
    };

/// "Today", "Tomorrow", "In 12 days", "3 days ago".
String relativeDay(AppLocalizations l, LocalDate day, LocalDate today) {
  final d = day.differenceInDays(today);
  if (d == 0) return l.dayToday;
  return d > 0 ? l.dayIn(d) : l.dayAgo(-d);
}

class BillEditorSheet extends StatefulWidget {
  const BillEditorSheet({required this.state, this.bill, super.key});

  final AppState state;
  final Bill? bill;

  static Future<BillDraft?> show(
    BuildContext context, {
    required AppState state,
    Bill? bill,
  }) =>
      showModalBottomSheet<BillDraft>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => BillEditorSheet(state: state, bill: bill),
      );

  @override
  State<BillEditorSheet> createState() => _BillEditorSheetState();
}

class _BillEditorSheetState extends State<BillEditorSheet> {
  late final _name = TextEditingController(text: widget.bill?.name ?? '');
  late final _amount = TextEditingController(
    text: widget.bill?.amount.display(withSymbol: false, grouped: false) ?? '',
  );
  late BillEvery _every = widget.bill?.every ?? BillEvery.month;
  late BillKind _kind = widget.bill?.kind ?? BillKind.bill;
  late String? _debt = widget.bill?.debtAccountId;
  late int _inDays = widget.bill == null
      ? 7
      : widget.bill!.nextDue.differenceInDays(widget.state.today);

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  Money? get _money => parseMoneyField(_amount.text, widget.state.currency);

  bool get _canSave => _name.text.trim().isNotEmpty && _money != null;

  BillDraft _draft({bool deleted = false}) => BillDraft(
        name: _name.text.trim(),
        amount: _money ?? widget.bill!.amount,
        every: _every,
        nextDue: widget.state.today.addDays(_inDays),
        kind: _kind,
        debtAccountId: _debt,
        deleted: deleted,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final state = widget.state;
    final editing = widget.bill != null;
    final debts = state.accounts.where((a) => a.isDebt).toList();
    final due = state.today.addDays(_inDays);

    return EditorSheetFrame(
      title: editing ? l.billEditExisting : l.billEditNew,
      children: [
        FieldLabel(l.billName),
        SunkenField(
          child: TextField(
            key: const Key('bill-name'),
            controller: _name,
            onChanged: (_) => setState(() {}),
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
            decoration: plainInput(theme, l.billNameHint),
          ),
        ),
        const SizedBox(height: 16),
        FieldLabel(l.billAmount),
        MoneyField(
          key: const Key('bill-amount'),
          controller: _amount,
          currency: state.currency,
          hint: l.tapToType,
          onChanged: () => setState(() {}),
        ),
        const SizedBox(height: 16),
        FieldLabel(l.billEvery),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final e in BillEvery.values)
              PillChoice(
                key: Key('bill-every-${e.name}'),
                label: billEveryLabel(l, e),
                selected: _every == e,
                onTap: () => setState(() => _every = e),
              ),
          ],
        ),
        const SizedBox(height: 16),
        FieldLabel(l.billNext),
        // A stepper rather than a calendar: it shows the date in the
        // reader's own calendar, and the next payment is rarely far off.
        SunkenField(
          child: Row(
            children: [
              IconButton(
                key: const Key('bill-day-earlier'),
                onPressed: _inDays > -60
                    ? () => setState(() => _inDays--)
                    : null,
                icon: const Icon(Icons.remove),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      formatDate(context, due),
                      key: const Key('bill-due'),
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      relativeDay(l, due, state.today),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                key: const Key('bill-day-later'),
                onPressed: _inDays < 400
                    ? () => setState(() => _inDays++)
                    : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final (label, days) in [
              (l.dayToday, 0),
              (l.dayIn(7), 7),
              (l.dayIn(30), 30),
            ])
              ActionChip(
                label: Text(label),
                onPressed: () => setState(() => _inDays = days),
              ),
          ],
        ),
        const SizedBox(height: 16),
        FieldLabel(l.billKind),
        Wrap(
          spacing: 8,
          children: [
            for (final k in BillKind.values)
              PillChoice(
                key: Key('bill-kind-${k.name}'),
                label: k == BillKind.bill
                    ? l.billKindBill
                    : l.billKindSubscription,
                selected: _kind == k,
                onTap: () => setState(() => _kind = k),
              ),
          ],
        ),
        if (debts.isNotEmpty) ...[
          const SizedBox(height: 16),
          FieldLabel(l.billRepays),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              PillChoice(
                label: l.billRepaysNothing,
                selected: _debt == null,
                onTap: () => setState(() => _debt = null),
              ),
              for (final Account a in debts)
                PillChoice(
                  label: a.name,
                  selected: _debt == a.id,
                  onTap: () => setState(() => _debt = a.id),
                ),
            ],
          ),
        ],
        const SizedBox(height: 20),
        FilledButton(
          key: const Key('bill-save'),
          onPressed: _canSave ? () => Navigator.of(context).pop(_draft()) : null,
          child: Text(editing ? l.goalSaveChanges : l.billAddThis),
        ),
        if (editing) ...[
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              key: const Key('bill-delete'),
              onPressed: () =>
                  Navigator.of(context).pop(_draft(deleted: true)),
              child: Text(
                l.billDelete,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isDark(context)
                      ? UpinoTokens.darkCritical
                      : UpinoTokens.critical,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
