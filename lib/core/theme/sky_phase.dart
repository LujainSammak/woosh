enum SkyPhase { dawn, day, sunset, night }

/// Decides the phase from the real sunrise/sunset times (from the API),
/// not from a fixed clock hour.
SkyPhase skyPhaseFor(DateTime now, DateTime sunrise, DateTime sunset) {
  final dawnStart = sunrise.subtract(const Duration(minutes: 45));
  final dawnEnd = sunrise.add(const Duration(minutes: 75));
  final sunsetStart = sunset.subtract(const Duration(minutes: 75));
  final sunsetEnd = sunset.add(const Duration(minutes: 45));

  if (!now.isBefore(dawnStart) && now.isBefore(dawnEnd)) return SkyPhase.dawn;
  if (!now.isBefore(dawnEnd) && now.isBefore(sunsetStart)) return SkyPhase.day;
  if (!now.isBefore(sunsetStart) && now.isBefore(sunsetEnd)) {
    return SkyPhase.sunset;
  }
  return SkyPhase.night;
}