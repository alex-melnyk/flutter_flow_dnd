import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow_dnd/widgets/widgets.dart';

class FlowStack extends StatefulWidget {
  FlowStack({
    Key key,
    this.scaleMin = 0.1,
    this.scaleMax = 2.0,
  })  : assert(scaleMin < scaleMax, 'scaleMax should be greater than scaleMin'),
        super(key: key);

  final double scaleMin;
  final double scaleMax;

  @override
  _FlowStackState createState() => _FlowStackState();
}

class _FlowStackState extends State<FlowStack> {
  final _flowOffset = ValueNotifier<Offset>(Offset(0, 0));
  final _magnifierController = MagnifierControlController();
  final _dragHold = ValueNotifier<bool>(false);
  final _panCaptured = ValueNotifier<bool>(false);
  Offset _tempOffset = Offset.zero;
  Offset _capturePosition = Offset.zero;
  double _scroll = 1.0;

  @override
  void initState() {
    super.initState();

    _magnifierController.addListener(() {
      _scroll = _magnifierController.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Listener(
      onPointerSignal: _handlePointer,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: _handleKeyboard,
        child: GestureDetector(
          onPanStart: _handlePanStart,
          onPanUpdate: _handlePanUpdate,
          onPanEnd: (details) => _handlePanEnd(),
          onPanCancel: _handlePanEnd,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
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
                    valueListenable: _magnifierController,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
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
                                            color: dragHold
                                                ? Colors.green
                                                : Colors.white,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' + Left Mouse Button',
                                          style: TextStyle(
                                            color: panCaptured
                                                ? Colors.green
                                                : Colors.white,
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
                                            color: dragHold
                                                ? Colors.green
                                                : Colors.white,
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
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 16.0,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                _flowOffset.value = Offset.zero;
                                _magnifierController.value = 1.0;
                              },
                              child: Text('Reset'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // INDICATORS
                Align(
                  alignment: Alignment.topLeft,
                  child: MagnifierControl(
                    controller: _magnifierController,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleKeyboard(event) {
    if (event.isKeyPressed(LogicalKeyboardKey.space)) {
      _dragHold.value = true;
    } else {
      _dragHold.value = false;
    }
  }

  void _handlePointer(event) {
    final height = MediaQuery.of(context).size.height;

    if (event is PointerScrollEvent && _dragHold.value) {
      _scroll += event.scrollDelta.dy / height;
      _scroll = _scroll > widget.scaleMax
          ? widget.scaleMax
          : _scroll < widget.scaleMin
              ? widget.scaleMin
              : _scroll;

      _magnifierController.value = _scroll;
    }
  }

  void _handlePanStart(DragStartDetails details) {
    _capturePosition = details.globalPosition;
    _tempOffset = _flowOffset.value;
    _panCaptured.value = true;
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_panCaptured.value || !_dragHold.value) return;

    final diff = details.globalPosition - _capturePosition;

    _flowOffset.value = _tempOffset + diff;
  }

  void _handlePanEnd() {
    _panCaptured.value = false;
  }
}
