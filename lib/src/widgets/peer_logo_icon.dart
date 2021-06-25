import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thepeer_flutter/src/consts/consts.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_business_model.dart';
import 'package:thepeer_flutter/src/utils/colors.dart';
import 'package:thepeer_flutter/src/utils/extensions.dart';

/// Peer Logo Icon Widger
class PeerLogoIcon extends StatelessWidget {
  const PeerLogoIcon({required this.business, this.size});

  final ThePeerBusiness? business;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: business!.logo ?? '',
      height: size ?? 40,
      width: size ?? 40,
      fit: BoxFit.contain,
      placeholder: (context, url) => EmptyPeerLogoIcon(
        business: business,
      ),
      errorWidget: (context, url, error) => EmptyPeerLogoIcon(
        business: business,
      ),
    );
  }
}

class EmptyPeerLogoIcon extends StatelessWidget {
  const EmptyPeerLogoIcon({
    Key? key,
    this.business,
  }) : super(key: key);

  final ThePeerBusiness? business;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
