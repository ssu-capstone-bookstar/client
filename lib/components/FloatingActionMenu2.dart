import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:bookstar_app/pages/WriteReview.dart';
import 'package:bookstar_app/pages/Scrap.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FloatingActionMenu2 extends StatefulWidget {
  final String bookId;
  final String url;

  FloatingActionMenu2({required this.bookId, required this.url});

  @override
  _FloatingActionMenu2State createState() => _FloatingActionMenu2State();
}

class _FloatingActionMenu2State extends State<FloatingActionMenu2> {
  bool showLabels = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 30), () {
      setState(() {
        showLabels = false;
      });
    });
  }

  Future<void> addToLibrary(String bookId) async {
    final url = Uri.parse(
        'http://localhost:8080/api/v1/memberbooks/$bookId/reading-status');
    final body = jsonEncode({
      "readingStatus": "READING",
      "star": 5,
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null || accessToken.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('액세스 토큰이 없습니다. 로그인해주세요.')),
        );
        return;
      }

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: body,
      );
      print(accessToken);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('서재에 성공적으로 추가되었습니다.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          // SnackBar(content: Text(bookId)),
          SnackBar(content: Text('서재에 추가 실패: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서재 추가 중 오류 발생: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.menu,
      activeIcon: Icons.close,
      backgroundColor: Colors.grey.shade800,
      iconTheme: IconThemeData(size: 32),
      foregroundColor: Colors.white,
      overlayOpacity: 0.0,
      spacing: 10,
      spaceBetweenChildren: 8,
      children: [
        SpeedDialChild(
          child: Icon(Icons.rate_review, size: 30, color: Colors.white),
          label: showLabels ? '리뷰 쓰기' : null,
          backgroundColor: Colors.grey.shade700,
          labelStyle: TextStyle(fontSize: 14.0, color: Colors.white),
          labelBackgroundColor: Colors.transparent,
          shape: CircleBorder(),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WriteReview(
                        bookId: widget.bookId,
                        url: widget.url,
                      )),
            );
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.bookmark, size: 30, color: Colors.white),
          label: showLabels ? '스크랩' : null,
          backgroundColor: Colors.grey.shade700,
          labelStyle: TextStyle(fontSize: 14.0, color: Colors.white),
          labelBackgroundColor: Colors.transparent,
          shape: CircleBorder(),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Scrap(
                        bookId: widget.bookId,
                      )),
            );
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.library_add, size: 30, color: Colors.white),
          label: showLabels ? '내 서재에 추가하기' : null,
          backgroundColor: Colors.grey.shade700,
          labelStyle: TextStyle(fontSize: 14.0, color: Colors.white),
          labelBackgroundColor: Colors.transparent,
          shape: CircleBorder(),
          onTap: () {
            addToLibrary(widget.bookId);
          },
        ),
      ],
    );
  }
}
