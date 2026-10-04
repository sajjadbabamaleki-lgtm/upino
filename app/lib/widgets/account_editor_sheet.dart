/// Adding an account (Strategy §7.2): a name, what kind it is, and what it
/// holds or owes today. No bank connection: the balance is the person's to
/// say, and confirming it later keeps it honest.
library;

import 'package:flutter/material.dart';

import '../domain/account.dart';
import '../engine/money.dart';
import '../l10n/app_localizations.dart';
import 'form_parts.dart';

class AccountDraft {
  const AccountDraft({
    required this.name,
    required this.kind,
    required this.opening,
    this.counted,
  });

  final String name;
  final AccountKind kind;
  final Money opening;
  final bool? counted;
}

String accountKindLabel(AppLocalizations l, AccountKind k) => switch (k) {
      AccountKind.bank => l.accountKindBank,
      AccountKind.cash => l.accountKindCash,
      AccountKind.savings => l.accountKindSavings,
      AccountKind.card => l.accountKindCard,
      AccountKind.loan => l.accountKindLoan,
    };

class AccountEditorSheet extends StatefulWidget {
  const AccountEditorSheet({required this.currency, super.key});

  final String currency;

  static Future<AccountDraft?> show(
    BuildContext context, {
    required String currency,
  }) =>
      showModalBottomSheet<AccountDraft>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => AccountEditorSheet(currency: currency),
      );

  @override
  State<AccountEditorSheet> createState() => _AccountEditorSheetState();
}

class _AccountEditorSheetState extends State<AccountEditorSheet> {
  final _name = TextEditingController();
  final _opening = TextEditingController();
  AccountKind _kind = AccountKind.cash;
  bool? _counted;

  @override
  void dispose() {
    _name.dispose();
    _opening.dispose();
    super.dispose();
  }

  bool get _debt => _kind == AccountKind.card || _kind == AccountKind.loan;

  /// What the switch shows before the person touches it: the kind's default.
  bool get _countedShown => _counted ?? _kind != AccountKind.savings;

  Money? get _money =>
      parseMoneyField(_opening.text, widget.currency, allowZero: true);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final canSave = _name.text.trim().isNotEmpty && _money != null;

    return EditorSheetFrame(
      title: l.accountEditNew,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final k in AccountKind.values)
              PillChoice(
                key: Key('account-kind-${k.name}'),
                label: accountKindLabel(l, k),
                selected: _kind == k,
                onTap: () => setState(() {
                  _kind = k;
                  _counted = null;
                }),
              ),
          ],
        ),
        const SizedBox(height: 16),
        FieldLabel(l.billName),
        SunkenField(
          child: TextField(
            key: const Key('account-name'),
            controller: _name,
            onChanged: (_) => setState(() {}),
            style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
            decoration: plainInput(theme, l.accountNameHint),
          ),
        ),
        const SizedBox(height: 16),
        FieldLabel(_debt ? l.accountOwes : l.accountHolds),
        MoneyField(
          key: const Key('account-opening'),
          controller: _opening,
          currency: widget.currency,
          hint: l.tapToType,
          onChanged: () => setState(() {}),
        ),
        if (!_debt) ...[
          const SizedBox(height: 10),
          // Its own Material, so the tile's ink shows on the raised sheet.
          Material(
            type: MaterialType.transparency,
            child: SwitchListTile(
              key: const Key('account-counted'),
              contentPadding: EdgeInsets.zero,
              title: Text(l.accountCounted, style: theme.textTheme.titleMedium),
              subtitle:
                  Text(l.accountCountedSub, style: theme.textTheme.bodySmall),
              value: _countedShown,
              onChanged: (v) => setState(() => _counted = v),
            ),
          ),
        ],
        const SizedBox(height: 20),
        FilledButton(
          key: const Key('account-save'),
          onPressed: !canSave
              ? null
              : () => Navigator.of(context).pop(
                    AccountDraft(
                      name: _name.text.trim(),
                      kind: _kind,
                      opening: _money!,
                      counted: _debt ? null : _counted,
                    ),
                  ),
          child: Text(l.accountAdd),
        ),
      ],
    );
  }
}
