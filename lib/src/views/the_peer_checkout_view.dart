import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:thepeer_flutter/src/const/const.dart';
import 'package:thepeer_flutter/src/model/the_peer_event_model.dart';
import 'package:thepeer_flutter/src/utils/functions.dart';
import 'package:thepeer_flutter/src/widgets/the_peer_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:thepeer_flutter/src/model/thepeer_data.dart';
import 'package:thepeer_flutter/src/utils/extensions.dart';

import 'package:thepeer_flutter/src/views/the_peer_error_view.dart';

class ThepeerCheckoutView extends StatefulWidget {
  /// Public Key from your https://app.withThepeer.com/apps
  final ThePeerData data;

  /// User email
  final String email;

  /// Success callback
  final ValueChanged<dynamic>? onSuccess;

  /// Error callback
  final ValueChanged<dynamic>? onError;

  /// Thepeer popup Close callback
  final VoidCallback? onClosed;

  /// Error Widget will show if loading fails
  final Widget? errorWidget;

  /// Show [ThepeerCheckoutView] Logs
  final bool showLogs;

  /// Toggle dismissible mode
  final bool isDismissible;

  const ThepeerCheckoutView({
    Key? key,
    required this.data,
    required this.email,
    this.errorWidget,
    this.onSuccess,
    this.onClosed,
    this.onError,
    this.showLogs = false,
    this.isDismissible = false,
  }) : super(key: key);

  /// Show Dialog with a custom child
  Future show(BuildContext context) => showCupertinoModalBottomSheet<void>(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        isDismissible: isDismissible,
        enableDrag: isDismissible,
        context: context,
        builder: (context) => ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: context.screenHeight(.9),
                    child: ThepeerCheckoutView(
                      data: data,
                      onClosed: onClosed,
                      email: email,
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
  _ThepeerCheckoutViewState createState() => _ThepeerCheckoutViewState();
}

class _ThepeerCheckoutViewState extends State<ThepeerCheckoutView> {
  final _controller = Completer<WebViewController>();
  Future<WebViewController> get _webViewController => _controller.future;

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    setState(() {
      _isLoading = val;
    });
  }

  bool _hasError = false;
  bool get hasError => _hasError;
  set hasError(bool val) {
    setState(() {
      _hasError = val;
    });
  }

  @override
  void initState() {
    super.initState();
    _handleInit();
  }

  String get createUrl => ThePeerFunctions.createUrl(
        data: widget.data,
        email: widget.email,
        sdkType: 'checkout',
      ).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<ConnectivityResult>(
        future: Connectivity().checkConnectivity(),
        builder: (context, snapshot) {
          /// Show error view
          if (hasError == true) {
            return Center(
              child: widget.errorWidget ??
                  ThePeerErrorView(
                    onClosed: widget.onClosed,
                    reload: () async {
                      await (await _webViewController).reload();
                    },
                  ),
            );
          }

          if (snapshot.hasData == true &&
              snapshot.data != ConnectivityResult.none) {
            return Stack(
              alignment: Alignment.center,
              children: [
                if (isLoading == true && hasError == false) ...[
                  const PeerLoader(),
                ],

                /// Thepeer Webview
                WebView(
                  initialUrl: '$createUrl',
                  onWebViewCreated: _controller.complete,
                  javascriptChannels: _thepeerJavascriptChannel,
                  javascriptMode: JavascriptMode.unrestricted,
                  zoomEnabled: false,
                  debuggingEnabled: true,
                  onPageStarted: (_) async {
                    isLoading = true;
                  },
                  onWebResourceError: (e) {
                    hasError = true;
                    if (widget.showLogs) ThePeerFunctions.log(e.toString());
                  },
                  onPageFinished: (_) async {
                    isLoading = false;
                    await _injectPeerStack(await _controller.future);
                  },
                  navigationDelegate: _handleNavigationInterceptor,
                ),
              ],
            );
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }

  /// Inject JS code to be run in webview
  Future<void> _injectPeerStack(WebViewController controller) async {
    await controller.runJavascript(
      ThePeerFunctions.peerMessageHandler(
        'ThepeerSendClientInterface',
      ),
    );
  }

  /// Javascript channel for events sent by Thepeer
  Set<JavascriptChannel> get _thepeerJavascriptChannel => {
        JavascriptChannel(
          name: 'ThepeerSendClientInterface',
          onMessageReceived: (JavascriptMessage data) {
            try {
              if (widget.showLogs)
                ThePeerFunctions.log('Event: -> ${data.message}');
              _handleResponse(data.message);
            } on Exception {
              if (mounted && widget.onClosed != null) widget.onClosed!();
            } catch (e) {
              if (widget.showLogs) ThePeerFunctions.log(e.toString());
            }
          },
        )
      };

  /// Parse event from javascript channel
  void _handleResponse(String res) async {
    try {
      final data = ThepeerEventModel.fromJson(res);
      switch (data.type) {
        case CHECKOUT_SUCCESS:
          if (widget.onSuccess != null) {
            widget.onSuccess!(data);
          }
          return;
        case CHECKOUT_CLOSE:
          if (mounted && widget.onClosed != null) widget.onClosed!();
          return;
        default:
          if (mounted && widget.onError != null) widget.onError!(res);
          return;
      }
    } catch (e) {
      if (widget.showLogs == true) ThePeerFunctions.log(e.toString());
    }
  }

  /// Handle WebView initialization
  void _handleInit() async {
    await SystemChannels.textInput.invokeMethod<String>('TextInput.hide');
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  NavigationDecision _handleNavigationInterceptor(NavigationRequest request) {
    final url = request.url.toLowerCase();

    if (url.contains('groot.thepeer.co') || url.contains('chain.thepeer.co')) {
      // Navigate to all urls contianing Thepeer
      return NavigationDecision.navigate;
    } else {
      // Block all navigations outside Thepeer
      return NavigationDecision.prevent;
    }
  }
}
