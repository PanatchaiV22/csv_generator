import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _lineCount = 0;
  bool _isUpdated = false;
  final TextEditingController _textEditingController = TextEditingController();

  String _removeRootDir(String fileName) {
    int rootIndex = 0;
    List names = fileName.split("/");
    int total = names.length;
    String prevDir = "";
    StringBuffer buffer = StringBuffer();
    bool isStarted = false;
    // /Users/panatchai/nowinandroid/build-logic/convention/src/main/kotlin/AndroidApplicationComposeConventionPlugin.kt
    for (var i = 0; i < total; i++) {
      if (isStarted) {
        buffer.write("/${names[i]}");
      } else if (names[i] == "src") {
        buffer.write("$prevDir/${names[i]}");
        isStarted = true;
      }
      prevDir = names[i];
    }
    return buffer.toString();
  }

  String _generateCSV(String msg, int totalLine) {
    int midLine = (totalLine / 2) as int;
    int nextLine = midLine;
    int firstLine = 0;
    List lines = msg.split('\n');
    StringBuffer buffer = StringBuffer();
    for (var l = 0; l < midLine; l++) {
      if (l == midLine - 1) {
        buffer.write(
            "${_removeRootDir(lines[firstLine])},${_removeRootDir(lines[nextLine])}");
      } else {
        buffer.writeln(
            "${_removeRootDir(lines[firstLine])},${_removeRootDir(lines[nextLine])}");
      }
    }
    return buffer.toString();
  }

  void _onTextChanged(String text) async {
    setState(() {
      if (_isUpdated) {
        _isUpdated = false;
      } else {
        _lineCount = text.split('\n').length;
        if (_lineCount % 2 != 0) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Lines are mismatched!"),
          ));
        } else {
          _isUpdated = true;
          _textEditingController.text =
              _generateCSV(_textEditingController.text, _lineCount);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Total Lines:',
            ),
            Text(
              '$_lineCount',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextField(
              controller: _textEditingController,
              onChanged: (text) {
                _onTextChanged(text);
              },
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 20,
              autofocus: true,
              style: const TextStyle(fontSize: 22.0, color: Colors.white),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.black38,
                contentPadding:
                    EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
