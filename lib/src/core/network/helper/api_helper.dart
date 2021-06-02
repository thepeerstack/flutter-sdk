import 'dart:io';

import 'package:dio/dio.dart';
import 'package:thepeer_flutter/src/core/commons/exceptions/exceptions.dart';
import 'package:thepeer_flutter/src/core/network/authenticated_dio_client.dart';
import 'package:thepeer_flutter/src/utils/logger.dart';

/// API Helper class for Authenticated Requests
class ApiHelper extends AuthenticatedDioClient {
  /// The Peer API Key
  final String publicKey;

  ApiHelper(this.publicKey);

  Future<String> getReq({
    /// Request Url
    required String url,

    /// Request Headers
    Map<String, Object>? headers,

    /// Request's queryParameters
    Map<String, Object>? queryParameters,

    /// Override default options
    Options? options,

    /// Progress report for data download
    ProgressCallback? onReceiveProgress,
  }) async {
    var responseJson = '';

    apiKey = publicKey;

    try {
      // Make Request
      final response = await get(
        url,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
        onReceiveProgress: onReceiveProgress,
      );

      // Log data response
      logger.i(url);
      logger.d(response.data);

      responseJson = _returnResponse(response);
    } on SocketException {
      // Handle Exceptions
      throw ServerException(message: 'No Internet connection');
    } catch (e) {
      // Catch Error
      if (e is Response) {
        logger.e(e.data);

        throw e.data;
      } else if (e.toString().toLowerCase().contains('time')) {
        throw 'Sever Took too long to Respond';
      } else {
        logger.e(e.toString());

        rethrow;
      }
    }
    return responseJson;
  }

  Future<String> postReq({
    /// Request Url
    required String url,

    /// Request Headers
    Map<String, String>? headers,

    /// Should throw error or return it
    bool throwError = true,

    /// Status code to accept as successful
    List<int>? passRange,

    /// Body of the Request
    Map<String, Object?>? body,

    /// Request's queryParameters
    Map<String, Object>? queryParameters,

    /// Override default options
    Options? options,

    /// Progress report for data upload
    ProgressCallback? onSendProgress,

    /// Progress report for data download
    ProgressCallback? onReceiveProgress,
  }) async {
    var responseJson = '';

    apiKey = publicKey;

    try {
      logger.d(body);

      // Make Request
      final response = await post(
        url,
        data: body,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
      );

      // Log data response
      logger.i(url);
      logger.d(response.data);

      responseJson = _returnResponse(response);
    } on SocketException {
      // Handle Exceptions
      throw ServerException(message: 'No Internet connection');
    } on DioError catch (e) {
      // Log data response
      logger.i(url);
      return e.response?.data;
    } catch (e) {
      print(e.toString());

      // Catch Error
      if (e is Response) {
        logger.e(e.data);
        throw e.data;
      } else if (e.toString().toLowerCase().contains('time')) {
        throw 'Sever Took too long to Respond';
      } else {
        logger.e(e.toString());
        rethrow;
      }
    }

    return responseJson;
  }

  String _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 201:
        return response.data;
      case 400:
        return '${response.data}';
      case 422:
        return '${response.data}';
      case 404:
        throw Exception('${response.data}');
      case 401:
      case 403:
        throw ServerException(message: '${response.data}');
      case 500:
      default:
        throw ServerException(
          message: 'Error occured while Communication with Server',
        );
    }
  }
}
