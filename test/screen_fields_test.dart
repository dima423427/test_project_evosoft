import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_integration_core/integration_tester.dart';

void main() async {
  await integrationTest(
    fileFolderName: 'screen_fields',
    fileName: 'screen_fields_fill_first',
    testRunner: (controller, tester) async {
      //  Делайем скриншот первого экрана
      await controller.capture();

      //  Переходим к экрану с полями
      await tester.tap(find.text('Поля'));
      await controller.capture();

      //  Заполняем первое поле
      await tester.enterText(find.byKey(Key('field1')), 'test message');
      await controller.capture();

      //  Пробуем нажать на кнопку чтобы убедиться что ничего не произошло
      await tester.tap(find.text('Проверка'));
      await controller.capture();
    },
  );
  await integrationTest(
    fileFolderName: 'screen_fields',
    fileName: 'screen_fields_fill_all',
    testRunner: (controller, tester) async {
      //  Переходим к экрану с полями
      await tester.tap(find.text('Поля'));
      await controller.capture();

      //  Заполняем все поля
      await tester.enterText(find.byKey(Key('field1')), 'test message 1');
      await tester.enterText(find.byKey(Key('field2')), 'test message 2');
      await tester.enterText(find.byKey(Key('field3')), 'test message 3');
      await controller.capture();

      //  Пробуем нажать на кнопку чтобы убедиться что ничего не произошло
      await tester.tap(find.text('Проверка'));
      await controller.capture();
    },
  );
}
