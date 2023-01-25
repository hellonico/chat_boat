import 'dart:convert';

import 'package:flutter/material.dart';
import 'gallery.dart';
import 'package:http/http.dart' as http;


Future<List<String>> parseJson(String url) async {
  final uri = Uri.parse(url);
  final host = url.substring(0,url.indexOf("/", 10));
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    final Map<String, dynamic> json_ = json.decode(response.body);
    final List objects = json_.remove("objects");
    return objects.map((e) =>
      host + "/" + e.remove("image").remove("path").replaceAll("\\", "").toString()
        ).toList();
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load data');
  }
}

Future<List<String>> loadImagesFromCSV(String url) async {
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var csvString = response.body;
    var csvLines = LineSplitter().convert(csvString);
    return csvLines;
  } else {
    throw Exception('Failed to load image CSV file from remote server');
  }
}

void main() {
  //loadImagesFromCSV('http://n1c0.hellonico.info/images.csv').then((images) {
  parseJson('http://n1c0.hellonico.info/deep-data.json').then((images) {
    runApp(MaterialApp(
      home: GalleryApp(images: images)
    ));
  });
}

//
// void main() {
//   runApp(MaterialApp(
//     home: GalleryApp(images: [
//       'http://n1c0.hellonico.info/slides/File%202023-01-15%2022%2006%2052%20%281%29%20%281%29.png',
//       'http://n1c0.hellonico.info/slides/File%202023-01-15%2022%2006%2052.png',
//     ]),
//   ));
// }


// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const MyHomePage({super.key, required this.title});

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
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
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
