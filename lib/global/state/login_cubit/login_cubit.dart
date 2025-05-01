import 'package:bookstar_app/api_service/api_service.dart';
import 'package:bookstar_app/main.dart';
import 'package:bookstar_app/model/common_dto.dart';
import 'package:bookstar_app/model/login_dto.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  /// ✅ 앱 로그인 메소드
  Future<void> handleAppLogin({
    required String? idToken,
    required String provider,
  }) async {
    try {
      final Response response =
          await ApiService.apiPostService(path: 'auth/login', body: {
        'idToken': idToken,
        'providerType': provider,
      });

      if (response.data is Map<String, dynamic>) {
        final CommonDto<LoginDto> commonResponse = CommonDto<LoginDto>.fromJson(
          response.data,
          (jsonData) => LoginDto.fromJson(jsonData as Map<String, dynamic>),
        );
        final LoginDto loginData = commonResponse.data;

        await prefs.setString('accessToken', loginData.accessToken);
        await prefs.setString('profileImage', loginData.profileImage);
        await prefs.setInt('memberId', loginData.memberId);
        await prefs.setString('nickName', loginData.nickName);
        await prefs.setString('refreshToken', loginData.refreshToken);
      } else {
        debugPrint('앱 로그인 실패 - json형식 오류');
      }
    } catch (e) {
      debugPrint('앱 로그인 실패 - $e');
    }
  }
}
