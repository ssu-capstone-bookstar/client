import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show Offset;

/// 스크랩 텍스트 DTO
class ScrapTextDto extends Equatable {
  final List<File> images;
  final List<List<Offset?>> highlights;
  final String text;
  final int bookId;
  final String privacy;

  const ScrapTextDto({
    required this.images,
    required this.highlights,
    required this.text,
    required this.bookId,
    this.privacy = 'PRIVATE',
  });

  Map<String, dynamic> toJson() {
    return {
      'filename': images.isNotEmpty ? images[0].path.split('/').last : "no_jpg",
      'title': "",
      'text': text,
      'bookId': bookId,
      'privacy': privacy,
    };
  }

  @override
  List<Object?> get props => [images, highlights, text, bookId, privacy];
}
