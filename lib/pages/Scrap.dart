import 'package:bookstar_app/components/CameraComponent.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Scrap extends StatefulWidget {
  final int bookId;
  Scrap({required this.bookId});
  @override
  _ScrapState createState() => _ScrapState();
}

class _ScrapState extends State<Scrap> {
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
        builder: (context) => CameraComponent(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 이 부분은 그대로 유지하되, 실제로는 화면에 표시되지 않습니다
    return Scaffold(
      appBar: AppBar(
        title: Text('Scrap'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('cam write scrap'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showCameraComponent,
            child: Text('Select Image'),
          ),
        ],
      ),
    );
  }
}
