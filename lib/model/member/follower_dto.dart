import 'package:equatable/equatable.dart';

class FollowerDto extends Equatable {
  final int memberId;
  final String nickname;
  final String profileImage;
  final String followDate;

  const FollowerDto({
    required this.memberId,
    required this.nickname,
    required this.profileImage,
    required this.followDate,
  });

  factory FollowerDto.fromJson(Map<String, dynamic> json) {
    return FollowerDto(
      memberId: json['memberId'] ?? 0,
      nickname: json['nickname'] ?? '',
      profileImage: json['profileImage'] ?? '',
      followDate: json['followDate'] ?? '',
    );
  }

  FollowerDto copyWith({
    int? memberId,
    String? nickname,
    String? profileImage,
    String? followDate,
  }) {
    return FollowerDto(
      memberId: memberId ?? this.memberId,
      nickname: nickname ?? this.nickname,
      profileImage: profileImage ?? this.profileImage,
      followDate: followDate ?? this.followDate,
    );
  }

  @override
  List<Object?> get props => [
        memberId,
        nickname,
        profileImage,
        followDate,
      ];
}
