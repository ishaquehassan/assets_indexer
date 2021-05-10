import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:quartet/quartet.dart';
import 'code_templating.dart';
import 'utils.dart';

class AssetsBuilder implements Builder {
  AssetsBuilder(BuilderOptions options) {}

  Map<String, Map<String, String>> classesToGenerate = {};
  bool isInitialDeleteFired = false;

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    String filePath = buildStep.inputId.path;
    List<String> fileParts = filePath.split("/");
    String fileName = fileParts.last;
    String fileBaseName = camelCase(clean(fileName.split(".").first));
    String fileExtension = fileName.split(".").last;
    if (keywords.contains(fileBaseName)) {
      log.warning(
          "SKIPPING : $fileName contains language keywords. Consider renameing it");
      return;
    }
    String dirName = buildStep.inputId.package;
    if (fileParts.length > 1) {
      dirName = fileParts[fileParts.length - 2];
    }
    String classFileName = snakeCase(dirName);
    dirName = titleCase(camelCase(clean(dirName)));

    if (classesToGenerate[dirName] == null) {
      classesToGenerate[dirName] = {};
    }

    if (classesToGenerate[dirName].containsKey(fileBaseName)) {
      if (fileParts.length > 2) {
        String parentDirName = snakeCase(fileParts[fileParts.length - 3]);
        fileBaseName = "${parentDirName}_${fileBaseName}";
        log.warning(fileBaseName);
      }
    }

    classesToGenerate[dirName][fileBaseName] = filePath;
    String classPath = './lib/generated/${classFileName}$genFileSuffix';
    File file = await createClass(classPath);
    var classToGenerate = {};
    classToGenerate[dirName] = classesToGenerate[dirName];
    await file.writeAsString(getStringKeysCodeFromMap(classToGenerate));
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        ".jpg": [genFileSuffix],
        ".png": [genFileSuffix],
        ".webp": [genFileSuffix],
        ".gif": [genFileSuffix]
      };
}
