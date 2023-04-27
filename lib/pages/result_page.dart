import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage(this.result, {Key? key}) : super(key: key);

  final String result;
  
  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text(widget.result),
    ));
  }
}
