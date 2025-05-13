import 'package:equatable/equatable.dart';

class BestsellerAladinDto extends Equatable {
  final int bookId;
  final String title;
  final String author;
  final String bookCover;
  final String pubDate;

  const BestsellerAladinDto({
    required this.bookId,
    required this.title,
    required this.author,
    required this.bookCover,
    required this.pubDate,
  });

  factory BestsellerAladinDto.fromJson(Map<String, dynamic> json) {
    return BestsellerAladinDto(
      bookId: json['bookId'] ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      bookCover: json['bookCover'] ?? '',
      pubDate: json['pubDate'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        bookId,
        title,
        author,
        bookCover,
        pubDate,
      ];
}
