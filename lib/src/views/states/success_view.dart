import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thepeer_flutter/src/consts/consts.dart';
import 'package:thepeer_flutter/src/core/providers.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';
import 'package:thepeer_flutter/src/utils/extensions.dart';
import 'package:thepeer_flutter/src/widgets/peer_header.dart';

/// Successful Transaction View
class ThePeerSuccessView extends HookWidget {
  final String description;

  const ThePeerSuccessView({Key? key, required this.description});

  @override
  Widget build(BuildContext context) {
    final peerContext = useProvider(peerControllerVM.select(
      (v) => v.context,
    ));
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 38,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PeerHeader(
                showTest: false,
              ),
            ],
          ),
        ),
        Flexible(
            child: ListView(
          padding: EdgeInsets.all(16),
          physics: BouncingScrollPhysics(),
          children: [
            Gap(80),
            SvgPicture.asset(
              'assets/images/success.svg',
              package: package,
            ),
            Gap(45),
            Center(
              child: Text(
                'Transcation successful',
                style: TextStyle(
                  fontFamily: 'Gilroy-Bold',
                  package: package,
                  fontSize: 24,
                  color: peerBoldTextColor,
                ),
              ),
            ),
            Gap(14),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Gilroy-Medium',
                    package: package,
                    fontSize: 15,
                    color: peerTextColor,
                  ),
                ),
              ),
            ),
            Gap(60),
            CountDownTimer(
              onTimeEnd: () {
                /// Close all screen of Bottom Sheet
                Navigator.pop(peerContext);
              },
            )
          ],
        )),
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
        Gap(32),
      ],
    );
  }
}

class CountDownTimer extends StatefulHookWidget {
  final VoidCallback onTimeEnd;

  CountDownTimer({required this.onTimeEnd});
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  final interval = const Duration(seconds: 1);

  Timer? timer;

  final int timerMaxSeconds = 10;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}:${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  void startTimeout([int? milliseconds]) {
    var duration = interval;
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          widget.onTimeEnd();
        }
      });
    });
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimeout.withPostFrameCallback();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: 'Closing in ',
          children: [
            TextSpan(
              text: '$timerText',
              style: TextStyle(
                fontFamily: 'Gilroy-Medium',
                package: package,
                fontSize: 16,
                color: peerBlue,
              ),
            ),
          ],
        ),
        style: TextStyle(
          fontFamily: 'Gilroy-Medium',
          package: package,
          fontSize: 16,
          color: peerTextColor,
        ),
      ),
    );
  }
}
