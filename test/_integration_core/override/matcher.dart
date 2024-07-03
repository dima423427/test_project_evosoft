import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class MatchesGoldenFileCustom extends MatchesGoldenFile {
  final double tolerance;

  const MatchesGoldenFileCustom(
    super.key,
    super.version, {
    required this.tolerance,
  });

  @override
  Future<String?> matchAsync(dynamic item) async {
    final Uri testNameUri = goldenFileComparator.getTestUri(key, version);

    Uint8List? buffer;
    if (item is Future<List<int>?>) {
      final List<int>? bytes = await item;
      buffer = bytes == null ? null : Uint8List.fromList(bytes);
    } else if (item is List<int>) {
      buffer = Uint8List.fromList(item);
    }
    if (buffer != null) {
      if (autoUpdateGoldenFiles) {
        await goldenFileComparator.update(testNameUri, buffer);
        return null;
      }
      try {
        final bool success =
            await goldenFileComparator.compare(buffer, testNameUri);
        return success ? null : 'does not match';
      } on TestFailure catch (ex) {
        return ex.message;
      }
    }
    Future<ui.Image?> imageFuture;
    final bool disposeImage;
    if (item is Future<ui.Image?>) {
      imageFuture = item;
      disposeImage = false;
    } else if (item is ui.Image) {
      imageFuture = Future<ui.Image>.value(item);
      disposeImage = false;
    } else if (item is Finder) {
      final Iterable<Element> elements = item.evaluate();
      if (elements.isEmpty) {
        return 'could not be rendered because no widget was found';
      } else if (elements.length > 1) {
        return 'matched too many widgets';
      }
      imageFuture = captureImage(elements.single);
      disposeImage = true;
    } else {
      throw AssertionError(
        'must provide a Finder, Image, Future<Image>, List<int>, or Future<List<int>>',
      );
    }

    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.instance;
    return binding.runAsync<String?>(() async {
      final ui.Image? image = await imageFuture;
      if (image == null) {
        throw AssertionError('Future<Image> completed to null');
      }
      try {
        final ByteData? bytes =
            await image.toByteData(format: ui.ImageByteFormat.png);
        if (bytes == null) {
          return 'could not encode screenshot.';
        }
        if (autoUpdateGoldenFiles) {
          await goldenFileComparator.update(
            testNameUri,
            bytes.buffer.asUint8List(),
          );
          return null;
        }
        try {
          final bool success = await goldenFileComparator
              .compare(bytes.buffer.asUint8List(), testNameUri)
              .onError((error, stackTrace) async {
            //  Добавлена проверка на толлерантность
            try {
              String split1 = 'Pixel test failed, ';
              String split2 = '% diff detected.';
              String text = '$error';
              text = text.substring(text.indexOf(split1));
              text = text.substring(split1.length);
              text = text.substring(0, text.indexOf(split2));
              double dif = double.parse(text);
              if (dif <= tolerance) {
                return true;
              }
            } catch (_) {}
            return false;
          });
          return success ? null : 'does not match';
        } on TestFailure catch (ex) {
          return ex.message;
        }
      } finally {
        if (disposeImage) {
          image.dispose();
        }
      }
    });
  }
}
