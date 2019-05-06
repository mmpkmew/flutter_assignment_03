import 'package:flutter/material.dart';
import './ui/home.dart';
import './ui/add.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      // home: MyHomePage(),
      initialRoute: "/",
      routes: {
        "/": (context) => Home(),
        // "/add": (context) => Add(),
      },
    );
  }
}

