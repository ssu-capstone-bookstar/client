import 'package:bookstar_app/api_service/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService {
  static Future<Response> apiPostService({
    required String path,
    Map<String, dynamic>? body,
    Options? options,
  }) async {
    try {
      // dio.post 호출 시 options 파라미터를 전달합니다.
      final Response response =
          await dio.post(path, data: body, options: options);
      // POST 요청 성공 시 일반적으로 200 (OK) 또는 201 (Created) 상태 코드를 반환합니다.
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
      rethrow; // 예외를 다시 던져 호출부에서 처리할 수 있도록 합니다.
    }
  }

  static Future<Response> apiGetService({
    required String path,
    Map<String, dynamic>?
        body, // GET 요청에 body를 사용하는 것은 일반적이지 않습니다. queryParameters 사용을 고려해보세요.
    Options? options,
  }) async {
    try {
      // dio.get 호출 시 options 파라미터를 전달합니다.
      // GET 요청의 경우 'data' 파라미터보다는 'queryParameters'를 사용하는 것이 일반적입니다.
      final Response response =
          await dio.get(path, data: body, options: options);
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
    Map<String, dynamic>? body,
    Options? options,
  }) async {
    try {
      final Response response =
          await dio.patch(path, data: body, options: options);
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
      // DELETE 요청 성공 시 일반적으로 200 (OK) 또는 204 (No Content) 상태 코드를 반환합니다.
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
}
