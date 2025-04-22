class PostContentDto {
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

  PostContentDto({
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

  factory PostContentDto.fromJson(Map<String, dynamic> json) {
    return PostContentDto(
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
}
