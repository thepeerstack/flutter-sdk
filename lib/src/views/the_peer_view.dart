import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_data.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_view_controller_data.dart';
import 'package:thepeer_flutter/src/core/providers.dart';
import 'package:thepeer_flutter/src/utils/extensions.dart';
import 'package:thepeer_flutter/src/widgets/internal_page.dart';
import 'package:thepeer_flutter/src/widgets/peer_loader_widget.dart';

class ThePeerView extends StatefulHookWidget {
  /// Public Key from your https://app.withThePeer.com/apps
  final ThePeerData data;

  /// Success callback
  final VoidCallback? onSuccess;

  /// ThePeer popup Close callback
  final VoidCallback? onClosed;

  /// Error Widget will show if loading fails
  final Widget? error;

  /// Show ThePeerView Logs
  final bool showLogs;

  /// Toggle dismissible mode
  final bool isDismissible;

  const ThePeerView({
    Key? key,
    required this.data,
    this.error,
    this.onSuccess,
    this.onClosed,
    this.showLogs = false,
    this.isDismissible = true,
  });

  ThePeerViewControllerData get thePeerViewControllerData {
    return ThePeerViewControllerData(
      data: data,
      onClosed: onClosed,
      onSuccess: onSuccess,
      showLogs: showLogs,
      error: error,
      isDismissible: isDismissible,
    );
  }

  /// Show Dialog with a custom child
  Future show(BuildContext context) => showCupertinoModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        isDismissible: isDismissible,
        enableDrag: false,
        context: context,
        builder: (context) => ProviderScope(
          child: PeerViewBuilder(
            thePeerViewControllerData: thePeerViewControllerData,
          ),
        ),
      );

  @override
  _ThePeerViewState createState() {
    return _ThePeerViewState(peerViewData: thePeerViewControllerData);
  }
}

class PeerViewBuilder extends HookWidget {
  const PeerViewBuilder({
    Key? key,
    required this.thePeerViewControllerData,
  }) : super(key: key);

  final ThePeerViewControllerData thePeerViewControllerData;

  @override
  Widget build(BuildContext context) {
    final provider = useProvider(peerControllerVM);
    provider.context = context;
    return PeerViewWrapper(
      peerViewData: thePeerViewControllerData,
    );
  }
}

class _ThePeerViewState extends State<ThePeerView> {
  final ThePeerViewControllerData peerViewData;

  _ThePeerViewState({
    required this.peerViewData,
  });

  @override
  void initState() {
    super.initState();
    () {
      context.read(peerControllerVM).initialize(data: peerViewData);
    }.withPostFrameCallback();
  }

  @override
  Widget build(BuildContext context) {
    final currentView = useProvider(
      peerControllerVM.select(
        (v) => v.currentView,
      ),
    );

    final controllerPageKey = useProvider(
      peerControllerVM.select(
        (v) => v.controllerPageKey,
      ),
    );

    final isLoading = useProvider(
      peerLoaderVM.select(
        (v) => v.isLoading,
      ),
    );

    print(isLoading);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          children: [
            InternalPage(
              key: controllerPageKey,
              child: currentView ?? PeerLoaderWidget(),
            ),
            if (isLoading == true)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white70,
                child: Center(
                  child: PeerLoaderWidget(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PeerViewWrapper extends StatelessWidget {
  const PeerViewWrapper({
    Key? key,
    required this.peerViewData,
  }) : super(key: key);

  final ThePeerViewControllerData peerViewData;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
                child: ThePeerView(
                  data: peerViewData.data,
                  onClosed: peerViewData.onClosed,
                  onSuccess: peerViewData.onSuccess,
                  showLogs: peerViewData.showLogs,
                  error: peerViewData.error,
                  isDismissible: peerViewData.isDismissible,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
