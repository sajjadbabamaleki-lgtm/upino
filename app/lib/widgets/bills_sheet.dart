/// Bills and subscriptions in one place, from Home's quick menu: what is
/// due and when, paid or changed with a tap, and a new one added. The same
/// flows as on Plan, so a bill is handled one way wherever it is reached.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../domain/bill.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../state/app_state.dart';
import 'bill_editor_sheet.dart';
import 'choice_sheet.dart';
import 'form_parts.dart';

Future<void> addBillFlow(BuildContext context, AppState state) async {
  final draft = await BillEditorSheet.show(context, state: state);
  if (draft == null) return;
  state.addBill(
    name: draft.name,
    amount: draft.amount,
    every: draft.every,
    nextDue: draft.nextDue,
    kind: draft.kind,
    debtAccountId: draft.debtAccountId,
  );
}

Future<void> openBillFlow(
  BuildContext context,
  AppState state,
  Bill bill,
) async {
  final l = AppLocalizations.of(context);
  final choice = await ChoiceSheet.show<String>(
    context,
    title: bill.name,
    subtitle: '${bill.amount.display()}${UpinoTokens.separator}'
        '${billEveryLabel(l, bill.every)}',
    choices: [
      Choice('pay', l.billPay, detail: formatDate(context, bill.nextDue)),
      Choice('edit', l.billEdit),
    ],
  );
  if (choice == null || !context.mounted) return;
  if (choice == 'pay') {
    state.payBill(bill.id);
    return;
  }
  final draft = await BillEditorSheet.show(context, state: state, bill: bill);
  if (draft == null) return;
  if (draft.deleted) {
    state.removeBill(bill.id);
    return;
  }
  state.updateBill(
    bill.id,
    name: draft.name,
    amount: draft.amount,
    every: draft.every,
    nextDue: draft.nextDue,
    kind: draft.kind,
  );
}

class BillsSheet extends StatelessWidget {
  const BillsSheet({required this.state, super.key});

  final AppState state;

  static Future<void> show(BuildContext context, AppState state) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => BillsSheet(state: state),
      );

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: state,
        builder: (context, _) {
          final theme = Theme.of(context);
          final l = AppLocalizations.of(context);
          final bills = state.bills;
          final critical =
              isDark(context) ? UpinoTokens.darkCritical : UpinoTokens.critical;
          return EditorSheetFrame(
            title: l.billsTitle,
            children: [
              Text(
                bills.isEmpty
                    ? l.billAddSub
                    : l.homeComingUpTotal(state.billsDueWithin().display()),
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 14),
              for (final bill in bills) ...[
                Material(
                  color: sunkenColor(context),
                  borderRadius: BorderRadius.circular(UpinoTokens.radiusInner),
                  child: InkWell(
                    key: Key('bills-sheet-${bill.id}'),
                    borderRadius:
                        BorderRadius.circular(UpinoTokens.radiusInner),
                    onTap: () => openBillFlow(context, state, bill),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bill.name,
                                  style: theme.textTheme.titleMedium,
                                ),
                                Text(
                                  bill.nextDue < state.today
                                      ? l.billOverdue(
                                          formatDate(context, bill.nextDue),
                                        )
                                      : '${formatDate(context, bill.nextDue)}'
                                          '${UpinoTokens.separator}'
                                          '${relativeDay(l, bill.nextDue, state.today)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: bill.nextDue < state.today
                                        ? critical
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            bill.amount.display(),
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontFeatures: moneyFeatures),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 6),
              FilledButton(
                key: const Key('bills-sheet-add'),
                onPressed: () => addBillFlow(context, state),
                child: Text(l.billAdd),
              ),
            ],
          );
        },
      );
}
