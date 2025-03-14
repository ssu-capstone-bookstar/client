import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:bookstar_app/providers/UserProvider.dart';

class ScrapTextComponent extends StatefulWidget {
  final List<File> images;
  final List<List<Offset?>> highlights;

  ScrapTextComponent({required this.images, required this.highlights});

  @override
  _ScrapTextComponentState createState() => _ScrapTextComponentState();
}

class _ScrapTextComponentState extends State<ScrapTextComponent> {
  final TextEditingController _textController = TextEditingController();

  Future<void> _postScrap() async {
    try {
      // SharedPreferences에서 accessToken과 bookId 가져오기
      final prefs = await SharedPreferences.getInstance();
      final accessToken =
          Provider.of<UserProvider>(context, listen: false).accessToken;
      final bookId = prefs.getInt('bookId');

      if (accessToken == null || bookId == null) {
        print('accessToken 또는 bookId가 없습니다.');
        return;
      }

      // API 요청 준비
      final uri = Uri.parse('http://15.164.30.67:8080/api/v1/scrap');
      final filename = widget.images.isNotEmpty
          ? widget.images[0].path.split('/').last
          : "no_jpg";

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "filename": filename,
          "title": "",
          "text": _textController.text,
          "bookId": bookId,
          "privacy": "PRIVATE"
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("scrap post 호출 성공");
        print("text: ${_textController.text}");
        print("image: $filename");
        // HomePage로 이동
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        print('API 호출 실패: ${response.statusCode}');
        final decodedData = jsonDecode(utf8.decode(response.bodyBytes));
        print('API 호출 실패: ${decodedData}');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('닫기'),
        backgroundColor: Colors.white,
        actions: [
          ElevatedButton(
            onPressed: _postScrap,
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 34, 78, 255),
              backgroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: Text('완료'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey,
              child: PageView.builder(
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  return Image.file(
                    widget.images[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: '자유 메모',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
