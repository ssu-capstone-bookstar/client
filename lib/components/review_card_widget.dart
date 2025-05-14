import 'package:flutter/material.dart';
import 'package:bookstar_app/pages/review/state/review_dto.dart';

/// 리뷰 카드 위젯
class ReviewCardWidget extends StatelessWidget {
  final ReviewDto review;
  final VoidCallback? onLikePressed;
  final VoidCallback? onMorePressed;
  final double iconSize;

  const ReviewCardWidget({
    super.key,
    required this.review,
    this.onLikePressed,
    this.onMorePressed,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBookImage(),
          const SizedBox(width: 10),
          Expanded(
            child: _buildReviewContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildBookImage() {
    return Container(
      height: 110,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
        image: review.bookImage.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(review.bookImage),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: review.bookImage.isEmpty
          ? const Center(
              child: Text(
                '이미지 없음',
                style: TextStyle(fontSize: 12, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            )
          : null,
    );
  }

  Widget _buildReviewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleAndRating(),
        const SizedBox(height: 10),
        _buildReviewText(),
        const SizedBox(height: 15),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildTitleAndRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            review.bookTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: List.generate(
            review.rating,
            (index) => Image.asset(
              'assets/images/star.png',
              height: iconSize,
              width: iconSize,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewText() {
    return Text(
      review.content,
      style: const TextStyle(fontSize: 14, color: Colors.black),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onLikePressed,
          child: Row(
            children: [
              Image.asset(
                'assets/images/good.png',
                height: iconSize,
                width: iconSize,
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
        GestureDetector(
          onTap: onMorePressed,
          child: Row(
            children: [
              Image.asset(
                'assets/images/chat.png',
                height: iconSize,
                width: iconSize,
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
      ],
    );
  }
}
