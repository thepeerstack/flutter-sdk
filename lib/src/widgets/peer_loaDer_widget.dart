import 'package:flutter/material.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';

class PeerLoaderWidget extends StatelessWidget {
  final Color? color;
  const PeerLoaderWidget({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 25,
      child: CircularProgressIndicator(
        strokeWidth: 2.4,
        valueColor: AlwaysStoppedAnimation(
          color ?? peerBoldTextColor,
        ),
      ),
    );
  }
}
