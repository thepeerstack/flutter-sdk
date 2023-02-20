import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:thepeer_flutter/src/const/const.dart';
import 'package:thepeer_flutter/src/model/the_peer_event_model.dart';
import 'package:thepeer_flutter/src/model/thepeer_success_model.dart';
import 'package:thepeer_flutter/src/utils/functions.dart';
import 'package:thepeer_flutter/src/widgets/the_peer_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import 'package:thepeer_flutter/src/model/thepeer_data.dart';
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

  /// Show [ThepeerDirectChargeView] Logs
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
  late final WebViewController _controller;

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    setState(() {});
  }

  bool _hasError = false;
  bool get hasError => _hasError;
  set hasError(bool val) {
    _hasError = val;
    setState(() {});
  }

  int? _loadingPercent;
  int? get loadingPercent => _loadingPercent;
  set loadingPercent(int? val) {
    _loadingPercent = val;
    setState(() {});
  }

  String get createUrl => ThePeerFunctions.createUrl(
        data: widget.data,
        sdkType: 'directCharge',
      ).toString();

  @override
  void initState() {
    super.initState();
    _handleInit();
  }

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
                      setState(() {});
                      await _controller.reload();
                    },
                  ),
            );
          }

          if (snapshot.hasData == true &&
              snapshot.data != ConnectivityResult.none) {
            return Stack(
              alignment: Alignment.center,
              children: [
                if (isLoading == true) ...[
                  const PeerLoader(),
                ],

                /// Thepeer Webview
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: isLoading == true ? 0 : 1,
                  child: WebViewWidget(
                    controller: _controller,
                  ),
                ),
              ],
            );
          } else {
            return CupertinoActivityIndicator();
          }
        },
      ),
    );
  }

  /// Inject JS code to be run in webview
  Future<void> _injectPeerStack(WebViewController controller) {
    return controller.runJavaScript(
      ThePeerFunctions.peerMessageHandler(
        'ThepeerDirectChargeClientInterface',
      ),
    );
  }

  /// Parse event from javascript channel
  void _handleResponse(String res) async {
    try {
      final data = ThepeerEventModel.fromJson(res);
      switch (data.type) {
        case DIRECT_DEBIT_SUCCESS:
          if (widget.onSuccess != null) {
            widget.onSuccess!(
              ThepeerSuccessModel.fromJson(res),
            );
          }

          return;
        case DIRECT_DEBIT_CLOSE:
          if (mounted && widget.onClosed != null) widget.onClosed!();

          return;
        default:
          if (mounted && widget.onError != null) widget.onError!(res);
          return;
      }
    } catch (e) {
      if (widget.showLogs) ThePeerFunctions.log(e.toString());
    }
  }

  /// Handle WebView initialization
  void _handleInit() async {
    await SystemChannels.textInput.invokeMethod<String>('TextInput.hide');

    //                 navigationDelegate: _handleNavigationInterceptor,
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(
            PlatformWebViewControllerCreationParams());

    controller
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('ThepeerSendClientInterface',
          onMessageReceived: _onMessageReceived)
      ..setNavigationDelegate(NavigationDelegate(
          onPageStarted: (_) async {
            isLoading = true;
          },
          onWebResourceError: (e) {
            hasError = true;
            if (widget.showLogs) ThePeerFunctions.log(e.toString());
          },
          onPageFinished: (_) async {
            isLoading = false;
            await _injectPeerStack(_controller);
          },
          onNavigationRequest: _handleNavigationInterceptor))
      ..loadRequest(Uri.parse('$createUrl'));
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
    }
    _controller = controller;
  }

  /// Javascript channel  onMessageRecieved for events sent by Thepeer
  void _onMessageReceived(JavaScriptMessage data) {
    try {
      if (widget.showLogs) ThePeerFunctions.log('Event: -> ${data.message}');
      _handleResponse(data.message);
    } on Exception {
      if (mounted && widget.onClosed != null) widget.onClosed!();
    } catch (e) {
      if (widget.showLogs) ThePeerFunctions.log(e.toString());
    }
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
