import 'package:bookstar_app/components/FloatingActionMenu4.dart';
import 'package:flutter/material.dart';

class MyBookFeed extends StatelessWidget {
  final int id;
  MyBookFeed({required this.id});

  @override
  Widget build(BuildContext context) {
    final int bookId = id;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Book Feed'),
      ),
      body: Center(
        child: Text('Your personalized book feed'),
      ),
      floatingActionButton:
          FloatingActionMenu4(bookId: id), // FloatingActionMenu4 추가
    );
  }
}
