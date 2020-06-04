import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  ];

  bool checkBoxValue = false;
  bool validate = false;
  final formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

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
     print(taskList);
   }

  void addItem(String title) {
    setState(() {
      taskList.add(Task(title: title, isDone: false));
      _textEditingController.text = '';
      print(taskList);
    });
  }

    displayDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return buildAlertDialog(context);
        }
    );
  }

  Widget buildAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Создать задачу'),
      content: Form(
        key: formKey,
        child: TextFormField(
          maxLines: null,
          controller: _textEditingController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Введите текст';
            } else if (value.length > 50) {
              return 'Максимальное число символов - 50';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Введите название задачи"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Отмена'),
          onPressed: () {
            _textEditingController.text = '';
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Добавить'),
          onPressed: () {
            if (formKey.currentState.validate()) {
              addItem(_textEditingController.text);
              Navigator.of(context).pop();
            }
          },
        )
      ],
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
            return buildListViewItem(context, index);
          },
        ));
  }

  Widget buildListViewItem(BuildContext context, int index) {
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
  }
}