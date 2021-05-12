import 'dart:io';

import 'package:assets_indexer/src/utils.dart';
import 'package:quartet/quartet.dart';
import 'package:yaml/yaml.dart';

const String _fontClassName = "AppFonts";

Future<void> indexFonts() async {
  File f = new File("./pubspec.yaml");
  var text = await f.readAsString();
  Map yaml = loadYaml(text);
  if (yaml['flutter']['fonts'] != null && yaml['flutter']['fonts'].isNotEmpty) {
    Map<dynamic, dynamic> fonts = {_fontClassName: {}};
    for (var font in yaml['flutter']['fonts']) {
      fonts[_fontClassName][camelCase(font['family'])] = font['family'];
    }
    filePutContents(snakeCase(_fontClassName), fonts);
  }
}
