import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "The News",
      theme: new ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Colors.red,
        accentColor: Colors.redAccent,
      ),
      home: new HomePage(),
    );
  }
}