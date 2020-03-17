import 'package:flutter/material.dart';
import 'package:clock/clock.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clock',
      home: Scaffold(
        body: Clock(),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}
