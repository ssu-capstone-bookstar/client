// lib/pages/review/state/review_dto.dart
import 'package:equatable/equatable.dart';

/// 리뷰의 멤버 DTO
class MemberDto extends Equatable {
  final DateTime createdDate;
  final DateTime updatedDate;
  final int id;
  final String nickName;
  final String profileImage;
  final String role;
  final bool privacy;
  final String email;
  final String birthYear;
  final String providerId;
  final String providerType;

  const MemberDto({
    required this.createdDate,
    required this.updatedDate,
    required this.id,
    required this.nickName,
    required this.profileImage,
    required this.role,
    required this.privacy,
    required this.email,
    required this.birthYear,
    required this.providerId,
    required this.providerType,
  });

  factory MemberDto.fromJson(Map<String, dynamic> json) {
    return MemberDto(
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: DateTime.parse(json['updatedDate']),
      id: json['id'] ?? 0,
      nickName: json['nickName'] ?? '',
      profileImage: json['profileImage'] ?? '',
      role: json['role'] ?? 'USER',
      privacy: json['privacy'] ?? true,
      email: json['email'] ?? '',
      birthYear: json['birthYear'] ?? '',
      providerId: json['providerId'] ?? '',
      providerType: json['providerType'] ?? 'KAKAO',
    );
  }

  @override
  List<Object?> get props => [
        createdDate,
        updatedDate,
        id,
        nickName,
        profileImage,
        role,
        privacy,
        email,
        birthYear,
        providerId,
        providerType,
      ];
}

/// 리뷰의 책 DTO
class BookDto extends Equatable {
  final DateTime createdDate;
  final DateTime updatedDate;
  final int id;
  final int aladingBookId;
  final String title;
  final String author;
  final String isbn;
  final String isbn13;
  final String bookCategory;
  final String categoryName;
  final String description;
  final String publisher;
  final DateTime publishedDate;
  final int page;
  final int toc;
  final String imageUrl;

  const BookDto({
    required this.createdDate,
    required this.updatedDate,
    required this.id,
    required this.aladingBookId,
    required this.title,
    required this.author,
    required this.isbn,
    required this.isbn13,
    required this.bookCategory,
    required this.categoryName,
    required this.description,
    required this.publisher,
    required this.publishedDate,
    required this.page,
    required this.toc,
    required this.imageUrl,
  });

  factory BookDto.fromJson(Map<String, dynamic> json) {
    return BookDto(
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: DateTime.parse(json['updatedDate']),
      id: json['id'] ?? 0,
      aladingBookId: json['aladingBookId'] ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      isbn: json['isbn'] ?? '',
      isbn13: json['isbn13'] ?? '',
      bookCategory: json['bookCategory'] ?? 'LITERATURE',
      categoryName: json['categoryName'] ?? '',
      description: json['description'] ?? '',
      publisher: json['publisher'] ?? '',
      publishedDate: DateTime.parse(json['publishedDate']),
      page: json['page'] ?? 0,
      toc: json['toc'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        createdDate,
        updatedDate,
        id,
        aladingBookId,
        title,
        author,
        isbn,
        isbn13,
        bookCategory,
        categoryName,
        description,
        publisher,
        publishedDate,
        page,
        toc,
        imageUrl,
      ];
}

/// 리뷰의 댓글 DTO
class CommentDto extends Equatable {
  final DateTime createdDate;
  final DateTime updatedDate;
  final int id;
  final String parent;
  final List<String> children;
  final MemberDto member;
  final ReviewDto review;
  final String content;
  final List<CommentLikeDto> commentLikes;

  const CommentDto({
    required this.createdDate,
    required this.updatedDate,
    required this.id,
    required this.parent,
    required this.children,
    required this.member,
    required this.review,
    required this.content,
    required this.commentLikes,
  });

  factory CommentDto.fromJson(Map<String, dynamic> json) {
    return CommentDto(
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: DateTime.parse(json['updatedDate']),
      id: json['id'] ?? 0,
      parent: json['parent'] ?? '',
      children: List<String>.from(json['children'] ?? []),
      member: MemberDto.fromJson(json['member']),
      review: ReviewDto.fromJson(json['review']),
      content: json['content'] ?? '',
      commentLikes: (json['commentLikes'] as List?)
              ?.map((e) => CommentLikeDto.fromJson(e))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [
        createdDate,
        updatedDate,
        id,
        parent,
        children,
        member,
        review,
        content,
        commentLikes,
      ];
}

/// 리뷰의 댓글 좋아요 DTO
class CommentLikeDto extends Equatable {
  final DateTime createdDate;
  final DateTime updatedDate;
  final int id;
  final MemberDto member;
  final String reviewComment;

  const CommentLikeDto({
    required this.createdDate,
    required this.updatedDate,
    required this.id,
    required this.member,
    required this.reviewComment,
  });

  factory CommentLikeDto.fromJson(Map<String, dynamic> json) {
    return CommentLikeDto(
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: DateTime.parse(json['updatedDate']),
      id: json['id'] ?? 0,
      member: MemberDto.fromJson(json['member']),
      reviewComment: json['reviewComment'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        createdDate,
        updatedDate,
        id,
        member,
        reviewComment,
      ];
}

/// 리뷰의 좋아요 DTO
class ReviewLikeDto extends Equatable {
  final DateTime createdDate;
  final DateTime updatedDate;
  final int id;
  final MemberDto member;
  final String review;

  const ReviewLikeDto({
    required this.createdDate,
    required this.updatedDate,
    required this.id,
    required this.member,
    required this.review,
  });

  factory ReviewLikeDto.fromJson(Map<String, dynamic> json) {
    return ReviewLikeDto(
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: DateTime.parse(json['updatedDate']),
      id: json['id'] ?? 0,
      member: MemberDto.fromJson(json['member']),
      review: json['review'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        createdDate,
        updatedDate,
        id,
        member,
        review,
      ];
}

/// 리뷰 DTO
class ReviewDto extends Equatable {
  final int reviewId;
  final int memberId;
  final String memberNickName;
  final String memberProfileImage;
  final String content;
  final int rating;
  final int bookId;
  final String bookImage;
  final String bookTitle;
  final String reviewContect;
  final DateTime reviewUploadTime;
  final int reviewLikesCount;
  final int reviewCommentsCount;
  final List<CommentDto> comments;
  final String privacy;

  const ReviewDto({
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

  factory ReviewDto.fromJson(Map<String, dynamic> json) {
    return ReviewDto(
      reviewId: json['reviewId'] ?? 0,
      memberId: json['memberId'] ?? 0,
      memberNickName: json['memberNickName'] ?? '',
      memberProfileImage: json['memberProfileImage'] ?? '',
      content: json['content'] ?? '',
      rating: (json['rating'] ?? 0).toInt(),
      bookId: json['bookId'] ?? 0,
      bookImage: json['bookImage'] ?? '',
      bookTitle: json['bookTitle'] ?? '',
      reviewContect: json['reviewContect'] ?? '',
      reviewUploadTime: DateTime.parse(json['reviewUploadTime']),
      reviewLikesCount: json['reviewLikesCount'] ?? 0,
      reviewCommentsCount: json['reviewCommentsCount'] ?? 0,
      comments: (json['comments'] as List?)
              ?.map((e) => CommentDto.fromJson(e))
              .toList() ??
          [],
      privacy: json['privacy'] ?? 'PRIVATE',
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
