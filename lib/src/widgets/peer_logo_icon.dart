import 'package:flutter/material.dart';
import 'package:thepeer_flutter/src/consts/consts.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_business_model.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';
import 'package:thepeer_flutter/src/utils/extensions.dart';

/// Peer Logo Icon Widger
class PeerLogoIcon extends StatelessWidget {
  const PeerLogoIcon(this.business);

  final ThePeerBusiness? business;

  @override
  Widget build(BuildContext context) {
    return business?.logo != null && business!.logo!.isNotEmpty
        ? Image.network(
            business!.logo!,
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 40,
              height: 40,
              color: peerBlue,
              child: Center(
                child: Text(
                  (business?.name ?? '').initials,
                  style: TextStyle(
                    fontFamily: 'Gilroy-Bold',
                    package: package,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
  }
}
