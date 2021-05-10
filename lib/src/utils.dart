import 'dart:io';

import 'package:numbers_to_words/numbers_to_words.dart';

const String genFileSuffix = ".asset.dart";

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
