part of 'single_book_cubit.dart';

class SingleBookState extends Equatable {
  final SingleBookDto? singleBookDto;

  const SingleBookState({
    this.singleBookDto,
  });

  SingleBookState copyWith({
    SingleBookDto? singleBookDto,
  }) {
    return SingleBookState(
      singleBookDto: singleBookDto ?? this.singleBookDto,
    );
  }

  @override
  List<Object?> get props => [];
}
