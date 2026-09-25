/// The six setup questions: the least the engine needs for a first
/// trustworthy Safe-to-Spend. Each step is one idea, answered mostly by
/// choosing; every answer is saved as it is given.
library;

import 'dart:math' as math;

import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../design/icon.dart';
import '../../design/parts.dart';
import '../../design/theme.dart';
import '../../engine/clock.dart';
import '../../engine/currencies.dart';
import '../../widgets/upino_sheet.dart';
import '../../engine/money.dart';
import '../../state/app_state.dart';
import '../../state/setup_draft.dart';
import '../currency_screen.dart';
import 'fr_parts.dart';

const _ease = Cubic(0.23, 1, 0.32, 1);

class SetupFlow extends StatefulWidget {
  const SetupFlow({required this.state, super.key});
  final AppState state;

  @override
  State<SetupFlow> createState() => _SetupFlowState();
}

class _SetupFlowState extends State<SetupFlow> {
  late final SetupDraft _d = widget.state.setupDraft;

  @override
  void initState() {
    super.initState();
    if (!_d.currencyChosen) _d.currency = _CurrencyStep.guess();
  }
  bool _forward = true;

  static const _steps = 7;

  void _changed() {
    setState(() {});
    widget.state.saveSetupDraft(_d);
  }

  void _go(int step) {
    FocusScope.of(context).unfocus();
    setState(() {
      _forward = step > _d.step;
      _d.step = step.clamp(0, _steps - 1);
    });
    widget.state.saveSetupDraft(_d);
  }

  void _finish() {
    FocusScope.of(context).unfocus();
    if (_d.protect == null) _d.protectSkipped = true;
    widget.state.completeSetup(_d);
  }

  LocalDate get _today => widget.state.today;

  /// The earliest next income, which bounds "before your next income".
  LocalDate get _horizon {
    final dates = [
      for (final i in _d.incomes)
        if (i.next != null) i.next!,
    ]..sort();
    return dates.isEmpty ? _today.addDays(30) : dates.first;
  }

  @override
  Widget build(BuildContext context) {
    final step = _d.step;
    final body = step == 0
        ? _CurrencyStep(
            state: widget.state, d: _d, onChanged: _changed, next: () => _go(1),)
        : switch (step - 1) {
            0 => _IntentStep(d: _d, onChanged: _changed),
            1 => _IncomeStep(d: _d, today: _today, onChanged: _changed),
            2 => _AvailableStep(d: _d, onChanged: _changed),
            3 => _ObligationsStep(
                d: _d, today: _today, horizon: _horizon, onChanged: _changed,),
            4 => _EssentialsStep(
                d: _d, today: _today, horizon: _horizon, onChanged: _changed,),
            _ => _ProtectStep(d: _d, today: _today, onChanged: _changed),
          };
    final (primary, primaryOn, secondary, secondaryOn) = step == 0
        ? (
            'Use ${_CurrencyStep.info(_d.currency).name}',
            () {
              widget.state.changeCurrency(_d.currency);
              _d.currencyChosen = true;
              _go(1);
            },
            null,
            null,
          )
        : switch (step - 1) {
            0 => (
                'Continue',
                _d.intents.isNotEmpty ? () => _go(2) : null,
                null,
                null
              ),
            1 => (
                'Continue',
                _d.incomeComplete &&
                        _d.incomes
                            .skip(1)
                            .every((i) => i.isComplete || i.amount == null)
                    ? () {
                        _d.incomes.removeWhere(
                            (i) => i != _d.incomes.first && !i.isComplete,);
                        _go(3);
                      }
                    : null,
                null,
                null,
              ),
            2 => (
                'Continue',
                _d.available != null ? () => _go(4) : null,
                null,
                null
              ),
            3 => (
                _d.obligations.any((o) => o.isComplete)
                    ? 'Continue'
                    : 'Nothing before payday',
                () {
                  _d.obligations.removeWhere((o) => !o.isComplete);
                  _d.obligationsDone = true;
                  _go(5);
                },
                null,
                null,
              ),
            4 => (
                'Continue',
                (_d.essentials?.minor ?? 0) > 0
                    ? () {
                        _d.essentialsSkipped = false;
                        _go(6);
                      }
                    : null,
                'Skip for now',
                () {
                  _d
                    ..essentials = null
                    ..essentialsSkipped = true;
                  _go(6);
                },
              ),
            _ => (
                'Build my plan',
                _d.protect == null || _d.protect!.isComplete ? _finish : null,
                _d.protect == null ? null : 'Skip for now',
                () {
                  _d
                    ..protect = null
                    ..protectSkipped = true;
                  _finish();
                },
              ),
          };

    return Scaffold(
      backgroundColor: pageOf(context),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 24, 0),
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: step == 0
                        ? null
                        : IconButton(
                            key: const Key('setup-back'),
                            onPressed: () => _go(step - 1),
                            icon: UpinoIcon('back',
                                size: 22, color: inkOf(context),),
                          ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(child: _Progress(step: step, of: _steps)),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 420),
                switchInCurve: _ease,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, anim) {
                  final incoming = child.key == ValueKey(step);
                  final dir = (_forward ? 1 : -1) * (incoming ? 1 : -1);
                  return FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position:
                          Tween(begin: Offset(0.08 * dir, 0), end: Offset.zero)
                              .animate(anim),
                      child: child,
                    ),
                  );
                },
                child: KeyedSubtree(key: ValueKey(step), child: body),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Column(
                children: [
                  FlowButton(
                    buttonKey: const Key('setup-next'),
                    label: primary,
                    onTap: primaryOn,
                  ),
                  if (secondary != null) ...[
                    const SizedBox(height: 4),
                    TextButton(
                      key: const Key('setup-skip'),
                      onPressed: secondaryOn,
                      child: Text(secondary,
                          style: TextStyle(
                              color: subOf(context),
                              fontWeight: FontWeight.w600,),),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.step, required this.of});
  final int step;
  final int of;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          for (var i = 0; i < of; i++)
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: _ease,
                margin: EdgeInsets.only(right: i == of - 1 ? 0 : 5),
                height: 4,
                decoration: BoxDecoration(
                  color: i <= step ? inkOf(context) : sunkenColor(context),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
        ],
      );
}

