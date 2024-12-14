import 'package:flutter/material.dart';

class BookCard4 extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String feed;

  BookCard4({
    required this.imageUrl,
    required this.title,
    required this.feed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? '제목',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    feed ?? '피드 유형',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imageUrl ?? 'https://via.placeholder.com/150x200?text=%20',
                width: 100,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
