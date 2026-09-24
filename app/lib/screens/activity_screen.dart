/// Activity — what you recorded, and the way to correct it (§15, §21).
///
/// A removed entry stays on the list, dimmed. This product's whole claim is
/// that it never quietly changes what it told you, and silently erasing a
/// line the user once saw would break that in the smallest, most damaging
/// way.
library;

import 'dart:io';

import 'package:flutter/material.dart';

import '../data/receipt_store.dart';
import '../domain/category.dart';
import '../design/motion.dart';
import '../design/parts.dart';
import '../design/theme.dart';
import '../design/icon.dart';
import '../design/tokens.dart';
import '../engine/money.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../domain/account.dart';
import '../domain/goal.dart';
import '../domain/recovery.dart';
import '../widgets/choice_sheet.dart';
import '../widgets/month_review.dart';
import '../widgets/amount_sheet.dart'
    show AmountSheet, CategoryChips, categoryLabel;

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({required this.state, required this.padding, super.key});

  final AppState state;
  final EdgeInsets padding;

  Future<void> _confirmRemoval(
    BuildContext context,
    ActivityEntry entry,
  ) async {
    final isSpend = entry.kind == ActivityKind.spend ||
        entry.kind == ActivityKind.cardPurchase;
    final action = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RemoveSheet(
        entry: entry,
        recovery: isSpend ? state.recoveryFor(entry.eventId) : null,
        canRecover: isSpend,
        category: state.categoryFor(entry.eventId),
        onCategory: entry.kind == ActivityKind.spend
            ? (c) => state.setCategory(
                  entry.eventId,
                  c == state.categoryFor(entry.eventId) ? null : c,
                )
            : null,
      ),
    );
    if (action == null || !context.mounted) return;
    switch (action) {
      case 'remove':
        state.removeEvent(entry.eventId);
      case 'returnable':
        state.markReturnable(entry.eventId);
      case 'expect':
        state.expectRefund(entry.eventId);
      case 'kept':
        state.closeRecovery(entry.eventId);
      case 'arrived':
        await _refundArrived(context, entry);
    }
  }

  /// The refund came: how much, and then where it goes, on purpose (§11.2).
  Future<void> _refundArrived(BuildContext context, ActivityEntry entry) async {
    final l = AppLocalizations.of(context);
    final amount = await AmountSheet.show(
      context,
      currency: state.currency,
      title: l.recoverArrived,
      initial: state.recoveryFor(entry.eventId)?.expected ?? entry.amount,
    );
    if (amount == null || !context.mounted) return;
    state.refundArrived(entry.eventId, amount.amount);
    final goals =
        state.goals.where((g) => g.kind != GoalKind.paused && !g.isComplete);
    final where = await ChoiceSheet.show<String>(
      context,
      title: l.recoverWhere(amount.amount.display()),
      choices: [
        for (final g in goals) Choice('goal:${g.id}', l.recoverToGoal(g.name)),
        Choice('buffer', l.recoverToBuffer),
        Choice('leave', l.recoverLeave),
      ],
    );
    if (where == null || where == 'leave') return;
    state.putRecoveredToward(
      goalId: where.startsWith('goal:') ? where.substring(5) : null,
      buffer: where == 'buffer',
      amount: amount.amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final entries = state.activity;
    final spending = state.spendingByCategory();
    final review = state.monthReview;

    return ListView(
      padding: padding,
      children: revealed([
        // The page's name is in the capsule above.
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 14),
          child: Text(
            entries.isEmpty ? l.activityBlurbEmpty : l.activityBlurb,
            style: theme.textTheme.bodySmall,
          ),
        ),
        // Only once something has been sorted: a card that says "Not sorted"
        // and nothing else tells the person nothing they did not know.
        // Once there is a month to look back on.
        if (review.ready) ...[
          MonthReviewCard(state: state),
          const SizedBox(height: 10),
        ],
        // Money on its way back is shown apart: it is not money yet.
        if (state.moneyComingBack.minor > 0) ...[
          UpinoCard(
            key: const Key('money-coming-back'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.recoverTitle, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  l.recoverTotal(state.moneyComingBack.display()),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        if (spending.any((r) => r.category != null)) ...[
          _WhereItWent(spending: spending),
          const SizedBox(height: 10),
        ],
        if (entries.isEmpty)
          UpinoCard(
            child: Text(
              l.activityEmpty,
              style: theme.textTheme.bodySmall,
            ),
          )
        else
          UpinoCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Column(
              children: [
                for (var i = 0; i < entries.length; i++) ...[
                  _ActivityRow(
                    entry: entries[i],
                    receipt: state.receiptFor(entries[i].eventId),
                    category: state.categoryFor(entries[i].eventId),
                    recovery: state.recoveryFor(entries[i].eventId),
                    from: state.accountOf(entries[i].eventId) == Account.mainId
                        ? null
                        : state.account(state.accountOf(entries[i].eventId))
                            ?.name,
                    onRemove: entries[i].removed
                        ? null
                        : () => _confirmRemoval(context, entries[i]),
                  ),
                  if (i != entries.length - 1)
                    Divider(height: 1, color: borderColor(context)),
                ],
              ],
            ),
          ),
      ]),
    );
  }
}

