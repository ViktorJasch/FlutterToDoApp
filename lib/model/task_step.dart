import 'package:flutter/material.dart';

class TaskStep {
  String title;
  bool isDone;
  TextEditingController textEditingController;

  TaskStep({@required this.title, @required this.isDone, @required this.textEditingController});
}
