import 'package:flutter/material.dart';
import 'package:thepeer_flutter/thepeer_flutter.dart';

class ThePeerViewControllerData {
  /// Public Key from your https://app.withThepeer.com/apps
  final ThePeerData data;

  /// Success callback
  final VoidCallback? onSuccess;

  /// Thepeer popup Close callback
  final VoidCallback? onClosed;

  /// Error Widget will show if loading fails
  final Widget? error;

  /// Show ThepeerView Logs
  final bool showLogs;

  /// Toggle dismissible mode
  final bool isDismissible;

  ThePeerViewControllerData({
    required this.data,
    required this.onSuccess,
    required this.onClosed,
    required this.error,
    required this.showLogs,
    required this.isDismissible,
  });
}
