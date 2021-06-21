import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final String message;
  final int? code;

  ServerException({
    this.message = 'Something unexpected has happened, we are sorry...',
    this.code = -1,
  });

  factory ServerException.fromResponse(
    Response response, {
    String? customMessage,
  }) {
    Map<String, dynamic> e = json.decode(response.data);
    final msg = e['message'] ?? 'Something unexpected has happened...';

    return ServerException(
      // try the api code first, and fallback to response if needed
      code: e['statusCode'] ?? response.statusCode,
      // try to use a local Custom message, or falltack to API message if needed
      message: customMessage ?? msg,
    );
  }

  @override
  List<Object?> get props => [message, code];
}
