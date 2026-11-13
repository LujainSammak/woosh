import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/sky_palette.dart';

/// What the landscape should show. Map your own WMO-based condition to this
/// with one switch (see INTEGRATION.md).
enum SceneWeather { clear, partlyCloudy, overcast, fog, rain, snow, storm }

extension on SceneWeather {
  /// How much the sky greys out (0 = untouched).
  double get dim => switch (this) {
        SceneWeather.clear => 0,
        SceneWeather.partlyCloudy => .08,
        SceneWeather.overcast => .30,
        SceneWeather.fog => .25,
        SceneWeather.rain => .38,
        SceneWeather.snow => .22,
        SceneWeather.storm => .55,
      };

  int get cloudCount => switch (this) {
        SceneWeather.clear => 2,
        SceneWeather.partlyCloudy => 3,
        SceneWeather.overcast => 5,
        SceneWeather.fog => 2,
        SceneWeather.rain => 5,
        SceneWeather.snow => 4,
        SceneWeather.storm => 5,
      };

  double get cloudAlpha => switch (this) {
        SceneWeather.clear => .14,
        SceneWeather.partlyCloudy => .26,
        _ => .38,
      };
}

/// The illustrated landscape. Fills whatever box it is given.
///
/// Colors come from [SkyPalette] in the current Theme, so they cross-fade with
/// the theme. [sunProgress] is 0 at sunrise, 1 at sunset (clamped), so the sun
/// really travels along its arc with the location's own sunrise and sunset.
class SkyScene extends StatelessWidget {
  const SkyScene({
    super.key,
    this.sunProgress = .5,
    this.weather = SceneWeather.clear,
  });

  final double sunProgress;
  final SceneWeather weather;

  @override
  Widget build(BuildContext context) {
    final palette = SkyPalette.of(context);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final still = MediaQuery.disableAnimationsOf(context);
    return ExcludeSemantics(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: weather.dim),
        duration: still ? Duration.zero : const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
        builder: (context, dim, _) => RepaintBoundary(
          child: CustomPaint(
            size: Size.infinite,
            painter: _SkyPainter(
              palette: palette,
              sunProgress: sunProgress,
              weather: weather,
              dim: dim,
              rtl: rtl,
            ),
          ),
        ),
      ),
    );
  }
}

class _SkyPainter extends CustomPainter {
  _SkyPainter({
    required this.palette,
    required this.sunProgress,
    required this.weather,
    required this.dim,
    required this.rtl,
  });

  final SkyPalette palette;
  final double sunProgress;
  final SceneWeather weather;
  final double dim;
  final bool rtl;

  static const _storm = Color(0xFF5E6A79);
  static const _clouds = [
    (.18, .20, 1.0),
    (.78, .33, .75),
    (.50, .14, .60),
    (.30, .38, .70),
    (.90, .18, .55),
  ];

  Color _sky(Color c) => Color.lerp(c, _storm, dim)!;
  Color _land(Color c) => Color.lerp(c, _storm, dim * .45)!;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final rect = Offset.zero & size;
    // Celestial bodies mirror in right-to-left layouts so they never sit
    // behind the text block.
    double fx(double f) => (rtl ? 1 - f : f) * w;
    const top = Alignment.topCenter, bottom = Alignment.bottomCenter;

