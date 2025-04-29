import 'package:equatable/equatable.dart';

class MemberDto extends Equatable {
  final int id;
  final String nickName;
  final String email;
  final String profileImage;

  const MemberDto({
    required this.id,
    required this.nickName,
    required this.email,
    required this.profileImage,
  });

  factory MemberDto.fromJson(Map<String, dynamic> json) {
    return MemberDto(
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
