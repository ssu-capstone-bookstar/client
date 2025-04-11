import 'package:bookstar_app/pages/MyFeed.dart';
import 'package:flutter/material.dart';

class BookCard5 extends StatelessWidget {
  final String imageUrl;
  final String bookId;
  final double bookWidth;
  final double bookHeight;

  const BookCard5({
    super.key,
    required this.imageUrl,
    required this.bookId,
    this.bookWidth = 81, // 기본값 설정
    this.bookHeight = 108, // 기본값 설정
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MyFeed(
              id: int.parse(bookId),
              url:
                  "https://image.aladin.co.kr/product/29137/2/coversum/8936434594_2.jpg",
            ),
          ),
        );
      },
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imageUrl,
                width: bookWidth, // 입력값 없으면 기본값 81
                height: bookHeight, // 입력값 없으면 기본값 108
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
