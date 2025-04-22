part of 'pheed_cubit.dart';

class PheedState extends Equatable {
  final List<PostItemResponse>? newItems;

  const PheedState({
    this.newItems,
  });

  PheedState copyWith({
    List<PostItemResponse>? newItems,
  }) {
    return PheedState(
      newItems: newItems ?? this.newItems,
    );
  }

  @override
  List<Object?> get props => [newItems];
}
