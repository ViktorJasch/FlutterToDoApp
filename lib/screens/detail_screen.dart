import 'package:flutter/material.dart';
import 'package:todoapp/model/task_step.dart';
import 'package:todoapp/model/task.dart';

var addStepFormController = TextEditingController();
var addNoteStepController = TextEditingController();

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
    return Center(
        child: Card(
      margin: EdgeInsets.only(top: 28, left: 16, right: 16),
      child: Column(children: <Widget>[
        SizedBox(
          height: 170,
          child: ListView(
            shrinkWrap: true,
            children: widget.task.steps.map((TaskStep step) {
              int index = widget.task.steps.indexOf(step);
              return ListViewItem(
                  step: step,
                  onStepChanged: () {
                    widget.onTaskChanged();
                  },
                  onDelete: () {
                    setState(() {
                      deleteItem(index);
                      widget.onTaskChanged();
                    });
                  });
            }).toList(),
          ),
        ),
        AddStepButton(
          shouldShowTextField: shouldShowTextField,
          onAddStep: () {
            setState(() {
              print(widget.task.steps);
              widget.task.steps
                  .add(TaskStep(title: addStepFormController.text, isDone: false));
              widget.onTaskChanged();
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Form(
            key: widget.noteForm,
            child: TextFormField(
              controller: addNoteStepController,
              decoration: InputDecoration(
                hintText: showNotePlaceholder(),
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
    ));
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
  final Function onDelete;
  final Function onStepChanged;
  final TaskStep step;

  ListViewItem({this.step, this.onDelete, this.onStepChanged});

  @override
  _ListViewItemState createState() => _ListViewItemState();
}

class _ListViewItemState extends State<ListViewItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
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
          Expanded(
            child: Text(widget.step.title,
                textDirection: TextDirection.ltr,
                overflow: TextOverflow.ellipsis,
                maxLines: 3),
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
            : Form(
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
              ));
  }
}
