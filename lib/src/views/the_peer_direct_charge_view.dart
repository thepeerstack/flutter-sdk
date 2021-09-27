import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:thepeer_flutter/src/const/const.dart';
import 'package:thepeer_flutter/src/model/the_peer_event_model.dart';
import 'package:thepeer_flutter/src/model/thepeer_success_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:thepeer_flutter/src/model/thepeer_data.dart';
import 'package:thepeer_flutter/src/raw/thepeer_html.dart';
import 'package:thepeer_flutter/src/utils/extensions.dart';

import 'package:thepeer_flutter/src/views/the_peer_error_view.dart';

class ThepeerDirectChargeView extends StatefulWidget {
  /// Public Key from your https://app.withThepeer.com/apps
  final ThePeerData data;

  /// Success callback
  final ValueChanged<ThepeerSuccessModel>? onSuccess;

  /// Error callback
  final Function(dynamic)? onError;

  /// Thepeer popup Close callback
  final VoidCallback? onClosed;

  /// Error Widget will show if loading fails
  final Widget? errorWidget;

  /// Show ThepeerDirectChargeView Logs
  final bool showLogs;

  /// Toggle dismissible mode
  final bool isDismissible;

  const ThepeerDirectChargeView({
    Key? key,
    required this.data,
    this.errorWidget,
    this.onSuccess,
    this.onClosed,
    this.onError,
    this.showLogs = false,
    this.isDismissible = true,
  });

  /// Show Dialog with a custom child
  Future show(BuildContext context) => showMaterialModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        isDismissible: isDismissible,
        context: context,
        builder: (context) => ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: context.screenHeight(.9),
                    child: ThepeerDirectChargeView(
                      data: data,
                      onClosed: onClosed,
                      onSuccess: onSuccess,
                      onError: onError,
                      showLogs: showLogs,
                      errorWidget: errorWidget,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  _ThepeerDirectChargeViewState createState() =>
      _ThepeerDirectChargeViewState();
}

class _ThepeerDirectChargeViewState extends State<ThepeerDirectChargeView> {
  @override
  void initState() {
    super.initState();
    _handleInit();
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  Future<WebViewController> get _webViewController => _controller.future;
  bool isLoading = false;
  bool hasError = false;

  String? contentBase64;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<String>(
          future: _getURL(),
          builder: (context, snapshot) {
            if (hasError == true) {
              return Center(
                child: widget.errorWidget ??
                    ThePeerErrorView(
                      onClosed: widget.onClosed,
                      reload: () async {
                        setState(() {});
                        (await _webViewController).reload();
                      },
                    ),
              );
            } else if (snapshot.hasData == true) {
              return Center(
                child: FutureBuilder<WebViewController>(
                  future: _controller.future,
                  builder: (BuildContext context,
                      AsyncSnapshot<WebViewController> controller) {
                    return WebView(
                      initialUrl: snapshot.data!,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller.complete(webViewController);
                      },
                      javascriptChannels: {_thepeerJavascriptChannel()},
                      javascriptMode: JavascriptMode.unrestricted,
                      onPageStarted: (String url) async {
                        setState(() {
                          isLoading = true;
                        });
                        await injectPeerStack(controller.data!);
                      },
                      onPageFinished: (String url) {
                        setState(() {
                          isLoading = false;
                        });
                      },
                      navigationDelegate: (_) =>
                          _handleNavigationInterceptor(_),
                    );
                  },
                ),
              );
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          }),
    );
  }

  /// Inject JS code to be run in webview
  Future<String> injectPeerStack(WebViewController controller) {
    return controller.evaluateJavascript('''
       window.onload = useThepeer;

      function useThepeer() {

        const directCharge = new ThePeer.directCharge({
              publicKey: "${widget.data.publicKey}",
              amount: "${widget.data.amount}",
              userReference: "${widget.data.userReference}",
              meta: JSON.parse('${json.encode(widget.data.meta)}'),

              onSuccess: function (success) {
                  sendMessage(success)
              },
              onError: function (error) {
                  sendMessage(error)
              },
              onClose: function (close) {
                 sendMessage(close)
              }
          });

            directCharge.setup();
            directCharge.open();
        }

        function sendMessage(message) {
            if (window.ThepeerDirectChargeClientInterface && window.ThepeerDirectChargeClientInterface.postMessage) {
                ThepeerDirectChargeClientInterface.postMessage(JSON.stringify(message));
            }
        }
      ''');
  }

  /// Javascript channel for events sent by Thepeer
  JavascriptChannel _thepeerJavascriptChannel() {
    return JavascriptChannel(
        name: 'ThepeerDirectChargeClientInterface',
        onMessageReceived: (JavascriptMessage msg) {
          try {
            handleResponse(msg.message);
          } on Exception {
            if (mounted && widget.onClosed != null) widget.onClosed!();
          } catch (e) {
            print(e.toString());
          }
        });
  }

  /// Parse event from javascript channel
  void handleResponse(String res) async {
    try {
      final data = ThepeerEventModel.fromJson(res);
      switch (data.type) {
        case DIRECT_DEBIT_SUCCESS:
          if (widget.onSuccess != null)
            widget.onSuccess!(
              ThepeerSuccessModel.fromJson(res),
            );

          return;
        case DIRECT_DEBIT_CLOSE:
          if (mounted && widget.onClosed != null) widget.onClosed!();

          return;
        default:
          if (mounted && widget.onError != null) widget.onError!(res);
          return;
      }
    } catch (e) {
      if (widget.showLogs == true) print(e.toString());
    }
  }

  /// Generate Url from string
  Future<String> _getURL() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          hasError = false;
        });
        return Uri.dataFromString(
          buildThepeerHtml(widget.data),
          mimeType: 'text/html',
        ).toString();
      } else {
        return Uri.dataFromString(
          '<html><body>An Error Occurred</body></html>',
          mimeType: 'text/html',
        ).toString();
      }
    } catch (_) {
      isLoading = false;
      hasError = true;
      return Uri.dataFromString(
        '<html><body>An Error Occurred</body></html>',
        mimeType: 'text/html',
      ).toString();
    }
  }

  /// Handle WebView initialization
  void _handleInit() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  NavigationDecision _handleNavigationInterceptor(NavigationRequest request) {
    if (request.url.toLowerCase().contains('peer')) {
      // Navigate to all urls contianing Thepeer
      return NavigationDecision.navigate;
    } else {
      // Block all navigations outside Thepeer
      return NavigationDecision.prevent;
    }
  }
}