// ---------------------------------------------------------------- step shell

class _Step extends StatelessWidget {
  const _Step({required this.title, this.sub, required this.children});
  final String title;
  final String? sub;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
        children: [
          Arrive(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 28,
                height: 1.12,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.9,
                color: inkOf(context),
              ),
            ),
          ),
          if (sub != null) ...[
            const SizedBox(height: 8),
            Arrive(
              delay: const Duration(milliseconds: 50),
              child: Text(sub!,
                  style: TextStyle(
                      fontSize: 14.5, height: 1.45, color: subOf(context),),),
            ),
          ],
          const SizedBox(height: 22),
          for (var i = 0; i < children.length; i++)
            Arrive(
                delay: Duration(milliseconds: 90 + 45 * math.min(i, 6)),
                child: children[i],),
        ],
      );
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 6),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.9,
              color: tertOf(context),),
        ),
      );
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.padding = const EdgeInsets.all(18)});
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
            color: cardColor(context), borderRadius: BorderRadius.circular(24),),
        child: child,
      );
}

// ---------------------------------------------------------------- 0 currency

/// The likely currency, read from the phone's region, as a card; eleven
/// common ones under it; everything else behind the last tile. A tap on a
/// tile swaps it with the card.
class _CurrencyStep extends StatefulWidget {
  const _CurrencyStep({required this.state, required this.d, required this.onChanged, required this.next});
  final AppState state;
  final SetupDraft d;
  final VoidCallback onChanged;
  final VoidCallback next;

  static const _common = ['USD', 'EUR', 'GBP', 'JPY', 'IRR', 'TRY', 'INR', 'CAD', 'CHF', 'CNY', 'AUD', 'RUB'];
  static const _euro = {'AT', 'BE', 'CY', 'DE', 'EE', 'ES', 'FI', 'FR', 'GR', 'HR', 'IE', 'IT', 'LT', 'LU', 'LV', 'MT', 'NL', 'PT', 'SI', 'SK'};

  /// The phone's region, as a currency the catalogue has; dollars otherwise.
  static String guess() {
    final region = PlatformDispatcher.instance.locale.countryCode?.toUpperCase();
    if (region == null) return 'USD';
    if (_euro.contains(region)) return 'EUR';
    return currencyCatalogue.where((c) => c.flagCountry == region).firstOrNull?.code ?? 'USD';
  }

  static CurrencyInfo info(String code) => currencyCatalogue.firstWhere((c) => c.code == code);

  static String glyph(CurrencyInfo c) => c.code == 'IRR' ? '﷼' : c.symbol;

  @override
  State<_CurrencyStep> createState() => _CurrencyStepState();
}

class _CurrencyStepState extends State<_CurrencyStep> {
  final String _guess = _CurrencyStep.guess();
  late final List<String> _grid = [
    for (final c in _CurrencyStep._common) if (c != widget.d.currency) c,
  ].take(11).toList();

