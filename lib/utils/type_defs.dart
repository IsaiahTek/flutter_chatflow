import 'package:flutter/material.dart';

/// Video Widget Builder Callback
typedef VideoWidgetBuilder = Widget Function(
    {required BuildContext context, required String uri});

/// Custom Widget Builder Callback
typedef CustomWidgetBuilder = Widget Function(
    {required BuildContext context, required String uri});
