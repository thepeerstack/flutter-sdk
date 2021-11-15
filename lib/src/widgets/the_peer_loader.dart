import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:thepeer_flutter/src/const/const.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';
import 'package:thepeer_flutter/src/utils/extensions.dart';

class PeerLoader extends StatelessWidget {
  const PeerLoader({
    Key? key,
    required this.percent,
  }) : super(key: key);

  final int? percent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo.png',
          package: package,
          height: 30,
        ),
        const Gap(20),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 3,
            width: context.screenWidth(0.2),
            child: LinearProgressIndicator(
              value: percent != null ? (percent! / 100) : null,
              valueColor: const AlwaysStoppedAnimation(peerBlue),
              backgroundColor: Colors.black12.withOpacity(.09),
            ),
          ),
        ),
      ],
    );
  }
}
