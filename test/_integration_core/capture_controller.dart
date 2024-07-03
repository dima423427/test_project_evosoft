import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'blocked_text_image.dart';
import 'integration_tester.dart';
import 'merger/images_merge_helper.dart';

class CaptureController {
  WidgetTester tester;
  List<ui.Image> images = [];
  String fileName = '';
  bool obscureText;

  CaptureController({
    required this.obscureText,
    required this.tester,
    required this.fileName,
  });

  Future<ui.Image> capture({bool pumpAndSettle = true}) async {
    if (pumpAndSettle) {
      await tester.pumpAndSettle();
    }

    var renderObject = tester.renderObject(find.byKey(rootKey));
    while (!renderObject.isRepaintBoundary) {
      renderObject = renderObject.parent!;
    }
    final layer = renderObject.debugLayer! as OffsetLayer;
    if (obscureText) {
      BlockedTextPaintingContext(
        containerLayer: layer,
        estimatedBounds: renderObject.paintBounds,
      ).paintSingleChild(renderObject);
    }

    ui.Image image = await layer.toImage(renderObject.paintBounds);

    images.add(image);

    return image;
  }

  Future<ui.Image> result() async {
    if (images.isEmpty) {
      throw 'images is empty';
    }

    ui.Image image = await ImagesMergeHelper.margeImages(
      images,
      fit: false,
      direction: Axis.horizontal,
      backgroundColor: Colors.white,
    );

    return image;
  }

  Future<void> writeFile({String? filePath}) async {
    ui.Image image = await result();
    await tester.runAsync(() async {
      await _writeFileImage(image: image, filePath: filePath);
    });
  }

  Future<void> _writeFileImage({
    required ui.Image image,
    String? filePath,
  }) async {
    ByteData bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
    File file = File(filePath ?? getFilePath());
    file.createSync(recursive: true);
    file.writeAsBytesSync(bytes.buffer.asInt8List(), flush: true);
  }

  String getFilePath() {
    Uri basedir = (goldenFileComparator as dynamic).basedir;
    String path = basedir.path;
    path = path.replaceAll(File('').absolute.uri.path, '');
    return '$path$fileName.png';
  }

  void dispose() {
    images.clear();
  }
}
