import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thepeer_flutter/src/consts/consts.dart';
class EXT {}
extension CustomContext on BuildContext {
  double screenHeight([double percent = 1]) =>
      MediaQuery.of(this).size.height * percent;

  double screenWidth([double percent = 1]) =>
      MediaQuery.of(this).size.width * percent;
}

extension PostFrameCallback on VoidCallback {
  void withPostFrameCallback() =>
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        this();
      });
}

extension PeerStates on ThePeerErrorStates {
  String get title => peerErrorStatesMap[describeEnum(this)]!.keys.first;
  String get description => peerErrorStatesMap[describeEnum(this)]!.values.first;
  String get image => 'assets/images/${describeEnum(this)}.svg';
}
