import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';

var logger = Logger(
  printer: SimpleLogPrinter(className: 'ThePeer'),
);

class SimpleLogPrinter extends LogPrinter {
  final String? className;
  SimpleLogPrinter({this.className});

  @override
  List<String> log(LogEvent event) {
    final emoji = PrettyPrinter.levelEmojis[event.level];
    final color = PrettyPrinter.levelColors[event.level];
    final message = stringifyMessage(event.message);

    return [
      Platform.isIOS ? '$emoji$message\n' : color!('$emoji$message\n'),
    ];
  }

  String? stringifyMessage(dynamic message) {
    final decoder = JsonDecoder();
    final encoder = JsonEncoder.withIndent('  ');
    final color = AnsiColor.fg(15);

    if (message is String) {
      try {
        final raw = decoder.convert(message);
        return Platform.isAndroid
            ? color(encoder.convert(raw))
            : encoder.convert(raw);
      } catch (e) {
        return message.toString();
      }
    } else if (message is Map || message is Iterable) {
      return Platform.isAndroid
          ? color(encoder.convert(message))
          : encoder.convert(message);
    } else {
      return message.toString();
    }
  }
}
