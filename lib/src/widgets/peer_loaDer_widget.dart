import 'package:flutter/material.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';

/// Peer Loader Widger
class PeerLoaderWidget extends StatelessWidget {
  final Color? color;
  final double? height, strokeWidth;
  const PeerLoaderWidget({
    Key? key,
    this.color,
    this.height,
    this.strokeWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 25,
      width: height ?? 25,
      child: CircularProgressIndicator.adaptive(
        strokeWidth: strokeWidth ?? 2.4,
        valueColor: AlwaysStoppedAnimation(
          color ?? peerBoldTextColor,
        ),
      ),
    );
  }
}
