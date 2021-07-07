import 'package:flutter/material.dart';
import 'package:thepeer_flutter/src/const/const.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';
import 'package:thepeer_flutter/src/views/the_peer_error_view.dart';

import 'touchable_opacity.dart';

/// Peer Button Widget
class PeerButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool enabled, isUnderlined;
  final Color? textColor, buttonColor;

  PeerButton({
    required this.title,
    Key? key,
    this.enabled = true,
    this.isUnderlined = false,
    this.onTap,
    this.textColor,
    this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: onTap,
      disabled: enabled == false,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          color:
              (buttonColor ?? peerBlue).withOpacity(enabled == true ? 1 : 0.3),
          padding: EdgeInsets.all(18),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Gilroy-SemiBold',
                package: package,
                fontSize: 16,
                color: textColor ?? Colors.white,
                decoration: isUnderlined ? TextDecoration.underline : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}