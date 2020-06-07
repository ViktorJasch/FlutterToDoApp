import 'package:flutter/material.dart';
import 'package:todoapp/screens/detail_screen.dart';
import 'package:todoapp/model/task.dart';
import 'package:flutter_svg/flutter_svg.dart';

final textEditingController = TextEditingController();

class ListOfTasks extends StatefulWidget {
  ListOfTasks({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListOfTasksState createState() => _ListOfTasksState();
}

class _ListOfTasksState extends State<ListOfTasks> {
  List<Task> taskList = <Task>[
    Task(title: 'Task1', isDone: false, isVisible: true),
    Task(title: 'Task2', isDone: true, isVisible: true),
    Task(title: 'Task3', isDone: false, isVisible: true),
    Task(title: 'Task4', isDone: true, isVisible: true),
    Task(title: 'Task5', isDone: false, isVisible: true),
  ];

  bool checkBoxValue = false;
  bool validate = false;
  int selectedRadio;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      appBar: AppBar(
        title: Text('Задачи'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: selectedItem,
            itemBuilder: (BuildContext context) {
              return {
                'Скрыть выполенные',
                'Удалить выполненные',
                'Изменить тему'
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => displayDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.tealAccent[700],
      ),
      body: Center(
          child: taskList.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SvgPicture.asset('assets/images/no_tasks_image.svg',
                        semanticsLabel: 'Acme Logo'),
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: SvgPicture.asset(
                            'assets/images/no_tasks_text.svg',
                            semanticsLabel: 'Acvvme Logo'))
                  ],
                )
              : ListView.builder(
                  itemCount: taskList.length,
                  itemBuilder: (BuildContext context, index) {
                    return TaskListItem(
                      task: taskList[index],
                      onDelete: () {
                        setState(() {
                          deleteItem(index);
                        });
                      },
                    );
                  },
                )),
    );
  }

  void showBottomDialog() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 137.0,
            color: Colors.transparent,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 20, top: 20),
                              child: Text('Выбор темы')),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, top: 30),
                        child: Row(
                          children: <Widget>[
                            Radio(
                              value: 1,
                              groupValue: selectedRadio,
                              activeColor: const Color(0xFFF44336),
                              onChanged: (val) {
                                setState(() => setSelectedRadio(val));
                              },
                            ),
                            Radio(
                              value: 2,
                              groupValue: selectedRadio,
                              activeColor: Color(0xFFFF5722),
                              onChanged: (val) {
                                setState(() => setSelectedRadio(val));
                              },
                            ),
                            Radio(
                              value: 3,
                              groupValue: selectedRadio,
                              activeColor: Color(0xFFFFC107),
                              onChanged: (val) {
                                setState(() => setSelectedRadio(val));
                              },
                            ),
                            Radio(
                              value: 4,
                              groupValue: selectedRadio,
                              activeColor: Color(0xFF4CAF50),
                              onChanged: (val) {
                                setState(() => setSelectedRadio(val));
                              },
                            ),
                            Radio(
                              value: 5,
                              groupValue: selectedRadio,
                              activeColor: Color(0xFF2C98F0),
                              onChanged: (val) {
                                setState(() => setSelectedRadio(val));
                              },
                            ),
                            Radio(
                              value: 6,
                              groupValue: selectedRadio,
                              activeColor: Color(0xFF6202EE),
                              onChanged: (val) {
                                setState(() => setSelectedRadio(val));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
            }),
          );
        });
  }

  setSelectedRadio(int value) {
    setState(() {
      selectedRadio = value;
    });
  }

  void selectedItem(String value) {
    switch (value) {
      case 'Скрыть выполенные':
        hideSelectedItems();
        break;
      case 'Удалить выполненные':
        deleteSelectedItems();
        break;
      case 'Изменить тему':
        showBottomDialog();
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
      textEditingController.clear();
      print(taskList);
    });
  }

  void hideSelectedItems() {
    for (Task task in taskList) {
      if (task.isDone) {}
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
          return AddTaskAlertDialog(onAddTask: () {
            addItem(textEditingController.text);
          });
        });
  }
}

class AddTaskAlertDialog extends StatelessWidget {
  final Function onAddTask;
  final formKey = GlobalKey<FormState>();

  AddTaskAlertDialog({@required this.onAddTask});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Создать задачу'),
      content: Form(
        key: formKey,
        child: TextFormField(
          maxLines: null,
          controller: textEditingController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Введите текст';
            } else if (value.length > 50) {
              return 'Максимальное число символов - 50';
            }
            return null;
          },
          decoration: InputDecoration(hintText: "Введите название задачи"),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Отмена'),
          onPressed: () {
            textEditingController.clear();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Добавить'),
          onPressed: () {
            if (formKey.currentState.validate()) {
              onAddTask();
              Navigator.of(context).pop();
            }
          },
        )
      ],
    );
  }
}

class TaskListItem extends StatefulWidget {
  final Function onDelete;
  final Task task;

  TaskListItem({@required this.task, @required this.onDelete});
  @override
  _TaskListItemState createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Tap!');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailScreen(title: widget.task.title)));
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
              value: widget.task.isDone,
              onChanged: (newValue) {
                setState(() {
                  widget.task.isDone = newValue;
                });
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.task.title,
                          textDirection: TextDirection.ltr,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 6),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("n шагов из n"))
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: widget.onDelete,
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
