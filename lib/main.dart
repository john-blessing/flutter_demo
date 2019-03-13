import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/self_bottom_navigation_bar.dart';
import 'package:flutter_demo/cameraManager.dart';
import 'package:flutter_demo/imagePickerService.dart';

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
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/cameraapp': (BuildContext bc) => CameraExampleHome(cameras: cameras),
        '/imagePicker': (BuildContext bc) => ImagePickerService()
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
  ScrollController _scrollController = new ScrollController();
  int num = 1;
  bool isPerformingRequest = false;
  int _selectedIndex = 0;

  final cardList = [
    {'imgUrl': 'http://192.168.7.50:8999/hyrz/2189146230.png'},
    {'imgUrl': 'http://192.168.7.50:8999/hyrz/2189148728.png'},
    {'imgUrl': 'http://192.168.7.50:8999/hyrz/2189162758.png'}
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fakeRequest() async {
    return Future.delayed(Duration(seconds: 2), () {
      setState(() {
        cardList.add({'imgUrl': 'http://192.168.7.50:8999/hyrz/2189162758.png'});
        isPerformingRequest = false;
      });
    });
  }

  _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      await fakeRequest();
    }
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _card(String imgUrl) {
    return Card(
      elevation: 8,
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

  Widget _renderContainer(int _selectedIndex) {
    switch (_selectedIndex) {
      case 0:
        return Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(241, 243, 244, 1),
              border: Border(
                  bottom: BorderSide(
                      width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1))),
            ),
            child: ListView.builder(
                controller: _scrollController,
                itemCount: cardList?.length,
                itemBuilder: (BuildContext context, int index) {
                  print('$index:${cardList.length}');
                  if (index == cardList.length - 1) {
                    return _buildProgressIndicator();
                  } else {
                    return _card(cardList[index]['imgUrl']);
                  }
                }));
      case 1:
        return Text('Picture');
      case 2:
        return Text('School');
      case 3:
        return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromRGBO(241, 243, 244, 1),
              border: Border(
                  bottom: BorderSide(
                      width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1))),
            ),
            child: ListView(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.only(left: 20),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                          width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
                      top: BorderSide(
                          width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              'http://p0.ifengimg.com/pmop/2018/0724/2BEA391D6F6C6FBD0FF1EA04852FE1A3DB809AC4_size8_w402_h363.jpeg'),
                        ),
                        Padding(
                          child: Text(
                            'Jhon',
                            style: TextStyle(fontSize: 20),
                          ),
                          padding: const EdgeInsets.only(left: 10),
                        ),
                        Expanded(
                            child: Align(
                          child: Icon(
                            Icons.chevron_right,
                            size: 30,
                            color: Colors.grey,
                          ),
                          alignment: Alignment.centerRight,
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Align(
          child: Row(
            children: <Widget>[
              Text(widget.title),
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  Navigator.pushNamed(context, '/imagePicker');
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
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