  void _choose(String code) {
    final was = widget.d.currency;
    if (code == was) return;
    setState(() {
      final i = _grid.indexOf(code);
      if (i >= 0) {
        _grid[i] = was;
      } else {
        _grid
          ..insert(0, was)
          ..removeLast();
      }
    });
    widget.d.currency = code;
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final hero = widget.d.currency;
    final hi = _CurrencyStep.info(hero);
    final more = currencyCatalogue.length - _grid.length - 1;
    final label = hero == _guess ? 'LOOKS LIKE' : 'SELECTED';
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
      children: [
        Arrive(
          child: Text('Which currency\nare you paid in?',
              maxLines: 2,
              style: TextStyle(fontSize: 30, height: 1.1, fontWeight: FontWeight.w600,
                  letterSpacing: -0.7, color: inkOf(context),),),
        ),
        const SizedBox(height: 20),
        Arrive(
          delay: const Duration(milliseconds: 80),
          child: Container(
            height: 176,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: cardColor(context),
              borderRadius: BorderRadius.circular(34),
            ),
            child: Stack(
              children: [
                HeroGlyph(_CurrencyStep.glyph(hi), key: ValueKey('g$hero'), color: lime.withValues(alpha: 0.1)),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 240),
                        child: Text(label, key: ValueKey(label), style: TextStyle(fontSize: 10.5,
                            fontWeight: FontWeight.w600, letterSpacing: 1.3, color: tertOf(context),),),
                      ),
                      const Spacer(),
                      SwapSlot(
                        id: hero,
                        child: Row(
                          children: [
                            CountryFlag(hi.flagCountry, size: 38),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(hi.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600,
                                          letterSpacing: -0.6, color: inkOf(context),),),
                                  Text('${hi.code} · ${hi.country}',
                                      style: TextStyle(fontSize: 12.5, color: subOf(context)),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('OR CHOOSE', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600,
            letterSpacing: 1.3, color: tertOf(context),),),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.75,
          children: [
            for (var i = 0; i < _grid.length; i++)
              Arrive(
                delay: Duration(milliseconds: 140 + 25 * i),
                child: SwapSlot(
                  id: _grid[i],
                  fromBelow: false,
                  child: pickTile(
                    context,
                    key: Key('cur-${_grid[i]}'),
                    title: _grid[i],
                    sub: _grid[i],
                    glyph: _CurrencyStep.glyph(_CurrencyStep.info(_grid[i])),
                    onTap: () => _choose(_grid[i]),
                  ),
                ),
              ),
            Arrive(
              delay: Duration(milliseconds: 140 + 25 * _grid.length),
              child: Pressable(
                key: const Key('currency-more'),
                scale: 0.95,
                onTap: () => UpinoSheet.show<void>(
                  context,
                  builder: (sheet) => UpinoSheet(
                    onClose: () => Navigator.of(sheet).pop(),
                    child: CurrencyPicker(
                      selected: hero,
                      onSelect: (code) {
                        Navigator.of(sheet).pop();
                        _choose(code);
                      },
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(color: sunkenColor(context), borderRadius: BorderRadius.circular(16)),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('+$more', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: mutedLime(context))),
                      Text('MORE', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600,
                          letterSpacing: 1.1, color: tertOf(context),),),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------- 1 intent

class _IntentStep extends StatelessWidget {
  const _IntentStep({required this.d, required this.onChanged});
  final SetupDraft d;
  final VoidCallback onChanged;

  static const _options = [
    (SetupIntent.safeToSpend, 'su-shield', 'Know what I can safely spend'),
    (SetupIntent.stopRunningOut, 'su-wave', 'Stop running out of money'),
    (SetupIntent.buildSavings, 'su-piggy', 'Build savings'),
    (SetupIntent.payOffDebt, 'su-card', 'Pay off debt'),
    (SetupIntent.irregularCosts, 'su-calendar', 'Prepare for irregular expenses'),
    (SetupIntent.reachGoal, 'su-target', 'Reach a goal'),
    (SetupIntent.understand, 'su-eye', 'Understand my money better'),
  ];

  /// The one number each choice needs, and how it reads once given.
  static (String, String, String) ask(SetupIntent i) => switch (i) {
        SetupIntent.safeToSpend => ('How much do you spend in a normal month?', 'A rough number is fine.', 'a month'),
        SetupIntent.stopRunningOut => ('How short do you usually fall before payday?', 'What you end up borrowing or going without.', 'short a month'),
        SetupIntent.buildSavings => ('How much would you like to save each month?', 'Upino sets it aside before you spend.', 'a month'),
        SetupIntent.payOffDebt => ('How much do you owe in total?', 'Cards, loans, anything you’re paying back.', 'owed'),
        SetupIntent.irregularCosts => ('What do they add up to in a year?', 'Insurance, repairs, gifts, fees.', 'a year'),
        SetupIntent.reachGoal => ('How much does your goal cost?', 'You can name it and set a date later.', 'to reach'),
        SetupIntent.understand => ('What do you think you spend in a month?', 'Upino will show you how close you were.', 'a month, you think'),
      };

  Future<void> _open(BuildContext context, SetupIntent i, String icon, String label) async {
    final edit = await _IntentSheet.show(context, i, icon, label, d.intents[i], d.currency);
    if (edit == null) return;
    if (edit.$1 == _Edit.remove) {
      d.intents.remove(i);
    } else {
      d.intents[i] = edit.$2!;
    }
    d.intent = d.intents.keys.firstOrNull;
    onChanged();
  }

  @override
  Widget build(BuildContext context) => _Step(
        title: 'What do you want Upino to help you with?',
        sub: 'Pick all that fit. Each one takes a single number.',
        children: [
          for (final (intent, icon, label) in _options)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ChoiceRow(
                key: Key('intent-${intent.name}'),
                icon: icon,
                label: label,
                detail: d.intents[intent] == null
                    ? null
                    : '${d.intents[intent]!.display()} ${ask(intent).$3}',
                on: d.intents.containsKey(intent),
                onTap: () => _open(context, intent, icon, label),
              ),
            ),
        ],
      );
}

/// Asks the one number a help choice needs. Saving picks the choice;
/// removing unpicks it.
class _IntentSheet extends StatefulWidget {
  const _IntentSheet({required this.intent, required this.icon, required this.label, this.amount, required this.currency});
  final SetupIntent intent;
  final String icon;
  final String label;
  final Money? amount;
  final String currency;

  static Future<(_Edit, Money?)?> show(
          BuildContext context, SetupIntent i, String icon, String label, Money? amount, String currency,) =>
      showModalBottomSheet<(_Edit, Money?)>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _IntentSheet(intent: i, icon: icon, label: label, amount: amount, currency: currency),
      );

  @override
  State<_IntentSheet> createState() => _IntentSheetState();
}

class _IntentSheetState extends State<_IntentSheet> {
  late final _amount = TextEditingController(text: plainAmount(widget.amount));
  late Money? _m = widget.amount;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (q, hint, _) = _IntentStep.ask(widget.intent);
    return _SheetShell(
      children: [
        Row(
          children: [
            IconTile(widget.icon, on: true, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Text(widget.label, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: subOf(context))),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(q, style: TextStyle(fontSize: 22, height: 1.2, fontWeight: FontWeight.w600,
            letterSpacing: -0.5, color: inkOf(context),),),
        const SizedBox(height: 6),
        Text(hint, style: TextStyle(fontSize: 13.5, color: subOf(context))),
        const SizedBox(height: 14),
        BigAmountField(
          fieldKey: const Key('intent-amount'),
          controller: _amount,
          currency: widget.currency,
          autofocus: true,
          size: 40,
          onChanged: (t) => setState(() => _m = readMoney(t, widget.currency)),
        ),
        const SizedBox(height: 18),
        FlowButton(
          buttonKey: const Key('intent-save'),
          label: widget.amount == null ? 'Add' : 'Save',
          onTap: (_m?.minor ?? 0) > 0 ? () => Navigator.of(context).pop((_Edit.save, _m)) : null,
        ),
        if (widget.amount != null)
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop((_Edit.remove, null)),
              child: Text('Remove', style: TextStyle(color: subOf(context))),
            ),
          ),
      ],
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow(
      {required this.icon,
      required this.label,
      required this.on,
      required this.onTap,
      this.detail,
      super.key,});
  final String icon;
  final String label;
  final String? detail;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Pressable(
        scale: 0.98,
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: _ease,
          padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
          decoration: BoxDecoration(
            color: on
                ? blueOf(context)
                    .withValues(alpha: isDark(context) ? 0.16 : 0.08)
                : cardColor(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: on ? blueOf(context) : Colors.transparent, width: 1.5,),
          ),
          child: Row(
            children: [
              IconTile(icon, on: on),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                          color: inkOf(context),),
                    ),
                    if (detail != null) ...[
                      const SizedBox(height: 2),
                      Text(detail!,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                              color: isDark(context) ? lime : const Color(0xFF4F7A00),),),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

// ---------------------------------------------------------------- 2 income

class _IncomeStep extends StatelessWidget {
  const _IncomeStep(
      {required this.d, required this.today, required this.onChanged,});
  final SetupDraft d;
  final LocalDate today;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) => _Step(
        title: 'Tell us how money comes in.',
        sub: 'If it varies, use what you can count on.',
        children: [
          for (var i = 0; i < d.incomes.length; i++) ...[
            _IncomeCard(
              key: ValueKey('income-$i'),
              income: d.incomes[i],
              currency: d.currency,
              today: today,
              first: i == 0,
              onChanged: onChanged,
              onRemove: i == 0
                  ? null
                  : () {
                      d.incomes.removeAt(i);
                      onChanged();
                    },
            ),
            const SizedBox(height: 12),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              key: const Key('income-add'),
              onPressed: () {
                d.incomes.add(SetupIncome());
                onChanged();
              },
              icon: UpinoIcon('add', size: 18, color: blueOf(context)),
              label: Text('Add another income source',
                  style: TextStyle(
                      color: blueOf(context), fontWeight: FontWeight.w600,),),
            ),
          ),
        ],
      );
}

class _IncomeCard extends StatefulWidget {
  const _IncomeCard({
    required this.income,
    required this.currency,
    required this.today,
    required this.first,
    required this.onChanged,
    this.onRemove,
    super.key,
  });

  final SetupIncome income;
  final String currency;
  final LocalDate today;
  final bool first;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  @override
  State<_IncomeCard> createState() => _IncomeCardState();
}

class _IncomeCardState extends State<_IncomeCard> {
  late final _amount =
      TextEditingController(text: plainAmount(widget.income.amount));

  static const _rhythms = [
    (PayRhythm.weekly, 'Weekly'),
    (PayRhythm.fortnightly, 'Every 2 weeks'),
    (PayRhythm.twiceMonthly, 'Twice a month'),
    (PayRhythm.monthly, 'Monthly'),
    (PayRhythm.irregular, 'Irregular'),
  ];

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inc = widget.income;
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: _Label(widget.first ? 'Each pay' : 'Another income'),),
              if (widget.onRemove != null)
                GestureDetector(
                  onTap: widget.onRemove,
                  child: UpinoIcon('close', size: 18, color: tertOf(context)),
                ),
            ],
          ),
          BigAmountField(
            fieldKey: Key(widget.first ? 'income-amount' : 'income-amount-2'),
            controller: _amount,
            currency: widget.currency,
            autofocus: widget.first && inc.amount == null,
            onChanged: (t) {
              inc.amount = readMoney(t, widget.currency);
              widget.onChanged();
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final (r, label) in _rhythms)
                Pick(
                  key: Key('rhythm-${r.name}'),
                  label: label,
                  on: inc.rhythm == r,
                  onTap: () {
                    inc.rhythm = r;
                    widget.onChanged();
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          const _Label('Next pay'),
          DayStrip(
            key: Key(widget.first ? 'income-days' : 'income-days-2'),
            from: widget.today,
            days: 45,
            selected: inc.next,
            onSelect: (day) {
              inc.next = day;
              widget.onChanged();
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- 3 available

class _AvailableStep extends StatefulWidget {
  const _AvailableStep({required this.d, required this.onChanged});
  final SetupDraft d;
  final VoidCallback onChanged;

  @override
  State<_AvailableStep> createState() => _AvailableStepState();
}

class _AvailableStepState extends State<_AvailableStep> {
  late final _c = TextEditingController(text: plainAmount(widget.d.available));

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _Step(
        title: 'How much money do you have available right now?',
        sub:
            'Cash and the accounts you spend from, together. Leave savings out — you can add accounts one by one later.',
        children: [
          _Panel(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Label('Available money today'),
                BigAmountField(
                  fieldKey: const Key('available-amount'),
                  controller: _c,
                  currency: widget.d.currency,
                  autofocus: true,
                  size: 52,
                  onChanged: (t) {
                    widget.d.available = readMoney(t, widget.d.currency);
                    widget.onChanged();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              UpinoIcon('su-shield', size: 16, color: tertOf(context)),
              const SizedBox(width: 8),
              Expanded(
                child: Text('This becomes today’s confirmed balance.',
                    style: TextStyle(fontSize: 13, color: tertOf(context)),),
              ),
            ],
          ),
        ],
      );
}

// ---------------------------------------------------------------- 4 obligations

String _obLabel(ObligationKind k) => switch (k) {
      ObligationKind.rent => 'Rent / Mortgage',
      ObligationKind.utilities => 'Utilities',
      ObligationKind.loan => 'Loan',
      ObligationKind.creditCard => 'Credit card',
      ObligationKind.insurance => 'Insurance',
      ObligationKind.subscriptions => 'Subscriptions',
      ObligationKind.other => 'Something else',
    };

String _obIcon(ObligationKind k) => switch (k) {
      ObligationKind.rent => 'goal-home',
      ObligationKind.utilities => 'su-bolt',
      ObligationKind.loan => 'su-loan',
      ObligationKind.creditCard => 'su-card',
      ObligationKind.insurance => 'goal-umbrella',
      ObligationKind.subscriptions => 'su-repeat',
      ObligationKind.other => 'su-dots',
    };

class _ObligationsStep extends StatelessWidget {
  const _ObligationsStep({
    required this.d,
    required this.today,
    required this.horizon,
    required this.onChanged,
  });

  final SetupDraft d;
  final LocalDate today;
  final LocalDate horizon;
  final VoidCallback onChanged;

  Future<void> _edit(BuildContext context, SetupObligation o,
      {required bool isNew,}) async {
    final result =
        await _ObligationSheet.show(context, o, d.currency, today, horizon);
    if (result == _Edit.remove || (result == null && isNew && !o.isComplete)) {
      d.obligations.remove(o);
    } else if (result == _Edit.save && isNew && !d.obligations.contains(o)) {
      d.obligations.add(o);
    }
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final fixed = ObligationKind.values.where((k) => k != ObligationKind.other);
    final others =
        d.obligations.where((o) => o.kind == ObligationKind.other).toList();
    return _Step(
      title: 'What must be paid before your next income?',
      sub: 'Only what’s due by ${_fmt(horizon)}. Tap each one.',
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.35,
          children: [
            for (final k in fixed)
              _ObTile(
                key: Key('ob-${k.name}'),
                kind: k,
                item: d.obligations.where((o) => o.kind == k).firstOrNull,
                onTap: () {
                  final existing =
                      d.obligations.where((o) => o.kind == k).firstOrNull;
                  if (existing != null) {
                    _edit(context, existing, isNew: false);
                  } else {
                    final o = SetupObligation(kind: k);
                    d.obligations.add(o);
                    _edit(context, o, isNew: true);
                  }
                },
              ),
            for (final o in others)
              _ObTile(
                  kind: ObligationKind.other,
                  item: o,
                  onTap: () => _edit(context, o, isNew: false),),
            _ObTile(
              key: const Key('ob-add'),
              kind: ObligationKind.other,
              item: null,
              addLabel: others.isEmpty ? 'Something else' : 'Add another',
              onTap: () {
                final o = SetupObligation(kind: ObligationKind.other);
                d.obligations.add(o);
                _edit(context, o, isNew: true);
              },
            ),
          ],
        ),
      ],
    );
  }
}

String _fmt(LocalDate d) {
  const mo = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${mo[d.month - 1]} ${d.day}';
}

class _ObTile extends StatelessWidget {
  const _ObTile(
      {required this.kind,
      required this.item,
      required this.onTap,
      this.addLabel,
      super.key,});
  final ObligationKind kind;
  final SetupObligation? item;
  final VoidCallback onTap;
  final String? addLabel;

  @override
  Widget build(BuildContext context) {
    final on = item?.isComplete ?? false;
    final label = addLabel ??
        ((item?.name?.isNotEmpty ?? false) ? item!.name! : _obLabel(kind));
    return Pressable(
      scale: 0.96,
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: _ease,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: on
              ? blueOf(context).withValues(alpha: isDark(context) ? 0.16 : 0.08)
              : cardColor(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: on ? blueOf(context) : Colors.transparent, width: 1.5,),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconTile(addLabel != null ? 'add' : _obIcon(kind),
                    on: on, size: 36,),
                const Spacer(),
                if (on) UpinoIcon('check', size: 18, color: blueOf(context)),
              ],
            ),
            const Spacer(),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: inkOf(context),),
            ),
            const SizedBox(height: 2),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                on
                    ? '${item!.amount!.display()} · ${_fmt(item!.due!)}'
                    : (addLabel != null
                        ? 'Add a name and amount'
                        : 'Tap to add'),
                key: ValueKey(on),
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: on ? FontWeight.w600 : FontWeight.w400,
                  color: on ? inkOf(context) : tertOf(context),
                  fontFeatures: moneyFeatures,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _Edit { save, remove }

class _ObligationSheet extends StatefulWidget {
  const _ObligationSheet({
    required this.o,
    required this.currency,
    required this.today,
    required this.horizon,
  });

  final SetupObligation o;
  final String currency;
  final LocalDate today;
  final LocalDate horizon;

  static Future<_Edit?> show(
    BuildContext context,
    SetupObligation o,
    String currency,
    LocalDate today,
    LocalDate horizon,
  ) =>
      showModalBottomSheet<_Edit>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _ObligationSheet(
            o: o, currency: currency, today: today, horizon: horizon,),
      );

  @override
  State<_ObligationSheet> createState() => _ObligationSheetState();
}

class _ObligationSheetState extends State<_ObligationSheet> {
  late final _amount =
      TextEditingController(text: plainAmount(widget.o.amount));
  late final _name = TextEditingController(text: widget.o.name ?? '');
  late Money? _m = widget.o.amount;
  late LocalDate? _due = widget.o.due;

  bool get _named =>
      widget.o.kind != ObligationKind.other || _name.text.trim().isNotEmpty;
  bool get _ok => (_m?.minor ?? 0) > 0 && _due != null && _named;

  @override
  void dispose() {
    _amount.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = math.max(1, widget.horizon.differenceInDays(widget.today) + 1);
    final other = widget.o.kind == ObligationKind.other;
    return _SheetShell(
      children: [
        Row(
          children: [
            IconTile(_obIcon(widget.o.kind), on: true, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                other ? 'Something else' : _obLabel(widget.o.kind),
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                    color: inkOf(context),),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (other) ...[
          TextField(
            key: const Key('ob-name'),
            controller: _name,
            onChanged: (_) => setState(() {}),
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'What is it?',
              filled: true,
              fillColor: sunkenColor(context),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,),
            ),
          ),
          const SizedBox(height: 14),
        ],
        const _Label('Amount'),
        BigAmountField(
          fieldKey: const Key('ob-amount'),
          controller: _amount,
          currency: widget.currency,
          autofocus: !other,
          size: 40,
          onChanged: (t) => setState(() => _m = readMoney(t, widget.currency)),
        ),
        const SizedBox(height: 14),
        const _Label('Due'),
        DayStrip(
          key: const Key('ob-days'),
          from: widget.today,
          days: days,
          selected: _due,
          marks: {widget.horizon},
          onSelect: (d) => setState(() => _due = d),
        ),
        const SizedBox(height: 18),
        FlowButton(
          buttonKey: const Key('ob-save'),
          label: 'Add',
          onTap: _ok
              ? () {
                  widget.o
                    ..amount = _m
                    ..due = _due
                    ..name = other ? _name.text.trim() : null;
                  Navigator.of(context).pop(_Edit.save);
                }
              : null,
        ),
        if (widget.o.isComplete)
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(_Edit.remove),
              child: Text('Remove', style: TextStyle(color: subOf(context))),
            ),
          ),
      ],
    );
  }
}

class _SheetShell extends StatelessWidget {
  const _SheetShell({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
          decoration: BoxDecoration(
            color: cardColor(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: borderColor(context),
                        borderRadius: BorderRadius.circular(4),),
                  ),
                ),
                const SizedBox(height: 18),
                ...children,
              ],
            ),
          ),
        ),
      );
}

// ---------------------------------------------------------------- 5 essentials

class _EssentialsStep extends StatefulWidget {
  const _EssentialsStep(
      {required this.d,
      required this.today,
      required this.horizon,
      required this.onChanged,});
  final SetupDraft d;
  final LocalDate today;
  final LocalDate horizon;
  final VoidCallback onChanged;

  @override
  State<_EssentialsStep> createState() => _EssentialsStepState();
}

class _EssentialsStepState extends State<_EssentialsStep> {
  late final _c = TextEditingController(text: plainAmount(widget.d.essentials));

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _estimate() async {
    final m = await _EstimateSheet.show(
        context, widget.d, widget.today, widget.horizon,);
    if (m == null) return;
    _c.text = plainAmount(m);
    widget.d
      ..essentials = m
      ..essentialsSkipped = false;
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) => _Step(
        title:
            'About how much will you need for everyday essentials until your next income?',
        sub: 'Until ${_fmt(widget.horizon)}. A rough number is fine.',
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final (icon, label) in const [
                ('su-cart', 'Groceries'),
                ('su-bus', 'Getting around'),
                ('goal-home', 'Household'),
                ('su-coins', 'Everyday needs'),
              ])
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                      color: cardColor(context),
                      borderRadius: BorderRadius.circular(99),),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UpinoIcon(icon, size: 15, color: subOf(context)),
                      const SizedBox(width: 6),
                      Text(label,
                          style: TextStyle(
                              fontSize: 12.5,
                              color: subOf(context),
                              fontWeight: FontWeight.w500,),),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _Panel(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
            child: BigAmountField(
              fieldKey: const Key('essentials-amount'),
              controller: _c,
              currency: widget.d.currency,
              size: 52,
              onChanged: (t) {
                widget.d
                  ..essentials = readMoney(t, widget.d.currency)
                  ..essentialsSkipped = false;
                widget.onChanged();
              },
            ),
          ),
          const SizedBox(height: 12),
          if (widget.d.incomeComplete)
            FlowButton(
              buttonKey: const Key('essentials-estimate'),
              label: 'Help me estimate',
              style: FlowButtonStyle.quiet,
              onTap: _estimate,
            ),
        ],
      );
}

