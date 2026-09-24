/// Four things reached from right under the figure, instead of being
/// buried in a tab or at the bottom of Home: ask, say the pay came, the
/// bills, and the month.
library;

import 'package:flutter/material.dart';

import '../design/icon.dart';
import '../design/parts.dart';
import '../design/tokens.dart';

class QuickAction {
  const QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.keyName,
    this.flagged = false,
    this.hint,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final String keyName;

  /// A dot on the tile: something here is waiting for the person.
  final bool flagged;

  /// Read out with the tile, and shown on long press.
  final String? hint;
}

class QuickActions extends StatelessWidget {
  const QuickActions({required this.actions, super.key});

  final List<QuickAction> actions;

  @override
  Widget build(BuildContext context) => Row(
        key: const Key('quick-actions'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < actions.length; i++) ...[
            Expanded(child: _Tile(action: actions[i])),
            if (i != actions.length - 1) const SizedBox(width: 10),
          ],
        ],
      );
}

class _Tile extends StatelessWidget {
  const _Tile({required this.action});

  final QuickAction action;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final tint = dark ? UpinoTokens.darkActionTint : UpinoTokens.actionTint;
    final ink = dark ? UpinoTokens.darkTextPrimary : UpinoTokens.actionOnTint;
    final critical = dark ? UpinoTokens.darkCritical : UpinoTokens.critical;

    final tile = Material(
      color: cardColor(context),
      borderRadius: BorderRadius.circular(UpinoTokens.radiusInner),
      child: InkWell(
        key: Key(action.keyName),
        borderRadius: BorderRadius.circular(UpinoTokens.radiusInner),
        onTap: action.onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 14, 6, 12),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tint,
                      shape: BoxShape.circle,
                    ),
                    child: UpinoIcon(action.icon, size: 21, color: ink),
                  ),
                  if (action.flagged)
                    PositionedDirectional(
                      top: -1,
                      end: -1,
                      child: Container(
                        key: Key('${action.keyName}-flag'),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: critical,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: cardColor(context),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                action.label,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
    final hint = action.hint;
    return Semantics(
      button: true,
      hint: hint,
      child: hint == null ? tile : Tooltip(message: hint, child: tile),
    );
  }
}
