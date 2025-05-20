import 'package:equatable/equatable.dart';

class CollectionListDto extends Equatable {
  final int collectionId;
  final String name;
  final String description;
  final List<dynamic> images;

  const CollectionListDto({
    required this.collectionId,
    required this.name,
    required this.description,
    required this.images,
  });

  factory CollectionListDto.fromJson(Map<String, dynamic> json) {
    return CollectionListDto(
      collectionId: json['collectionId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: json['images'] ?? [],
    );
  }

  @override
  List<Object?> get props => [
        collectionId,
        name,
        description,
        images,
      ];
}
