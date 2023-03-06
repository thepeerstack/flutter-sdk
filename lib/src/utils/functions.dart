import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:thepeer_flutter/src/model/thepeer_data.dart';
import 'package:thepeer_flutter/src/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class ThepeerFunctions {
  /// `[JS]` Create EventListener config for message client
  static String peerMessageHandler(String clientName) => '''


     // Create our shared stylesheet:
     var style = document.createElement("style");
      
      // Add EventListener for onMessage Event
      window.addEventListener('message', (event) => {
        sendMessage(event.data)
      });
      
      // Override default JS Console function
      console._log_old = console.log
      console.log = function(msg) {
          sendMessageRaw(msg);
          console._log_old(msg);
      }

      console._error_old = console.error
      console.error = function(msg) {
          sendMessageRaw(msg);
          console._error_old(msg);
      }
      
      // Send callback to dart JSMessageClient
      function sendMessage(message) {
          if (window.$clientName && window.$clientName.postMessage) {
              $clientName.postMessage(JSON.stringify(message));
          }
      } 

      // Send raw callback to dart JSMessageClient
      function sendMessageRaw(message) {
          if (window.$clientName && window.$clientName.postMessage) {
              $clientName.postMessage(message);
          }
      } 
''';

  /// Log data from thepeer sdk
  static void log(String data) => debugPrint('ThepeerLog: $data');

  /// Create peer url
  static Uri createUrl({
    required ThepeerData data,
    String? email,
    required String sdkType,
  }) {
    var base = 'https://chain.thepeer.co?';

    final params = {
      'publicKey': data.publicKey,
      'amount': '${data.amount}',
      'currency': data.currency,
      if (email != null) 'email': email,
      'userReference': data.userReference,
      'sdkType': sdkType,
    };

    for (final k in params.keys) {
      if (params[k] != null && params[k] is String) {
        final value = params[k];
        base = '$base$k=$value&';
      }
    }

    final tempUri = Uri.parse(base.slice(0, -1));

    return Uri(
      scheme: tempUri.scheme,
      host: tempUri.host,
      path: tempUri.path,
      queryParameters: {
        ...tempUri.queryParameters,
        'meta': jsonEncode(data.meta),
      },
    );
  }

  /// Open url in an external browser
  static void launchExternalUrl(
      {required String url, required bool showLogs}) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      // handle failure
      if (showLogs == true) ThepeerFunctions.log(e.toString());
    }
  }
}
