import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


/// Platform-aware activity indicator
class PeerLoader extends StatelessWidget {
  const PeerLoader({
    Key? key,
    this.materialStrokeWidth = 1.5,
    this.height,
  }) : super(key: key);

  final double? height;
  final double materialStrokeWidth;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return SizedBox(
        height: height ?? 20,
        width: height ?? 20,
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: CircularProgressIndicator(strokeWidth: materialStrokeWidth),
          ),
        ),
      );
    }

    return const CupertinoActivityIndicator();
  }
}
