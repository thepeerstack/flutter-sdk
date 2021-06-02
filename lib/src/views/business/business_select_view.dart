import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:thepeer_flutter/src/consts/consts.dart';
import 'package:thepeer_flutter/src/core/providers.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';
import 'package:thepeer_flutter/src/widgets/touchable_opacity.dart';

class BusinessSelectView extends HookWidget {
  const BusinessSelectView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 38,
          ),
          child: Column(
            children: [
              PeerHeader(),
              Gap(22),
              Center(
                child: Text(
                  'Hi Trojan, you are about to send',
                  style: TextStyle(
                    fontFamily: 'Gilroy-Medium',
                    package: package,
                    fontSize: 14,
                    color: peerTextColor,
                  ),
                ),
              ),
              Gap(8),
              Center(
                child: Text(
                  '$ngn' '5,000',
                  style: TextStyle(
                    fontFamily: 'Gilroy-Bold',
                    package: package,
                    fontSize: 32,
                    color: peerBoldTextColor,
                  ),
                ),
              ),
              Gap(47),
              Text(
                'Select fintech',
                style: TextStyle(
                  fontFamily: 'Gilroy-Medium',
                  package: package,
                  fontSize: 14,
                  color: peerLightTextColor,
                ),
              ),
              Gap(13),
              PeerBusinessSearch(),
            ],
          ),
        ),
        Gap(18),
        PeerBusinessList(),
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
      ],
    );
  }
}

class PeerBusinessList extends HookWidget {
  const PeerBusinessList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final businesses = useProvider(
        peerControllerVM.select((v) => v.appListModel?.businesses ?? []));
    return Flexible(
      child: ListView(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 38,
        ),
        physics: BouncingScrollPhysics(),
        children: [
          for (var i = 0; i < 3; i++)
            ...businesses.map((e) => Column(
                  children: [
                    TouchableOpacity(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        width: double.infinity,
                        child: Row(
                          children: [
                            Image.network(
                              e.logo ?? '',
                              width: 38,
                              height: 38,
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
                ))
        ],
      ),
    );
  }
}

class PeerBusinessSearch extends StatelessWidget {
  const PeerBusinessSearch({
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
                autofocus: false,
                style: TextStyle(
                  fontFamily: 'Gilroy-Semibold',
                  package: package,
                  fontSize: 16,
                  color: peerBoldTextColor,
                ),
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

class PeerHeader extends StatelessWidget {
  const PeerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        Gap(50),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            color: peerPeach,
            child: Text(
              'Test',
              style: TextStyle(
                fontFamily: 'Gilroy-SemiBold',
                package: package,
                color: peerRed,
              ),
            ),
          ),
        ),
        Spacer(),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            'assets/images/close.svg',
            package: package,
          ),
        ),
      ],
    );
  }
}