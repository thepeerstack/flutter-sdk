import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';

const package = 'thepeer_flutter';

String get ngn => Platform.isAndroid ? 'N' : '₦';

var outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(6),
  borderSide: BorderSide(
    color: peerTextFieldBorderColor,
  ),
);

enum ThePeerErrorStates { error, failed }

final peerErrorStatesMap = {
  'failed': {
    'Transcation failed':
        'Business partner does not have sufficient funds, please try again later'
  },
  'error': {
    'Something went wrong':
        'Something went wrong with our server. Please check back later'
    
  }
};
