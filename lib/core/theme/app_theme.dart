import 'package:flutter/material.dart';

import 'sky_palette.dart';
import 'sky_phase.dart';

ThemeData themeFor(SkyPhase phase) {
  final p = SkyPalette.forPhase(phase);
  return ThemeData(
    useMaterial3: true,
    brightness: phase == SkyPhase.night ? Brightness.dark : Brightness.light,
    colorSchemeSeed: p.accent,
    scaffoldBackgroundColor: p.skyTop,
    extensions: [p],
  );
}