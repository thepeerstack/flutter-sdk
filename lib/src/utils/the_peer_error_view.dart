import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:thepeer_flutter/src/const/const.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';
import 'package:thepeer_flutter/src/widgets/the_peer_button.dart';
import 'package:thepeer_flutter/src/widgets/touchable_opacity.dart';

/// ThepeerErrorView States Widget
class ThepeerErrorView extends StatelessWidget {
  final VoidCallback reload;
  final VoidCallback? onClosed;

  const ThepeerErrorView({
    Key? key,
    this.onClosed,
    required this.reload,
  }) : super(key: key);

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
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            children: [
              const Gap(80),
              SvgPicture.asset(
                'assets/images/warning_badge.svg',
                package: package,
              ),
              const Gap(45),
              const Center(
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
              const Gap(14),
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
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
              const Gap(32),
              PeerButton(
                title: 'Reload',
                buttonColor: Colors.white,
                textColor: peerBlue,
                isUnderlined: true,
                onTap: reload,
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Powered by',
              style: TextStyle(
                fontFamily: 'Gilroy-Medium',
                package: package,
                fontSize: 14,
                color: peerLightTextColor,
              ),
            ),
            const Gap(4),
            Image.asset(
              'assets/images/logo.png',
              package: package,
              height: 18,
            ),
          ],
        ),
        const Gap(32),
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
        const Spacer(),
        TouchableOpacity(
          onTap: onClosed ?? () {},
          child: SizedBox(
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
