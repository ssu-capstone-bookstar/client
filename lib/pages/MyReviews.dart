import 'package:flutter/material.dart';

class MyReviews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Reviews'),
      ),
      body: Center(
        child: Text('Your book reviews'),
      ),
    );
  }
}
