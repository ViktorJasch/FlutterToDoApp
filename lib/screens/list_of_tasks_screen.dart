import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/model/task_step.dart';
import 'package:todoapp/screens/detail_screen.dart';
import 'package:todoapp/model/task.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

final textEditingController = TextEditingController();

class ListOfTasks extends StatefulWidget {
  ListOfTasks({Key key, this.title}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String title;
  final random = Random();

  @override
  _ListOfTasksState createState() => _ListOfTasksState();
}

class _ListOfTasksState extends State<ListOfTasks> {
  List<Task> taskList = <Task>[
    Task(title: 'Task1', isDone: false, steps: [TaskStep(title: 'Step 1 of Task 1', isDone: false, textEditingController: TextEditingController()), TaskStep(title: 'Step 2 of Task 1', isDone: false, textEditingController: TextEditingController()), TaskStep(title: 'Step 3 of Task 1', isDone: false,textEditingController: TextEditingController()), ], id: '2'),
    Task(title: 'Task2', isDone: true, steps: [TaskStep(title: 'Step of Task 2', isDone: false, textEditingController: TextEditingController()),TaskStep(title: 'Step 2 of Task 2', isDone: false, textEditingController: TextEditingController()), ], id: '324'),
    Task(title: 'Task3', isDone: false, steps: [TaskStep(title: 'Step of Task 3', isDone: false, textEditingController: TextEditingController())], id: '28'),
    Task(title: 'Task4', isDone: true, steps: [TaskStep(title: 'Step 1 of Task 4', isDone: false, textEditingController: TextEditingController()),TaskStep(title: 'Step 2 of Task 4', isDone: false, textEditingController: TextEditingController()),TaskStep(title: 'Step 3 of Task 4', isDone: false, textEditingController: TextEditingController()),TaskStep(title: 'Step 4 of Task 4', isDone: false, textEditingController: TextEditingController()),TaskStep(title: 'Step 4 of Task 4', isDone: false, textEditingController: TextEditingController()),TaskStep(title: 'Step 4 of Task 4', isDone: false, textEditingController: TextEditingController()),TaskStep(title: 'Step 4 of Task 4', isDone: false, textEditingController: TextEditingController()),TaskStep(title: 'Step 4 of Task 4', isDone: false, textEditingController: TextEditingController()),TaskStep(title: 'Step 4 of Task 4', isDone: false, textEditingController: TextEditingController()),TaskStep(title: 'Step 4 of Task 4', isDone: false, textEditingController: TextEditingController()),], id: '854'),
    Task(title: 'Task5', isDone: false, steps: [TaskStep(title: 'Step of Task 5', isDone: false, textEditingController: TextEditingController()), ], id: '43'),
  ];

