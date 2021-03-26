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
  Offset _tempOffset = Offset.zero;
  Offset _capturePosition = Offset.zero;
  double _scroll = 1.0;
  bool _captured = false;
  bool _dragHold = false;

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
            _dragHold = true;
          } else {
            _dragHold = false;
          }
        },
        child: Listener(
          onPointerSignal: (event) {
            if (event is PointerScrollEvent && _dragHold) {
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
              _captured = true;
            },
            onPanUpdate: (details) {
              if (!_captured || !_dragHold) return;

              final diff = details.globalPosition - _capturePosition;

              _flowOffset.value = _tempOffset + diff;
            },
            onPanEnd: (details) {
              _captured = false;
            },
            onPanCancel: () {
              _captured = false;
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
                      child: Text(
                        'Drag: Space + Left Mouse Button'
                            '\nScale: Space + Mouse Scroll',
                        textAlign: TextAlign.center,
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
