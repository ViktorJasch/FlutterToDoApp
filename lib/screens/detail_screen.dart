import 'package:flutter/material.dart';
class item_manager {
  void deleteItem(int index) {}
}

class DetailScreen extends StatelessWidget {
  DetailScreen({@required this.title});

  final title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        title: Text('$title'),
      ),
      body: DetailView(),
    );
  }
}

class DetailView extends StatefulWidget {

  final List<Step> steps = [
    Step(title: "Найти запчасти", isDone: false),
    Step(
        title:
            "Купить запчасти",
        isDone: false)
  ];

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> implements item_manager {

  final key = GlobalKey<FormState>();
  bool shouldShowTextField = false;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 322),
      child: Column(
        children: <Widget>[
          ListView(
            shrinkWrap: true,
          children: widget.steps.map((Step step) {
           int index =  widget.steps.indexOf(step);
            return ListViewItem(step: step, onDelete: () {
              setState(() {
                deleteItem(index);
              });
            });
          }).toList(),
        ),
          switchWidgets(),
        ]
      ),
    ));
  }

  Widget switchWidgets() {
    if (shouldShowTextField == false) {
      return ButtonBar(
        layoutBehavior: ButtonBarLayoutBehavior.constrained,
        alignment: MainAxisAlignment.start,
        children: <Widget>[
          FlatButton(
            child: Text('+ Добавить шаг'),
            onPressed: () {
              setState(() {
                  shouldShowTextField = !shouldShowTextField ? shouldShowTextField = true  : shouldShowTextField = false;
              });
            },
          ),
        ],
      );
    } else {
      return Form(
          key: key,
          child: TextFormField(
            onFieldSubmitted:(value) {
                setState(() {
                  shouldShowTextField = false;
                  widget.steps.add(Step(title: value, isDone: false));
                });
            },
          ),

        );
    }
}

  @override
  void deleteItem(int index) {
    setState(() {
      widget.steps.removeAt(index);
    });
  }

}

class ListViewItem extends StatefulWidget {

  final Function onDelete;
  final Step step;


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

class Step {
  String title;
  bool isDone;

  Step({@required this.title, @required this.isDone});
}
