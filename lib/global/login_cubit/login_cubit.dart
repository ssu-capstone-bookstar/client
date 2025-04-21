import 'package:bookstar_app/api_service/dio_client.dart';
import 'package:bookstar_app/main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  /// ✅ 앱 로그인 메소드
  Future<void> handleAppLogin({
    required String? idToken,
    required String provider,
  }) async {
    final response = await dio.post(
      'auth/login',
      data: {
        'idToken': idToken,
        'providerType': provider,
      },
    );
    final String accessToken = response.data['data']['accessToken'];
    final String profileImage = response.data['data']['profileImage'] ?? '';
    final String refreshToken = response.data['data']['refreshToken'];
    final String nickName = response.data['data']['nickName'];
    final int memberId = response.data['data']['memberId'];
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('profileImage', profileImage);
    await prefs.setInt('memberId', memberId);
    await prefs.setString('nickName', nickName);
    await prefs.setString('refreshToken', refreshToken);
  }
}
