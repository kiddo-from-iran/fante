import 'package:flutter/widgets.dart';
import 'package:frontend/app_runner.dart';
import 'package:frontend/config/app_config.dart';
import 'package:frontend/config/build_type.dart';
import 'package:frontend/config/environment.dart';
import 'package:frontend/data/repository/auth_repository.dart';

void main(List<String> args) {
  Environment.init(
    buildType: BuildType.debug,
    config: AppConfig(
      url: 'http://localhost:8000',
      // Set your Google Cloud OAuth Web client ID here or via:
      // flutter run --dart-define=GOOGLE_WEB_CLIENT_ID=xxx.apps.googleusercontent.com
      googleWebClientId: const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID'),
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAuthInfo();
  run();
}
