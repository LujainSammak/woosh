import 'package:flutter/material.dart';

import '../../../core/theme/sky_palette.dart';

/// Location bar plus the big temperature, drawn in white over the sky.
/// Every string comes from the caller, so it is already localized.
class HeroHeader extends StatelessWidget {
  const HeroHeader({
    super.key,
    required this.placeName,
    required this.dateText,
    required this.temperature,
    required this.condition,
    required this.feelsLike,
    this.highLow,
    this.conditionIcon,
    this.onSearch,
    this.onSettings,
    this.onUseMyLocation,
    this.useMyLocationLabel = 'Use my location',
    this.searchLabel = 'Change location',
    this.settingsLabel = 'Settings',
  });

  final String placeName;
  final String dateText;

  /// Already formatted in the user's unit, for example "23°".
  final String temperature;
  final String condition;

  /// Woosh's feels-like sentence, for example "Feels like 24° · humidity makes it feel warmer".
  final String feelsLike;
  final String? highLow;
  final Widget? conditionIcon;
  final VoidCallback? onSearch;
  final VoidCallback? onSettings;
  final VoidCallback? onUseMyLocation;
  final String useMyLocationLabel;
  final String searchLabel;
  final String settingsLabel;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    const shadow = [Shadow(color: Color(0x40000000), blurRadius: 12)];
    TextStyle s(double size, FontWeight weight, [double alpha = 1]) => TextStyle(
          color: SkyPalette.onSky.withValues(alpha: alpha),
          fontSize: size,
          fontWeight: weight,
          height: 1.25,
          shadows: shadow,
        );

    // The hero block keeps its layout up to 125% text size; the sheet below
    // scales fully.
    return MediaQuery(
      data: mq.copyWith(textScaler: mq.textScaler.clamp(maxScaleFactor: 1.25)),
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 24, end: 8, top: mq.padding.top + 4, bottom: 12),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Semantics(
                        button: true,
                        excludeSemantics: true,
                        label: '$placeName. $searchLabel',
                        child: InkWell(
                          onTap: onSearch,
                          borderRadius: BorderRadius.circular(24),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 48),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.place_outlined, color: Colors.white, size: 20),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(placeName, maxLines: 1, overflow: TextOverflow.ellipsis, style: s(18, FontWeight.w600)),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(Icons.expand_more_rounded, color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (onUseMyLocation != null)
                    IconButton(
                      tooltip: useMyLocationLabel,
                      onPressed: onUseMyLocation,
                      icon: const Icon(Icons.my_location_rounded),
                      color: Colors.white,
                    ),
                  IconButton(
                    tooltip: settingsLabel,
                    onPressed: onSettings,
                    icon: const Icon(Icons.tune_rounded),
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(dateText, style: s(15, FontWeight.w500, .92)),
              Semantics(
                excludeSemantics: true,
                label: '$temperature, $condition',
                child: Text(temperature, style: s(112, FontWeight.w300).copyWith(height: 1.0, letterSpacing: -4)),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (conditionIcon != null) ...[
                    IconTheme(data: const IconThemeData(color: Colors.white, size: 26), child: conditionIcon!),
                    const SizedBox(width: 8),
                  ],
                  Flexible(child: Text(condition, style: s(22, FontWeight.w600))),
                ],
              ),
              const SizedBox(height: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Text(feelsLike, style: s(15, FontWeight.w400, .95)),
              ),
              if (highLow != null) Text(highLow!, style: s(15, FontWeight.w400, .85)),
            ],
          ),
        ),
      ),
    );
  }
}