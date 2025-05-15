import 'package:equatable/equatable.dart';

class AiRecommedBookDto extends Equatable {
  final int bookId;
  final String title;
  final String author;
  final String bookCategory;
  final String imageUrl;

  const AiRecommedBookDto({
    required this.bookId,
    required this.title,
    required this.author,
    required this.bookCategory,
    required this.imageUrl,
  });

  factory AiRecommedBookDto.fromJson(Map<String, dynamic> json) {
    return AiRecommedBookDto(
      bookId: json['book_id'] ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      bookCategory: json['book_category'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        bookId,
        title,
        author,
        bookCategory,
        imageUrl,
      ];
}
