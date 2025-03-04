import 'package:bookstar_app/pages/BookInfo.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String imageUrl;
  final int id;

  BookCard({
    required this.imageUrl,
    required this.id,
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
      child: Container(
        width: 120.0,
        margin: EdgeInsets.only(right: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imageUrl.isNotEmpty
                    ? imageUrl
                    : 'https://via.placeholder.com/150x200?text=%20',
                width: 120,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
