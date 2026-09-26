/// A short list of things that can be done with one item — a bill, an
/// account, a purchase — rising from the bottom like every other question
/// the app asks.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/tokens.dart';

class Choice<T> {
  const Choice(this.value, this.label, {this.detail, this.destructive = false});
  final T value;
  final String label;
  final String? detail;
  final bool destructive;
}

class ChoiceSheet<T> extends StatelessWidget {
  const ChoiceSheet({
    required this.title,
    required this.choices,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<Choice<T>> choices;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    String? subtitle,
    required List<Choice<T>> choices,
  }) =>
      showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) =>
            ChoiceSheet<T>(title: title, subtitle: subtitle, choices: choices),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = isDark(context);
    final critical = dark ? UpinoTokens.darkCritical : UpinoTokens.critical;
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
      decoration: BoxDecoration(
        color: dark ? UpinoTokens.darkSurfaceRaised : UpinoTokens.surfaceRaised,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(UpinoTokens.radiusHero),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Text(title, style: theme.textTheme.headlineMedium),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(subtitle!, style: theme.textTheme.bodySmall),
              ],
              const SizedBox(height: 16),
              for (final c in choices) ...[
                Material(
                  color: sunkenColor(context),
                  borderRadius: BorderRadius.circular(UpinoTokens.radiusInner),
                  child: InkWell(
                    key: Key('choice-${c.value}'),
                    borderRadius:
                        BorderRadius.circular(UpinoTokens.radiusInner),
                    onTap: () => Navigator.of(context).pop(c.value),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.label,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: c.destructive ? critical : null,
                            ),
                          ),
                          if (c.detail != null) ...[
                            const SizedBox(height: 2),
                            Text(c.detail!, style: theme.textTheme.bodySmall),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
