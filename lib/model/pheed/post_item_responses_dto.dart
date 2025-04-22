import 'package:bookstar_app/model/pheed/post_content_dto.dart';

class PostItemResponse {
  final int id;
  final String type;
  final String createdAt;
  final PostContentDto content;

  PostItemResponse({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.content,
  });

  factory PostItemResponse.fromJson(Map<String, dynamic> json) {
    return PostItemResponse(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      createdAt: json['createdAt'] ?? '',
      content: PostContentDto.fromJson(json['content'] ?? {}),
    );
  }
}
