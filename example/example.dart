import 'package:flutter/material.dart';

void main() {
  runApp(new DemoApp());
}

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Selectable Test Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const SelectableTextDemo(),
    );
  }
}

class SelectableTextDemo extends StatefulWidget {
  const SelectableTextDemo({Key key}) : super(key: key);

  @override
  _SelectableTextDemoState createState() => _SelectableTextDemoState();
}

class _SelectableTextDemoState extends State<SelectableTextDemo> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selectable Text Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Select any part of this text!",
              textAlign: TextAlign.start,
            )
          ],
        ),
      ),
    );
  }
}