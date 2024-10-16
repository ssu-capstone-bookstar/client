import 'package:bookstar_app/components/FloatingActionMenu1.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Welcome Home Page!'),
      ),
      floatingActionButton: FloatingActionMenu1(), // FloatingActionMenu1 추가
    );
  }
}
