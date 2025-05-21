import 'package:bookstar_app/model/pheed/pheed_item_dto.dart';

class ScrapContentDto extends PostContentDto {
  final int scrapId;
  final int memberId;
  final String content;
  final int bookId;
  final String bookImage;
  final String bookTitle;
  final String scrapImages;
  final String scrapUploadTime;
  final int scrapLikesCount;
  final int scrapCommentsCount;
  final List<dynamic> comments;
  final String privacy;

  const ScrapContentDto({
    required this.scrapId,
    required this.memberId,
    required this.content,
    required this.bookId,
    required this.bookImage,
    required this.bookTitle,
    required this.scrapImages,
    required this.scrapUploadTime,
    required this.scrapLikesCount,
    required this.scrapCommentsCount,
    required this.comments,
    required this.privacy,
  });

  factory ScrapContentDto.fromJson(Map<String, dynamic> json) {
    return ScrapContentDto(
      scrapId: json['scrapId'] ?? 0,
      memberId: json['memberId'] ?? 0,
      content: json['content'] ?? '',
      bookId: json['bookId'] ?? 0,
      bookImage: json['bookImage'] ?? '',
      bookTitle: json['bookTitle'] ?? '',
      scrapImages: json['scrapImages'] ?? '',
      scrapUploadTime: json['scrapUploadTime'] ?? '',
      scrapLikesCount: json['scrapLikesCount'] ?? 0,
      scrapCommentsCount: json['scrapCommentsCount'] ?? 0,
      comments: (json['comments']) ?? [],
      privacy: json['privacy'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        scrapId,
        memberId,
        content,
        bookId,
        bookImage,
        bookTitle,
        scrapImages,
        scrapUploadTime,
        scrapLikesCount,
        scrapCommentsCount,
        comments,
        privacy,
      ];
}
