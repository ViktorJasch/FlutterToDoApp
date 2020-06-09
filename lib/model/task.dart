import 'package:flutter/material.dart';
import 'package:todoapp/model/task_step.dart';

class Task {
  List<TaskStep> steps;
  String title;
  bool isDone;
  String note;
  String id;

  Task({this.title, this.isDone, this.steps, this.note, @required this.id});
}
