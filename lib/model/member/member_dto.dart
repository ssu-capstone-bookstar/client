class MemberDto {
  final int id;
  final String nickName;
  final String email;
  final String profileImage;

  MemberDto({
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
}
