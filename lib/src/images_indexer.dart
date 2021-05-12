import 'package:assets_indexer/src/utils.dart';
import 'package:build/build.dart';
import 'package:quartet/quartet.dart';

Map<String, Map<String, String>> _classesToGenerate = {};

Future<void> indexImages(BuildStep buildStep) async {
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

  if (_classesToGenerate[dirName] == null) {
    _classesToGenerate[dirName] = {};
  }

  if (_classesToGenerate[dirName]!.containsKey(fileBaseName)) {
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
