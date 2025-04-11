import 'package:flutter/material.dart';

class MyCompletedBooks extends StatelessWidget {
  const MyCompletedBooks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Completed Books'),
      ),
      body: const Center(
        child: Text('Books you have completed'),
      ),
    );
  }
}
