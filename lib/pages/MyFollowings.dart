import 'package:flutter/material.dart';

class MyFollowings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Followings'),
      ),
      body: Center(
        child: Text('People you are following'),
      ),
    );
  }
}
