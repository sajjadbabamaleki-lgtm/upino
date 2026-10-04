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
  Widget build(BuildContext context) => UpinoCard(
        key: const Key('quick-actions'),
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < actions.length; i++) ...[
                Expanded(child: _Tile(action: actions[i])),
                if (i != actions.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: VerticalDivider(width: 1, thickness: 1, color: borderColor(context)),
                  ),
              ],
            ],
          ),
        ),
      );
}

class _Tile extends StatelessWidget {
  const _Tile({required this.action});

  final QuickAction action;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final ink = dark ? UpinoTokens.darkTextPrimary : UpinoTokens.actionOnTint;
    final critical = dark ? UpinoTokens.darkCritical : UpinoTokens.critical;

    final tile = Pressable(
      key: Key(action.keyName),
      onTap: action.onTap,
      scale: 0.94,
        child: SizedBox(
          height: 78,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Center(child: UpinoIcon(action.icon, size: 22, color: ink)),
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
                const SizedBox(height: 7),
                // Whatever height is left: a long label in a narrow tile
                // ends in an ellipsis rather than spilling out of the square.
                Flexible(
                  child: Text(
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
