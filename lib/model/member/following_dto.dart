import 'package:equatable/equatable.dart';

class FollowingDto extends Equatable {
  final int memberId;
  final String nickname;
  final String profileImage;
  final String followDate;

  const FollowingDto({
    required this.memberId,
    required this.nickname,
    required this.profileImage,
    required this.followDate,
  });

  factory FollowingDto.fromJson(Map<String, dynamic> json) {
    return FollowingDto(
      memberId: json['memberId'] ?? 0,
      nickname: json['nickname'] ?? '',
      profileImage: json['profileImage'] ?? '',
      followDate: json['followDate'] ?? '',
    );
  }

  FollowingDto copyWith({
    int? memberId,
    String? nickname,
    String? profileImage,
    String? followDate,
  }) {
    return FollowingDto(
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
