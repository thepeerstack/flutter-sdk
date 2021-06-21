import 'package:flutter/material.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';

const package = 'thepeer_flutter';

String get ngn => '₦';

var outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(6),
  borderSide: BorderSide(
    color: peerTextFieldBorderColor,
  ),
);

enum ThePeerErrorStates {
  error,
  failed,
  server_error,
  insufficient_funds,
  invalid_receipt,
  user_insuffient_funds,
}

final peerErrorStatesMap = {
  'insufficient_funds': {
    'Transcation failed':
        'Business partner can not process this transaction at the momeent, please try again later'
  },
  'user_insuffient_funds': {
    'Transcation failed':
        'You do not have sufficient funds, please top-up and try again'
  },
  'error': {
    'Transaction error':
        'Something went wrong with our server. Please check back later'
  },
  'failed': {
    'Transaction error':
        'Something went wrong with our server. Please check back later'
  },
  'server_error': {
    'Something went wrong':
        'Something went wrong with our server. Please check back later'
  }
};
