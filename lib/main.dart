import 'package:flutter/material.dart';
import 'package:flutter_flow_dnd/flow_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Flow Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: FlowScreen(),
    );
  }
}
