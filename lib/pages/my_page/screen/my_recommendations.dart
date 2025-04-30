import 'package:flutter/material.dart';

class MyRecommendations extends StatelessWidget {
  static const String routeName = 'myrecommendations';
  static const String routePath = '/myrecommendations';

  const MyRecommendations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('컬렉션'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '아직 컬렉션이 없습니다!',
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Add your button action here
                print('Add button pressed');
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
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
