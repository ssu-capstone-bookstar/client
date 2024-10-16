import 'package:flutter/material.dart';

class MyComments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Comments'),
      ),
      body: Center(
        child: Text('Your comments on books'),
      ),
    );
  }
}
