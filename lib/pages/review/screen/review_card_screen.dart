import 'package:bookstar_app/components/review_card_widget.dart';
import 'package:bookstar_app/pages/review/state/review_cubit/review_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 리뷰 카드 화면
class ReviewCardScreen extends StatelessWidget {
  final int reviewId;
  final int memberId;
  final VoidCallback? onLikePressed;
  final VoidCallback? onMorePressed;
  final double iconSize;

  const ReviewCardScreen({
    super.key,
    required this.reviewId,
    required this.memberId,
    this.onLikePressed,
    this.onMorePressed,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: BlocProvider를 왜 ui안에?
    return BlocProvider(
      create: (context) => ReviewCubit()
        ..fetchReviewDetail(
          memberId: memberId,
          reviewId: reviewId,
        ),
      child: BlocBuilder<ReviewCubit, ReviewState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }

          if (state.review == null) {
            return const Center(child: Text('No data available'));
          }

          return ReviewCardWidget(
            review: state.review!,
            onLikePressed: onLikePressed,
            onMorePressed: onMorePressed,
            iconSize: iconSize,
          );
        },
      ),
    );
  }
}
