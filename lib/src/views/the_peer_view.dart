import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:thepeer_flutter/src/model/thepeer_data.dart';
import 'package:thepeer_flutter/src/raw/thepeer_html.dart';
import 'package:thepeer_flutter/src/utils/extensions.dart';

import 'package:thepeer_flutter/src/views/error_view.dart';

class PeerstackView extends StatefulWidget {
  /// Public Key from your https://app.withPeerstack.com/apps
  final ThePeerData data;

  /// Success callback
  final VoidCallback? onSuccess;

  /// Peerstack popup Close callback
  final VoidCallback? onClosed;

  /// Error Widget will show if loading fails
  final Widget? error;

  /// Show PeerstackView Logs
  final bool showLogs;

  /// Toggle dismissible mode
  final bool isDismissible;

  const PeerstackView({
    Key? key,
    required this.data,
    this.error,
    this.onSuccess,
    this.onClosed,
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
                    child: PeerstackView(
                      data: data,
                      onClosed: onClosed,
                      onSuccess: onSuccess,
                      showLogs: showLogs,
                      error: error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  _PeerstackViewState createState() => _PeerstackViewState();
}

class _PeerstackViewState extends State<PeerstackView> {
  @override
  void initState() {
    super.initState();
    _handleInit();
    // Enable hybrid composition.
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
            if (hasError) {
              return widget.error ??
                  ErrorView(reload: () async {
                    setState(() {});
                    (await _webViewController).reload();
                  });
            } else
              return snapshot.hasData
                  ? FutureBuilder<WebViewController>(
                      future: _controller.future,
                      builder: (BuildContext context,
                          AsyncSnapshot<WebViewController> controller) {
                        return WebView(
                          initialUrl: snapshot.data!,
                          onWebViewCreated:
                              (WebViewController webViewController) {
                            _controller.complete(webViewController);
                          },
                          javascriptChannels: {_peerstackJavascriptChannel()},
                          javascriptMode: JavascriptMode.unrestricted,
                          onPageStarted: (String url) async {
                            setState(() {
                              isLoading = true;
                            });
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
                    )
                  : Center(child: CupertinoActivityIndicator());
          }),
    );
  }

  /// javascript channel for events sent by Peerstack
  JavascriptChannel _peerstackJavascriptChannel() {
    return JavascriptChannel(
        name: 'PeerstackClientInterface',
        onMessageReceived: (JavascriptMessage message) {
          if (widget.showLogs == true)
            print('PeerstackClientInterface, ${message.message}');
          Map<String, dynamic> res = json.decode(message.message);
          handleResponse(res);
        });
  }

  /// parse event from javascript channel
  void handleResponse(Map<String, dynamic>? body) async {
    try {
      String? key = body?['event'];
      if (body != null && key != null) {
        switch (key) {
          case 'send.success':
            if (widget.onSuccess != null) widget.onSuccess!();
            return;
          case 'thepeer.dart.success':
            if (widget.onSuccess != null) widget.onSuccess!();
            return;
          case 'thepeer.dart.closed':
            if (mounted && widget.onClosed != null) widget.onClosed!();
            return;
          default:
        }
      }
    } catch (e) {
      if (widget.showLogs == true) print(e.toString());
    }
  }

  Future<String> _getURL() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          hasError = false;
        });
        return Uri.dataFromString(buildPeerstackHtml(widget.data),
                mimeType: 'text/html')
            .toString();
      } else {
        return Uri.dataFromString('<html><body>An Error Occurred</body></html>',
                mimeType: 'text/html')
            .toString();
      }
    } catch (_) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      return Uri.dataFromString('<html><body>An Error Occurred</body></html>',
              mimeType: 'text/html')
          .toString();
    }
  }

  void _handleInit() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  NavigationDecision _handleNavigationInterceptor(NavigationRequest request) {
    if (request.url.toLowerCase().contains('peer')) {
      // Navigate to all urls contianing Peerstack
      return NavigationDecision.navigate;
    } else {
      // Block all navigations outside Peerstack
      return NavigationDecision.prevent;
    }
  }
}
