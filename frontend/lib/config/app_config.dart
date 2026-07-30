/// Application configuration.
class AppConfig {
  AppConfig({
    required this.url,
    this.googleWebClientId = '',
  });

  /// Base url.
  final String url;

  /// Google OAuth 2.0 Web client ID (from Google Cloud Console).
  final String googleWebClientId;

  AppConfig copyWith({
    String? url,
    String? googleWebClientId,
  }) =>
      AppConfig(
        url: url ?? this.url,
        googleWebClientId: googleWebClientId ?? this.googleWebClientId,
      );
}
