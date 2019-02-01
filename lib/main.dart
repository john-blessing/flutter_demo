import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/self_bottom_navigation_bar.dart';
import 'package:flutter_demo/cameraManager.dart';

import 'package:camera/camera.dart';

List<CameraDescription> cameras;

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

Future<void> main() async {
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '灵感助手',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      routes: {
        '/cameraapp': (BuildContext bc) => CameraExampleHome(cameras: cameras)
      },
      home: MyHomePage(title: '灵感助手'),
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

  int num = 1;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final imgUrl = 'https://i.kfs.io/playlist/global/47130192v1/fit/500x500.jpg';

  Widget _card() {
    return Card(
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
                'Happy Team',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Smile',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _setList() {
    setState(() {
      num += 1;
    });
  }

  Widget _renderContainer(int _selectedIndex) {
    switch (_selectedIndex) {
      case 0:
        return ListView.builder(
            itemCount: num,
            itemBuilder: (BuildContext context, int index) {
              return _card();
            });
      case 1:
        return Text('Picture');
      case 2:
        return Text('School');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          child: Row(
            children: <Widget>[
              Text(widget.title),
              IconButton(
                icon: Icon(Icons.camera),
                onPressed: () {
                  Navigator.pushNamed(context, '/cameraapp');
                },
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          alignment: Alignment.centerLeft,
        ),
      ),
      body: _renderContainer(_selectedIndex),
      bottomNavigationBar: SelfBottomNavigationBar(
        type: SelfBottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), title: Text('关注')),
          BottomNavigationBarItem(icon: Icon(Icons.message), title: Text('消息')),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('我的')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.orangeAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
