import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_integration_core/integration_tester.dart';


void main() async {
  await integrationTest(
    fileFolderName: 'screen_fields',
    fileName: 'screen_fields_fill_all',
    testRunner: (controller, tester) async {
      //  Переходим к экрану с полями
      await tester.tap(find.text('Поля'));
      await controller.capture();
      await tester.pumpAndSettle();

      //1 - слово тест
      await tester.enterText(find.byKey(Key('field1')), 'test');
      await tester.pumpAndSettle();
      await controller.capture();

      expect(find.text('test'), findsOneWidget);
      await controller.capture();

      //2 - пустое поле
      await tester.enterText(find.byKey(Key('field2')), '');
      await tester.pumpAndSettle();
      await controller.capture();

      expect(find.text(''), findsOneWidget);
      await controller.capture();

      //3 - не менее 5 сим
      await tester.enterText(find.byKey(Key('field2')), '12345');
      await tester.pumpAndSettle();
      await controller.capture();

      String field3Value = (tester.widget(find.byKey(Key('field3'))) as TextField).controller.text;
      expect(field3Value.length > 4, isTrue);
      await controller.capture();

      await tester.tap(find.text('Проверка'));
      await tester.pumpAndSettle();
      await controller.capture();
    },
  );
}
