import 'package:flutter/material.dart';

class MyLibrary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Library'),
      ),
      body: Center(
        child: Text('Your personal book collection'),
      ),
    );
  }
}
