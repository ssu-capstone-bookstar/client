import 'package:bookstar_app/pages/MyFeed.dart';
import 'package:flutter/material.dart';

class BookCard5 extends StatelessWidget {
  final String imageUrl;
  final String bookId;

  BookCard5({
    required this.imageUrl,
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MyFeed(
              id: 932,
              url:
                  "https://image.aladin.co.kr/product/29137/2/coversum/8936434594_2.jpg",
            ),
          ),
        );
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imageUrl ?? 'https://via.placeholder.com/150x200?text=%20',
                width: 81,
                height: 108,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
