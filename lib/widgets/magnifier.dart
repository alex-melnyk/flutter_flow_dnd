import 'package:flutter/material.dart';

class MagnifierControlController extends ValueNotifier<double> {
  MagnifierControlController({
    this.min = 0.1,
    this.max = 2.0,
    double value = 1.0,
  }) : super(value);

  final double min;
  final double max;

  @override
  set value(double newValue) {
    super.value = newValue > max
        ? max
        : newValue < min
            ? min
            : newValue;
  }
}

class MagnifierControl extends StatefulWidget {
  MagnifierControl({
    Key key,
    @required this.controller,
    this.style = const TextStyle(
      fontSize: 12.0,
    ),
  }) : super(key: key);

  final MagnifierControlController controller;
  final TextStyle style;

  @override
  _MagnifierControlState createState() => _MagnifierControlState();
}

class _MagnifierControlState extends State<MagnifierControl>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (event) => _animationController.forward(),
      onExit: (event) => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: Tween<double>(begin: 0.3, end: 0.9)
                .evaluate(_animationController),
            child: child,
          );
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: theme.canvasColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ValueListenableBuilder(
              valueListenable: widget.controller,
              builder: (_, value, __) {
                final percents =
                    (widget.controller.value * 100.0).toStringAsFixed(2);

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.remove,
                        size: 16.0,
                      ),
                      onPressed: () => widget.controller.value -= 0.1,
                    ),
                    InkWell(
                      onTap: () => widget.controller.value = 1.0,
                      child: Container(
                        width: 50,
                        child: Text(
                          '$percents%',
                          textAlign: TextAlign.center,
                          style: widget.style,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        size: 16.0,
                      ),
                      onPressed: () => widget.controller.value += 0.1,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
