import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'sky_phase.dart';

/// All colors that change with the time of day, as a [ThemeExtension].
///
/// Attach it in your ThemeData (`extensions: [SkyPalette.forPhase(phase)]`).
/// MaterialApp then cross-fades it for free when the phase changes, which
/// replaces the manual 700 ms background animation.
@immutable
class SkyPalette extends ThemeExtension<SkyPalette> {
  const SkyPalette({
    required this.skyTop,
    required this.skyMid,
    required this.skyHorizon,
    required this.hillFar,
    required this.hillMid,
    required this.hillNear,
    required this.tree,
    required this.water,
    required this.sheet,
    required this.ink,
    required this.inkMuted,
    required this.accent,
    required this.sunColor,
    required this.moonColor,
    required this.sunAmount,
    required this.moonAmount,
    required this.starAmount,
  });

  // Sky and landscape.
  final Color skyTop, skyMid, skyHorizon;
  final Color hillFar, hillMid, hillNear, tree, water;

  // Forecast sheet.
  final Color sheet, ink, inkMuted, accent;

  // Celestial bodies. The *Amount values (0..1) fade them in and out.
  final Color sunColor, moonColor;
  final double sunAmount, moonAmount, starAmount;

  /// Text on the sky is always white. Every sky palette keeps white text at
  /// 4.5:1 or better down to the point where the text block ends.
  static const Color onSky = Colors.white;

  Color get hairline => ink.withValues(alpha: .12);

  static SkyPalette of(BuildContext context) =>
      Theme.of(context).extension<SkyPalette>() ?? forPhase(SkyPhase.day);

  static SkyPalette forPhase(SkyPhase phase) => switch (phase) {
        SkyPhase.dawn => _dawn,
        SkyPhase.day => _day,
        SkyPhase.sunset => _sunset,
        SkyPhase.night => _night,
      };

  static const _day = SkyPalette(
    skyTop: Color(0xFF14609F),
    skyMid: Color(0xFF1F7BB6),
    skyHorizon: Color(0xFF9ADCF0),
    hillFar: Color(0xFFA6DB93),
    hillMid: Color(0xFF7BCB7C),
    hillNear: Color(0xFF4FB870),
    tree: Color(0xFF1F7F63),
    water: Color(0xFFBFEAF3),
    sheet: Color(0xFFF4F9FD),
    ink: Color(0xFF12263A),
    inkMuted: Color(0xFF506478),
    accent: Color(0xFF1F6FB2),
    sunColor: Color(0xFFFFF2B5),
    moonColor: Color(0xFFE4F5FF),
    sunAmount: 1,
    moonAmount: 0,
    starAmount: 0,
  );

  static const _dawn = SkyPalette(
    skyTop: Color(0xFF2F3F85),
    skyMid: Color(0xFF9A4A7E),
    skyHorizon: Color(0xFFFFC48C),
    hillFar: Color(0xFF86C5B0),
    hillMid: Color(0xFF5CAE95),
    hillNear: Color(0xFF3E9179),
    tree: Color(0xFF286F66),
    water: Color(0xFFF6D5C4),
    sheet: Color(0xFFFFF8F3),
    ink: Color(0xFF2B2340),
    inkMuted: Color(0xFF645A78),
    accent: Color(0xFFB0426C),
    sunColor: Color(0xFFFFE3A3),
    moonColor: Color(0xFFE4F5FF),
    sunAmount: 1,
    moonAmount: 0,
    starAmount: .25,
  );

  static const _sunset = SkyPalette(
    skyTop: Color(0xFF4E2476),
    skyMid: Color(0xFFB0467A),
    skyHorizon: Color(0xFFFFB07A),
    hillFar: Color(0xFF6A3A8C),
    hillMid: Color(0xFF4B2F7A),
    hillNear: Color(0xFF3C286B),
    tree: Color(0xFF29234D),
    water: Color(0xFFF3A5A0),
    sheet: Color(0xFFFFF4EF),
    ink: Color(0xFF2E1F3F),
    inkMuted: Color(0xFF685474),
    accent: Color(0xFFB9405F),
    sunColor: Color(0xFFFFD08A),
    moonColor: Color(0xFFE4F5FF),
    sunAmount: 1,
    moonAmount: 0,
    starAmount: .35,
  );

  static const _night = SkyPalette(
    skyTop: Color(0xFF1D1850),
    skyMid: Color(0xFF3A3F94),
    skyHorizon: Color(0xFF5A75B5),
    hillFar: Color(0xFF302E70),
    hillMid: Color(0xFF272A5E),
    hillNear: Color(0xFF1E214A),
    tree: Color(0xFF1A1840),
    water: Color(0xFF3B4F94),
    sheet: Color(0xFF1B1A3F),
    ink: Color(0xFFF1F0FF),
    inkMuted: Color(0xFFB0B2DA),
    accent: Color(0xFF9DB0FF),
    sunColor: Color(0xFFFFF2B5),
    moonColor: Color(0xFFE4F5FF),
    sunAmount: 0,
    moonAmount: 1,
    starAmount: 1,
  );

  // The palette is immutable and never patched, so copyWith has nothing to do.
  @override
  SkyPalette copyWith() => this;

  @override
  SkyPalette lerp(ThemeExtension<SkyPalette>? other, double t) {
    if (other is! SkyPalette) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    double d(double a, double b) => lerpDouble(a, b, t)!;
    return SkyPalette(
      skyTop: c(skyTop, other.skyTop),
      skyMid: c(skyMid, other.skyMid),
      skyHorizon: c(skyHorizon, other.skyHorizon),
      hillFar: c(hillFar, other.hillFar),
      hillMid: c(hillMid, other.hillMid),
      hillNear: c(hillNear, other.hillNear),
      tree: c(tree, other.tree),
      water: c(water, other.water),
      sheet: c(sheet, other.sheet),
      ink: c(ink, other.ink),
      inkMuted: c(inkMuted, other.inkMuted),
      accent: c(accent, other.accent),
      sunColor: c(sunColor, other.sunColor),
      moonColor: c(moonColor, other.moonColor),
      sunAmount: d(sunAmount, other.sunAmount),
      moonAmount: d(moonAmount, other.moonAmount),
      starAmount: d(starAmount, other.starAmount),
    );
  }
}
