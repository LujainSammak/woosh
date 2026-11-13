import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/sky_palette.dart';
import '../../core/widgets/sky_scene.dart';

/// Page skeleton: the landscape fills the top, and the forecast sheet rises
/// over it. The sheet's top edge is shaped like one more hill, so the
/// landscape continues into the content.
class WeatherLayout extends StatelessWidget {
  const WeatherLayout({
    super.key,
    required this.header,
    required this.sections,
    this.sunProgress = .5,
    this.weather = SceneWeather.clear,
    this.onRefresh,
  });

  /// Usually a HeroHeader.
  final Widget header;

  /// Sheet content, top to bottom. Spacing between them is added for you.
  final List<Widget> sections;

  /// 0 at sunrise, 1 at sunset (from the API's real times).
  final double sunProgress;
  final SceneWeather weather;

  /// Pull-to-refresh. Leave null to disable.
  final Future<void> Function()? onRefresh;

  static const double _overlap = 40;

  @override
  Widget build(BuildContext context) {
    final p = SkyPalette.of(context);
    final mq = MediaQuery.of(context);
    final heroHeight = (mq.size.height * .60).clamp(440.0, 600.0).toDouble();
    final sheetMinHeight = mq.size.height - (heroHeight - _overlap);

    Widget scroll = SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // Laid out shorter than it is painted, so the sheet overlaps the sky.
          Align(
            alignment: Alignment.topCenter,
            heightFactor: (heroHeight - _overlap) / heroHeight,
            child: SizedBox(
              height: heroHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(child: SkyScene(sunProgress: sunProgress, weather: weather)),
                  Align(alignment: Alignment.topCenter, child: header),
                ],
              ),
            ),
          ),
          _Sheet(minHeight: sheetMinHeight, bottomInset: mq.padding.bottom, children: sections),
        ],
      ),
    );

    if (onRefresh != null) {
      scroll = RefreshIndicator(
        onRefresh: onRefresh!,
        edgeOffset: mq.padding.top + 8,
        color: p.accent,
        backgroundColor: p.sheet,
        child: scroll,
      );
    }

    final sheetIsLight = ThemeData.estimateBrightnessForColor(p.sheet) == Brightness.light;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: p.sheet,
        systemNavigationBarIconBrightness: sheetIsLight ? Brightness.dark : Brightness.light,
      ),
      // Behind the scroll view: sky color on top, sheet color below, so
      // iOS overscroll never shows a wrong color.
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0, .5, .5, 1],
            colors: [p.skyTop, p.skyTop, p.sheet, p.sheet],
          ),
        ),
        child: scroll,
      ),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({required this.minHeight, required this.bottomInset, required this.children});

  final double minHeight;
  final double bottomInset;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final p = SkyPalette.of(context);
    return ClipPath(
      clipper: const _HillEdge(),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: minHeight),
        color: p.sheet,
        padding: EdgeInsetsDirectional.fromSTEB(24, 52, 24, 32 + bottomInset),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(height: 32),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

class _HillEdge extends CustomClipper<Path> {
  const _HillEdge();

  @override
  Path getClip(Size size) => Path()
    ..moveTo(0, 22)
    ..quadraticBezierTo(size.width * .28, -6, size.width * .52, 14)
    ..quadraticBezierTo(size.width * .78, 32, size.width, 6)
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height)
    ..close();

  @override
  bool shouldReclip(_HillEdge oldClipper) => false;
}