  bool shouldDoneTaskHidden = false;
  int selectedRadio;
  Color backgroundColor;

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    backgroundColor = Color(0xFFe3e3e3);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      backgroundColor: backgroundColor,
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
        backgroundColor: Color(0xFF01A39D),
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
              : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: getTasks(shouldDoneTaskHidden).map((Task task) {
                        return TaskListItem(task: task,
                            doneSteps: task.steps.where((step) => step.isDone).toList().length,
                            totalSteps: task.steps.length,
                            onDelete: () {
                            deleteItem(task);
                        });
                      }).toList(),
                      ),
                  ),
                ],
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
                              activeColor: Color(0xFFF44336),
                              onChanged: (val) {
                                setState(() {
                                  setSelectedRadio(val);
                                  setColor(val);
                                });
                              },
                            ),
                            Radio(
                              value: 2,
                              groupValue: selectedRadio,
                              activeColor: Color(0xFFFF5722),
                              onChanged: (val) {
                                setState(() {
                                  setSelectedRadio(val);
                                  setColor(val);
                                });
                              },
                            ),
                            Radio(
                              value: 3,
                              groupValue: selectedRadio,
                              activeColor: Color(0xFFFFC107),
                              onChanged: (val) {
                                setState(() {
                                  setSelectedRadio(val);
                                  setColor(val);
                                });
                              },
                            ),
                            Radio(
                              value: 4,
                              groupValue: selectedRadio,
                              activeColor: Color(0xFF4CAF50),
                              onChanged: (val) {
                                setState(() {
                                  setSelectedRadio(val);
                                  setColor(val);
                                });
                              },
                            ),
                            Radio(
                              value: 5,
                              groupValue: selectedRadio,
                              activeColor: Color(0xFF2C98F0),
                              onChanged: (val) {
                                setState(() {
                                  setSelectedRadio(val);
                                  setColor(val);
                                });
                              },
                            ),
                            Radio(
                              value: 6,
                              groupValue: selectedRadio,
                              activeColor: Color(0xFF6202EE),
                              onChanged: (val) {
                                setState(() {
                                  setSelectedRadio(val);
                                  setColor(val);
                                });
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

  List<Task> getTasks(bool shouldRemoveDone) {
    if (shouldRemoveDone) {
      return taskList.where((task) => !task.isDone).toList();
    } else {
      return taskList;
    }
  }

  void setColor(val) {
    switch (val) {
      case 1:
        changeColor(Color(0xFFF44336), Color(0xFFFF7961));
        break;
      case 2:
        changeColor(Color(0xFFFF5722), Color(0xFFff8a50));
        break;
      case 3:
        changeColor(Color(0xFFFFC107), Color(0xFFfff350));
        break;
      case 4:
        changeColor(Color(0xFF4CAF50), Color(0xFF80e27e));
        break;
      case 5:
        changeColor(Color(0xFF2C98F0), Color(0xFF72c8ff));
        break;
      case 6:
        changeColor(Color(0xFF6202EE), Color(0xFFe3e3e3));
        break;
    }
  }

  void changeColor(Color color, Color background) {
    DynamicTheme.of(context).setThemeData(new ThemeData(
      primaryColor: color,
    ));
    backgroundColor = background;
  }

  void setSelectedRadio(int value) {
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

  void deleteItem(Task task) {
    setState(() {
      taskList.remove(task);
    });
    print('Delete');
    print(taskList);
  }

  String generateIdForTask() {
    final String id = (widget.random.nextInt(1000)).toString();
    print(id);
    return id;
  }

  void addTask(String title) {
    setState(() {
      taskList.add(Task(title: title, isDone: false, steps: [], id: generateIdForTask(), creationDate: getCurrentTime()));
      textEditingController.clear();
      print(taskList);
    });
  }

  String getCurrentTime() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd.MM.yyyy');
    String currentDate = formatter.format(now);
    return currentDate;
  }

  void hideSelectedItems() {
    setState(() {
      shouldDoneTaskHidden = !shouldDoneTaskHidden;
    });
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
            addTask(textEditingController.text);
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Form(
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
        ],
      ),
      actions: <Widget>[
        FlatButton(
          textColor: Colors.black,
          child: Text('Отмена'),
          onPressed: () {
            textEditingController.clear();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          textColor: Colors.black,
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
  int doneSteps;
  int totalSteps;

  TaskListItem({@required this.task, @required this.onDelete, @required this.doneSteps, @required this.totalSteps});
  @override
  _TaskListItemState createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {


  @override
  void initState() {
    super.initState();
    widget.doneSteps = getDoneSteps(widget.task);
    widget.totalSteps = getTotalSteps(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          right: 0,
          child: Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red,
            ),
          ),
        ),
        Dismissible(
          key: Key(widget.task.id),
          onDismissed: (direction) {
              widget.onDelete();
          },
          child: InkWell(
            onTap: () {
              print('Tap!');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        task: widget.task,
                        onTaskChanged: (task) {
                          setState(() {
                            widget.doneSteps = getDoneSteps(task);
                            widget.totalSteps = getTotalSteps(task);
                            widget.task.isDone = task.isDone;
                            widget.task.title = task.title;
                          });
                        },
                        onDeleteTask: (task) {
                          widget.onDelete();
                        },
                      )
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
                    value: widget.task.isDone,
                    onChanged: (newValue) {
                      setState(() {
                        print(widget.task.creationDate);
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
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 6),
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "${widget.doneSteps} из ${widget.totalSteps}"))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      ]

    );
  }

  int getDoneSteps(Task task) {
    return task.steps.where((step) => step.isDone).toList().length;
  }

  int getTotalSteps(Task task) {
    return task.steps.length;
  }
}