/// A starting figure from two taps, scaled to the person's own income so it
/// means the same in any currency. It only fills the field; the person sees
/// it and can change it before anything uses it.
class _EstimateSheet extends StatefulWidget {
  const _EstimateSheet(
      {required this.d, required this.today, required this.horizon,});
  final SetupDraft d;
  final LocalDate today;
  final LocalDate horizon;

  static Future<Money?> show(BuildContext context, SetupDraft d,
          LocalDate today, LocalDate horizon,) =>
      showModalBottomSheet<Money>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _EstimateSheet(d: d, today: today, horizon: horizon),
      );

  @override
  State<_EstimateSheet> createState() => _EstimateSheetState();
}

class _EstimateSheetState extends State<_EstimateSheet> {
  int _people = 1;
  int _travel = 1; // 0 walk/bike, 1 public transport, 2 car

  Money get _value {
    final inc = widget.d.incomes.first;
    final perPeriod = inc.amount!.minor;
    final share = 0.16 + 0.07 * (_people - 1) + [0.0, 0.03, 0.07][_travel];
    final days = math.max(1, widget.horizon.differenceInDays(widget.today));
    final raw = perPeriod * share * days / inc.rhythm.days;
    // Rounded to a tidy figure in the currency's own units.
    final unit =
        math.pow(10, Currency.of(widget.d.currency).exponent + 1).toInt();
    return Money(
        math.max(unit, (raw / unit).round() * unit), widget.d.currency,);
  }

