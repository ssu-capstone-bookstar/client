import 'package:equatable/equatable.dart';

class ProfileDto extends Equatable {
  final int id;
  final String nickName;
  final String email;
  final String profileImage;

  const ProfileDto({
    required this.id,
    required this.nickName,
    required this.email,
    required this.profileImage,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    return ProfileDto(
      id: json['id'] ?? 0,
      nickName: json['nickName'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        nickName,
        email,
        profileImage,
      ];
}
