import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlowScreen extends StatefulWidget {
  @override
  _FlowScreenState createState() => _FlowScreenState();
}

class _FlowScreenState extends State<FlowScreen> {
  final _flowOffset = ValueNotifier<Offset>(Offset(0, 0));
  final _scale = ValueNotifier<double>(1.0);
  final _dragHold = ValueNotifier<bool>(false);
  final _panCaptured = ValueNotifier<bool>(false);
  Offset _tempOffset = Offset.zero;
  Offset _capturePosition = Offset.zero;
  double _scroll = 1.0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.space)) {
            _dragHold.value = true;
          } else {
            _dragHold.value = false;
          }
        },
        child: Listener(
          onPointerSignal: (event) {
            if (event is PointerScrollEvent && _dragHold.value) {
              _scroll += event.scrollDelta.dy / 100.0;

              _scroll = _scroll > 1.5
                  ? 1.5
                  : _scroll < 0.5
                      ? 0.5
                      : _scroll;

              _scale.value = _scroll;
            }
          },
          child: GestureDetector(
            onPanStart: (details) {
              _capturePosition = details.globalPosition;
              _tempOffset = _flowOffset.value;
              _panCaptured.value = true;
            },
            onPanUpdate: (details) {
              if (!_panCaptured.value || !_dragHold.value) return;

              final diff = details.globalPosition - _capturePosition;

              _flowOffset.value = _tempOffset + diff;
            },
            onPanEnd: (details) {
              _panCaptured.value = false;
            },
            onPanCancel: () {
              _panCaptured.value = false;
            },
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                ValueListenableBuilder(
                  valueListenable: _flowOffset,
                  builder: (_, value, child) {
                    return Positioned(
                      left: value.dx,
                      top: value.dy,
                      width: screenSize.width,
                      height: screenSize.height,
                      child: child,
                    );
                  },
                  child: ValueListenableBuilder(
                    valueListenable: _scale,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      width: screenSize.width,
                      height: screenSize.height,
                      color: Colors.red,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: _dragHold,
                            builder: (context, dragHold, child) {
                              return ValueListenableBuilder(
                                valueListenable: _panCaptured,
                                builder: (context, panCaptured, child) {
                                  return RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Drag: ',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Space',
                                          style: TextStyle(
                                            color:
                                                dragHold ? Colors.green : Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' + Left Mouse Button',
                                          style: TextStyle(
                                            color: panCaptured ? Colors.green : Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\nScale: ',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Space',
                                          style: TextStyle(
                                            color:
                                                dragHold ? Colors.green : Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' + Mouse Scroll',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _flowOffset.value = Offset.zero;
                              _scale.value = 1.0;
                            },
                            child: Text('Reset'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
