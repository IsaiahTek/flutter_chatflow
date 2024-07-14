import 'package:flutter/material.dart';

/// Use this widget if you want to dynamically constrain parent this container to its child height
class MeasureSize extends StatefulWidget {
  /// Widget to use as child
  final Widget child;

  /// Pass in the required child
  const MeasureSize({super.key, required this.child});

  @override
  State<MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  Size? _size;
  final GlobalKey _widgetKey = GlobalKey();

  void _afterLayout(_) {
    final context = _widgetKey.currentContext;
    if (context == null) return;

    final size = context.size;
    setState(() {
      _size = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: Colors.amber,
          height: _size?.height ?? 20,
          width: MediaQuery.of(context).size.width,
          child: widget.child,
        );
      },
    );
  }
}
