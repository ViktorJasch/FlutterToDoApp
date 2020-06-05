import 'package:flutter/material.dart';
import 'package:todoapp/screens/detail_screen.dart';
import 'package:todoapp/screens/list_of_tasks_screen.dart';


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
        primaryColor: Color(0xFF6202EE),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        canvasColor: Colors.transparent,
      ),
      home: ListOfTasks(),
      routes:  {
        '/DetailScreen' : (BuildContext context) => DetailScreen()
      },
    );
  }
}


