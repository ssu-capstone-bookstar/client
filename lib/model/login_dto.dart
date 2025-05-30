import 'package:equatable/equatable.dart';

class LoginDto extends Equatable {
  final int memberId;
  final String nickName;
  final String profileImage;
  final String accessToken;
  final String refreshToken;
  final String accessTokenExpiration;
  final String refreshTokenExpiration;

  const LoginDto({
    required this.memberId,
    required this.nickName,
    required this.profileImage,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiration,
    required this.refreshTokenExpiration,
  });

  factory LoginDto.fromJson(Map<String, dynamic> json) {
    return LoginDto(
      memberId: json['memberId'] ?? 0,
      nickName: json['nickName'] ?? '',
      profileImage: json['profileImage'] ?? '',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      accessTokenExpiration: json['accessTokenExpiration'] ?? '',
      refreshTokenExpiration: json['refreshTokenExpiration'] ?? '',
    );
  }
  @override
  List<Object?> get props => [
        memberId,
        nickName,
        profileImage,
        accessToken,
        refreshToken,
        accessTokenExpiration,
        refreshTokenExpiration,
      ];
}
