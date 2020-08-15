import 'package:flutter/material.dart';
import 'package:fluttershare/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          //primaryswatch modifies our application directly as required
          // , primarycolor in case we have to modifiy where we want
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.teal),
      home: Home(),
    );
  }
}
