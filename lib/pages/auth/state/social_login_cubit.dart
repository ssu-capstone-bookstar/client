import 'package:bookstar_app/main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
      final String idToken = token.idToken ?? '';
      prefs.setString('idToken', idToken);
      prefs.setString('provider', 'KAKAO');
    } catch (error) {
      debugPrint('알 수 없는 카카오 에러: $error');
    }
  }

  /// ✅ 애플 로그인 메소드
  Future<void> handleAppleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final String idToken = credential.identityToken ?? '';
      prefs.setString('provider', 'APPLE');
      prefs.setString('idToken', idToken);
    } catch (error) {
      debugPrint('애플 로그인 에러: $error');
    }
  }
}
