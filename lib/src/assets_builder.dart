import 'dart:async';
import 'dart:io';
import 'package:build/build.dart';
import 'package:quartet/quartet.dart';
import 'utils.dart';

class AssetsBuilder implements Builder {
  AssetsBuilder(BuilderOptions options) {}

  Map<String, Map<String, String>> _classesToGenerate = {};

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    String filePath = buildStep.inputId.path;
    String packageName = buildStep.inputId.package;
    if (_classesToGenerate.isEmpty) {
      _classesToGenerate = (await decodeAssetGenFile(
          "$outDirectory/${buildStep.classFileName}"));
    }

    for (var file in Directory((() {
      var splt = filePath.split('/');
      splt.removeLast();
      return splt.join('/');
    }()))
        .listSync()) {
      await buildAsset(file.path, packageName);
    }
    await buildAsset(filePath, packageName);
  }

  Future<void> buildAsset(String filePath, String defaultDirName) async {
    List<String> fileParts = filePath.split("/");
    String fileName = fileParts.last;
    var dirPath = [...fileParts];
    dirPath.removeLast();
    String fileBaseName = camelCase(clean(fileName.split(".").first));
    if (keywords.contains(fileBaseName)) {
      log.warning(
          "SKIPPING : $fileName contains language keywords. Consider renameing it");
      return;
    }
    String dirName = defaultDirName;
    if (fileParts.length > 1) {
      dirName = fileParts[fileParts.length - 2];
    }
    String classFileName = snakeCase(dirName);
    dirName = titleCase(camelCase(clean(dirName)));

    if (_classesToGenerate[dirName] == null) {
      _classesToGenerate[dirName] = {};
    }

    if (_classesToGenerate[dirName]!.containsKey(fileBaseName) &&
        _classesToGenerate[dirName]![fileBaseName] != filePath) {
      if (fileParts.length > 2) {
        String parentDirName = snakeCase(fileParts[fileParts.length - 3]);
        fileBaseName = "${parentDirName}_${fileBaseName}";
        log.warning(fileBaseName);
      }
    }

    _classesToGenerate[dirName]![fileBaseName] = filePath;
    var classToGenerate = {};
    classToGenerate[dirName] = _classesToGenerate[dirName];
    await filePutContents(classFileName, classToGenerate);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        ".jpg": [genFileSuffix],
        ".png": [genFileSuffix],
        ".webp": [genFileSuffix],
        ".gif": [genFileSuffix]
      };
}
