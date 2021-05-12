import 'dart:async';
import 'package:assets_indexer/src/images_indexer.dart';
import 'package:build/build.dart';
import 'fonts_indexer.dart';
import 'utils.dart';

class AssetsBuilder implements Builder {
  AssetsBuilder(BuilderOptions options) {}

  List<String> get imagesExt => [".jpg", ".png", ".webp", ".gif"];

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    if (imagesExt.contains(buildStep.fileExtension)) {
      await indexImages(buildStep);
    }
    await indexFonts();
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        ".jpg": [genFileSuffix],
        ".png": [genFileSuffix],
        ".webp": [genFileSuffix],
        ".gif": [genFileSuffix],
        ".yaml": [genFileSuffix]
      };
}
