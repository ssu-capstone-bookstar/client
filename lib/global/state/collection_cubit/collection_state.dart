part of 'collection_cubit.dart';

class CollectionState extends Equatable {
  final List<CollectionListDto>? collectionList;

  const CollectionState({
    this.collectionList,
  });

  CollectionState copyWith({
    List<CollectionListDto>? collectionList,
  }) {
    return CollectionState(
      collectionList: collectionList ?? this.collectionList,
    );
  }

  @override
  List<Object?> get props => [collectionList];
}
