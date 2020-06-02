import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({@required this.title});

  final title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        title: Text('$title'),
      ),
    );
  }
}
