part of 'scrap_cubit.dart';

/// 스크랩 상태
class ScrapState extends Equatable {
  final ScrapDto? scrap;
  final bool isLoading;
  final String? error;

  const ScrapState({
    this.scrap,
    this.isLoading = false,
    this.error,
  });

  ScrapState copyWith({
    ScrapDto? scrap,
    bool? isLoading,
    String? error,
  }) {
    return ScrapState(
      scrap: scrap ?? this.scrap,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [scrap, isLoading, error];
}
