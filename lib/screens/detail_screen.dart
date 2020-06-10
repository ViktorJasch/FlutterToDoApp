import 'package:sliver_fab/sliver_fab.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/model/task_step.dart';
import 'package:todoapp/model/task.dart';

var addStepFormController = TextEditingController();
var addNoteStepController = TextEditingController();
var editStepController = TextEditingController();
var taskNameEditorController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    addNoteStepController = TextEditingController()..text = widget.task.note;
    _scrollController = ScrollController();
    _scrollController.addListener(() => setState(() {}));
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
              floating: true,
              pinned: false,
              snap: false,
              bottom: buildTaskName(),
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Card(
                      elevation: 10.0,
                      margin: EdgeInsets.only(top: 28, left: 16, right: 16),
                      child: Column(children: <Widget>[
                        Column(
                          children: widget.task.steps.map((TaskStep step) {
                            return StepListItem(
                              textEditingController: step.textEditingController
                                ..text = step.title,
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
                          onAddStep: () {
                            setState(() {
                              print(widget.task.steps);
                              widget.task.steps.add(TaskStep(
                                  title: addStepFormController.text,
                                  isDone: false,
                                  textEditingController:
                                      TextEditingController()));
                              widget.onTaskChanged();
                            });
                          },
                        ),
                        const Divider(
                          color: Colors.black,
                          height: 0,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
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
                    )
                  ],
                ),
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

    return PreferredSize(
      child: Padding(
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
      ),
    );
  }

  Widget buildFab() {
    final double defaultFabSize = 56.0;
    final double paddingTop = MediaQuery
        .of(context)
        .padding
        .top;
    final double defaultTopMargin = 128;

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
    };

    return Positioned(
      top: top,
      left: 16,
      child: new Transform(
        transform: new Matrix4.identity()..scale(scale, scale),
        alignment: Alignment.center,
        child: FloatingActionButton(

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

  void deleteTask() {
    Navigator.pop(context);
    widget.onTaskDelete();
  }

  Future displayDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AddTaskAlertDialog(
              task: widget.task,
              onEditTaskName: () {
                setState(() {
                  widget.onTaskChanged();
                });
              });
        });
  }

  void selectedItem(String value) {
    switch (value) {
      case 'Редактировать':
        displayDialog(context);
        break;
      case 'Удалить':
        deleteTask();
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
  final stepForm = GlobalKey<FormState>();
  TextEditingController textEditingController;
  final Function onDelete;
  final Function onStepChanged;
  final TaskStep step;

  StepListItem(
      {this.step,
      this.onDelete,
      this.onStepChanged,
      this.textEditingController});

  @override
  _StepListItemState createState() => _StepListItemState();
}

class _StepListItemState extends State<StepListItem> {
  @override
  void initState() {
    super.initState();
    widget.textEditingController = TextEditingController()
      ..text = widget.step.title;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Checkbox(
            value: widget.step.isDone,
            onChanged: (bool value) {
              setState(() {
                widget.step.isDone = value;
                widget.onStepChanged();
              });
            },
          ),
          Flexible(
            child: Form(
              key: widget.stepForm,
              child: TextFormField(
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
                  if (widget.stepForm.currentState.validate()) {
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
            width: 40,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: widget.onDelete,
              child: Icon(
                Icons.close,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddStepButton extends StatefulWidget {
  final addStepForm = GlobalKey<FormState>();
  final Function onAddStep;

  AddStepButton({@required this.onAddStep});

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
    return ButtonBar(
      layoutBehavior: ButtonBarLayoutBehavior.constrained,
      alignment: MainAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          child: Text('+  Добавить шаг'),
          onPressed: () {
            setState(() {
              shouldShowTextField = !shouldShowTextField
                  ? shouldShowTextField = true
                  : shouldShowTextField = false;
            });
            myFocusNode.requestFocus();
          },
        ),
      ],
    );
  }

  Widget buildAddStepTextFormField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Form(
        key: widget.addStepForm,
        child: TextFormField(
          focusNode: myFocusNode,
          maxLines: null,
          keyboardType: TextInputType.text,
          controller: addStepFormController,
          onFieldSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
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

class AddTaskAlertDialog extends StatelessWidget {
  final Function onEditTaskName;
  final Task task;
  final formKey = GlobalKey<FormState>();

  AddTaskAlertDialog({@required this.onEditTaskName, @required this.task});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Редактирование'),
      content: Form(
        key: formKey,
        child: TextFormField(
          maxLines: null,
          controller: editStepController,
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
            editStepController.clear();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Выбрать'),
          onPressed: () {
            if (formKey.currentState.validate()) {
              task.title = editStepController.text;
              onEditTaskName();
              Navigator.of(context).pop();
            }
          },
        )
      ],
    );
  }
}
