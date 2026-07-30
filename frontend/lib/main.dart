import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/app_runner.dart';
import 'package:frontend/config/app_config.dart';
import 'package:frontend/config/build_type.dart';
import 'package:frontend/config/environment.dart';
import 'package:frontend/data/repository/auth_repository.dart';

void main(List<String> args) {
  const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  Environment.init(
    buildType: kReleaseMode ? BuildType.release : BuildType.debug,
    config: AppConfig(
      url: apiBaseUrl.isEmpty ? 'http://localhost:8000' : apiBaseUrl,
      // Set your Google Cloud OAuth Web client ID here or via:
      // flutter run --dart-define=GOOGLE_WEB_CLIENT_ID=xxx.apps.googleusercontent.com
      googleWebClientId: const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID'),
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAuthInfo();
  run();
}
