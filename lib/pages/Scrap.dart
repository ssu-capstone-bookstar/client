import 'package:flutter/material.dart';

class Scrap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scrap'),
      ),
      body: Center(
        child: Text('Your saved scraps'),
      ),
    );
  }
}
