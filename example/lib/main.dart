import 'package:flutter/material.dart';
import 'package:assets_generator_example/generated/images.asset.dart';
// Since 'Icons' is built-in class under material.dart, we can simple alias it as 'app_icons'
import 'package:assets_generator_example/generated/icons.asset.dart'
    as app_icons;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Assets indexer Demo')),
        body: ListView(
          children: [
            Image.asset(Images.a),
            // Since 'Icons' is built-in class under material.dart, we can simple alias it as 'app_icons'
            Image.asset(app_icons.Icons.b)
          ],
        ),
      ),
    );
  }
}
