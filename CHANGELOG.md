## [0.0.1] - Initial Release

* Just implemented indexer functionality
* Each asset directory will be generated as its separate class

## [0.0.2] - File Name bug fixed

* Fixed bug when filename starts from number
* Added validation to skip filenames matching with language keywords

## [0.0.3] - Version conflict issue resolved

* Version conflicts issue resolved with build_runner for both older and new dependents
* Example added
* Multiple directories with same name will be merged in same class and can be differentiated by their parent dir name prefix

## [0.0.4] - Added font family names indexing 🥳

* Now when you add `flutter > fonts` in your pubspec.yaml, it will automatically indexed in app_fonts.asset.dart class which can be referenced by AppFonts.<yourFontName>

## [0.0.5] - Bugs Fixes

* Bugs fixes

## [0.0.6] - Breaking changes - Bugs Fixes

* Fixed indexing for new files in existing dir
* Auto removing files from generated dir when dir is removed
* Null-safety opt-in
* Now assets dirs are linked to pubspec.yaml declarations from `flutter > assets` list

## [0.0.7] - Dart doc issues fixed

* Dartdoc generated
* Removed not-required keywords
* Combined both indexers in single file

## [0.0.8] - Font family generation issue fixed

* Font family generation issue fixed