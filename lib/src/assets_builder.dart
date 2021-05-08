import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:quartet/quartet.dart';
import 'code_templating.dart';

class AssetsBuilder implements Builder {
  AssetsBuilder(BuilderOptions options) {}

  Map<String, Map<String, String>> classesToGenerate = {};

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    String filePath = buildStep.inputId.path;
    List<String> fileParts = filePath.split("/");
    String fileName = fileParts.last;
    String fileBaseName = camelCase(fileName.split(".").first);
    String dirName = buildStep.inputId.package;
    if (fileParts.length > 1) {
      dirName = fileParts[fileParts.length - 2];
    }
    String classFileName = snakeCase(dirName);
    dirName = titleCase(camelCase(dirName));

    if (classesToGenerate[dirName] == null) {
      classesToGenerate[dirName] = {};
    }
    classesToGenerate[dirName][fileBaseName] = filePath;
    String classPath = './lib/generated/${classFileName}.asset.dart';
    File file = await createClass(classPath);
    var classToGenerate = {};
    classToGenerate[dirName] = classesToGenerate[dirName];
    await file.writeAsString(getStringKeysCodeFromMap(classToGenerate));
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        ".jpg": [".asset.dart"],
        ".png": [".asset.dart"],
        ".webp": [".asset.dart"],
        ".gif": [".asset.dart"]
      };

  Future<File> createClass(String path) async {
    var myFile = File(path);
    var checkFile = await myFile.exists();
    if (!checkFile) {
      return myFile.create(recursive: true);
    } else {
      return Future.value(myFile);
    }
  }
}
