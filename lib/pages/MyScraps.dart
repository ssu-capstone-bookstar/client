import 'package:flutter/material.dart';

class MyScraps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Scraps'),
      ),
      body: Center(
        child: Text('Your saved scraps'),
      ),
    );
  }
}
