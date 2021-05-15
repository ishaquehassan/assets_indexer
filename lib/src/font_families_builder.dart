import 'dart:async';
import 'dart:io';
import 'package:build/build.dart';
import 'package:quartet/quartet.dart';
import 'package:yaml/yaml.dart';
import 'utils.dart';

class FontFamiliesBuilder implements Builder {
  FontFamiliesBuilder(BuilderOptions options) {}

  final String _fontClassName = "AppFonts";

  Map<String, Map<String, String>> _classesToGenerate = {};

  @override
  FutureOr<void> build(BuildStep? buildStep) async {
    File f = File("./pubspec.yaml");
    var text = await f.readAsString();
    Map yaml = loadYaml(text);
    if (yaml['flutter']['fonts'] != null &&
        yaml['flutter']['fonts'].isNotEmpty) {
      Map<dynamic, dynamic> fonts = {_fontClassName: {}};
      for (var font in yaml['flutter']['fonts']) {
        fonts[_fontClassName][camelCase(font['family'])] = font['family'];
      }
      filePutContents(snakeCase(_fontClassName), fonts);
    }
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        ".yaml": [genFileSuffix],
        ".ttf": [genFileSuffix],
        ".otf": [genFileSuffix],
        "${snakeCase(_fontClassName)}$genFileSuffix": [genFileSuffix],
      };
}
