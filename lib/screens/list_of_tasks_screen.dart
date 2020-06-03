import 'package:flutter/material.dart';
import 'detail_screen.dart';
import 'package:todoapp/model/task.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Task> taskList = <Task>[
    Task(title: 'To do 1', isDone: false),
    Task(
        title: 'You should use CrossAxisAlignment.baseline if you.111',
        isDone: false),
    Task(
        title:
            'You should use CrossAxisAlignment.baseline if you.111You should use CrossAxisAlignment.baseline if you.111You should use CrossAxisAlignment.baseline if you.111e if you.111You should use CrossAxisAlignment.baseline if you.111',
        isDone: false),
    Task(title: 'To do 2', isDone: false),
    Task(title: 'To do 3', isDone: false),
    Task(title: 'To do 4', isDone: false),
    Task(title: 'To do 5', isDone: false),
    Task(title: 'To do 6', isDone: false),
    Task(title: 'To do 7', isDone: false),
    Task(title: 'To do 8', isDone: false),
  ];

  bool checkBoxValue = false;
  final _textEditingController = TextEditingController();

  void selectedItem(String value) {
    switch (value) {
      case 'Скрыть выполенные':
        print('Скрыл выполненные задачи');
        break;
      case 'Удалить выполненные':
        print('Удалил выполненные задачи');
        break;
    }
  }

   void deleteItem(int index) {
    setState(() {
      taskList.removeAt(index);
    });
    print('Delete');
  }

  void addItem(String title) {
    setState(() {
      taskList.add(Task(title: title, isDone: false));
      _textEditingController.text = '';
    });
  }

   displayDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Создать задачу'),
          content: TextField(
            decoration: InputDecoration(
              hintText: 'Введите название задачи',
            ),
            controller: _textEditingController,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Добавить'),
              onPressed: () {
                addItem(_textEditingController.text);
                Navigator.of(context).pop();
              },
            )
          ],
        );
    }
    );
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
                return {'Скрыть выполенные', 'Удалить выполненные'}.map((String choice) {
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
            onPressed: () => displayDialog(context),
            child: Icon(Icons.add),
            backgroundColor: Colors.tealAccent[700],
          ),
        ),
        body: ListView.builder(
          itemCount: taskList.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                print('Tap!');
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(title: taskList[index].title)
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
                      value: taskList[index].isDone,
                      onChanged: (newValue) {
                        setState(() {
                           taskList[index].isDone = newValue;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        '${taskList[index].title}',
                        textDirection: TextDirection.ltr,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 6,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () => deleteItem(index),
                        child: Icon(
                          Icons.delete,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}