/// The state layer names the kind; the language belongs here.
String labelFor(AppLocalizations l, ActivityKind kind) => switch (kind) {
      ActivityKind.spend => l.activitySpent,
      ActivityKind.cardPurchase => l.activityCardPurchase,
      ActivityKind.cardPayment => l.activityCardPayment,
      ActivityKind.income => l.activityIncome,
      ActivityKind.refund => l.activityRefund,
      ActivityKind.transfer => l.activityTransfer,
      ActivityKind.loan => l.activityLoan,
      ActivityKind.debtPayment => l.activityDebtPayment,
      ActivityKind.balanceCorrected => l.activityBalanceCorrected,
    };

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.entry,
    required this.receipt,
    required this.onRemove,
    this.category,
    this.recovery,
    this.from,
  });

  final ActivityEntry entry;
  final SpendCategory? category;
  final Recovery? recovery;

  /// The account it was paid from, when not the main one.
  final String? from;

  /// A photograph taken when the spend was recorded, if there was one.
  final String? receipt;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final dimmed = entry.removed;
    final muted = isDark(context)
        ? UpinoTokens.darkTextTertiary
        : UpinoTokens.textTertiary;

    return InkWell(
      onTap: onRemove,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  if (receipt != null) ...[
                    _ReceiptThumb(name: receipt!),
                    const SizedBox(width: 10),
                  ],
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          labelFor(l, entry.kind),
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: dimmed ? muted : null),
                        ),
                        if (category != null ||
                            from != null ||
                            recovery != null)
                          Text(
                            [
                              if (category != null) categoryLabel(l, category),
                              if (from != null) from!,
                              if (recovery != null)
                                recoveryLabel(l, recovery!.state),
                            ].join(UpinoTokens.separator),
                            style: theme.textTheme.bodySmall
                                ?.copyWith(fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  if (dimmed) ...[
                    const SizedBox(width: 8),
                    UpinoBadge(
                      l.activityRemoved,
                      background: sunkenColor(context),
                      foreground: muted,
                    ),
                  ],
                ],
              ),
            ),
            Text(
              '${entry.increasesMoney ? '+' : '−'}${entry.amount.display()}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: dimmed ? muted : null,
                decoration: dimmed ? TextDecoration.lineThrough : null,
                fontFeatures: moneyFeatures,
              ),
            ),
            if (onRemove != null) ...[
              const SizedBox(width: 10),
              UpinoIcon('more', size: 20, color: muted),
            ],
          ],
        ),
      ),
    );
  }
}

String recoveryLabel(AppLocalizations l, RecoveryState s) => switch (s) {
      RecoveryState.returnable => l.recoverReturnable,
      RecoveryState.returned ||
      RecoveryState.refundPending =>
        l.recoverPending,
      RecoveryState.refunded => l.recoverRefunded,
      RecoveryState.closed => l.recoverKept,
    };

class _RemoveSheet extends StatefulWidget {
  const _RemoveSheet({
    required this.entry,
    this.category,
    this.onCategory,
    this.recovery,
    this.canRecover = false,
  });

  final ActivityEntry entry;
  final Recovery? recovery;
  final bool canRecover;
  final SpendCategory? category;

