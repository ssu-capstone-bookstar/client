import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String imageUrl;

  BookCard({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.0,
      margin: EdgeInsets.only(right: 8.0),
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
        ],
      ),
    );
  }
}
