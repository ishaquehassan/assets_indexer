# assets_indexer

To generate indexed constants for your assets in dart/flutter project! Inspired by android R.java concept

## Installation

```yaml
dev_dependencies:
  assets_indexer: <latest-version>
```

also, don't forget to add 

```yaml
dev_dependencies:
  build_runner:
```

## Usage

```
flutter packages pub run build_runner build
````

## Output

you can find your generated assets classes in `lib/generated/<asset_dir_name>.asset.dart`

## Example usage

```dart
import 'package:example_app/generated/images.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget{

    @override
    Widget build(BuildContext context){
        return Scaffold(
            body: Center(
                child: Image.asset(Images.icon,width: 100)
            )
        )
    }
}
```