/// @nodoc
library assets_indexer;

import 'dart:async';
import 'dart:io';

import 'package:assets_indexer/src/font_families_builder.dart';
import 'package:build/build.dart';
import 'package:assets_indexer/src/assets_builder.dart';
import 'package:quartet/quartet.dart';
import 'package:yaml/yaml.dart';
import 'src/utils.dart';

/// @nodoc
class EmptyBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {};

  @override
  FutureOr<void> build(BuildStep buildStep) {}
}

/// @nodoc
Builder assetsIndexer(BuilderOptions options) {
  var builder = AssetsBuilder(options);
  preExecuter(builder);
  return EmptyBuilder();
}

/// @nodoc
Builder fontFamiliesIndexer(BuilderOptions options) {
  var builder = FontFamiliesBuilder(options);
  builder.build(null);
  return EmptyBuilder();
}

/// @nodoc
preExecuter(AssetsBuilder builder) {
  Directory directory = Directory(outDirectory);
  directory.createSync(recursive: true);
  (() async {
    var assetDirs = [];
    File f = File("./pubspec.yaml");
    var text = await f.readAsString();
    Map yaml = loadYaml(text);
    if (yaml['flutter']['assets'] != null &&
        yaml['flutter']['assets'].isNotEmpty) {
      for (String assetPath in yaml['flutter']['assets']) {
        if (assetPath.endsWith("/") || assetPath.endsWith("\\")) {
          assetPath = assetPath.replaceRange(
              assetPath.length - 1, assetPath.length, '');
          print(assetPath);
        }
        if (!assetPath.contains(".") && (await Directory(assetPath).exists())) {
          assetDirs.add(assetPath);
          for (var inpDirFile in Directory(assetPath).listSync()) {
            var ext = inpDirFile.path.split('.').last;
            if (builder.buildExtensions.keys.toList().contains(".$ext")) {
              await builder.buildAsset(
                  inpDirFile.path, assetPath.split('/').last);
            }
          }
        }
      }
    }
    assetDirs = assetDirs.map((e) => snakeCase(e.split("/").last)).toList();
    for (var file in directory.listSync()) {
      if (file.existsSync() &&
          file.path.split("/").last != "app_fonts.asset.dart") {
        var fileDir = file.path.split("/").last.split(".").first;
        if (!assetDirs.contains(fileDir)) {
          log.info(
              "Removed : ${file.path} since its directory removed from assets paths");
          file.deleteSync();
        }
      }
    }
  })();
}
