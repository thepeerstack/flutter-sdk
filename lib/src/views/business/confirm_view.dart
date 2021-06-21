import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thepeer_flutter/src/consts/consts.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_business_model.dart';
import 'package:thepeer_flutter/src/core/providers.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';
import 'package:thepeer_flutter/src/utils/validator.dart';
import 'package:thepeer_flutter/src/widgets/peer_button.dart';
import 'package:thepeer_flutter/src/widgets/peer_header.dart';
import 'package:thepeer_flutter/src/widgets/peer_logo_icon.dart';

/// Confirm Transaction Widget
class ConfirmView extends HookWidget {
  final ThePeerBusiness business;
  const ConfirmView(
    this.business, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentBusiness = useProvider(peerControllerVM.select(
      (v) => v.currentBusiness,
    ));

    final amount = useProvider(peerControllerVM.select(
      (v) => Validator.noSymbolCurrency.format(
        v.peerViewData.data.amount,
      ),
    ));

    final username = useProvider(peerControllerVM.select(
      (v) => v.usernameTEC.text.replaceAll('@', ''),
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
                showClose: true,
              ),
              Gap(22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PeerLogoIcon(currentBusiness?.business),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: RotatedBox(
                      quarterTurns: 2,
                      child: SvgPicture.asset(
                        'assets/images/back.svg',
                        package: package,
                      ),
                    ),
                  ),
                  PeerLogoIcon(business),
                ],
              ),
              Gap(47),
            ],
          ),
        ),
        Flexible(
            child: ListView(
          padding: EdgeInsets.all(16),
          physics: BouncingScrollPhysics(),
          children: [
            Gap(11),
            Center(
              child: Text(
                'Confirm transaction',
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
              child: Text.rich(
                TextSpan(
                  text: '',
                  children: [
                    TextSpan(
                      text: 'You are about to send ',
                      style: TextStyle(
                        fontFamily: 'Gilroy-Medium',
                        package: package,
                        fontSize: 15,
                        color: peerTextColor,
                      ),
                    ),
                    TextSpan(
                      text: '$ngn',
                      style: TextStyle(
                        fontSize: 15,
                        color: peerTextColor,
                      ),
                    ),
                    TextSpan(
                      text:
                          '$amount to ${business.isUsernameIdentifier ? '@' : ''}$username on ${business.name}. Do you want to proceed?',
                      style: TextStyle(
                        fontFamily: 'Gilroy-Medium',
                        package: package,
                        fontSize: 15,
                        color: peerTextColor,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Gap(56),
            PeerButton(
              title: 'Proceed',
              onTap: () => context
                  .read(peerControllerVM)
                  .handleProcessTransaction(business),
            ),
            Gap(10),
            PeerButton(
              title: 'Go back',
              buttonColor: Colors.white,
              textColor: peerLightTextColor,
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
