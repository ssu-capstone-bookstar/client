part of 'pheed_cubit.dart';

class PheedState extends Equatable {
  final List<PheedItemDto>? pheedItems;
  final List<PheedItemDto>? pheedNewItems;
  final List<PheedItemDto>? pheedMyItems;
  final List<AiRecommedBookDto>? aiRecommedBooks;

  const PheedState({
    this.pheedItems,
    this.pheedNewItems,
    this.pheedMyItems,
    this.aiRecommedBooks,
  });

  PheedState copyWith({
    List<PheedItemDto>? pheedItems,
    List<PheedItemDto>? pheedNewItems,
    List<PheedItemDto>? pheedMyItems,
    List<AiRecommedBookDto>? aiRecommedBooks,
  }) {
    return PheedState(
      pheedItems: pheedItems ?? this.pheedItems,
      pheedNewItems: pheedNewItems ?? this.pheedNewItems,
      pheedMyItems: pheedMyItems ?? this.pheedMyItems,
      aiRecommedBooks: aiRecommedBooks ?? this.aiRecommedBooks,
    );
  }

  @override
  List<Object?> get props => [
        pheedNewItems,
        pheedItems,
        pheedMyItems,
        aiRecommedBooks,
      ];
}
