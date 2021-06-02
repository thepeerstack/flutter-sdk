import 'package:flutter/material.dart';
import 'package:thepeer_flutter/src/core/api/the_peer_api_services.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_view_controller_data.dart';
import 'package:thepeer_flutter/src/views/business/business_select_view.dart';
import 'package:thepeer_flutter/thepeer_flutter.dart';

class ThePeerControllerVM extends ChangeNotifier {
  ThePeerApiServices? _api;
  ThePeerApiServices get api => _api!;

  set api(ThePeerApiServices? val) {
    _api = val;
    notifyListeners();
  }

  BuildContext? _context;
  BuildContext get context => _context!;
  set context(BuildContext val) {
    _context = val;
    notifyListeners();
  }

  ThePeerViewControllerData? _peerViewData;
  ThePeerViewControllerData get peerViewData => _peerViewData!;
  set peerViewData(ThePeerViewControllerData val) {
    _peerViewData = val;
    notifyListeners();
  }

  Widget? _currentView;
  Widget? get currentView => _currentView;
  set currentView(Widget? val) {
    _currentView = val;
    notifyListeners();
  }

  ThePeerAppListModel? _appListModel;
  ThePeerAppListModel? get appListModel => _appListModel;
  set appListModel(ThePeerAppListModel? val) {
    _appListModel = val;
    notifyListeners();
  }

  void initialize(
    BuildContext _, {
    required ThePeerViewControllerData data,
  }) {
    context = _;
    peerViewData = data;
    api = ThePeerApiServices(data.data.publicKey);
    currentView = BusinessSelectView();
    loadAppList();
  }

  void loadAppList() async {
    try {
      print('1234567890-');
      final req = await api.getApps();

      req.fold((l) {
        print(l);
        //return PeerLoaderWidget();
      }, (r) {
        appListModel = r;
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
