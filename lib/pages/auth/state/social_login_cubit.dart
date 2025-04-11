import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';

part 'social_login_state.dart';

/// 🏷️ 소셜로그인 큐빗
class SocialLoginCubit extends Cubit<SocialLoginState> {
  SocialLoginCubit() : super(SocialLoginState());

  /// ✅ 카카오 로그인 메소드
  Future<void> handleKakaoLogin() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken token;
      if (isInstalled) {
        try {
          token = await UserApi.instance.loginWithKakaoTalk();
        } catch (e) {
          if (e is PlatformException) {
            token = await UserApi.instance.loginWithKakaoAccount();
          } else {
            debugPrint('카카오 로그인 에러: $e');
            return;
          }
        }
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }
      String accessToken = token.accessToken;

      emit(SocialLoginState(accessToken: accessToken));
    } catch (error) {
      debugPrint('알 수 없는 카카오 에러: $error');
    }
  }
}
