import 'package:flutter/material.dart';

class MyRecommendations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('컬렉션'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '아직 컬렉션이 없습니다!',
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Add your button action here
                print('Add button pressed');
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
