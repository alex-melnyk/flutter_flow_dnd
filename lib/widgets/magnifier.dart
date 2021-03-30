import 'package:flutter/material.dart';

class MagnifierControl extends StatefulWidget {
  MagnifierControl({
    Key key,
    this.scale = 1.0,
    this.style = const TextStyle(
      fontSize: 12.0,
    ),
    this.onChanged,
  }) : super(key: key);

  /// Scale value from that converts to percentage.
  final double scale;

  /// Text style.
  final TextStyle style;

  /// Value changed callback.
  final ValueChanged<double> onChanged;

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

    final percents = (widget.scale * 100.0).toStringAsFixed(2);

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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove,
                    size: 16.0,
                  ),
                  onPressed: () => _handleValueChanged(widget.scale - 0.1),
                ),
                InkWell(
                  onTap: () => _handleValueChanged(1.0),
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
                  onPressed: () => _handleValueChanged(widget.scale + 0.1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleValueChanged(double newValue) {
    if (widget.onChanged != null) {
      widget.onChanged(newValue);
    }
  }
}
