part of 'index_cubit.dart';

class IndexState extends Equatable {
  final int index;
  const IndexState({
    required this.index,
  });

  factory IndexState.initial() => const IndexState(index: 1);

  IndexState copyWith({
    int? index,
  }) {
    return IndexState(
      index: index ?? this.index,
    );
  }

  @override
  List<Object> get props => [index];
}
