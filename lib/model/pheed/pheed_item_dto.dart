import 'package:bookstar_app/model/pheed/review_content_dto.dart';
import 'package:bookstar_app/model/pheed/scrap_content_dto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PheedItemDto extends Equatable {
  final int id;
  final String type;
  final String createdAt;
  final PostContentDto content;

  const PheedItemDto({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.content,
  });

  factory PheedItemDto.fromJson(Map<String, dynamic> json) {
    final String itemType = json['type'] ?? '';
    final Map<String, dynamic> contentJson =
        json['content'] as Map<String, dynamic>? ?? {};

    PostContentDto resolvedContent;

    if (itemType == 'SCRAP') {
      resolvedContent = ScrapContentDto.fromJson(contentJson);
    } else if (itemType == 'REVIEW') {
      resolvedContent = ReviewContentDto.fromJson(contentJson);
    } else {
      debugPrint('스크랩, 리뷰가 아님: $itemType');
      resolvedContent = UnknownContentDto.fromJson(contentJson);
    }

    return PheedItemDto(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      createdAt: json['createdAt'] ?? '',
      content: resolvedContent,
    );
  }
  @override
  List<Object?> get props => [
        id,
        type,
        createdAt,
        content,
      ];
}

abstract class PostContentDto extends Equatable {
  const PostContentDto();
}

class UnknownContentDto extends PostContentDto {
  final Map<String, dynamic> rawData;

  const UnknownContentDto(this.rawData);

  factory UnknownContentDto.fromJson(Map<String, dynamic> json) {
    return UnknownContentDto(json);
  }

  @override
  List<Object?> get props => [rawData];
}
