import 'package:flutter/material.dart';
import 'package:ven_a_ver/homeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(primaryColor: Colors.blue),
    );
  }
}
