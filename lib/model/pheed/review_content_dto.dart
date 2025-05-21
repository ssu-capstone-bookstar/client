import 'package:bookstar_app/model/pheed/pheed_item_dto.dart';
import 'package:bookstar_app/pages/review/state/review_dto.dart';

class ReviewContentDto extends PostContentDto {
  final int reviewId;
  final int memberId;
  final String memberNickName;
  final String memberProfileImage;
  final String content;
  final double rating;
  final int bookId;
  final String bookImage;
  final String bookTitle;
  final String reviewContect;
  final String reviewUploadTime;
  final int reviewLikesCount;
  final int reviewCommentsCount;
  final List<CommentDto> comments;
  final String privacy;

  const ReviewContentDto({
    required this.reviewId,
    required this.memberId,
    required this.memberNickName,
    required this.memberProfileImage,
    required this.content,
    required this.rating,
    required this.bookId,
    required this.bookImage,
    required this.bookTitle,
    required this.reviewContect,
    required this.reviewUploadTime,
    required this.reviewLikesCount,
    required this.reviewCommentsCount,
    required this.comments,
    required this.privacy,
  });

  factory ReviewContentDto.fromJson(Map<String, dynamic> json) {
    return ReviewContentDto(
      reviewId: json['reviewId'] ?? 0,
      memberId: json['memberId'] ?? 0,
      memberNickName: json['memberNickName'] ?? '',
      memberProfileImage: json['memberProfileImage'] ?? '',
      content: json['content'] ?? '',
      rating: json['rating'] ?? 0,
      bookId: json['bookId'] ?? 0,
      bookImage: json['bookImage'] ?? '',
      bookTitle: json['bookTitle'] ?? '',
      reviewContect: json['reviewContect'] ?? '',
      reviewUploadTime: json['reviewUploadTime'] ?? '',
      reviewLikesCount: json['reviewLikesCount'] ?? 0,
      reviewCommentsCount: json['reviewCommentsCount'] ?? 0,
      comments: (json['comments'] as List<dynamic>)
          .map((commentJson) => CommentDto.fromJson(commentJson))
          .toList(),
      privacy: json['privacy'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        reviewId,
        memberId,
        memberNickName,
        memberProfileImage,
        content,
        rating,
        bookId,
        bookImage,
        bookTitle,
        reviewContect,
        reviewUploadTime,
        reviewLikesCount,
        reviewCommentsCount,
        comments,
        privacy,
      ];
}
