import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_project/main.dart';

import 'capture_controller.dart';
import 'override/matcher.dart';

Key rootKey = Key('golden_test_root');

Future<void> integrationTest({
  required String fileName,
  String? fileNamePrefix,
  String? fileFolderName,
  Future<void> Function()? setUp,
  required Future<void> Function(
    CaptureController controller,
    WidgetTester tester,
  ) testRunner,
}) async {
  _test(
    obscureText: false,
    fileName: fileName,
    fileFolderName: fileFolderName,
    screenWidth: 1100,
    screenHeight: 2400,
    fileNamePrefix: fileNamePrefix,
    setUp: setUp,
    builder: () {
      return App();
    },
    testRunner: testRunner,
  );
}

void _test({
  required bool obscureText,
  required String fileName,
  String? fileNamePrefix,
  String? fileFolderName,
  required double screenWidth,
  required double screenHeight,
  Future<void> Function()? setUp,
  required Widget Function() builder,
  required Future<void> Function(
    CaptureController controller,
    WidgetTester tester,
  ) testRunner,
}) {
  late CaptureController controller;

  testWidgets('Integration golden test: $fileName', (tester) async {
    await tester.runAsync(() async {
      await loadFonts();
    });

    //  Имя должно содержать все префиксы, для корректного создания файлов с ошибками. Иначе перезапишутся поверх друг-друга файлы с разных конфигураций
    controller = CaptureController(
      fileName:
          'golden/${fileFolderName ?? fileName}/${fileNamePrefix == null ? '' : '${fileNamePrefix}_'}$fileName',
      tester: tester,
      obscureText: obscureText,
    );
    tester.view.physicalSize = Size(screenWidth, screenHeight);
    await tester.binding.setSurfaceSize(
      Size(
        screenWidth / tester.view.devicePixelRatio,
        screenHeight / tester.view.devicePixelRatio,
      ),
    );

    if (setUp != null) {
      await setUp.call();
    }

    await tester.pumpWidget(
      Container(
        key: rootKey,
        padding: EdgeInsets.only(left: 4, right: 4),
        color: Colors.black,
        child: builder.call(),
      ),
    );
    await testRunner.call(controller, tester);
    await tester.pumpAndSettle();

    if (autoUpdateGoldenFiles) {
      await controller.writeFile();
    } else {
      await expectLater(
        await controller.result(),
        MatchesGoldenFileCustom(
          File(controller.getFilePath()).absolute.uri,
          null,
          tolerance: 0.0,
        ),
      );
    }

    await tester.binding.setSurfaceSize(null);
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Future<void> loadFonts() async {
  final bundle = rootBundle;
  final fontManifestString = await bundle.loadString('FontManifest.json');
  List<Map<String, dynamic>> fontManifest =
      (json.decode(fontManifestString) as List<dynamic>)
          .map((dynamic x) => x as Map<String, dynamic>)
          .toList();

  for (final entry in fontManifest) {
    final family = (entry['family'] as String).stripFontFamilyPackageName();

    final fontAssets = [
      for (final fontAssetEntry in entry['fonts'] as List<dynamic>)
        (fontAssetEntry as Map<String, dynamic>)['asset'] as String,
    ];

    final loader = FontLoader(family);
    for (final fontAsset in fontAssets) {
      loader.addFont(bundle.load(fontAsset));
    }

    await loader.load();
  }
}

extension FontFamilyStringExtensions on String {
  /// Strips the package name from this font family for use in golden tests.
  String stripFontFamilyPackageName() {
    return replaceAll(RegExp(r'packages/[^/]*/'), '');
  }
}
