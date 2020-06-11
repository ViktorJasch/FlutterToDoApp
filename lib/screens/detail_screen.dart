import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/helpers/constants.dart';
import 'package:todoapp/model/task_step.dart';
import 'package:todoapp/model/task.dart';
import 'package:flutter/cupertino.dart';

var addStepFormController = TextEditingController();
var addNoteStepController = TextEditingController();
var taskNameEditorController = TextEditingController();
MyGlobals myGlobals = new MyGlobals();

class DetailScreen extends StatefulWidget {
  final Function(Task task) onTaskChanged;
  final Function(Task task) onDeleteTask;
  final Task task;

  DetailScreen({@required this.task, this.onTaskChanged, this.onDeleteTask});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: myGlobals.scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.indigo[100],
      body: DetailView(
        task: widget.task,
        onTaskChanged: () {
          widget.onTaskChanged(widget.task);
        },
        onTaskDelete: () {
          widget.onDeleteTask(widget.task);
        },
      ),
    );
  }
}

class DetailView extends StatefulWidget {
  final noteForm = GlobalKey<FormState>();
  final Function onTaskChanged;
  final Function onTaskDelete;
  final Task task;

  DetailView(
      {@required this.task,
      @required this.onTaskChanged,
      @required this.onTaskDelete});

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  ScrollController _scrollController;
  bool isKeyboardShow;

  @override
  void initState() {
    super.initState();
    addNoteStepController = TextEditingController()..text = widget.task.note;
    _scrollController = ScrollController();
    _scrollController.addListener(() => setState(() {}));
    isKeyboardShow = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 128,
              floating: false,
              pinned: true,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(widget.task.title),
              ),
              actions: <Widget>[
                PopupMenuButton(
                  onSelected: selectedItem,
                  itemBuilder: (BuildContext context) {
                    return {'Редактировать', 'Удалить'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                )
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Card(
                  elevation: 10.0,
                  margin: EdgeInsets.only(top: 28, left: 16, right: 16),
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: Container(
                        child: Text('Создано: ${widget.task.creationDate}',
                        style: TextStyle(
                          color: Constants.stepTaskColor
                        ),),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    Column(
                      children: widget.task.steps.map((TaskStep step) {
                        return StepListItem(
                          step: step,
                          onStepChanged: widget.onTaskChanged,
                          onDelete: () {
                            setState(() {
                              deleteItem(step);
                              widget.onTaskChanged();
                            });
                          },
                        );
                      }).toList(),
                    ),
                    AddStepButton(
                      isKeyboardShow: isKeyboardShow,
                      onAddStep: () {
                        setState(() {
                          print(widget.task.steps);
                          widget.task.steps.add(TaskStep(
                              title: addStepFormController.text,
                              isDone: false,
                              textEditingController: TextEditingController()));
                          widget.onTaskChanged();
                        });
                      },
                    ),
                     Divider(
                      color: Constants.stepTaskColor,
                      height: 0,
                      thickness: 1,
                      indent: 26,
                      endIndent: 26,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Form(
                        key: widget.noteForm,
                        child: TextFormField(
                          maxLines: null,
                          keyboardType: TextInputType.text,
                          controller: addNoteStepController,
                          decoration: InputDecoration(
                              hintText: 'Заметки по задаче',
                              border: InputBorder.none),
                          onFieldSubmitted: (text) {
                            setState(() {
                              widget.task.note = text;
                            });
                          },
                        ),
                      ),
                    )
                  ]),
                ),
                Card(
                  elevation: 10.0,
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 16, top: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.add_alert,
                              color: Constants.stepTaskColor,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                'Напомнить',
                                style:
                                    TextStyle(color: Constants.stepTaskColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: ToDoDivider(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.calendar_today,
                              color: Constants.stepTaskColor,
                            ),
                            SizedBox(
                              height: 25,
                              child: FlatButton(
                                textColor: Constants.stepTaskColor,
                                child: widget.task.deadlineDate == null
                                    ? Text('Добавить дату выполнения')
                                    : Text(widget.task.deadlineDate),
                                onPressed: () {
                                  showSelectDateDialog(context);
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ]),
            ),
          ],
        ),
        buildFab()
      ],
    );
  }

  Widget buildTaskName() {
    double top = 124.0;
    double scaleStart = top;
    double scaleEnd = scaleStart * 0.5;
    double scale = 1.0;

    if (_scrollController.hasClients) {
      top -= _scrollController.offset;
      if (_scrollController.offset < top - scaleStart) {
        scale = 1.0;
      } else if (_scrollController.offset < top - scaleEnd) {
        scale = (top - scaleEnd - _scrollController.offset) / scaleEnd;
      } else {
        scale = 0.0;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(scale),
        child: Text(
          widget.task.title,
          style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildFab() {
    final double defaultTopMargin = 124;

    final double scale0edge = 128 - kToolbarHeight;
    final double scale1edge = defaultTopMargin - 96;

    double top = defaultTopMargin;
    double scale = 1.0;

    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset > 0 ? offset : 0;
      if (offset < scale1edge) {
        scale = 1.0;
      } else if (offset > scale0edge) {
        scale = 0.0;
      } else {
        scale = (scale0edge - offset) / (scale0edge - scale1edge);
      }
    }
    ;

    return Positioned(
      top: top,
      left: 16,
      child: new Transform(
        transform: new Matrix4.identity()..scale(scale, scale),
        alignment: Alignment.center,
        child: FloatingActionButton(
          backgroundColor: Color(0xFF01A39D),
          child: showIcon(),
          onPressed: () {
            setState(() {
              changeStatusOfTask();
              widget.onTaskChanged();
            });
          },
        ),
      ),
    );
  }

  String showNotePlaceholder() {
    if (widget.task.note == null || widget.task.note.isEmpty) {
      return "Заметки по задаче...";
    } else {
      return widget.task.note;
    }
  }

  void changeStatusOfTask() {
    if (widget.task.isDone) {
      widget.task.isDone = !widget.task.isDone;
    } else {
      widget.task.isDone = !widget.task.isDone;
    }
  }

  Icon showIcon() {
    if (widget.task.isDone) {
      return Icon(Icons.clear);
    } else {
      return Icon(Icons.check);
    }
  }

  Future showEditNameTaskDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return EditNameTaskAlertDialog(
              task: widget.task,
              onEditTaskName: () {
                setState(() {
                  widget.onTaskChanged();
                });
              });
        });
  }

  Future showSelectDateDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return DateSelectorDialog(onDateSet: (date) {
            setState(() {
              widget.task.deadlineDate = date;
            });
          });
        });
  }

  Future showConfirmDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return ConfirmDeleteTaskDialog(
          onDeleteTaskFromConfirmDialog: () {
            setState(() {
              Navigator.pop(context);
              widget.onTaskDelete();
            });
          }
        );
      }
    );
  }

  void selectedItem(String value) {
    switch (value) {
      case 'Редактировать':
        showEditNameTaskDialog(context);
        break;
      case 'Удалить':
        showConfirmDialog(context);
        break;
    }
  }

  void deleteItem(TaskStep step) {
    setState(() {
      widget.task.steps.remove(step);
    });
    print(widget.task.steps);
  }
}

