final class VersionInfoEntity {
  final String currentVersion;
  final String latestVersion;
  final String minVersion;
  final bool updateAvailable;
  final bool updateRequired;

  VersionInfoEntity({
    required this.currentVersion,
    required this.latestVersion,
    required this.minVersion,
    required this.updateAvailable,
    required this.updateRequired,
  });
}
