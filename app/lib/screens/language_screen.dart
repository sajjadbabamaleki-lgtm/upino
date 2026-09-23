/// Language choice — the very first thing the app asks, and the same screen
/// Profile opens later.
///
/// It comes before the currency question for the plain reason that the
/// currency question is written in words: asking it in a language the user
/// does not read is asking nothing at all.
///
/// Each language is named in itself. Someone who cannot read the language
/// currently showing still has to be able to find their own, so the list
/// never relies on the current one. No flags: a language is not a country,
/// and Spanish, Arabic and English each belong to dozens.
library;

import 'package:flutter/material.dart';

import '../design/motion.dart';
import '../design/parts.dart';
import '../design/tokens.dart';
import '../l10n/app_localizations.dart';

/// Native name first, then the English name as a second key for anyone who
/// arrives here by accident and needs a way back.
const languageNames = <String, ({String native, String english})>{
  'en': (native: 'English', english: 'English'),
  'zh': (native: '中文', english: 'Chinese'),
  'hi': (native: 'हिन्दी', english: 'Hindi'),
  'es': (native: 'Español', english: 'Spanish'),
  'fr': (native: 'Français', english: 'French'),
  'ar': (native: 'العربية', english: 'Arabic'),
  'fa': (native: 'فارسی', english: 'Persian'),
  'pt': (native: 'Português', english: 'Portuguese'),
  'ru': (native: 'Русский', english: 'Russian'),
  'tr': (native: 'Türkçe', english: 'Turkish'),
};

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({
    required this.selected,
    required this.onSelect,
    this.showHeading = true,
    super.key,
  });

  /// Null means follow the phone, which is the default and the first row.
  final String? selected;
  final ValueChanged<String?> onSelect;
  final bool showHeading;

  static const rowHeight = 44.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final codes = <String?>[null, ...languageNames.keys];

    return Column(
      // Ten languages and the phone make a list short enough to show whole,
      // so the sheet is sized to it rather than to a share of the screen: a
      // fixed height would leave a band of empty sheet under the last row.
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showHeading)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              UpinoTokens.gutter + 4,
              4,
              UpinoTokens.gutter + 4,
              12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.languageTitle, style: theme.textTheme.headlineLarge),
                const SizedBox(height: 6),
                Text(l.languageBlurb, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        Flexible(
          child: ListView.separated(
            shrinkWrap: true,
            // Tight on purpose: eleven rows, and the sheet is sized to show
            // all of them at once on a phone. Every point spent here is a
            // point the last row has to be scrolled to reach.
            padding: const EdgeInsets.fromLTRB(
              UpinoTokens.gutter,
              0,
              UpinoTokens.gutter,
              12,
            ),
            itemCount: codes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (context, i) => Reveal(
              index: i,
              child: _LanguageRow(
                code: codes[i],
                selected: codes[i] == selected,
                onTap: () => onSelect(codes[i]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// One line at the same height as a currency row, so the two questions the
/// app opens with read as one pair rather than two screens.
class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.code,
    required this.selected,
    required this.onTap,
  });

  final String? code;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = isDark(context);
    final l = AppLocalizations.of(context);
    final names = code == null ? null : languageNames[code];

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        key: Key('language-${code ?? 'system'}'),
        height: LanguagePicker.rowHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected
              ? (dark ? UpinoTokens.darkActionTint : UpinoTokens.actionTint)
              : cardColor(context),
          borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      // The phone row is the only one written in the current
                      // language, because it is the only one that is not the
                      // name of a language.
                      text: names?.native ?? l.languagePhone,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        color:
                            selected && !dark ? UpinoTokens.actionOnTint : null,
                      ),
                    ),
                    if (names != null && names.english != names.native)
                      TextSpan(
                        text: '  ${names.english}',
                        style:
                            theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                      ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (code != null) ...[
              const SizedBox(width: 8),
              Text(
                code!.toUpperCase(),
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontSize: 11, letterSpacing: 0.4),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
