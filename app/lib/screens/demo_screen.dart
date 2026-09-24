/// The app with sample data (a copy, not the person's plan), under a band
/// that says so and a way out.
library;

import 'package:flutter/material.dart';

import '../design/tokens.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../state/demo.dart';
import 'home_screen.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({required this.from, super.key});

  /// The person's own plan, used only for its clock and zone.
  final AppState from;

  static Future<void> open(BuildContext context, AppState from) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => DemoScreen(from: from)),
      );

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  AppState? _demo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l = AppLocalizations.of(context);
    _demo ??= buildDemo(
      now: widget.from.now,
      utcOffset: widget.from.utcOffset,
      names: DemoNames(
        goals: [
          l.demoGoalTrip,
          l.demoGoalLaptop,
          l.demoGoalEmergency,
          l.demoGoalCar,
        ],
        bills: [l.demoBillPhone, l.demoBillInternet, l.demoBillGym],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      body: Column(
        children: [
          Container(
            key: const Key('demo-banner'),
            color: const Color(0xFFFFF3C4),
            padding: EdgeInsets.fromLTRB(18, top + 6, 8, 6),
            child: Row(
              children: [
                const Icon(
                  Icons.science_outlined,
                  size: 18,
                  color: Color(0xFF7A5B00),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.demoBanner,
                    style: const TextStyle(
                      color: Color(0xFF5A4300),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  key: const Key('demo-exit'),
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: UpinoTokens.textPrimary,
                  ),
                  child: Text(l.demoExit),
                ),
              ],
            ),
          ),
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: HomeScreen(state: _demo!),
            ),
          ),
        ],
      ),
    );
  }
}
