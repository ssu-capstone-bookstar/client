import 'package:flutter/material.dart';

class BookCard1 extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String feedType;
  final int reviewId;

  BookCard1({
    required this.imageUrl,
    required this.title,
    required this.feedType,
    required this.reviewId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.0,
      margin: EdgeInsets.only(right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              imageUrl ?? 'https://via.placeholder.com/150x200?text=%20',
              width: 120,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              title ?? '제목',
              style: TextStyle(
                fontSize: 14.0,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              feedType ?? '피드유형',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
