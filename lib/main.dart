import 'package:flutter/material.dart';
import 'file:///C:/Users/Shilo.VS/AndroidStudioProjects/todo_app/lib/Screens/detail_screen.dart';
import 'Screens/list_of_tasks_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To do list',
      theme: ThemeData(
        primaryColor: Colors.deepPurple[800],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      routes:  {
        '/DetailScreen' : (BuildContext context) => DetailScreen()
      },
    );
  }
}


