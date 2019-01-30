import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  int _selectedIndex = 1;
  final _widgetOptions = [
    Text('Index 0: Home'),
    Text('Index 1: Business'),
    Text('Index 2: School'),
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final imgUrl = 'https://i.kfs.io/playlist/global/47130192v1/fit/500x500.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          child: Text(widget.title),
          alignment: Alignment.centerLeft,
        ),
      ),
      body: Column(
        children: <Widget>[
          Center(
              child: Card(
            elevation: 4,
            margin: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Image.network(imgUrl),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Code Formatting While Saving the File:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Visual Studio code allows user can customize the default settings.',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey),
                    ),
                  ),
                )
              ],
            ),
          ))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), title: Text('Business')),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), title: Text('School')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}
