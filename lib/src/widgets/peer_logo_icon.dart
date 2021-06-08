import 'package:flutter/material.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_business_model.dart';

/// Peer Logo Icon Widger
class PeerLogoIcon extends StatelessWidget {
  const PeerLogoIcon(this.business);

  final ThePeerBusiness? business;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      business?.logo ??
          'https://img.pngio.com/grey-circle-png-15-clip-arts-for-free-download-on-een-2019-gray-circle-png-476_803.png',
      width: 40,
      height: 40,
      fit: BoxFit.cover,
    );
  }
}
