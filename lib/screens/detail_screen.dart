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
      resizeToAvoidBottomPadding: false,
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
  bool shouldShowTextField = false;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              shouldShowTextField: shouldShowTextField,
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
                  controller: addNoteStepController,
                  decoration: InputDecoration(
                    hintText: showNotePlaceholder(),
                    border: InputBorder.none
                  ),
                  onFieldSubmitted: (text) {
                    setState(() {
                      widget.task.note = text;
                      addNoteStepController.clear();
                    });
                  },
                ),
              ),
            )
          ]),
        )
      ],
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
                decoration: InputDecoration(
                  border: InputBorder.none
                ),
                controller: widget.textEditingController,
//                initialValue: 'Init',
                onFieldSubmitted: (text) {
                  setState(() {
                    widget.step.title = text;
                    print(widget.step.title);
                  });
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
  bool shouldShowTextField;

  AddStepButton({@required this.shouldShowTextField, @required this.onAddStep});

  @override
  _AddStepButtonState createState() => _AddStepButtonState();
}

class _AddStepButtonState extends State<AddStepButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: !widget.shouldShowTextField
            ? ButtonBar(
                layoutBehavior: ButtonBarLayoutBehavior.constrained,
                alignment: MainAxisAlignment.start,
                children: <Widget>[
                  FlatButton(
                    child: Text('+  Добавить шаг'),
                    onPressed: () {
                      setState(() {
                        widget.shouldShowTextField = !widget.shouldShowTextField
                            ? widget.shouldShowTextField = true
                            : widget.shouldShowTextField = false;
                      });
                    },
                  ),
                ],
              )
            : Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Form(
                  key: widget.key,
                  child: TextFormField(
                    controller: addStepFormController,
                    onFieldSubmitted: (value) {
                      setState(() {
                        widget.onAddStep();
                        widget.shouldShowTextField = !widget.shouldShowTextField;
                        addStepFormController.clear();
                      });
                    },
                  ),
                ),
            ));
  }
}
