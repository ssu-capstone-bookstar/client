part of 'search_cubit.dart';

class SearchState extends Equatable {
  final int? cursor;
  final List<BestsellerAladinDto>? books;
  final bool? isLoadingMore;

  const SearchState({
    this.cursor,
    this.books,
    this.isLoadingMore,
  });

  SearchState copyWith({
    int? cursor,
    List<BestsellerAladinDto>? books,
    bool? isLoadingMore,
  }) {
    return SearchState(
      cursor: cursor ?? this.cursor,
      books: books ?? this.books,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  factory SearchState.initial() => SearchState(
        cursor: 1,
        books: null,
        isLoadingMore: false,
      );

  @override
  List<Object?> get props => [
        cursor,
        books,
        isLoadingMore,
      ];
}
