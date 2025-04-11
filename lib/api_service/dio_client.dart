import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: dotenv.env['BASE_URL']!,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    headers: {
      'Content-Type': 'application/json',
    },
  ),
)..interceptors.addAll([
    LogInterceptor(
      requestBody: true,
      responseBody: true,
    ),
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        debugPrint("DIO INTERCEPTOR:::!! ${dotenv.env['BASE_URL']!}");

        final requiresToken = options.extra['requiresToken'] == true;
        if (requiresToken) {
          final token = ''; //TODO: 토큰 어떻게 가져올지 정하기
          options.headers['Authorization'] = 'Bearer $token';
        }

        debugPrint("DIO :: ${options.baseUrl}");
        debugPrint("DIO :: ${options.uri}");
        debugPrint("DIO :: ${options.method}");
        debugPrint("DIO :: ${options.headers}");
        debugPrint("DIO :: ${options.contentType}");
        debugPrint("DIO DATA :: ${options.data}");
        return handler.next(options);
      },
      onError: (e, handler) {
        debugPrint("DIO ERROR :: $e");
        return handler.next(e);
      },
    ),
  ]);
