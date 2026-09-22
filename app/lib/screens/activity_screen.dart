/// Activity — what you recorded, and the way to correct it (§15, §21).
///
/// A removed entry stays on the list, dimmed. This product's whole claim is
/// that it never quietly changes what it told you, and silently erasing a
/// line the user once saw would break that in the smallest, most damaging
/// way.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../state/app_state.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({required this.state, required this.padding, super.key});

  final AppState state;
  final EdgeInsets padding;

  Future<void> _confirmRemoval(BuildContext context, ActivityEntry entry) async {
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
    final entries = state.activity;

    return ListView(
      padding: padding,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Activity', style: theme.textTheme.headlineLarge),
              const SizedBox(height: 2),
              Text(
                entries.isEmpty
                    ? 'Nothing recorded yet.'
                    : 'Everything you have recorded, newest first.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        if (entries.isEmpty)
          UpinoCard(
            child: Text(
              'When you record a spend it will appear here, and you can '
              'remove it if you got it wrong.',
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
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.entry, required this.onRemove});

  final ActivityEntry entry;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  Flexible(
                    child: Text(
                      entry.label,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: dimmed ? muted : null),
                    ),
                  ),
                  if (dimmed) ...[
                    const SizedBox(width: 8),
                    UpinoBadge(
                      'Removed',
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
              Icon(Icons.more_horiz_rounded, size: 20, color: muted),
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
              'Remove ${entry.amount.display()}?',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'It stops counting toward your plan straight away. The entry '
              'stays on this list marked as removed, so your record is still '
              'complete.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remove it'),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Keep it', style: theme.textTheme.titleMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
