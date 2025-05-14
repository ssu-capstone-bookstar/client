import 'dart:io';

import 'package:bookstar_app/api_service/dio_client.dart';
import 'package:bookstar_app/constants/mime_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ApiService {
  static Future<Response> apiPostService({
    required String path,
    Map<String, dynamic>? body,
    Options? options,
  }) async {
    try {
      final Response response =
          await dio.post(path, data: body, options: options);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'API POST Error - Status Code: ${response.statusCode}',
        );
      }
      return response;
    } catch (e) {
      debugPrint('API POST 에러 - $path: $e');
      rethrow;
    }
  }

  static Future<Response> apiGetService({
    required String path,
    Map<String, dynamic>? body,
    Options? options,
  }) async {
    try {
      final Response response = await dio.get(
        path,
        queryParameters: body,
        options: options,
      );
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'API GET Error - Status Code: ${response.statusCode}',
        );
      }
      return response;
    } catch (e) {
      debugPrint('API GET 에러 - $path: $e');
      rethrow;
    }
  }

  static Future<Response> apiPutService({
    required String path,
    Map<String, dynamic>? body,
    Options? options,
  }) async {
    try {
      final Response response =
          await dio.put(path, data: body, options: options);
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'API PUT Error - Status Code: ${response.statusCode}',
        );
      }
      return response;
    } catch (e) {
      debugPrint('API PUT 에러 - $path: $e');
      rethrow;
    }
  }

  static Future<Response> apiPatchService({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final Response response = await dio.patch(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'API PATCH Error - Status Code: ${response.statusCode}',
        );
      }
      return response;
    } catch (e) {
      debugPrint('API PATCH 에러 - $path: $e');
      rethrow;
    }
  }

  static Future<Response> apiDeleteService({
    required String path,
    Map<String, dynamic>? body,
    Options? options,
  }) async {
    try {
      final Response response =
          await dio.delete(path, data: body, options: options);
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'API DELETE Error - Status Code: ${response.statusCode}',
        );
      }
      return response;
    } catch (e) {
      debugPrint('API DELETE 에러 - $path: $e');
      rethrow;
    }
  }

  static Future<Response> awsPutFileToPresignedUrl({
    required String presignedUrl,
    required File file,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final headers = {
        'Content-Type': mimeType[url.extension(file.path).toLowerCase()] ??
            'application/octet-stream',
        'Content-Length': bytes.length.toString(),
      };

      final response = await awsDio.put(
        presignedUrl,
        data: Stream.fromIterable([bytes]),
        options: Options(
          headers: headers,
        ),
        onSendProgress: (sent, total) {
          debugPrint('AWS 전송중..: $sent / $total');
        },
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'AWS PUT Error - Status Code: ${response.statusCode}, URL: $presignedUrl',
        );
      }

      return response;
    } catch (e) {
      debugPrint('AWS PUT 에러: $e');
      rethrow;
    }
  }
}
