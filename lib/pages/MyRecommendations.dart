import 'package:flutter/material.dart';

class MyRecommendations extends StatelessWidget {
  final String recommendingId;

  // 생성자에 required 키워드를 사용하여 recommendingId를 필수 매개변수로 받음
  MyRecommendations({required this.recommendingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommendations'),
      ),
      body: Center(
        child: Text('Recommendations for: $recommendingId'),
      ),
    );
  }
}
