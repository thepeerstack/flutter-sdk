import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_data.dart';
import 'package:thepeer_flutter/src/utils/extensions.dart';

class ThepeerView extends StatefulWidget {
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

  const ThepeerView({
    Key? key,
    required this.data,
    this.error,
    this.onSuccess,
    this.onClosed,
    this.showLogs = false,
    this.isDismissible = true,
  });

  /// Show Dialog with a custom child
  Future show(BuildContext context) => showMaterialModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        isDismissible: isDismissible,
        context: context,
        builder: (context) => ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: context.screenHeight(.9),
                    child: ThepeerView(
                      data: data,
                      onClosed: onClosed,
                      onSuccess: onSuccess,
                      showLogs: showLogs,
                      error: error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  _ThepeerViewState createState() => _ThepeerViewState();
}

class _ThepeerViewState extends State<ThepeerView> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
    );
  }
}
