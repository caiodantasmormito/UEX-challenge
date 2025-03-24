import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

final _baseOptions = BaseOptions(
  baseUrl: '',
  headers: {'Content-Type': 'application/json'},
  connectTimeout: const Duration(milliseconds: 30000),
  receiveTimeout: const Duration(milliseconds: 30000),
);

class HttpClient extends DioForNative {
  HttpClient() : super(_baseOptions);
}

class AuthenticatedClient extends HttpClient {
  AuthenticatedClient({required this.sharedPreferences}) : super();
  final SharedPreferences sharedPreferences;

  @override
  Interceptors get interceptors => super.interceptors
    ..add(AuthenticateInterceptor(sharedPreferences: sharedPreferences));
}

class AuthenticateInterceptor extends Interceptor {
  const AuthenticateInterceptor({required this.sharedPreferences});
  final SharedPreferences sharedPreferences;
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (kDebugMode) {
      log('BaseUrl: ${options.baseUrl}');
      log('URL: ${options.path}');
      log('HEADERS: ${options.headers.toString()}');
    }
    final token = await sharedPreferences.getString('access_token');
    if (token != null) {
      options.headers.addAll({'Authorization': 'Bearer $token'});
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      log('BODY: ${response.data.toString()}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      log(
        err.message ?? '',
      );
      log(
        err.toString(),
      );
      log(err.message ?? '', error: err.error);
    }
    super.onError(err, handler);
  }
}
