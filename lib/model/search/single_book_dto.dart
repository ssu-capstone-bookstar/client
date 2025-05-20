import 'package:equatable/equatable.dart';

class SingleBookDto extends Equatable {
  final int id;
  final int aladingBookId;
  final String title;
  final String author;
  final String isbn;
  final String isbn13;
  final String categoryName;
  final String description;
  final String publisher;
  final String publishedDate;
  final int page;
  final int toc;
  final String imageUrl;
  final double star;

  const SingleBookDto({
    required this.id,
    required this.aladingBookId,
    required this.title,
    required this.author,
    required this.isbn,
    required this.isbn13,
    required this.categoryName,
    required this.description,
    required this.publisher,
    required this.publishedDate,
    required this.page,
    required this.toc,
    required this.imageUrl,
    required this.star,
  });

  factory SingleBookDto.fromJson(Map<String, dynamic> json) {
    return SingleBookDto(
      id: json['id'] ?? 0,
      aladingBookId: json['aladingBookId'] ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      isbn: json['isbn'] ?? '',
      isbn13: json['isbn13'] ?? '',
      categoryName: json['categoryName'] ?? '',
      description: json['description'] ?? '',
      publisher: json['publisher'] ?? '',
      publishedDate: json['publishedDate'] ?? '',
      page: json['page'] ?? 0,
      toc: json['toc'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      star: json['star'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isbn13': isbn13,
    };
  }

  SingleBookDto copyWith({
    int? id,
    int? aladingBookId,
    String? title,
    String? author,
    String? isbn,
    String? isbn13,
    String? categoryName,
    String? description,
    String? publisher,
    String? publishedDate,
    int? page,
    int? toc,
    String? imageUrl,
    double? star,
  }) {
    return SingleBookDto(
      id: id ?? this.id,
      aladingBookId: aladingBookId ?? this.aladingBookId,
      title: title ?? this.title,
      author: author ?? this.author,
      isbn: isbn ?? this.isbn,
      isbn13: isbn13 ?? this.isbn13,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
      publisher: publisher ?? this.publisher,
      publishedDate: publishedDate ?? this.publishedDate,
      page: page ?? this.page,
      toc: toc ?? this.toc,
      imageUrl: imageUrl ?? this.imageUrl,
      star: star ?? this.star,
    );
  }

  @override
  List<Object?> get props => [
        id,
        aladingBookId,
        title,
        author,
        isbn,
        isbn13,
        categoryName,
        description,
        publisher,
        publishedDate,
        page,
        toc,
        imageUrl,
        star,
      ];
}
