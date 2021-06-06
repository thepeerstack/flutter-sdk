import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thepeer_flutter/src/consts/consts.dart';
import 'package:thepeer_flutter/src/core/providers.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';
import 'package:thepeer_flutter/src/utils/extensions.dart';
import 'package:thepeer_flutter/src/widgets/peer_button.dart';
import 'package:thepeer_flutter/src/widgets/peer_header.dart';

class ThePeerErrorView extends StatelessWidget {
  final ThePeerErrorStates state;

  const ThePeerErrorView({Key? key, required this.state});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PeerHeader(
                showTest:false ,
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
              state.image,
              package: package,
            ),
            Gap(45),
            Center(
              child: Text(
                state.title,
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
                padding: const EdgeInsets.symmetric(horizontal:30),
                child: Text(
                  state.description,
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
            Gap(32),
          
            PeerButton(
              title: 'Go back',
              buttonColor: Colors.white,
              textColor: peerBlue,
              isUnderlined:  true,
              onTap: () => context.read(peerControllerVM).popPage(),
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
