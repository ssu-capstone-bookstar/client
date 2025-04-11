import 'package:bookstar_app/pages/search/BookInfo.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String imageUrl;
  final int id;
  final double bookWidth;
  final double bookHeight;

  const BookCard({
    super.key,
    required this.imageUrl,
    required this.id,
    this.bookWidth = 120,
    this.bookHeight = 160,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookInfo(id: id),
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
                imageUrl.isNotEmpty
                    ? imageUrl
                    : 'https://via.placeholder.com/150x200?text=%20',
                width: bookWidth,
                height: bookHeight,
                fit: BoxFit.cover,
              ),
            ),
            // SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
