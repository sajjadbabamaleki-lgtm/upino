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
import '../design/motion.dart';
import '../design/parts.dart';
import '../design/theme.dart';
import '../design/icon.dart';
import '../design/tokens.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({required this.state, required this.padding, super.key});

  final AppState state;
  final EdgeInsets padding;

  Future<void> _confirmRemoval(
    BuildContext context,
    ActivityEntry entry,
  ) async {
    final removed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _RemoveSheet(entry: entry),
    );
    if (removed ?? false) state.removeEvent(entry.eventId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final entries = state.activity;

    return ListView(
      padding: padding,
      children: revealed([
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.activityTitle, style: theme.textTheme.headlineLarge),
              const SizedBox(height: 2),
              Text(
                entries.isEmpty ? l.activityBlurbEmpty : l.activityBlurb,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
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
  });

  final ActivityEntry entry;

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
                    child: Text(
                      labelFor(l, entry.kind),
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: dimmed ? muted : null),
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

class _RemoveSheet extends StatelessWidget {
  const _RemoveSheet({required this.entry});

  final ActivityEntry entry;

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
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l.activityRemoveIt),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
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
