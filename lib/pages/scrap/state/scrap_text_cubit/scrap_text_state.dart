part of 'scrap_text_cubit.dart';

/// 스크랩 텍스트 상태
class ScrapTextState extends Equatable {
  final bool isLoading;
  final String? error;
  final String? scrapImageUrl;

  const ScrapTextState({
    this.isLoading = false,
    this.error,
    this.scrapImageUrl,
  });

  ScrapTextState copyWith({
    bool? isLoading,
    String? error,
    String? scrapImageUrl,
  }) {
    return ScrapTextState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      scrapImageUrl: scrapImageUrl ?? this.scrapImageUrl,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, scrapImageUrl];
}