  @override
  Widget build(BuildContext context) => _SheetShell(
        children: [
          Text('A quick estimate',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                  color: inkOf(context),),),
          const SizedBox(height: 6),
          Text('Two taps. You can change the number after.',
              style: TextStyle(fontSize: 14, color: subOf(context)),),
          const SizedBox(height: 18),
          const _Label('People you cover'),
          Row(
            children: [
              for (final n in [1, 2, 3, 4])
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Pick(
                      label: n == 4 ? '4+' : '$n',
                      on: _people == n,
                      onTap: () => setState(() => _people = n),),
                ),
            ],
          ),
          const SizedBox(height: 14),
          const _Label('Getting around'),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final (i, label) in const [
                (0, 'Walk or bike'),
                (1, 'Public transport'),
                (2, 'Car'),
              ])
                Pick(
                    label: label,
                    on: _travel == i,
                    onTap: () => setState(() => _travel = i),),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(end: _value.minor.toDouble()),
                duration: const Duration(milliseconds: 420),
                curve: _ease,
                builder: (context, v, _) => Text(
                  Money(v.round(), widget.d.currency).display(),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.6,
                    color: inkOf(context),
                    fontFeatures: moneyFeatures,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('until ${_fmt(widget.horizon)}',
                    style: TextStyle(color: subOf(context)),),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FlowButton(
            buttonKey: const Key('estimate-use'),
            label: 'Use this',
            onTap: () => Navigator.of(context).pop(_value),
          ),
        ],
      );
}

