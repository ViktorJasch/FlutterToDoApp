import 'package:flutter/material.dart';
import 'package:todoapp/screens/detail_screen.dart';
import 'package:todoapp/model/task.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Task> taskList = <Task>[
    Task(title: 'Faaaaaaaa', isDone: false,),
    Task(title: 'Faaaaaaaa', isDone: true,),
    Task(title: 'Faaaaaaaa', isDone: false,),
    Task(title: 'Faaaaaaaa', isDone: true,),
    Task(title: 'Faaaaaaaa', isDone: false,),
  ];

  bool checkBoxValue = false;
  bool validate = false;
  bool isVisible = true;
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
        hideSelectedItems();
        break;
      case 'Удалить выполненные':
        deleteSelectedItems();
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
      _textEditingController.clear();
      print(taskList);
    });
  }

  void hideSelectedItems() {
    for (Task task in taskList) {
      if (task.isDone) {

      }
    }
  }

  void deleteSelectedItems() {
      taskList.removeWhere((element) => element.isDone);
      setState(() {});
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
            _textEditingController.clear();
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
          itemBuilder: (BuildContext context, index) {
            return buildListViewItem(context, index);
          },
        )
    );
  }

  Widget buildListViewItem(BuildContext context, int index) {
      return InkWell(
        onTap: () {
          print('Tap!');
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) =>
                      DetailScreen(title: taskList[index].title)
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

//class ListItem extends StatelessWidget {
//  final Task task;
//  ListItem({@required this.task});
//  @override
//  Widget build(BuildContext context) {
//    return InkWell(
//      onTap: () {
//        print('Tap!');
//        Navigator.push(context,
//            MaterialPageRoute(
//                builder: (context) => DetailScreen(title:task.title)
//            )
//        );
//      },
//      child: Container(
//        margin: const EdgeInsets.all(8),
//        padding: EdgeInsets.only(right: 8, top: 8, bottom: 8),
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(10),
//          color: Colors.white,
//        ),
//        child: Row(
//          mainAxisSize: MainAxisSize.max,
//          mainAxisAlignment: MainAxisAlignment.start,
//          children: <Widget>[
//            Checkbox(
//              value: task.isDone,
//              onChanged: (newValue) {
//                setState(() {
//                  task.isDone = newValue;
//                });
//              },
//            ),
//            Expanded(
//              child: Text(
//                '${task.title}',
//                textDirection: TextDirection.ltr,
//                overflow: TextOverflow.ellipsis,
//                maxLines: 6,
//              ),
//            ),
//            SizedBox(
//              width: 40,
//              child: FlatButton(
//                padding: EdgeInsets.all(0),
//                onPressed: () => deleteItem(task),
//                child: Icon(
//                  Icons.delete,
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
