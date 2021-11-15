import 'dart:convert';

import 'package:thepeer_flutter/src/model/thepeer_data.dart';
import 'package:thepeer_flutter/src/utils/css.dart';
import 'package:thepeer_flutter/src/utils/extensions.dart';

class ThePeerFunctions {
  /// `[JS]` Create EventListener config for message client
  static String peerMessageHandler(String clientName) => '''


     // Create our shared stylesheet:
     var style = document.createElement("style");
      
     // Apply the stylesheet to a document:
     style.sheet = `$noSelectCssSheet`;
     document.body.appendChild(style);

      // Add EventListener for onMessage Event
      window.addEventListener('message', (event) => {
        sendMessage(event.data)
      });
      
      window.addEventListener("long-press", function(e) {
         e.preventDefault();
      }, false);

      // Send callback to dart JSMessageClient
      function sendMessage(message) {
          if (window.$clientName && window.$clientName.postMessage) {
              $clientName.postMessage(JSON.stringify(message));
          }
      } 
''';

  /// Log data from thepeer sdk
  static void log(String data) => print('ThePeerLog: $data');

  /// Create peer url
  static String createUrl({
    required ThePeerData data,
    required String sdkType,
  }) {
    var base = 'https://chain.thepeer.co?';

    final params = {
      'publicKey': data.publicKey,
      'amount': '${data.amount}',
      'receiptUrl': '${data.receiptUrl}',
      'userReference': data.userReference,
      if (data.meta.isNotEmpty) 'meta': json.encode(data.meta),
      'sdkType': sdkType,
    };

    for (final k in params.keys) {
      if (params[k] != null && params[k] is String) {
        final value = k == 'meta' ? json.encode(params[k]) : params[k];
        base = '$base$k=$value&';
      }
    }

    return base.slice(0, -1);
  }
}
