part of 'review_cubit.dart';

/// 리뷰 상태
class ReviewState extends Equatable {
  final ReviewDto? review;
  final bool isLoading;
  final String? error;

  const ReviewState({
    this.review,
    this.isLoading = false,
    this.error,
  });

  ReviewState copyWith({
    ReviewDto? review,
    bool? isLoading,
    String? error,
  }) {
    return ReviewState(
      review: review ?? this.review,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [review, isLoading, error];
}
