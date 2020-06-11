import 'package:flutter/material.dart';
import 'package:todoapp/model/task_step.dart';

class Task {
  List<TaskStep> steps;
  String title;
  bool isDone;
  String note;
  String id;
  String creationDate;
  String deadlineDate;

  Task({@required this.title, @required this.isDone, @required this.steps, @required this.note, @required this.id, @required this.creationDate, @required this.deadlineDate});
}
