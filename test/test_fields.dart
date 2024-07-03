import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_integration_core/integration_tester.dart';


//По моей логике будет 3 итерации, в ходе которых по одному пройдут мои тест сценарии. По скольку проект не большой, то так
//возможно сделать более разумно, ибо можно проследить, что происходит на каждой итерации

void main() async {
  await integrationTest(
    fileFolderName: 'screen_test_fields',
    fileName: 'screen_test_fields_fill_first',
    testRunner: (controller, tester) async {
      //  Делайем скриншот первого экрана
      await controller.capture();

      //  Переходим к экрану с полями
      await tester.tap(find.text('Поля'));
      await controller.capture();

      //  Заполняем первое поле
      await tester.enterText(find.byKey(Key('field1')), 'test');
      await controller.capture();

      //  Пробуем нажать на кнопку чтобы убедиться что ничего не произошло
      await tester.tap(find.text('Проверка'));
      await controller.capture();
    },
  );
  await integrationTest(
    fileFolderName: 'screen_test_fields',
    fileName: 'screen_test_fields_fill_first',
    testRunner: (controller, tester) async {
      //  Делайем скриншот первого экрана
      await controller.capture();

      //  Переходим к экрану с полями
      await tester.tap(find.text('Поля'));
      await controller.capture();

      //  Заполняем второе поле
      await tester.enterText(find.byKey(Key('field2')), '');
      await controller.capture();

      //  Пробуем нажать на кнопку чтобы убедиться что ничего не произошло
      await tester.tap(find.text('Проверка'));
      await controller.capture();
    },
  );
  await integrationTest(
    fileFolderName: 'screen_test_fields',
    fileName: 'screen_test_fields_fill_first',
    testRunner: (controller, tester) async {
      //  Делайем скриншот первого экрана
      await controller.capture();

      //  Переходим к экрану с полями
      await tester.tap(find.text('Поля'));
      await controller.capture();

      //  Заполняем третье поле
      var fdfd = (tester.enterText(find.byKey(Key('field3')), '12345'));
      await (fdfd.toString().length > 4, isTrue);

      await controller.capture();

      //  Пробуем нажать на кнопку чтобы убедиться что ничего не произошло
      await tester.tap(find.text('Проверка'));
      await controller.capture();
    },
  );
}
