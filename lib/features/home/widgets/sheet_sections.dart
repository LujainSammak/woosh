import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/sky_palette.dart';

const _tabular = [FontFeature.tabularFigures()];

// ---------------------------------------------------------------------------
// Section wrapper
// ---------------------------------------------------------------------------

class SheetSection extends StatelessWidget {
  const SheetSection({super.key, required this.title, this.trailing, required this.child});

  final String title;

  /// Small note on the far side of the title, for example "Updated 15:20".
  final String? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = SkyPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(title, style: TextStyle(color: p.ink, fontSize: 18, fontWeight: FontWeight.w600)),
              ),
            ),
            if (trailing != null) Text(trailing!, style: TextStyle(color: p.inkMuted, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Alerts (umbrella, sunscreen, wind, heat, cold)
// ---------------------------------------------------------------------------

enum AlertKind { umbrella, sunscreen, wind, heat, cold }

class AlertTile extends StatelessWidget {
  const AlertTile({super.key, required this.kind, required this.title, this.message = ''});

  final AlertKind kind;
  final String title;
  final String message;

  static (IconData, Color) _look(AlertKind kind) => switch (kind) {
        AlertKind.umbrella => (Icons.umbrella_rounded, const Color(0xFF3C8DDE)),
        AlertKind.sunscreen => (Icons.wb_sunny_rounded, const Color(0xFFE8A21A)),
        AlertKind.wind => (Icons.air_rounded, const Color(0xFF2FA5A0)),
        AlertKind.heat => (Icons.thermostat_rounded, const Color(0xFFE0583A)),
        AlertKind.cold => (Icons.ac_unit_rounded, const Color(0xFF4FB3E8)),
      };

  @override
  Widget build(BuildContext context) {
    final p = SkyPalette.of(context);
    final (icon, tint) = _look(kind);
    return Semantics(
      container: true,
      label: '$title. $message',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: tint.withValues(alpha: .16), borderRadius: BorderRadius.circular(20)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: p.ink, fontSize: 16, fontWeight: FontWeight.w600, height: 1.3)),
                    const SizedBox(height: 2),
                    if (message.isNotEmpty) Text(message, style: TextStyle(color: p.ink, fontSize: 14, height: 1.35)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hourly strip
// ---------------------------------------------------------------------------

class HourlyEntry {
  const HourlyEntry({
    required this.label,
    required this.icon,
    required this.temp,
    this.rain,
    this.isNow = false,
  });

  final String label;
  final Widget icon;
  final String temp;

  /// Shown only when there is something to say, for example "40%".
  final String? rain;
  final bool isNow;
}

class HourlyStrip extends StatelessWidget {
  const HourlyStrip({super.key, required this.entries});

  final List<HourlyEntry> entries;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [for (final e in entries) _HourCell(e)],
      ),
    );
  }
}

class _HourCell extends StatelessWidget {
  const _HourCell(this.e);

  final HourlyEntry e;

  @override
  Widget build(BuildContext context) {
    final p = SkyPalette.of(context);
    final spoken = [e.label, e.temp, if (e.rain != null) e.rain!].join(', ');
    return Semantics(
      container: true,
      label: spoken,
      child: ExcludeSemantics(
        child: Container(
          width: 64,
          margin: const EdgeInsetsDirectional.only(end: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: e.isNow ? p.accent.withValues(alpha: .12) : null,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                e.label,
                style: TextStyle(
                  color: e.isNow ? p.ink : p.inkMuted,
                  fontSize: 13,
                  fontWeight: e.isNow ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox.square(dimension: 28, child: FittedBox(child: e.icon)),
              const SizedBox(height: 8),
              Text(
                e.temp,
                style: TextStyle(color: p.ink, fontSize: 16, fontWeight: FontWeight.w600, fontFeatures: _tabular),
              ),
              const SizedBox(height: 2),
              Visibility(
                visible: e.rain != null,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Text(
                  e.rain ?? '0%',
                  style: TextStyle(color: p.accent, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Daily list with temperature range bars
// ---------------------------------------------------------------------------

class DailyEntry {
  const DailyEntry({
    required this.label,
    required this.icon,
    required this.lowText,
    required this.highText,
    required this.low,
    required this.high,
    this.rain,
  });

  final String label;
  final Widget icon;
  final String lowText;
  final String highText;

  /// Numeric values in the displayed unit; only used to size the range bar.
  final double low;
  final double high;
  final String? rain;
}

class DailyList extends StatelessWidget {
  const DailyList({super.key, required this.entries});

  final List<DailyEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    final p = SkyPalette.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    final weekMin = entries.map((e) => e.low).reduce(math.min);
    final weekMax = entries.map((e) => e.high).reduce(math.max);

    return Column(
      children: [
        for (var i = 0; i < entries.length; i++) ...[
          if (i > 0) Divider(height: 1, thickness: 1, color: p.hairline),
          Semantics(
            container: true,
            label: '${entries[i].label}: ${entries[i].lowText} / ${entries[i].highText}',
            child: ExcludeSemantics(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: scaler.scale(72),
                      child: Text(
                        entries[i].label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: p.ink, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox.square(dimension: 28, child: FittedBox(child: entries[i].icon)),
                    SizedBox(
                      width: scaler.scale(44),
                      child: Text(
                        entries[i].rain ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: p.accent, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      width: scaler.scale(38),
                      child: Text(
                        entries[i].lowText,
                        textAlign: TextAlign.end,
                        style: TextStyle(color: p.inkMuted, fontSize: 15, fontFeatures: _tabular),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _RangeBar(
                        min: weekMin,
                        max: weekMax,
                        low: entries[i].low,
                        high: entries[i].high,
                        track: p.hairline,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: scaler.scale(38),
                      child: Text(
                        entries[i].highText,
                        textAlign: TextAlign.end,
                        style: TextStyle(color: p.ink, fontSize: 15, fontWeight: FontWeight.w600, fontFeatures: _tabular),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _RangeBar extends StatelessWidget {
  const _RangeBar({
    required this.min,
    required this.max,
    required this.low,
    required this.high,
    required this.track,
  });

  final double min, max, low, high;
  final Color track;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final span = (max - min) == 0 ? 1.0 : (max - min);
      final w = c.maxWidth;
      final len = math.max(8.0, ((high - low) / span) * w);
      final start = (((low - min) / span) * w).clamp(0.0, math.max(0.0, w - len)).toDouble();
      return SizedBox(
        height: 6,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(decoration: BoxDecoration(color: track, borderRadius: BorderRadius.circular(3))),
            ),
            PositionedDirectional(
              start: start,
              width: len,
              top: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  gradient: const LinearGradient(
                    begin: AlignmentDirectional.centerStart,
                    end: AlignmentDirectional.centerEnd,
                    colors: [Color(0xFF6EC1F0), Color(0xFFF5B85A)],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ---------------------------------------------------------------------------
// Details: stat grid, UV scale, sun arc
// ---------------------------------------------------------------------------

class StatBlock extends StatelessWidget {
  const StatBlock({super.key, required this.label, required this.value, this.caption, this.trailing});

  final String label;
  final String value;
  final String? caption;

  /// For example a small wind-direction arrow.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final p = SkyPalette.of(context);
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: p.inkMuted, fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Row(
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(color: p.ink, fontSize: 30, fontWeight: FontWeight.w300, fontFeatures: _tabular),
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            ],
          ),
          if (caption != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(caption!, style: TextStyle(color: p.inkMuted, fontSize: 13, height: 1.3)),
            ),
        ],
      ),
    );
  }
}

/// Lays stats out two per row, separated by hairlines.
class StatGrid extends StatelessWidget {
  const StatGrid({super.key, required this.stats});

  final List<StatBlock> stats;

  @override
  Widget build(BuildContext context) {
    final p = SkyPalette.of(context);
    return Column(
      children: [
        for (var i = 0; i < stats.length; i += 2) ...[
          if (i > 0) Divider(height: 1, thickness: 1, color: p.hairline),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: stats[i]),
                const SizedBox(width: 16),
                Expanded(child: i + 1 < stats.length ? stats[i + 1] : const SizedBox.shrink()),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class UvScale extends StatelessWidget {
  const UvScale({
    super.key,
    required this.label,
    required this.value,
    required this.level,
    required this.uv,
    this.caption,
  });

  final String label;
  final String value;

  /// Word for the level, for example "High".
  final String level;

  /// Numeric UV index, used to place the marker on the 0 to 11 scale.
  final double uv;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final p = SkyPalette.of(context);
    const dot = 18.0;
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: p.inkMuted, fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: TextStyle(color: p.ink, fontSize: 30, fontWeight: FontWeight.w300, fontFeatures: _tabular)),
              const SizedBox(width: 12),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(level, style: TextStyle(color: p.ink, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(builder: (context, c) {
            final f = (uv / 11).clamp(0.0, 1.0).toDouble();
            return SizedBox(
              height: dot,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: const LinearGradient(
                        begin: AlignmentDirectional.centerStart,
                        end: AlignmentDirectional.centerEnd,
                        colors: [
                          Color(0xFF4CAF50),
                          Color(0xFFFFD54F),
                          Color(0xFFFF9800),
                          Color(0xFFF44336),
                          Color(0xFF8E5BD6),
                        ],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    start: f * (c.maxWidth - dot),
                    child: Container(
                      width: dot,
                      height: dot,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: p.sheet,
                        border: Border.all(color: p.ink, width: 3),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          if (caption != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(caption!, style: TextStyle(color: p.inkMuted, fontSize: 13, height: 1.3)),
            ),
        ],
      ),
    );
  }
}

class SunArc extends StatelessWidget {
  const SunArc({
    super.key,
    required this.sunriseLabel,
    required this.sunrise,
    required this.sunsetLabel,
    required this.sunset,
    this.progress,
  });

  final String sunriseLabel;
  final String sunrise;
  final String sunsetLabel;
  final String sunset;

  /// 0 at sunrise, 1 at sunset. Null hides the sun (night).
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final p = SkyPalette.of(context);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    Widget time(String label, String value, CrossAxisAlignment align) => MergeSemantics(
          child: Column(
            crossAxisAlignment: align,
            children: [
              Text(label, style: TextStyle(color: p.inkMuted, fontSize: 14, fontWeight: FontWeight.w500)),
              Text(value, style: TextStyle(color: p.ink, fontSize: 20, fontWeight: FontWeight.w500, fontFeatures: _tabular)),
            ],
          ),
        );
    return Column(
      children: [
        ExcludeSemantics(
          child: SizedBox(
            height: 96,
            width: double.infinity,
            child: CustomPaint(
              painter: _ArcPainter(
                line: p.inkMuted,
                accent: const Color(0xFFF2A900),
                sun: const Color(0xFFF2A900),
                progress: progress,
                rtl: rtl,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: time(sunriseLabel, sunrise, CrossAxisAlignment.start)),
            Expanded(child: time(sunsetLabel, sunset, CrossAxisAlignment.end)),
          ],
        ),
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({
    required this.line,
    required this.accent,
    required this.sun,
    required this.progress,
    required this.rtl,
  });

  final Color line, accent, sun;
  final double? progress;
  final bool rtl;

  @override
  void paint(Canvas canvas, Size size) {
    if (rtl) {
      canvas.translate(size.width, 0);
      canvas.scale(-1, 1);
    }
    final base = size.height - 6;
    final rect = Rect.fromLTRB(14, 6, size.width - 14, base + (base - 6));
    final arc = Path()..addArc(rect, math.pi, math.pi);

    canvas.drawLine(
      Offset(0, base),
      Offset(size.width, base),
      Paint()
        ..color = line.withValues(alpha: .4)
        ..strokeWidth = 1.5,
    );

    final dashed = Paint()
      ..color = line.withValues(alpha: .55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final metric = arc.computeMetrics().first;
    for (double d = 0; d < metric.length; d += 10) {
      canvas.drawPath(metric.extractPath(d, math.min(d + 5, metric.length)), dashed);
    }

    final pr = progress;
    if (pr != null) {
      final len = metric.length * pr.clamp(0.0, 1.0).toDouble();
      canvas.drawPath(
        metric.extractPath(0, len),
        Paint()
          ..color = accent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
      final pos = metric.getTangentForOffset(len)!.position;
      canvas.drawCircle(pos, 16, Paint()..color = sun.withValues(alpha: .28));
      canvas.drawCircle(pos, 9, Paint()..color = sun);
    }
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.line != line || old.progress != progress || old.rtl != rtl || old.accent != accent;
}
