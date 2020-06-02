import 'package:flutter/material.dart';
import 'package:todoapp/DetailScreen.dart';

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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> tasks = <String>[
    'To do 1',
    'You should use CrossAxisAlignment.baseline if you.111',
    'You should use CrossAxisAlignment.baseline if you.111You should use CrossAxisAlignment.baseline if you.111You should use CrossAxisAlignment.baseline if you.111e if you.111You should use CrossAxisAlignment.baseline if you.111',
    'To do 1',
    'To do 1',
    'To do 1',
    'To do 1',
    'To do 1',
    'To do 1',
    'To do 1'
  ];

  bool checkBoxValue = false;

  void selectedItem(String value) {
    switch (value) {
      case 'Test':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple[100],
        appBar: AppBar(
          title: Text('Задачи'),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: selectedItem,
              itemBuilder: (BuildContext context) {
                return {''}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () {
              final snackBar = SnackBar(
                content: Text('Функционал в разработке'),
                action: SnackBarAction(
                  label: 'Ok',
                  onPressed: () {},
                ),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.tealAccent[700],
          ),
        ),
        body: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                print('Tap!');
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(title: tasks[index])
                    )
                );
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: EdgeInsets.only(right: 8, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Checkbox(
                      value: checkBoxValue,
                    ),
                    Expanded(
                      child: Text(
                        '${tasks[index]}',
                        textDirection: TextDirection.ltr,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 6,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
