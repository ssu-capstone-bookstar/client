import 'package:bookstar_app/components/BookCard1.dart';
import 'package:bookstar_app/components/FloatingActionMenu1.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: ListView(
        children: [
          BookCard1(
            imageUrl: 'https://via.placeholder.com/80x120',
            title: 'Book Title 1',
            feedType: 'Feed Type 1',
          ),
          BookCard1(
            imageUrl: 'https://via.placeholder.com/80x120',
            title: 'Book Title 2',
            feedType: 'Feed Type 2',
          ),
          BookCard1(
            imageUrl: 'https://via.placeholder.com/80x120',
            title: 'Book Title 3',
            feedType: 'Feed Type 3',
          ),
        ],
      ),
      floatingActionButton: FloatingActionMenu1(), // Floating action button 추가
    );
  }
}
