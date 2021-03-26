import 'package:flutter/material.dart';
import 'package:flutter_flow_dnd/widgets/flow_stack.dart';

class FlowScreen extends StatefulWidget {
  @override
  _FlowScreenState createState() => _FlowScreenState();
}

class _FlowScreenState extends State<FlowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FlowStack(),
    );
  }
}
