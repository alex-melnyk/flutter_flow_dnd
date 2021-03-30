import 'package:flutter/material.dart';
import 'package:flutter_flow_dnd/widgets/flow_stack.dart';

class FlowScreen extends StatefulWidget {
  @override
  _FlowScreenState createState() => _FlowScreenState();
}

class _FlowScreenState extends State<FlowScreen> {
  final flowStackController = FlowStackController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.red,
      body: FlowStack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Drag: ',
                      ),
                      TextSpan(
                        text: 'Space + Left Mouse Button',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                      TextSpan(
                        text: '\nScale: ',
                      ),
                      TextSpan(
                        text: 'Space + Mouse Scroll',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // _flowOffset.value = Offset.zero;
                      // _magnifierController.value = 1.0;
                    },
                    child: Text('Reset'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}/**/