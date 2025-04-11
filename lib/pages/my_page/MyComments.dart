import 'package:flutter/material.dart';

class MyComments extends StatelessWidget {
  const MyComments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Comments'),
      ),
      body: const Center(
        child: Text('Your comments on books'),
      ),
    );
  }
}
