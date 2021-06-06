import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thepeer_flutter/src/consts/consts.dart';
import 'package:thepeer_flutter/src/core/api/the_peer_api_services.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_business_model.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_view_controller_data.dart';
import 'package:thepeer_flutter/src/core/providers.dart';
import 'package:thepeer_flutter/src/core/viewmodels/the_peer_loader_vm.dart';
import 'package:thepeer_flutter/src/utils/debouncer.dart';
import 'package:thepeer_flutter/src/utils/logger.dart';
import 'package:thepeer_flutter/src/utils/validator.dart';
import 'package:thepeer_flutter/src/views/business/business_select_view.dart';
import 'package:thepeer_flutter/src/views/business/confirm_view.dart';
import 'package:thepeer_flutter/src/views/states/peer_error_view.dart';
import 'package:thepeer_flutter/src/views/states/success_view.dart';
import 'package:thepeer_flutter/src/widgets/internal_page.dart';
import 'package:thepeer_flutter/thepeer_flutter.dart';

class ThePeerControllerVM extends ChangeNotifier {
  final controllerPageKey = GlobalKey<InternalPageState>();

  /// Current state of all fragments
  InternalPageState? get pageState => controllerPageKey.currentState;

  ThePeerLoaderVM get loader => context.read(peerLoaderVM);

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
  }

  ThePeerViewControllerData? _peerViewData;
  ThePeerViewControllerData get peerViewData => _peerViewData!;
  set peerViewData(ThePeerViewControllerData val) {
    _peerViewData = val;
    notifyListeners();
  }

  ThePeerBusinessModel? _currentBusiness;
  ThePeerBusinessModel? get currentBusiness => _currentBusiness;
  set currentBusiness(ThePeerBusinessModel? val) {
    _currentBusiness = val;
    notifyListeners();
  }

  ThePeerAppListModel? _appListModel;
  ThePeerAppListModel? get appListModel => _appListModel;
  set appListModel(ThePeerAppListModel? val) {
    _appListModel = val;
    notifyListeners();
  }

  ThePeerUserRefModel? _userModel;
  ThePeerUserRefModel? get userModel => _userModel;
  set userModel(ThePeerUserRefModel? val) {
    _userModel = val;
    notifyListeners();
  }

  Widget? _currentView;
  Widget? get currentView => _currentView;
  set currentView(Widget? val) {
    _currentView = val;
    notifyListeners();
  }

  final usernameTEC = TextEditingController();
  final reasonTEC = TextEditingController();

  final debouncer = Debouncer(milliseconds: 800);

  void initialize({
    required ThePeerViewControllerData data,
  }) {
    peerViewData = data;
    api = ThePeerApiServices(data.data.publicKey);
    currentView = BusinessSelectView();
    loader.runTask(() async {
      loadCurrentBusiness();
      loadAppList();
    });
  }

  void loadCurrentBusiness() async {
    final req = await api.getBusiness();

    req.fold((l) {
      print(l);
      //return PeerLoaderWidget();
    }, (r) {
      currentBusiness = r;
    });
  }

  void loadAppList() async {
    final req = await api.getApps();

    req.fold((l) {
      pushPage(ThePeerErrorView(
        state: ThePeerErrorStates.failed,
      ));
    }, (r) {
      appListModel = r;
    });
  }

  void searchUsername({
    required String businessId,
    required String identifier,
  }) {
    debouncer.run(() async {
      final req = await api.resolveUser(
        businessId: businessId,
        identifier: identifier,
      );

      req.fold((l) {
        userModel = null;
      }, (r) {
        userModel = r;
      });
    });
  }

  void handleInputDetails(ThePeerBusiness business) {
    if (userModel == null) {
      return;
    }
    pushPage(ConfirmView(business));
  }

  void handleProcessTransaction(ThePeerBusiness business) async {
    loader.isLoading = true;
    final req = await api.generateReceipt(
      receipt: ThePeerReceiptModel(
        amount: peerViewData.data.amount,
        from: peerViewData.data.userReference,
        to: userModel!.reference,
        remark: reasonTEC.text,
      ),
    );
    loader.isLoading = false;

    req.fold((l) {
      pushPage(
        ThePeerErrorView(
          state: ThePeerErrorStates.failed,
        ),
      );
    }, (r) {
      pushPage(
        ThePeerSuccessView(
          description:
              'You have successfully sent ${Validator.currency.format(peerViewData.data.amount)} to ${usernameTEC.text}.',
        ),
      );
    });
  }

  /// If ui can remove current fragment
  bool get canPop => pageState!.canPop;

  /// Removes current fragment
  void popPage() {
    if (canPop) {
      pageState!.popPage();
      logger.i('Nav: Popped Current Fragment');
    }
  }

  /// Removes all fragments in page store
  void popAll() {
    while (canPop) {
      popPage();
    }
    logger.i('Nav: Popped all Fragments');
  }

  /// Push new fragment atop the page stack
  void pushPage(Widget? page) {
    logger.i('Nav: Current Fragment -> ${(page.runtimeType)}');

    pageState!.addPage(page);
  }

  /// Replaces current page with a new one
  void replaceTopPage(Widget page) {
    logger.i('Nav: Current Fragment -> ${(page.runtimeType)}');

    pageState!.replaceTopPage(page);
  }
}
