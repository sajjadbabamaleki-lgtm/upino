/// Icons, drawn from SVG rather than a font.
///
/// Material's icons are a general-purpose set and it shows: mixed weights,
/// mixed corner treatments, and a few glyphs that carry meanings this product
/// does not use. lucide is one weight on one grid, which is most of what makes
/// a set look considered rather than assembled.
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'icons.dart';
import 'tokens.dart';

/// An interface icon. The source carries `currentColor`, so [color] tints it
/// the way a font glyph would.
class UpinoIcon extends StatelessWidget {
  const UpinoIcon(
    this.name, {
    this.size = 20,
    this.color,
    super.key,
  });

  final String name;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final svg = upinoIcons[name];
    assert(svg != null, 'no icon named "$name"');
    if (svg == null) return SizedBox(width: size, height: size);

    return SvgPicture.string(
      svg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? UpinoTokens.textPrimary,
        BlendMode.srcIn,
      ),
    );
  }
}

/// A round country flag. Full colour, so nothing tints it.
///
/// Returns an empty circle for a country with no flag in the set rather than
/// a broken glyph — the row still lines up, which is what matters in a list.
class CountryFlag extends StatelessWidget {
  const CountryFlag(this.country, {this.size = 22, super.key});

  /// ISO 3166-1 alpha-2, in any case.
  final String country;
  final double size;

  @override
  Widget build(BuildContext context) {
    final svg = countryFlags[country.toLowerCase()];
    if (svg == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: UpinoTokens.borderSubtle,
          shape: BoxShape.circle,
        ),
      );
    }
    return SvgPicture.string(svg, width: size, height: size);
  }
}
