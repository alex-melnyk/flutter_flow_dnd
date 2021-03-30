import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flow_dnd/widgets/widgets.dart';

class FlowStackValue {
  const FlowStackValue({
    this.offset = Offset.zero,
    this.scale = 1.0,
  });

  /// Stack offset.
  final Offset offset;

  /// Stack scale
  final double scale;

  /// Creates a new instance of [FlowStackValue] based on current values
  /// replaced with new [offset] or [scale].
  FlowStackValue copyWith({
    Offset offset,
    double scale,
  }) =>
      FlowStackValue(
        offset: offset ?? this.offset,
        scale: scale ?? this.scale,
      );
}

class FlowStackController extends ValueNotifier<FlowStackValue> {
  FlowStackController({
    FlowStackValue value,
    this.scaleMin = 0.1,
    this.scaleMax = 10.0,
  })  : assert(scaleMin < scaleMax, 'scaleMax should be greater than scaleMin'),
        super(value ?? FlowStackValue());

  /// Minimum canvas scale.
  final double scaleMin;

  /// Maximum canvas scale.
  final double scaleMax;

  /// Returns [value] offset.
  Offset get offset => this.value.offset;

  /// Sets a new offset.
  set offset(Offset newValue) {
    super.value = super.value.copyWith(
          offset: newValue,
        );
  }

  /// Returns [value] scale.
  double get scale => this.value.scale;

  /// Sets a new scale.
  set scale(double newValue) {
    final newScale = newValue > scaleMax
        ? scaleMax
        : newValue < scaleMin
            ? scaleMin
            : newValue;

    super.value = super.value.copyWith(
          scale: newScale,
        );
  }
}

class FlowStack extends StatefulWidget {
  const FlowStack({
    Key key,
    @required this.children,
    this.controller,
  }) : super(key: key);

  /// List of child on a stack.
  final List<Widget> children;

  /// Controller that manage stack state.
  final FlowStackController controller;

  @override
  _FlowStackState createState() => _FlowStackState();
}

class _FlowStackState extends State<FlowStack> {
  FlowStackController _controller;
  final _dragHold = ValueNotifier<bool>(false);
  final _panCaptured = ValueNotifier<bool>(false);
  Offset _tempOffset = Offset.zero;
  Offset _capturePosition = Offset.zero;
  double _tempScale;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? FlowStackController();
    _tempScale = _controller.scale;
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
            backgroundColor: Colors.transparent,
            body: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                // GridPaper(),
                ValueListenableBuilder<FlowStackValue>(
                  valueListenable: _controller,
                  builder: (_, value, child) {
                    return Positioned(
                      left: value.offset.dx,
                      top: value.offset.dy,
                      width: screenSize.width,
                      height: screenSize.height,
                      child: child,
                    );
                  },
                  child: ValueListenableBuilder<FlowStackValue>(
                    valueListenable: _controller,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value.scale,
                        child: child,
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: widget.children,
                      ),
                    ),
                  ),
                ),
                // INDICATORS
                Align(
                  alignment: Alignment.topLeft,
                  child: ValueListenableBuilder<FlowStackValue>(
                    valueListenable: _controller,
                    builder: (context, value, child) {
                      return MagnifierControl(
                        scale: value.scale,
                        onChanged: (value) => _controller.scale = value,
                      );
                    },
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
      _tempScale += event.scrollDelta.dy / height;
      _tempScale = _tempScale > _controller.scaleMax
          ? _controller.scaleMax
          : _tempScale < _controller.scaleMin
              ? _controller.scaleMin
              : _tempScale;

      _controller.scale = _tempScale;
    }
  }

  void _handlePanStart(DragStartDetails details) {
    _capturePosition = details.globalPosition;
    _tempOffset = _controller.offset;
    _panCaptured.value = true;
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_panCaptured.value || !_dragHold.value) return;

    final diff = details.globalPosition - _capturePosition;

    _controller.offset = _tempOffset + diff;
  }

  void _handlePanEnd() {
    _panCaptured.value = false;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }
}
