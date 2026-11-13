import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:woosh/core/theme/sky_palette.dart';
import 'package:woosh/core/theme/sky_phase.dart';

double _ratio(Color a, Color b) {
  final la = a.computeLuminance(), lb = b.computeLuminance();
  final hi = la > lb ? la : lb, lo = la > lb ? lb : la;
  return (hi + .05) / (lo + .05);
}

void main() {
  for (final phase in SkyPhase.values) {
    final p = SkyPalette.forPhase(phase);

    test('$phase: white text on the sky is at least 4.5:1', () {
      expect(_ratio(Colors.white, p.skyTop), greaterThanOrEqualTo(4.5));
      expect(_ratio(Colors.white, p.skyMid), greaterThanOrEqualTo(4.5));
    });

    test('$phase: sheet text is readable', () {
      expect(_ratio(p.ink, p.sheet), greaterThanOrEqualTo(7));
      expect(_ratio(p.inkMuted, p.sheet), greaterThanOrEqualTo(4.5));
      expect(_ratio(p.accent, p.sheet), greaterThanOrEqualTo(4.5));
    });
  }

  test('lerp at 0 and 1 returns the end palettes', () {
    final a = SkyPalette.forPhase(SkyPhase.day);
    final b = SkyPalette.forPhase(SkyPhase.night);
    expect(a.lerp(b, 0).sheet, a.sheet);
    expect(a.lerp(b, 1).sheet, b.sheet);
    expect(a.lerp(b, .5).moonAmount, closeTo(.5, 1e-9));
  });
}