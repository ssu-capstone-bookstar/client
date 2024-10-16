import 'package:bookstar_app/components/FloatingActionMenu4.dart';
import 'package:flutter/material.dart';

class MyBookFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Book Feed'),
      ),
      body: Center(
        child: Text('Your personalized book feed'),
      ),
      floatingActionButton: FloatingActionMenu4(), // FloatingActionMenu4 추가
    );
  }
}
