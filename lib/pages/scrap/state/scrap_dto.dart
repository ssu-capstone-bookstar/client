import 'package:equatable/equatable.dart';

/// 스크랩 DTO
class ScrapDto extends Equatable {
  final int scrapId;
  final int memberId;
  final String bookImage;
  final String bookTitle;
  final String scrapImages;
  final String content;

  const ScrapDto({
    required this.scrapId,
    required this.memberId,
    required this.bookImage,
    required this.bookTitle,
    required this.scrapImages,
    required this.content,
  });

  factory ScrapDto.fromJson(Map<String, dynamic> json) {
    return ScrapDto(
      scrapId: json['scrapId'] ?? 0,
      memberId: json['memberId'] ?? 0,
      bookImage: json['bookImage'] ?? '',
      bookTitle: json['bookTitle'] ?? '',
      scrapImages: json['scrapImages'] ?? '',
      content: json['content'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        scrapId,
        memberId,
        bookImage,
        bookTitle,
        scrapImages,
        content,
      ];
}
