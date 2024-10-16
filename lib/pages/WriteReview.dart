import 'package:flutter/material.dart';

class WriteReview extends StatelessWidget {
  final String bookName;

  WriteReview({required this.bookName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write a Review'),
      ),
      body: Center(
        child: Text('Write a review for: $bookName'),
      ),
    );
  }
}
