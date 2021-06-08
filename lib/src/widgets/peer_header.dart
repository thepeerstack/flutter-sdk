import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thepeer_flutter/src/consts/consts.dart';
import 'package:thepeer_flutter/src/core/providers.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';

/// Peer Header Widget
class PeerHeader extends HookWidget {
  final bool showClose, showTest;
  const PeerHeader({
    Key? key,
    this.showClose = false,
    this.showTest = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final peerContext = useProvider(peerControllerVM.select(
      (v) => v.context,
    ));
    return Row(
      children: [
        if (showClose == true) ...[
          IconButton(
            padding: EdgeInsets.all(5),
            onPressed: () => context.read(peerControllerVM).popPage(),
            icon: SvgPicture.asset(
              'assets/images/back.svg',
              package: package,
            ),
          ),
        ] else ...[
          if (showTest == true) ...[
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
          ]
        ],
        Spacer(),
        IconButton(
          padding: EdgeInsets.all(5),
          onPressed: () {
            /// Close all screen of Bottom Sheet
            Navigator.pop(peerContext);
          },
          icon: SvgPicture.asset(
            'assets/images/close.svg',
            package: package,
          ),
        ),
      ],
    );
  }
}
