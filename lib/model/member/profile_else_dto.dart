import 'package:equatable/equatable.dart';

class ProfileElseDto extends Equatable {
  final int id;
  final int followings;
  final int followers;
  final int books;
  final int collections;
  final int scraps;
  final int reviews;
  final ProfileBookDto memberBookResponseCursorPageResponse;

  const ProfileElseDto({
    required this.id,
    required this.followings,
    required this.followers,
    required this.books,
    required this.collections,
    required this.scraps,
    required this.reviews,
    required this.memberBookResponseCursorPageResponse,
  });

  factory ProfileElseDto.fromJson(Map<String, dynamic> json) {
    final bookResponseJson = json['memberBookResponseCursorPageResponse'];

    return ProfileElseDto(
      id: json['id'] ?? 0,
      followings: json['followings'] ?? 0,
      followers: json['followers'] ?? 0,
      books: json['books'] ?? 0,
      collections: json['collections'] ?? 0,
      scraps: json['scraps'] ?? 0,
      reviews: json['reviews'] ?? 0,
      memberBookResponseCursorPageResponse:
          bookResponseJson != null && bookResponseJson is Map<String, dynamic>
              ? ProfileBookDto.fromJson(bookResponseJson)
              : ProfileBookDto(data: [], nextCursor: 0, hasNext: false),
    );
  }
  @override
  List<Object?> get props => [
        id,
        followings,
        followers,
        books,
        collections,
        scraps,
        reviews,
        memberBookResponseCursorPageResponse,
      ];
}

class ProfileBookDto extends Equatable {
  final List<ProfileBookDetailDto> data;
  final int nextCursor;
  final bool hasNext;

  const ProfileBookDto({
    required this.data,
    required this.nextCursor,
    required this.hasNext,
  });

  factory ProfileBookDto.fromJson(Map<String, dynamic> json) {
    final List<ProfileBookDetailDto> dataList =
        (json['data'] as List<dynamic>? ?? [])
            .map((item) =>
                ProfileBookDetailDto.fromJson(item as Map<String, dynamic>))
            .toList();

    return ProfileBookDto(
      data: dataList,
      nextCursor: json['nextCursor'] ?? 0,
      hasNext: json['hasNext'] ?? false,
    );
  }
  @override
  List<Object?> get props => [
        data,
        nextCursor,
        hasNext,
      ];
}

class ProfileBookDetailDto extends Equatable {
  final String bookCoverImage;
  final String bookId;

  const ProfileBookDetailDto({
    required this.bookCoverImage,
    required this.bookId,
  });

  factory ProfileBookDetailDto.fromJson(Map<String, dynamic> json) {
    return ProfileBookDetailDto(
      bookCoverImage: json['bookCoverImage'] ?? '',
      bookId: json['bookId'] ?? '',
    );
  }
  @override
  List<Object?> get props => [
        bookCoverImage,
        bookId,
      ];
}