// ---------------------------------------------------------------- 6 protect

String _protectLabel(ProtectKind k) => switch (k) {
      ProtectKind.emergency => 'Emergency fund',
      ProtectKind.trip => 'Trip',
      ProtectKind.car => 'Car',
      ProtectKind.home => 'Home',
      ProtectKind.debt => 'Pay off debt',
      ProtectKind.annual => 'Yearly expense',
      ProtectKind.custom => 'Something else',
    };

String _protectIcon(ProtectKind k) => switch (k) {
      ProtectKind.emergency => 'goal-emergency',
      ProtectKind.trip => 'goal-trip',
      ProtectKind.car => 'goal-car',
      ProtectKind.home => 'goal-home',
      ProtectKind.debt => 'su-card',
      ProtectKind.annual => 'su-calendar',
      ProtectKind.custom => 'goal-savings',
    };

class _ProtectStep extends StatefulWidget {
  const _ProtectStep(
      {required this.d, required this.today, required this.onChanged,});
  final SetupDraft d;
  final LocalDate today;
  final VoidCallback onChanged;

  @override
  State<_ProtectStep> createState() => _ProtectStepState();
}

class _ProtectStepState extends State<_ProtectStep> {
  final _target = TextEditingController();
  final _saved = TextEditingController();
  final _name = TextEditingController();
  final _panel = GlobalKey();

