import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/app/app.dart';

void main() {
  testWidgets('Auth landing page renders', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MyApp());

    expect(find.text('به Fante Quiz خوش آمدید!'), findsOneWidget);
    expect(find.text('ورود'), findsOneWidget);
    expect(find.text('ثبت‌نام'), findsOneWidget);
  });
}
