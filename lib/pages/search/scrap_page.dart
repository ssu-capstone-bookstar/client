import 'package:bookstar_app/components/CameraComponent.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScrapPage extends StatefulWidget {
  final int bookId;
  const ScrapPage({
    super.key,
    required this.bookId,
  });
  @override
  State<ScrapPage> createState() => _ScrapPageState();
}

class _ScrapPageState extends State<ScrapPage> {
  @override
  void initState() {
    super.initState();
    _saveBookId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCameraComponent();
    });
  }

  Future<void> _saveBookId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bookId', widget.bookId); // bookId 저장
    print("bookId pref: ${prefs.getInt('bookId')}");
  }

  void _showCameraComponent() {
    // Navigator.push 대신 pushReplacement를 사용합니다
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const CameraComponent(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 이 부분은 그대로 유지하되, 실제로는 화면에 표시되지 않습니다
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrap'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text('cam write scrap'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showCameraComponent,
            child: const Text('Select Image'),
          ),
        ],
      ),
    );
  }
}
