import 'package:bookstar_app/pages/search/screen/aladin_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecentBookCard extends StatelessWidget {
  final String imageUrl;
  final int id;
  final double bookWidth;
  final double bookHeight;

  const RecentBookCard({
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
        context.pushNamed(
          AladinBookScreen.routeName,
          extra: {
            'id': id,
          },
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
