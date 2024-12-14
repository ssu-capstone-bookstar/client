import 'package:bookstar_app/components/BookCard4.dart';
import 'package:flutter/material.dart';

class NewsFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0), // 좌우 마진 추가
          child: Column(
            children: List.generate(10, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: BookCard4(
                  imageUrl: 'https://via.placeholder.com/150x200',
                  title: '제목 $index',
                  feed: '피드 유형은1',
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
