import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Mine extends StatefulWidget {
  @override
  _MineState createState() => new _MineState();
}

class _MineState extends State<Mine> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Email", fillColor: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter Password",
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.text,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                    ),
                    MaterialButton(
                      height: 50.0,
                      minWidth: 150.0,
                      color: Colors.green,
                      splashColor: Colors.teal,
                      textColor: Colors.white,
                      child: Icon(FontAwesomeIcons.signInAlt),
                      onPressed: () {},
                    )
                  ],
                ),
              )
            ]));
  }
}
