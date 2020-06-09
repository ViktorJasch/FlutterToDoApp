import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/model/task_step.dart';
import 'package:todoapp/model/task.dart';

var addStepFormController = TextEditingController();
var addNoteStepController = TextEditingController();
var editStepController = TextEditingController();

class DetailScreen extends StatelessWidget {
  final Function(Task task) onTaskChanged;

  DetailScreen({@required this.task, this.onTaskChanged});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: DetailView(task: task, onTaskChanged: () {
        onTaskChanged(task);
      },),
    );
  }
}

class DetailView extends StatefulWidget {
  final noteForm = GlobalKey<FormState>();
  final Function onTaskChanged;
  final Task task;

DetailView({@required this.task, this.onTaskChanged});

  @override
  _DetailViewState createState() => _DetailViewState();
}



class _DetailViewState extends State<DetailView> {

  @override
  void initState() {
    super.initState();
    addNoteStepController = TextEditingController()..text = widget.task.note;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(
            elevation: 10.0,
            margin: EdgeInsets.only(top: 28, left: 16, right: 16),
            child: Column(children: <Widget>[
              Column(
                children: widget.task.steps.map((TaskStep step) {
                  int index = widget.task.steps.indexOf(step);
                  return ListViewItem(
                    textEditingController: step.textEditingController..text = step.title,
                    step: step,
                    onStepChanged: widget.onTaskChanged,
                    onDelete: () {
                      setState(() {
                        deleteItem(index);
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
                    widget.task.steps
                        .add(TaskStep(title: addStepFormController.text, isDone: false, textEditingController: TextEditingController()));
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
                      border: InputBorder.none
                    ),
                    onFieldSubmitted: (text) {
                      setState(() {
                        widget.task.note = text;
//                      addNoteStepController.clear();
                      });
                    },
                  ),
                ),
              )
            ]),
          )
        ],
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

  void deleteItem(int index) {
    setState(() {
      widget.task.steps.removeAt(index);
    });
    print(widget.task.steps);
  }
}

class ListViewItem extends StatefulWidget {
  final stepForm = GlobalKey<FormState>();
  TextEditingController textEditingController;
  final Function onDelete;
  final Function onStepChanged;
  final TaskStep step;
  bool validate;

  ListViewItem({this.step, this.onDelete, this.onStepChanged, this.textEditingController});

  @override
  _ListViewItemState createState() => _ListViewItemState();
}

class _ListViewItemState extends State<ListViewItem> {

  @override
  void initState() {
    super.initState();
    widget.textEditingController = TextEditingController()..text = widget.step.title;
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
                decoration: InputDecoration(
                  border: InputBorder.none
                ),
                controller: widget.textEditingController,
//                initialValue: 'Init',
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
            ? ButtonBar(
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
              )
            : Padding(
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
            ));
  }
}
