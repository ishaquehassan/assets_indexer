import 'dart:io';

import 'package:build/build.dart';
import 'package:numbers_to_words/numbers_to_words.dart';
import 'package:quartet/quartet.dart';

import 'code_templating.dart';

const String genFileSuffix = ".asset.dart";
const String outDirectory = './lib/generated';

List<String> keywords =
    "abstract else import super as enum in switch assert export interface sync async  extends is this await extension library throw break external mixin true case factory new try catch false null typedef class final on  var const finally operator void continue for part while covariant Function rethrow with default get return yield deferred hide  set.do if show. dynamic implements static int double String bool List Set Map Runes characters Symbol Null null"
        .split(" ");

String clean(String s) {
  // Remove invalid characters
  s = s.replaceAll('[^0-9a-zA-Z_]', '');

  // Remove leading characters until we find a letter or underscore
  s = s.replaceAll('^[^a-zA-Z_]+', '');

  if (int.tryParse(s[0]) != null) {
    s = NumberToWords.convert(int.parse(s[0]), "en") + s.substring(1, s.length);
  }

  return s;
}

Future<File> createClass(String path) async {
  var myFile = File(path);
  var checkFile = await myFile.exists();
  if (!checkFile) {
    return myFile.create(recursive: true);
  } else {
    return Future.value(myFile);
  }
}

Future<void> filePutContents(
    String fileName, Map<dynamic, dynamic> classData) async {
  String classPath = '$outDirectory/${fileName}$genFileSuffix';
  File file = await createClass(classPath);
  await file.writeAsString(getStringKeysCodeFromMap(classData));
}

Future<Map<String, Map<String, String>>> decodeAssetGenFile(
    String filePath) async {
  Map<String, Map<String, String>> varsMap = {};

  File assetFile = File(filePath);
  if (!(await assetFile.exists())) {
    return Future.value(varsMap);
  }
  var fileLines = (await assetFile.readAsString()).split("\n");
  var fileName = assetFile.path.split("/").last.split(".").first;
  var className = titleCase(camelCase(fileName));
  var startLineIndex = fileLines.indexOf('class $className {');
  if (startLineIndex < 0) {
    return Future.value(varsMap);
  }
  fileLines.removeRange(0, startLineIndex + 1);
  var endLineIndex = fileLines.indexOf("}");
  fileLines.removeRange(endLineIndex, fileLines.length - 1);
  varsMap[className] = {};
  for (var line in fileLines) {
    var varName = line.split("static String ").last.split(" ").first;
    var varValue = line.split('= "').last.split('"').first;
    if (await File(varValue).exists()) {
      varsMap[className]![varName] = varValue;
    }
  }
  return varsMap;
}

extension BuildStepExt on BuildStep {
  List<String> get pathParts => inputId.path.split("/");

  String get fileExtension {
    return pathParts.last.split(".").last;
  }

  String get dirName {
    return pathParts.length > 1
        ? pathParts[pathParts.length - 2]
        : pathParts.last.split('.').first;
  }

  String get classFileName {
    String classFileName = snakeCase(dirName);
    return "$classFileName$genFileSuffix";
  }
}
