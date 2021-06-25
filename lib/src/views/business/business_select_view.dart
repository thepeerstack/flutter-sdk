import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thepeer_flutter/src/consts/consts.dart';
import 'package:thepeer_flutter/src/core/providers.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';
import 'package:thepeer_flutter/src/utils/extensions.dart';
import 'package:thepeer_flutter/src/utils/validator.dart';
import 'package:thepeer_flutter/src/views/business/input_identifier_view.dart';
import 'package:thepeer_flutter/src/widgets/peer_header.dart';
import 'package:thepeer_flutter/src/widgets/touchable_opacity.dart';

/// Select Business Widget
class BusinessSelectView extends StatefulHookWidget {
  const BusinessSelectView({
    Key? key,
  }) : super(key: key);

  @override
  _BusinessSelectViewState createState() => _BusinessSelectViewState();
}

class _BusinessSelectViewState extends State<BusinessSelectView> {
  /// Focus nodes
  final focus1 = FocusNode();

  @override
  void initState() {
    super.initState();

    /// Start focus listeners
    focus1.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = useProvider(
      peerControllerVM.select(
        (v) => v.isLoading,
      ),
    );
    return isLoading == true
        ? SpinKitPulse(
            color: peerBlue,
            size: 50.0,
          )
        : Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 38,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PeerHeader(),
                  ],
                ),
              ),
              Gap(18),
              PeerBusinessHeader(focus1),
              PeerBusinessList(),
              if (focus1.hasFocus == false) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Powered by',
                      style: TextStyle(
                        fontFamily: 'Gilroy-Medium',
                        package: package,
                        fontSize: 14,
                        color: peerLightTextColor,
                      ),
                    ),
                    Gap(4),
                    Image.asset(
                      'assets/images/logo.png',
                      package: package,
                      height: 18,
                    ),
                  ],
                ),
                Gap(18),
              ]
            ],
          );
  }
}

class PeerBusinessHeader extends HookWidget {
  final FocusNode focus;
  const PeerBusinessHeader(
    this.focus, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final amount = useProvider(peerControllerVM.select(
      (v) => Validator.noSymbolCurrency.format(
        v.peerViewData.data.amount,
      ),
    ));

    final name = useProvider(
      peerControllerVM.select(
        (v) => (v.receiverUserModel?.name ?? '').split(' ').first,
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Text(
            'Hi $name, you are about to send',
            style: TextStyle(
              fontFamily: 'Gilroy-Medium',
              package: package,
              fontSize: 14,
              color: peerTextColor,
            ),
          )),
          Gap(8),
          Center(
            child: Text.rich(
              TextSpan(
                text: '₦',
                children: [
                  TextSpan(
                    text: amount,
                    style: TextStyle(
                      fontFamily: 'Gilroy-Bold',
                      package: package,
                      fontSize: 32,
                      color: peerBoldTextColor,
                    ),
                  )
                ],
                style: TextStyle(
                  package: package,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: peerBoldTextColor,
                ),
              ),
            ),
          ),
          Gap(47),
          Text(
            'Select business',
            style: TextStyle(
              fontFamily: 'Gilroy-Medium',
              package: package,
              fontSize: 14,
              color: peerLightTextColor,
            ),
          ),
          Gap(13),
          PeerBusinessSearch(focus),
          Gap(13),
        ],
      ),
    );
  }
}

/// Business List Widget
class PeerBusinessList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final businesses = useProvider(peerControllerVM.select(
        (v) => v.searchBusinessList ?? v.appListModel?.businesses ?? []));

    return Flexible(
      child: ListView(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 0,
        ),
        physics: BouncingScrollPhysics(),
        children: [
          ...businesses.map((e) => Column(
                children: [
                  TouchableOpacity(
                    onTap: () {
                      context.read(peerControllerVM)
                        ..userModel = null
                        ..identifierTEC.text = ''
                        ..reasonTEC.text = ''
                        ..pushPage(InputIdentifierView(e));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                e.logo ?? '',
                                width: 38,
                                height: 38,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                          Gap(21),
                          Text(
                            e.name,
                            style: TextStyle(
                              fontFamily: 'Gilroy-Medium',
                              package: package,
                              fontSize: 16,
                              color: peerBoldTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
          Gap(context.screenHeight(.11)),
        ],
      ),
    );
  }
}

/// Search bar Widget
class PeerBusinessSearch extends HookWidget {
  final FocusNode focusNode;
  const PeerBusinessSearch(
    this.focusNode, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        color: peerLightPeach,
        child: Row(
          children: [
            Flexible(
              child: TextField(
                focusNode: focusNode,
                style: TextStyle(
                  fontFamily: 'Gilroy-Semibold',
                  package: package,
                  fontSize: 16,
                  color: peerBoldTextColor,
                ),
                onChanged: context.read(peerControllerVM).searchBusiness,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    border: InputBorder.none,
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      fontFamily: 'Gilroy-Semibold',
                      package: package,
                      fontSize: 16,
                      color: peerBoldTextColor,
                    ),
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/search.svg',
                          package: package,
                          height: 18,
                        ),
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
