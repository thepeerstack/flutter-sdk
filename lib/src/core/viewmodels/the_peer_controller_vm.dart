import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thepeer_flutter/src/consts/consts.dart';
import 'package:thepeer_flutter/src/core/api/the_peer_api_services.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_business_model.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_view_controller_data.dart';
import 'package:thepeer_flutter/src/core/providers.dart';
import 'package:thepeer_flutter/src/core/viewmodels/the_peer_loader_vm.dart';
import 'package:thepeer_flutter/src/utils/debouncer.dart';
import 'package:thepeer_flutter/src/utils/validator.dart';
import 'package:thepeer_flutter/src/views/business/business_select_view.dart';
import 'package:thepeer_flutter/src/views/business/confirm_view.dart';
import 'package:thepeer_flutter/src/views/states/peer_error_view.dart';
import 'package:thepeer_flutter/src/views/states/success_view.dart';
import 'package:thepeer_flutter/src/widgets/internal_page.dart';
import 'package:thepeer_flutter/thepeer_flutter.dart';

final controllerPageKey = GlobalKey<InternalPageState>();

class ThePeerControllerVM extends ChangeNotifier {
  /// Current state of all fragments
  InternalPageState? get pageState => controllerPageKey.currentState;

  ThePeerLoaderVM get loader => context.read(peerLoaderVM);

  static ThePeerControllerVM get instance =>
      controllerPageKey.currentContext != null
          ? controllerPageKey.currentContext!.read(peerControllerVM)
          : ThePeerControllerVM();

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

  List<ThePeerBusiness>? _searchBusinessList;
  List<ThePeerBusiness>? get searchBusinessList => _searchBusinessList;
  set searchBusinessList(List<ThePeerBusiness>? val) {
    _searchBusinessList = val;
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

  ThePeerUserRefModel? _receiverUserModel;
  ThePeerUserRefModel? get receiverUserModel => _receiverUserModel;
  set receiverUserModel(ThePeerUserRefModel? val) {
    _receiverUserModel = val;
    notifyListeners();
  }

  Widget? _currentView;
  Widget? get currentView => _currentView;
  set currentView(Widget? val) {
    _currentView = val;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double? _percent;
  double? get percent => _percent;

  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  /// TextField Controllers
  final identifierTEC = TextEditingController();
  final reasonTEC = TextEditingController();

  /// Debounce timer
  final debouncer = Debouncer(milliseconds: 800);

  /// Initilaize SDK
  void initialize({
    required ThePeerViewControllerData data,
  }) {
    peerViewData = data;
    api = ThePeerApiServices(data.data.publicKey);
    pushPage(BusinessSelectView());
    loadReceiverUser();
    loadCurrentBusiness();
    loadBusinessList();
  }

  /// Load Receiving User Data
  void loadReceiverUser() async {
    isLoading = true;
    await Future.delayed(Duration(milliseconds: 400));

    final req = await api.resolveUserByRef(
      reference: peerViewData.data.userReference,
    );

    req.fold(
      (l) => null,
      (r) => receiverUserModel = r,
    );

    isLoading = false;
  }

  /// Load Current Busineess Data
  void loadCurrentBusiness() async {
    final req = await api.getBusiness();

    req.fold(
      (l) => null,
      (r) => currentBusiness = r,
    );
  }

  /// Load Business List Data
  void loadBusinessList() async {
    final req = await api.getBusinesses();

    req.fold(
      (l) => pushPage(ThePeerErrorView(
        state: ThePeerErrorStates.error,
      )),
      (r) => appListModel = r,
    );
  }

  void searchIdentifier({
    required String businessId,
    required String identifier,
    required ThePeerIdentifierType identifier_type,
  }) {
    debouncer.run(() async {
      isLoading = true;

      final req = await api.resolveUser(
        businessId: businessId,
        identifier: identifier,
        identifier_type:  identifier_type,
      );
      
      isLoading = false;

      req.fold(
        (l) {
          userModel = identifier.isEmpty ? null : ThePeerUserRefModel.empty();
        },
        (r) => userModel = r,
      );
    });
  }

  void searchBusiness(String? name) {
    Debouncer(milliseconds: 300).run(() async {
      if (name == null || name.trim().isEmpty) {
        searchBusinessList = [];
        notifyListeners();
        searchBusinessList = appListModel!.businesses;
        return;
      }
      if (appListModel == null || appListModel!.businesses!.isEmpty) {
        return;
      }

      searchBusinessList = appListModel!.businesses!
          .where((e) => e.name.toLowerCase().contains(name.toLowerCase()))
          .toList();

      notifyListeners();
    });
  }

  void handleInputDetails(ThePeerBusiness business) {
    if (userModel == null) return;

    pushPage(ConfirmView(business));
  }

  void handleProcessTransaction(ThePeerBusiness business) async {
    loader.isLoading = true;

    final req = await api.generateReceipt(
      receipt: ThePeerReceiptModel(
        amount: peerViewData.data.amount * 100, // convert to kobo
        from: peerViewData.data.userReference,
        to: userModel!.reference!,
        remark: reasonTEC.text,
      ),
    );

    loader.isLoading = false;

    req.fold(
      (l) {
        pushPage(
          ThePeerErrorView(
            state: ThePeerErrorStates.server_error,
          ),
        );
      },
      (id) => handleVerifyReceipt(
        business: business,
        receiptID: id,
      ),
    );
  }

  void handleVerifyReceipt({
    required ThePeerBusiness business,
    required String receiptID,
  }) async {
    loader.isLoading = true;

    final req = await api.verifyReceipt(
      receiptID: receiptID,
      callbackUrl: peerViewData.data.receiptUrl!,
    );

    loader.isLoading = false;

    req.fold(
      (l) {
        l.fold(
          (l) => ThePeerErrorView(
            state: ThePeerErrorStates.server_error,
          ),
          (r) => pushPage(
            ThePeerErrorView(
              state: r,
            ),
          ),
        );
      },
      (r) => pushPage(
        ThePeerSuccessView(
          description: [
            'You have successfully sent ',
            '${Validator.currency.format(peerViewData.data.amount)}',
            ' to ${business.isUsernameIdentifier ? '@' : ''}${business.isUsernameIdentifier ? identifierTEC.text.replaceAll('@', '') : identifierTEC.text}.',
          ],
        ),
      ),
    );
  }

  /// If ui can remove current fragment
  bool get canPop => pageState!.canPop;

  /// Removes current fragment
  void popPage() {
    if (canPop) pageState!.popPage();
  }

  /// Removes all fragments in page store
  void popAll() {
    while (canPop) {
      popPage();
    }
  }

  /// Push new fragment atop the page stack
  void pushPage(Widget? page) => pageState!.addPage(page);

  /// Replaces current page with a new one
  void replaceTopPage(Widget page) => pageState!.replaceTopPage(page);

  void resonChange() => debouncer.run(notifyListeners);
}
