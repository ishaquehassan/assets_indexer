library assets_generator;

import 'package:build/build.dart';
import 'package:assets_generator/src/assets_builder.dart';

Builder assetsGenerator(BuilderOptions options) => AssetsBuilder(options);