    // Sky.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: top,
          end: bottom,
          colors: [_sky(palette.skyTop), _sky(palette.skyMid), _sky(palette.skyHorizon)],
          stops: const [0, .52, .80],
        ).createShader(rect),
    );
    // Quiet scrim so white text stays readable on every phase.
    final scrim = Rect.fromLTWH(0, 0, w, h * .5);
    canvas.drawRect(
      scrim,
      Paint()
        ..shader = LinearGradient(
          begin: top,
          end: bottom,
          colors: [Colors.black.withValues(alpha: .20), Colors.black.withValues(alpha: 0)],
        ).createShader(scrim),
    );

    // Stars.
    if (palette.starAmount > 0) {
      final rng = math.Random(8);
      final fade = (1 - dim * 1.6).clamp(0.0, 1.0).toDouble();
      final p = Paint();
      for (var i = 0; i < 40; i++) {
        final sx = rng.nextDouble() * w;
        final sy = rng.nextDouble() * h * .5;
        final r = rng.nextDouble() * 1.5 + .5;
        final a = rng.nextDouble() * .7 + .2;
        p.color = Colors.white.withValues(alpha: a * palette.starAmount * fade);
        canvas.drawCircle(Offset(sx, sy), r, p);
      }
    }

    // Sun on its arc.
    final t = sunProgress.clamp(0.0, 1.0).toDouble();
    final horizonY = h * .60, peakY = h * .30;
    final sun = Offset(fx(.28 + .62 * t), horizonY - math.sin(math.pi * t) * (horizonY - peakY));
    final sunA = (palette.sunAmount * (1 - dim * 1.4)).clamp(0.0, 1.0).toDouble();
    if (sunA > 0) {
      canvas.drawCircle(
        sun,
        120,
        Paint()
          ..shader = RadialGradient(colors: [
            palette.sunColor.withValues(alpha: .55 * sunA),
            palette.sunColor.withValues(alpha: 0),
          ]).createShader(Rect.fromCircle(center: sun, radius: 120)),
      );
      canvas.drawCircle(sun, 26, Paint()..color = palette.sunColor.withValues(alpha: sunA));
    }

    // Moon (a true crescent, cut out of the disc rather than painted over).
    final moonA = (palette.moonAmount * (1 - dim * 1.2)).clamp(0.0, 1.0).toDouble();
    if (moonA > 0) {
      final m = Offset(fx(.74), h * .27);
      canvas.drawCircle(
        m,
        90,
        Paint()
          ..shader = RadialGradient(colors: [
            palette.moonColor.withValues(alpha: .22 * moonA),
            palette.moonColor.withValues(alpha: 0),
          ]).createShader(Rect.fromCircle(center: m, radius: 90)),
      );
      final disc = Path()..addOval(Rect.fromCircle(center: m, radius: 24));
      final bite = Path()..addOval(Rect.fromCircle(center: m.translate(rtl ? -11 : 11, -7), radius: 21));
      canvas.drawPath(
        Path.combine(PathOperation.difference, disc, bite),
        Paint()..color = palette.moonColor.withValues(alpha: moonA),
      );
    }

    // Clouds: more and darker as the weather worsens.
    final cloudColor = Color.lerp(Colors.white, const Color(0xFF3E4756), (dim * 1.3).clamp(0.0, 1.0).toDouble())!;
    final cloudPaint = Paint()..color = cloudColor.withValues(alpha: weather.cloudAlpha);
    for (var i = 0; i < weather.cloudCount && i < _clouds.length; i++) {
      final c = _clouds[i];
      _cloud(canvas, Offset(c.$1 * w, c.$2 * h), c.$3, cloudPaint);
    }

    // Three layers of hills, far to near.
    final far = Path()
      ..moveTo(0, h * .62)
      ..quadraticBezierTo(w * .18, h * .47, w * .37, h * .60)
      ..quadraticBezierTo(w * .63, h * .72, w, h * .56)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    _fill(canvas, far, rect, _land(palette.hillFar), _land(Color.lerp(palette.hillFar, palette.hillMid, .7)!));

    final mid = Path()
      ..moveTo(0, h * .69)
      ..quadraticBezierTo(w * .30, h * .56, w * .52, h * .68)
      ..quadraticBezierTo(w * .78, h * .79, w, h * .62)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    _fill(canvas, mid, rect, _land(palette.hillMid), _land(Color.lerp(palette.hillMid, palette.hillNear, .6)!));

    final near = Path()
      ..moveTo(0, h * .76)
      ..quadraticBezierTo(w * .26, h * .65, w * .47, h * .77)
      ..quadraticBezierTo(w * .70, h * .87, w, h * .70)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    _fill(canvas, near, rect, _land(palette.hillNear), _land(Color.lerp(palette.hillNear, palette.tree, .35)!));

    // River.
    final river = Path()
      ..moveTo(w * .20, h)
      ..cubicTo(w * .25, h * .88, w * .58, h * .91, w * .72, h * .77)
      ..cubicTo(w * .60, h * .82, w * .42, h * .83, w * .38, h * .90)
      ..cubicTo(w * .33, h * .95, w * .29, h * .97, w * .27, h)
      ..close();
    canvas.drawPath(river, Paint()..color = _land(palette.water).withValues(alpha: .9));

    // Trees.
    final treeColor = _land(palette.tree);
    _tree(canvas, Offset(w * .16, h * .73), h * .18, treeColor);
    _tree(canvas, Offset(w * .84, h * .71), h * .10, treeColor);
    _tree(canvas, Offset(w * .91, h * .72), h * .08, treeColor);

    // Fog banks.
    if (weather == SceneWeather.fog) {
      for (final fy in const [.50, .60, .70]) {
        final band = Rect.fromLTWH(0, h * (fy - .06), w, h * .12);
        canvas.drawRect(
          band,
          Paint()
            ..shader = LinearGradient(begin: top, end: bottom, colors: [
              Colors.white.withValues(alpha: 0),
              Colors.white.withValues(alpha: .38),
              Colors.white.withValues(alpha: 0),
            ]).createShader(band),
        );
      }
    }

    // Rain.
    final streaks = switch (weather) {
      SceneWeather.rain => 70,
      SceneWeather.storm => 110,
      _ => 0,
    };
    if (streaks > 0) {
      final rng = math.Random(3);
      final p = Paint()
        ..color = Colors.white.withValues(alpha: .38)
        ..strokeWidth = 1.3
        ..strokeCap = StrokeCap.round;
      for (var i = 0; i < streaks; i++) {
        final sx = rng.nextDouble() * (w + 20);
        final sy = rng.nextDouble() * h * .96;
        final len = 12 + rng.nextDouble() * 10;
        canvas.drawLine(Offset(sx, sy), Offset(sx - len * .25, sy + len), p);
      }
    }

    // Snow.
    if (weather == SceneWeather.snow) {
      final rng = math.Random(5);
      final p = Paint()..color = Colors.white.withValues(alpha: .85);
      for (var i = 0; i < 60; i++) {
        canvas.drawCircle(
          Offset(rng.nextDouble() * w, rng.nextDouble() * h * .96),
          rng.nextDouble() * 1.8 + 1.4,
          p,
        );
      }
    }
  }

  void _fill(Canvas canvas, Path path, Rect rect, Color topColor, Color bottomColor) {
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [topColor, bottomColor],
        ).createShader(rect),
    );
  }

  void _cloud(Canvas canvas, Offset o, double s, Paint paint) {
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: o.translate(0, 8 * s), width: 120 * s, height: 26 * s),
        Radius.circular(13 * s),
      ))
      ..addOval(Rect.fromCircle(center: o.translate(-28 * s, -4 * s), radius: 19 * s))
      ..addOval(Rect.fromCircle(center: o.translate(0, -14 * s), radius: 26 * s))
      ..addOval(Rect.fromCircle(center: o.translate(30 * s, -3 * s), radius: 18 * s));
    canvas.drawPath(path, paint);
  }

  void _tree(Canvas canvas, Offset base, double height, Color color) {
    final trunk = Paint()
      ..color = color.withValues(alpha: .85)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(base, base.translate(0, -height * .75), trunk);
    final leaves = Paint()..color = color.withValues(alpha: .86);
    canvas.drawOval(Rect.fromCenter(center: base.translate(-5, -height * .62), width: height * .43, height: height * .60), leaves);
    canvas.drawOval(Rect.fromCenter(center: base.translate(4, -height * .78), width: height * .43, height: height * .63), leaves);
    canvas.drawOval(Rect.fromCenter(center: base.translate(-1, -height * .92), width: height * .35, height: height * .45), leaves);
  }

  @override
  bool shouldRepaint(_SkyPainter old) =>
      old.palette != palette ||
      old.sunProgress != sunProgress ||
      old.weather != weather ||
      old.dim != dim ||
      old.rtl != rtl;
}
