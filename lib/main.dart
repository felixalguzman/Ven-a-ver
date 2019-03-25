import 'package:flutter/material.dart';
import 'package:ven_a_ver/homeScreen.dart';
import 'package:ven_a_ver/src/widgets/moviesBloc.dart';

void main() {
  final moviesBloc = MoviesBloc();
  runApp(MyApp(
    bloc: moviesBloc,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final MoviesBloc bloc;

  MyApp({
    Key key,
    this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(
        bloc: bloc,
      ),
      theme: ThemeData(primaryColor: Colors.blue),
    );
  }
}
