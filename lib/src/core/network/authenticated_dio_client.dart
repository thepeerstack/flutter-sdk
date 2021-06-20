import 'package:dio/dio.dart';

class AuthenticatedDioClient {
  final _dio = Dio();

  AuthenticatedDioClient() {
    _dio.options.responseType = ResponseType.plain;
    _dio.interceptors.add(InterceptorsWrapper(requestInterceptor));
  }

  // ApiKey
  String apiKey = '';

  Future<Response<dynamic>> get<T>(
    String path, {
    Map<String, Object>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    onReceiveProgress,
  }) async {
    final resp = await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );

    return resp;
  }

  Future<Response<dynamic>> head<T>(
    String path, {
    data,
    Map<String, Object>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final resp = await _dio.head(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );

    return resp;
  }

  Future<Response<dynamic>> post<T>(
    String path, {
    data,
    Map<String, Object>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    onSendProgress,
    onReceiveProgress,
  }) async {
    final resp = await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return resp;
  }

  // Don't forget to reset the cache when logging out the user
  void resetApiKey() {
    apiKey = '';
  }

  void requestInterceptor(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (apiKey.isNotEmpty) {
       options.headers.putIfAbsent(
        'x-api-key',
        () => '$apiKey',
      );
    }
    options.headers.putIfAbsent(
      'Content-type',
      () => 'application/json;charset=UTF-8',
    );
    options.headers.putIfAbsent(
      'Accept',
      () => 'application/json;charset=UTF-8',
    );

    return handler.next(options);
  }
}

class InterceptorsWrapper extends Interceptor {
  void Function(RequestOptions options, RequestInterceptorHandler handler)
      requestInterceptor;

  InterceptorsWrapper(this.requestInterceptor);

  @override
  void onRequest(RequestOptions o, RequestInterceptorHandler h) {
    return requestInterceptor(o, h);
  }

  @override
  void onResponse(Response res, ResponseInterceptorHandler handler) {
    // logger.d('RESPONSE[${res.statusCode}] => PATH: ${res.realUri}');
    // logger.d('${res.data}');
    return super.onResponse(res, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    return super.onError(err, handler);
  }
}
