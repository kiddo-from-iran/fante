import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/app/app.dart';
import 'package:frontend/config/url_strategy_stub.dart'
    if (dart.library.html) 'package:frontend/config/url_strategy_web.dart';

Future<void> run([
  List<DeviceOrientation> orientations = const [
    DeviceOrientation.portraitUp,
  ],
]) async {
  WidgetsFlutterBinding.ensureInitialized();
  configureUrlStrategy();

  await SystemChrome.setPreferredOrientations(orientations);

  _runApp();
}

void _runApp() {
  runApp(const MyApp());
}
