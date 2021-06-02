import 'dart:convert';

import 'package:dartz/dartz.dart' show Either, Right, Left;
import 'package:thepeer_flutter/src/core/commons/errors/failure.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_app_details_model.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_app_list_model.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_receipt_model.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_user_ref_model.dart';
import 'package:thepeer_flutter/src/core/network/helper/api_helper.dart';
import 'package:thepeer_flutter/src/utils/logger.dart';
import 'package:thepeer_flutter/src/utils/peer_api_url.dart';

class ThePeerApiServices {
  ApiHelper get apiHelper => ApiHelper(publicKey);
  final String publicKey;

  ThePeerApiServices(this.publicKey);

  /// Gets List of available businesses
  Future<Either<Failure, ThePeerAppListModel>> getApps() async {
    try {
      logger.d('func: getApps() ->');

      /// Handle Request
      final res = await apiHelper.getReq(
        url: PeerApiURL.businesses,
      );

      /// Handle Response
      if (res.contains('businesses')) {
        return Right(ThePeerAppListModel.fromJson(res));
      } else {
        return Left(Failure(message: 'Unable to get Apps'));
      }
    } catch (e) {
      return Left(Failure(message: "Couldn't connect to Server"));
    }
  }

  /// Gets Current business Details
  Future<Either<Failure, ThePeerAppDetailsModel>> getAppDetails() async {
    try {
      logger.d('func: getAppDetails() ->');

      /// Handle Request
      final res = await apiHelper.getReq(
        url: PeerApiURL.business,
      );

      /// Handle Response
      if (res.contains('business')) {
        return Right(ThePeerAppDetailsModel.fromJson(res));
      } else {
        return Left(Failure(message: 'Unable to get App Detail'));
      }
    } catch (e) {
      return Left(Failure(message: "Couldn't connect to Server"));
    }
  }

  /// Gets User from Business Id & Identifier
  Future<Either<Failure, ThePeerUserRefModel>> resolveUser({
    required String businessId,
    required String identifier,
  }) async {
    try {
      logger.d('func: resolveUser() ->');

      /// Handle Request
      final res = await apiHelper.getReq(
        url: PeerApiURL.resolveUser(
          businessId: businessId,
          identifier: identifier,
        ),
      );

      /// Handle Response
      if (res.contains('name')) {
        return Right(ThePeerUserRefModel.fromJson(res));
      } else {
        return Left(Failure(message: 'Unable to get User'));
      }
    } catch (e) {
      return Left(Failure(message: "Couldn't connect to Server"));
    }
  }

  /// Gets User from Reference
  Future<Either<Failure, ThePeerUserRefModel>> resolveUserByRef({
    required String reference,
  }) async {
    try {
      logger.d('func: resolveUserByRef() ->');

      /// Handle Request
      final res = await apiHelper.getReq(
        url: PeerApiURL.resolveUserRef(ref: reference),
      );

      /// Handle Response
      if (res.contains('name')) {
        return Right(ThePeerUserRefModel.fromJson(res));
      } else {
        return Left(Failure(message: 'Unable to get User By Ref'));
      }
    } catch (e) {
      return Left(Failure(message: "Couldn't connect to Server"));
    }
  }

  /// Gets User from Reference
  Future<Either<Failure, String>> generateReceipt({
    required ThePeerReceiptModel receipt,
  }) async {
    try {
      logger.d('func: generateReceipt() ->');

      /// Handle Request
      final res = await apiHelper.postReq(
          url: PeerApiURL.receipt, body: receipt.toMap());

      /// Handle Response
      if (res.contains('receipt')) {
        return Right(jsonDecode(res)['receipt']);
      } else {
        return Left(Failure(message: 'Unable to Generate Receipt'));
      }
    } catch (e) {
      return Left(Failure(message: "Couldn't connect to Server"));
    }
  }
}
