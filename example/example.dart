import 'package:flutter/material.dart';
import 'package:flutter_selectext/flutter_selectext.dart';

void main() {
  runApp(new DemoApp());
}

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
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
  int _counter = 0;

  List<TextSelection> markList = List();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
            MarkText.rich(
              TextSpan(children: [
                TextSpan(
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 30,
                        wordSpacing: 3,
                        shadows: [
                          Shadow(
                              color: Colors.black,
                              offset: Offset(6, 3),
                              blurRadius: 10)
                        ]),
                    text: 'This has mark option'),
                TextSpan(
                    style: TextStyle(
                      color: Colors.deepPurple,
                    ),
                    text: ' test test test!!'),
              ]),
              handlerMark: (TextSelection selection) {
                setState(() {
                  markList.add(selection);
                });
              },
              markColor: Colors.deepOrange,
              markList: markList,
            ),
            SelectableText.rich(
              TextSpan(
                children: [
                  TextSpan(
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 30,
                        wordSpacing: 3,
                        shadows: [
                          Shadow(
                              color: Colors.black,
                              offset: Offset(6, 3),
                              blurRadius: 10),
                        ],
                      ),
                      text: 'You have pushed the'),
                  TextSpan(
                      style: TextStyle(
                        color: Colors.blueAccent,
                      ),
                      text: 'button this many times:'),
                ],
              ),
            ),
            SelectableText(
              '$_counter',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
    );
  }
}