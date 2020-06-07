import 'package:flutter/material.dart';
import 'package:todoapp/screens/detail_screen.dart';
import 'package:todoapp/screens/list_of_tasks_screen.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
              backgroundColor: Colors.yellow,
              primaryColor: Color(0xFF6202EE),
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'To do list',
            theme: theme,
            home: ListOfTasks(),
            routes: {'/DetailScreen': (BuildContext context) => DetailScreen()},
          );
        });
  }
}