class StepListItem extends StatefulWidget {
  TextEditingController textEditingController;
  final Function onDelete;
  final Function onStepChanged;
  final TaskStep step;

  StepListItem({
    this.step,
    this.onDelete,
    this.onStepChanged,
  });

  @override
  _StepListItemState createState() => _StepListItemState();
}

class _StepListItemState extends State<StepListItem> {
  GlobalKey<FormState> stepForm;

  @override
  void initState() {
    super.initState();
    stepForm = GlobalKey<FormState>();
    widget.textEditingController = TextEditingController()
      ..text = widget.step.title;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20,
            width: 20,
            child: Checkbox(
              activeColor: Color(0xFF6202EE),
              checkColor: Colors.white,
              value: widget.step.isDone,
              onChanged: (bool value) {
                setState(() {
                  widget.step.isDone = value;
                  widget.onStepChanged();
                });
              },
            ),
          ),
          SizedBox(
            width: 9,
          ),
          Flexible(
            child: Form(
              key: stepForm,
              child: TextFormField(
                style: TextStyle(color: Constants.stepTaskColor),
                keyboardType: TextInputType.text,
                maxLines: null,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Введите текст';
                  }
                  return null;
                },
                decoration: InputDecoration(border: InputBorder.none),
                controller: widget.textEditingController,
                onFieldSubmitted: (text) {
                  if (stepForm.currentState.validate()) {
                    setState(() {
                      widget.step.title = text;
                      print(widget.step.title);
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(
            width: 20,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: widget.onDelete,
              child: Icon(
                Icons.close,
                color: Constants.stepTaskColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddStepButton extends StatefulWidget {
  static final addStepForm = GlobalKey<FormState>();
  final Function onAddStep;
  bool isKeyboardShow;

  AddStepButton({@required this.onAddStep, @required this.isKeyboardShow});

  @override
  _AddStepButtonState createState() => _AddStepButtonState();
}

class _AddStepButtonState extends State<AddStepButton> {
  FocusNode myFocusNode;
  bool shouldShowTextField = false;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: !shouldShowTextField
            ? buildAddStepButton(context)
            : buildAddStepTextFormField(context));
  }

  Widget buildAddStepButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: ButtonBar(
        layoutBehavior: ButtonBarLayoutBehavior.constrained,
        alignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.add, color: Color(0xFF1A9FFF)),
          FlatButton(
            child: Text('Добавить шаг'),
            onPressed: () {
              widget.isKeyboardShow = true;
              setState(() {
                shouldShowTextField = !shouldShowTextField
                    ? shouldShowTextField = true
                    : shouldShowTextField = false;
              });
              myFocusNode.requestFocus();
            },
          ),
        ],
      ),
    );
  }

  Widget buildAddStepTextFormField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Form(
        key: AddStepButton.addStepForm,
        child: TextFormField(
          focusNode: myFocusNode,
          maxLines: null,
          keyboardType: TextInputType.text,
          controller: addStepFormController,
          onFieldSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                widget.isKeyboardShow = false;
                widget.onAddStep();
                shouldShowTextField = !shouldShowTextField;
                addStepFormController.clear();
              });
            } else {
              setState(() {
                shouldShowTextField = !shouldShowTextField;
              });
            }
          },
        ),
      ),
    );
  }
}

