import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '_integration_core/integration_tester.dart';
import 'package:test_project/screen_checkers.dart'; // Замените на правильный путь к вашему виджету

Future<void> main() async {
  await integrationTest(
    fileFolderName: 'test_checkers',
    fileName: 'test_checkers',
    testRunner: (controller, tester) async {

      await tester.pumpWidget(MaterialApp(home: ScreenCheckers()));
      await tester.pumpAndSettle();

      await controller.capture();

      expect(find.byType(MaterialButton), findsOneWidget);
      MaterialButton button = tester.widget(find.byType(MaterialButton));
      expect(button.onPressed, isNull);
      await controller.capture();

      // Вкл Switch 1
      await tester.tap(find.byKey(Key('swithc1')));
      await tester.pumpAndSettle();
      await controller.capture();

      button = tester.widget(find.byType(MaterialButton));
      expect(button.onPressed, isNull);
      await controller.capture();

      // Вкл Switch 3
      await tester.tap(find.byKey(Key('swithc3')));
      await tester.pumpAndSettle();
      await controller.capture();

      button = tester.widget(find.byType(MaterialButton));
      expect(button.onPressed, isNotNull);
      await controller.capture();

      // Вкл Switch 2
      await tester.tap(find.byKey(Key('swithc2')));
      await tester.pumpAndSettle();
      await controller.capture();

      button = tester.widget(find.byType(MaterialButton));
      expect(button.onPressed, isNull);
      await controller.capture();
    },
  );
}