  /// Null for anything that is not a spend, which has no category to give.
  final ValueChanged<SpendCategory>? onCategory;

  @override
  State<_RemoveSheet> createState() => _RemoveSheetState();
}

class _RemoveSheetState extends State<_RemoveSheet> {
  late SpendCategory? _category = widget.category;

  ActivityEntry get entry => widget.entry;

  /// What can happen next, given where the purchase is in getting its
  /// money back.
  List<(String, String)> _recoveryActions(AppLocalizations l) =>
      switch (widget.recovery?.state) {
        null || RecoveryState.closed => [
            ('returnable', l.recoverReturnable),
            ('expect', l.recoverExpect),
          ],
        RecoveryState.returnable => [
            ('expect', l.recoverExpect),
            ('kept', l.recoverKept),
          ],
        RecoveryState.returned || RecoveryState.refundPending => [
            ('arrived', l.recoverArrived),
            ('kept', l.recoverKept),
          ],
        RecoveryState.refunded => [],
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
      decoration: BoxDecoration(
        color: isDark(context)
            ? UpinoTokens.darkSurfaceRaised
            : UpinoTokens.surfaceRaised,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(UpinoTokens.radiusHero),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: borderColor(context),
                  borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              l.activityRemoveAmount(entry.amount.display()),
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              l.activityRemoveDetail,
              style: theme.textTheme.bodySmall,
            ),
            if (widget.onCategory != null) ...[
              const SizedBox(height: 18),
              Text(l.categoryPrompt, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              CategoryChips(
                selected: _category,
                onSelect: (c) {
                  widget.onCategory!(c);
                  setState(() => _category = c == _category ? null : c);
                },
              ),
            ],
            if (widget.canRecover && !entry.removed) ...[
              const SizedBox(height: 18),
              Text(l.recoverPrompt, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (action, label) in _recoveryActions(l))
                    ActionChip(
                      key: Key('recover-$action'),
                      label: Text(label),
                      onPressed: () => Navigator.of(context).pop(action),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.of(context).pop('remove'),
              child: Text(l.activityRemoveIt),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child:
                    Text(l.activityKeepIt, style: theme.textTheme.titleMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A receipt on the row it belongs to, opening full screen on a tap. The
/// photograph stays with the entry even once it is removed: §21 says a
/// correction adds to the record rather than erasing it.
class _ReceiptThumb extends StatelessWidget {
  const _ReceiptThumb({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) => FutureBuilder<File?>(
        future: const ReceiptStore().file(name),
        builder: (context, snap) {
          final file = snap.data;
          if (file == null) return const SizedBox.shrink();
          return GestureDetector(
            key: Key('receipt-thumb-$name'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => _ReceiptView(file: file),
              ),
            ),
            child: Container(
              width: 30,
              height: 30,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: sunkenColor(context),
              ),
              child: Image.file(file, fit: BoxFit.cover),
            ),
          );
        },
      );
}

class _ReceiptView extends StatelessWidget {
  const _ReceiptView({required this.file});

  final File file;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            AppLocalizations.of(context).receipt,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: InteractiveViewer(
            maxScale: 5,
            child: Image.file(file),
          ),
        ),
      );
}

/// Where the money went, as bars rather than a pie: lengths compare at a
/// glance and the amounts sit beside them, never abbreviated (§32.8).
class _WhereItWent extends StatelessWidget {
  const _WhereItWent({required this.spending});

  final List<({SpendCategory? category, Money total})> spending;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final dark = isDark(context);
    final largest = spending.first.total.minor;
    final bar = dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
    return UpinoCard(
      key: const Key('where-it-went'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.spendingTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(l.spendingWindow, style: theme.textTheme.bodySmall),
          const SizedBox(height: 14),
          for (final row in spending) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    categoryLabel(l, row.category),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Text(
                  row.total.display(),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontFeatures: moneyFeatures),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
              child: LinearProgressIndicator(
                value: largest <= 0 ? 0 : row.total.minor / largest,
                minHeight: 6,
                backgroundColor: sunkenColor(context),
                color: row.category == null
                    ? UpinoTokens.textTertiary
                    : bar,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