class EditNameTaskAlertDialog extends StatelessWidget {
  final Function onEditTaskName;
  final Task task;
  final formKey = GlobalKey<FormState>();

  EditNameTaskAlertDialog({@required this.onEditTaskName, @required this.task});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Редактирование'),
      content: Form(
        key: formKey,
        child: TextFormField(
          maxLines: null,
          controller: taskNameEditorController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Введите текст';
            } else if (value.length > 50) {
              return 'Максимальное число символов - 50';
            }
            return null;
          },
          decoration: InputDecoration(hintText: ''),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Отмена'),
          onPressed: () {
            taskNameEditorController.clear();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Выбрать'),
          onPressed: () {
            if (formKey.currentState.validate()) {
              task.title = taskNameEditorController.text;
              onEditTaskName();
              Navigator.of(context).pop();
            }
          },
        )
      ],
    );
  }
}

class DateSelectorDialog extends StatelessWidget {
  final Function(String date) onDateSet;

  DateSelectorDialog({@required this.onDateSet});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FlatButton(
            child: Text('Сегодня', style: TextStyle(color: Constants.stepTaskColor)),
            onPressed: () {
              Navigator.pop(context);
              final date = DateFormat('dd.mm.yy').format(DateTime.now());
              onDateSet(date);
            },
          ),
          FlatButton(
            child: Text('Завтра', style: TextStyle(color: Constants.stepTaskColor),),
            onPressed: () {
              Navigator.pop(context);
              final tomorrow = DateTime.now().add(Duration(days: 1));
              final date = DateFormat('dd.mm.yy').format(tomorrow);
              onDateSet(date);
            },
          ),
          FlatButton(
            child: Text('На следующей неделе', style: TextStyle(color: Constants.stepTaskColor)),
            onPressed: () {
              Navigator.pop(context);
              final tomorrow = DateTime.now().add(Duration(days: 7));
              final date = DateFormat('dd.mm.yy').format(tomorrow);
              onDateSet(date);
            },
          ),
          FlatButton(
            child: Text('Выбрать дату и время', style: TextStyle(color: Constants.stepTaskColor)),
            onPressed: () {
              Navigator.pop(context);
              var platform = Theme.of(context).platform;
              if (platform == TargetPlatform.android) {
                selectDate(context);
              } else if (platform == TargetPlatform.iOS) {
              showCupertinoDatePicker();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2050));
    if (date != null) {
      final formattedDate = DateFormat('dd.MM.yyyy').format(date);
      onDateSet(formattedDate);
    }
  }

  Future showCupertinoDatePicker() async {
   return showModalBottomSheet(
        context: myGlobals.scaffoldKey.currentContext,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(myGlobals.scaffoldKey.currentContext).copyWith().size.width / 3,
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime date) {
                final formattedDate = DateFormat('dd.MM.yyyy').format(date);
                onDateSet(formattedDate);
              },
              maximumYear: 2050,
              minimumYear: 2020,
              mode: CupertinoDatePickerMode.date,
            ),
          );
        });
  }
}

class ToDoDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Constants.stepTaskColor,
      height: 0,
      thickness: 1,
      indent: 56,
      endIndent: 0,
    );
  }
}

class ConfirmDeleteTaskDialog extends StatelessWidget {
  final Function onDeleteTaskFromConfirmDialog;

  ConfirmDeleteTaskDialog({this.onDeleteTaskFromConfirmDialog});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Вы действительно хотите удалить это задание?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Отмена'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Удалить'),
          onPressed: () {
            Navigator.pop(context);
              onDeleteTaskFromConfirmDialog();
          },
        )
      ],
    );
  }
}


class MyGlobals {
  GlobalKey _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}