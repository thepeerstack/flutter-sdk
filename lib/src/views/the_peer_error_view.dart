import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:thepeer_flutter/src/const/const.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';
import 'package:thepeer_flutter/src/widgets/the_peer_button.dart';
import 'package:thepeer_flutter/src/widgets/touchable_opacity.dart';

/// ThePeerErrorView States Widget
class ThePeerErrorView extends StatelessWidget {
  final VoidCallback reload;
  final VoidCallback? onClosed;

  const ThePeerErrorView({
    Key? key,
    this.onClosed,
    required this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
              PeerHeader(
                onClosed: onClosed,
                showClose: true,
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
              'assets/images/warning_badge.svg',
              package: package,
            ),
            Gap(45),
            Center(
              child: Text(
                'Something went wrong',
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
                  'Please check your internet connection',
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
              title: 'Reload',
              buttonColor: Colors.white,
              textColor: peerBlue,
              isUnderlined: true,
              onTap: reload,
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

/// Peer Header Widget
class PeerHeader extends StatelessWidget {
  final bool showClose;
  final VoidCallback? onClosed;

  const PeerHeader({
    Key? key,
    this.showClose = false,
    this.onClosed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        TouchableOpacity(
          onTap: onClosed ?? () {},
          child: Container(
            height: 40,
            width: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  'assets/images/close.svg',
                  package: package,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
