import 'package:bookstar_app/api_service/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService {
  static Future<Response> apiPostService({
    required String path,
    Map<String, dynamic>? body,
  }) async {
    late Response response;
    try {
      response = await dio.post(path, data: body);
    } catch (e) {
      debugPrint('API에러 - $e');
    }
    if (response.statusCode != 200) {
      throw Exception('API에러 - ${response.statusCode}');
    }
    return response;
  }

  static Future<Response> apiGetService({
    required String path,
    Map<String, dynamic>? body,
  }) async {
    late Response response;
    try {
      response = await dio.get(path, data: body);
    } catch (e) {
      debugPrint('API에러 - $e');
    }
    return response;
  }

  static Future<Response> apiPutService({
    required String path,
    Map<String, dynamic>? body,
  }) async {
    late Response response;
    try {
      response = await dio.put(path, data: body);
    } catch (e) {
      debugPrint('API에러 - $e');
    }
    return response;
  }

  static Future<Response> apiDeleteService({
    required String path,
    Map<String, dynamic>? body,
  }) async {
    late Response response;
    try {
      response = await dio.delete(path, data: body);
    } catch (e) {
      debugPrint('API에러 - $e');
    }
    return response;
  }
}
