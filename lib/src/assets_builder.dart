import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:numbers_to_words/numbers_to_words.dart';
import 'package:quartet/quartet.dart';
import 'code_templating.dart';
import 'utils.dart';

class AssetsBuilder implements Builder {
  AssetsBuilder(BuilderOptions options) {}

  Map<String, Map<String, String>> classesToGenerate = {};

  String clean(String s) {
    // Remove invalid characters
    s = s.replaceAll('[^0-9a-zA-Z_]', '');

    // Remove leading characters until we find a letter or underscore
    s = s.replaceAll('^[^a-zA-Z_]+', '');

    if (int.tryParse(s[0]) != null) {
      s = NumberToWords.convert(int.parse(s[0]), "en") +
          s.substring(1, s.length);
    }

    return s;
  }

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    String filePath = buildStep.inputId.path;
    List<String> fileParts = filePath.split("/");
    String fileName = fileParts.last;
    String fileBaseName = camelCase(clean(fileName.split(".").first));
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
      fileBaseName = "${fileBaseName}_${lowerCase(fileName.split(".").last)}";
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
