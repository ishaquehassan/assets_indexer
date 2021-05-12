import 'dart:async';
import 'package:assets_indexer/src/images_indexer.dart';
import 'package:build/build.dart';
import 'fonts_indexer.dart';
import 'utils.dart';

class AssetsBuilder implements Builder {
  AssetsBuilder(BuilderOptions options) {}

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    await indexImages(buildStep);
    await indexFonts();
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        ".jpg": [genFileSuffix],
        ".png": [genFileSuffix],
        ".webp": [genFileSuffix],
        ".gif": [genFileSuffix]
      };
}
