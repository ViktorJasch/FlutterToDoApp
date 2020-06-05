import 'package:flutter/material.dart';

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
            "Отвезти автомобиль в автосервис, если Иваныч опять нажрался, то ремонтировать самому",
        isDone: false)
  ];

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
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
            return ListViewItem(step: step);
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
      return WillPopScope(
        child: Form(
          key: key,
          child: TextFormField(
            onFieldSubmitted:(value) {
                setState(() {
                  shouldShowTextField = false;
                  widget.steps.add(Step(title: value, isDone: false));
                });
            },
          ),
          onWillPop: () {
            setState(() {
              shouldShowTextField = false;
            });
          },
        ),
      );
    }

}

}

class ListViewItem extends StatefulWidget {
  final Step step;

  ListViewItem({@required this.step});

  @override
  _ListViewItemState createState() => _ListViewItemState(step: step);
}

class _ListViewItemState extends State<ListViewItem> {
  final Step step;

  _ListViewItemState({@required this.step});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Checkbox(
            value: step.isDone,
            onChanged: (bool value) {
              setState(() {
                step.isDone = value;
              });
            },
          ),
          Expanded(
            child: Text(step.title,
                textDirection: TextDirection.ltr,
                overflow: TextOverflow.ellipsis,
                maxLines: 3),
          ),
          SizedBox(
            width: 40,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () => deleteItem(),
              child: Icon(
                Icons.close,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deleteItem() {}
}

class Step {
  String title;
  bool isDone;

  Step({@required this.title, @required this.isDone});
}
