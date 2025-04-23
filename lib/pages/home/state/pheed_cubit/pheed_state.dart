part of 'pheed_cubit.dart';

class PheedState extends Equatable {
  final List<PostItemResponse>? pheedItems;
  final List<PostItemResponse>? pheedNewItems;
  final List<PostItemResponse>? pheedMyItems;

  const PheedState({
    this.pheedItems,
    this.pheedNewItems,
    this.pheedMyItems,
  });

  PheedState copyWith({
    List<PostItemResponse>? pheedItems,
    List<PostItemResponse>? pheedNewItems,
    List<PostItemResponse>? pheedMyItems,
  }) {
    return PheedState(
      pheedItems: pheedItems ?? this.pheedItems,
      pheedNewItems: pheedNewItems ?? this.pheedNewItems,
      pheedMyItems: pheedMyItems ?? this.pheedMyItems,
    );
  }

  @override
  List<Object?> get props => [
        pheedNewItems,
        pheedItems,
        pheedMyItems,
      ];
}