  /// The details open below the cards; bring them up into view.
  void _reveal() {
    Future<void>.delayed(const Duration(milliseconds: 380), () {
      if (!mounted) return;
      final c = _panel.currentContext;
      if (c == null || !c.mounted) return;
      Scrollable.ensureVisible(
        c,
        duration: const Duration(milliseconds: 450),
        curve: const Cubic(0.77, 0, 0.175, 1),
        alignment: 0.05,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    final p = widget.d.protect;
    _target.text = plainAmount(p?.target);
    _saved.text = plainAmount(p?.saved);
    _name.text = p?.name ?? '';
  }

  @override
  void dispose() {
    _target.dispose();
    _saved.dispose();
    _name.dispose();
    super.dispose();
  }

  static const _horizons = [
    (3, '3 months'),
    (6, '6 months'),
    (12, '1 year'),
    (24, '2 years'),
  ];

  LocalDate _months(int m) => widget.today.addDays((m * 30.44).round());

  @override
  Widget build(BuildContext context) {
    final p = widget.d.protect;
    final cur = widget.d.currency;
    return _Step(
      title: 'Anything you want your money to protect?',
      sub:
          'Optional. Upino sets a little aside each pay so it’s there on time.',
      children: [
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.95,
          children: [
            for (final k in ProtectKind.values)
              Pressable(
                key: Key('protect-${k.name}'),
                scale: 0.95,
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    if (p?.kind == k) {
                      widget.d.protect = null;
                    } else {
                      final known = widget.d.intents[switch (k) {
                        ProtectKind.debt => SetupIntent.payOffDebt,
                        ProtectKind.annual => SetupIntent.irregularCosts,
                        _ => SetupIntent.reachGoal,
                      }];
                      final prefill = k == ProtectKind.debt || k == ProtectKind.annual || k == ProtectKind.custom;
                      widget.d.protect = SetupProtect(kind: k, target: prefill ? known : null);
                      widget.d.protectSkipped = false;
                      _target.text = prefill ? plainAmount(known) : '';
                      _saved.clear();
                      _name.clear();
                    }
                  });
                  widget.onChanged();
                  if (widget.d.protect != null) _reveal();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: _ease,
                  decoration: BoxDecoration(
                    color: p?.kind == k
                        ? blueOf(context)
                            .withValues(alpha: isDark(context) ? 0.16 : 0.08)
                        : cardColor(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color:
                            p?.kind == k ? blueOf(context) : Colors.transparent,
                        width: 1.5,),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconTile(_protectIcon(k), on: p?.kind == k, size: 42),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          _protectLabel(k),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 12.5,
                              height: 1.2,
                              fontWeight: FontWeight.w600,
                              color: inkOf(context),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 360),
          curve: _ease,
          alignment: Alignment.topCenter,
          child: p == null
              ? const SizedBox(width: double.infinity)
              : Padding(
                  key: _panel,
                  padding: const EdgeInsets.only(top: 14),
                  child: _Panel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (p.kind == ProtectKind.custom ||
                            p.kind == ProtectKind.annual) ...[
                          TextField(
                            key: const Key('protect-name'),
                            controller: _name,
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (t) {
                              p.name = t;
                              widget.onChanged();
                            },
                            decoration: InputDecoration(
                              hintText: p.kind == ProtectKind.annual
                                  ? 'e.g. Car insurance'
                                  : 'What is it for?',
                              filled: true,
                              fillColor: sunkenColor(context),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        _Label(p.kind == ProtectKind.annual
                            ? 'How much, once a year'
                            : 'Target',),
                        BigAmountField(
                          fieldKey: const Key('protect-target'),
                          controller: _target,
                          currency: cur,
                          autofocus: p.target == null &&
                              p.kind != ProtectKind.custom &&
                              p.kind != ProtectKind.annual,
                          size: 36,
                          onChanged: (t) {
                            p.target = readMoney(t, cur);
                            widget.onChanged();
                          },
                        ),
                        const SizedBox(height: 12),
                        _Label(p.kind == ProtectKind.annual
                            ? 'Next due in'
                            : 'By when',),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final (m, label) in _horizons)
                              Pick(
                                key: Key('protect-when-$m'),
                                label: label,
                                on: p.date == _months(m),
                                onTap: () {
                                  p.date = _months(m);
                                  widget.onChanged();
                                },
                              ),
                          ],
                        ),
                        if (p.kind != ProtectKind.annual) ...[
                          const SizedBox(height: 14),
                          const _Label('Already saved'),
                          BigAmountField(
                            fieldKey: const Key('protect-saved'),
                            controller: _saved,
                            currency: cur,
                            size: 26,
                            onChanged: (t) {
                              p.saved = readMoney(t, cur);
                              widget.onChanged();
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
