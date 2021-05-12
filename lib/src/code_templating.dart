import 'package:mustache/mustache.dart';

const String GeneratorComment = '''
/// This code is generated. DO NOT edit by hand
''';

const String _MustacheTemplate = '''
{{{generatorComment}}}
{{#stringClasses}}
class {{className}} {
  {{#keys}}
  static String {{propertyName}} = "{{propertyValue}}";
  {{/keys}}
}
{{/stringClasses}}
''';

String getStringKeysCodeFromMap(Map<dynamic, dynamic> sourceMap) {
  var template = Template(_MustacheTemplate, htmlEscapeValues: false);
  var classInfos = [];
  for (var viewKey in sourceMap.keys) {
    var classMap = sourceMap[viewKey] as Map;
    var classProperties = classMap.keys
        .map((propertyKey) => PropertyInfo(
            propertyName: propertyKey, propertyValue: classMap[propertyKey]))
        .toList();
    var info = StringsClassInfo(className: viewKey, keys: classProperties);
    classInfos.add(info);
  }

  var output = template.renderString({
    'generatorComment': GeneratorComment,
    'stringClasses': classInfos,
  });
  return output;
}

class StringsClassInfo {
  final String? className;
  final List<PropertyInfo>? keys;

  StringsClassInfo({this.className, this.keys});
}

class PropertyInfo {
  final String? propertyName;
  final String? propertyValue;

  PropertyInfo({this.propertyName, this.propertyValue});
}
