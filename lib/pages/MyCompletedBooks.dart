import 'package:flutter/material.dart';

class MyCompletedBooks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Completed Books'),
      ),
      body: Center(
        child: Text('Books you have completed'),
      ),
    );
  }
}
