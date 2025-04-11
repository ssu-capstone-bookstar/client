part of 'social_login_cubit.dart';

class SocialLoginState extends Equatable {
  const SocialLoginState({
    this.accessToken,
  });

  final String? accessToken;

  @override
  List<Object?> get props => [accessToken];
}
