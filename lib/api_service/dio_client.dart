import 'package:bookstar_app/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: '${dotenv.env['BASE_URL']!}${dotenv.env['VERSION']!}',
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
        debugPrint(
            "DIO INTERCEPTOR:::!! ${dotenv.env['BASE_URL']!}${dotenv.env['VERSION']!}");

        final requiresToken = options.extra['requiresToken'] == true;
        if (requiresToken) {
          String? token = await secureStorage.read(key: 'accessToken');
          // String? token = prefs.getString('accessToken');
          options.headers['Authorization'] = 'Bearer $token';
        }

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

final Dio aiDio = Dio(
  BaseOptions(
    baseUrl: 'http://15.164.30.67:8000/',
    connectTimeout: const Duration(seconds: 600),
    receiveTimeout: const Duration(seconds: 600),
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
        debugPrint("DIO INTERCEPTOR:::!! http://15.164.30.67:8000/");

        // final requiresToken = options.extra['requiresToken'] == true;
        // if (requiresToken) {
        //   String? token = prefs.getString('accessToken');
        //   options.headers['Authorization'] = 'Bearer $token';
        // }

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

final Dio awsDio = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  ),
)..interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
    ),
  );
