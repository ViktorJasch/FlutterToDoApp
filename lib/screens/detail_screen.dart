import 'package:flutter/material.dart';
import 'package:todoapp/model/task_step.dart';

var myController = TextEditingController();

class DetailScreen extends StatelessWidget {
  DetailScreen({@required this.title});

  final title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        title: Text(title),
      ),
      body: DetailView(),
    );
  }
}

class DetailView extends StatefulWidget {
  final List<TaskStep> steps = [
    TaskStep(title: "Найти запчасти", isDone: false),
    TaskStep(title: "Купить запчасти", isDone: false)
  ];

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  bool shouldShowTextField = false;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 322),
      child: Column(children: <Widget>[
        ListView(
          shrinkWrap: true,
          children: widget.steps.map((TaskStep step) {
            int index = widget.steps.indexOf(step);
            return ListViewItem(
                step: step,
                onDelete: () {
                  setState(() {
                    deleteItem(index);
                  });
                });
          }).toList(),
        ),
        AddStepButton(
          shouldShowTextField: shouldShowTextField,
          onAddStep: () {
            setState(() {
              print(widget.steps);
              widget.steps
                  .add(TaskStep(title: myController.text, isDone: false));
            });
          },
        )
      ]),
    ));
  }

  void deleteItem(int index) {
    setState(() {
      widget.steps.removeAt(index);
    });
  }
}

class ListViewItem extends StatefulWidget {
  final Function onDelete;
  final TaskStep step;

  ListViewItem({@required this.step, @required this.onDelete});

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
  final key = GlobalKey<FormState>();
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
                    child: Text('+ Добавить шаг'),
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
                  controller: myController,
                  onFieldSubmitted: (value) {
                    setState(() {
                      widget.onAddStep();
                      widget.shouldShowTextField = !widget.shouldShowTextField;
                      myController.clear();
                    });
                  },
                ),
              ));
  }
}
