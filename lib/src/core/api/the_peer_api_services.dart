import 'dart:convert';

import 'package:dartz/dartz.dart' show Either, Right, Left;
import 'package:dio/dio.dart';
import 'package:thepeer_flutter/src/consts/consts.dart';
import 'package:thepeer_flutter/src/core/commons/errors/failure.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_app_list_model.dart';
import 'package:thepeer_flutter/src/core/models/the_peer_business_model.dart';
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
  Future<Either<Failure, ThePeerAppListModel>> getBusinesses() async {
    try {
      logger.d('func: getBusinesses() ->');

      /// Handle Request
      final res = await apiHelper.getReq(
        url: PeerApiURL.businesses,
      );

      /// Handle Response
      if (res.contains('businesses')) {
        return Right(ThePeerAppListModel.fromJson(res));
      } else {
        return Left(Failure(message: 'Unable to get Businesses'));
      }
    } catch (e) {
      return Left(Failure(message: "Couldn't connect to Server"));
    }
  }

  /// Gets Current business
  Future<Either<Failure, ThePeerBusinessModel>> getBusiness() async {
    try {
      logger.d('func: getBusiness() ->');

      /// Handle Request
      final res = await apiHelper.getReq(
        url: PeerApiURL.business,
      );

      /// Handle Response
      if (res.contains('business')) {
        return Right(ThePeerBusinessModel.fromJson(res));
      } else {
        return Left(Failure(message: 'Unable to get Current Business'));
      }
    } catch (e) {
      return Left(Failure(message: "Couldn't connect to Server"));
    }
  }

  /// Gets User from Business Id & Identifier
  Future<Either<Failure, ThePeerUserRefModel>> resolveUser({
    required String businessId,
    required String identifier,
    required ThePeerIdentifierType identifier_type,
  }) async {
    try {
      logger.d('func: resolveUser() ->');

      /// Handle Request
      final res = await apiHelper.getReq(
        url: PeerApiURL.resolveUser(
          businessId: businessId,
          identifier: identifier_type == ThePeerIdentifierType.username
              ? identifier.replaceAll('@', '')
              : identifier,
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
      if (e is DioError) {
        logger.e(e.message);
      }
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
        url: PeerApiURL.receipt,
        body: receipt.toMap(),
      );

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

  /// Gets User from Reference
  Future<Either<Either<Failure, ThePeerErrorStates>, String>> verifyReceipt({
    required String receiptID,
    required String callbackUrl,
  }) async {
    try {
      logger.d('func: generateReceipt() ->');

      /// Handle Request
      final res = await apiHelper.getReq(
        url: '$callbackUrl?receipt=$receiptID',
      );

      /// Handle Response
      if (res.contains('.error')) {
        return Left(Right(ThePeerErrorStates.error));
      } else if (res.contains('.failed')) {
        return Left(Right(ThePeerErrorStates.failed));
      } else if (res.contains('.server_error')) {
        return Left(Right(ThePeerErrorStates.server_error));
      } else if (res.contains('.invalid_receipt')) {
        return Left(Right(ThePeerErrorStates.invalid_receipt));
      } else if (res.contains('.insufficient_funds')) {
        return Left(Right(ThePeerErrorStates.insufficient_funds));
      } else if (res.contains('.user_insuffient_funds')) {
        return Left(Right(ThePeerErrorStates.user_insuffient_funds));
      } else if (res.contains('success')) {
        return Right('');
      } else {
        return Left(Left(Failure(message: 'Unable to Generate Receipt')));
      }
    } catch (e) {
      return Left(Left(Failure(message: "Couldn't connect to Server")));
    }
  }
}
