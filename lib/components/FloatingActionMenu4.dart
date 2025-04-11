import 'dart:async';
import 'dart:convert';

import 'package:bookstar_app/pages/Scrap.dart';
import 'package:bookstar_app/pages/WriteReview.dart';
import 'package:bookstar_app/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class FloatingActionMenu4 extends StatefulWidget {
  final int bookId;
  final String url;

  const FloatingActionMenu4(
      {super.key, required this.bookId, required this.url});

  @override
  State<FloatingActionMenu4> createState() => _FloatingActionMenu4State();
}

class _FloatingActionMenu4State extends State<FloatingActionMenu4> {
  bool showLabels = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 30), () {
      if (mounted) {
        // 위젯이 여전히 트리에 있을 때만 setState 호출
        setState(() {
          showLabels = false;
        });
      }
    });
  }

  Future<void> changeBookState(int bookId) async {
    final url = Uri.parse(
        'http://15.164.30.67:8080/api/v1/memberbooks/$bookId/reading-status');
    final body = jsonEncode({
      "readingStatus": "WANT_TO_READ",
      "star": 5,
    });

    try {
      final accessToken =
          Provider.of<UserProvider>(context, listen: false).accessToken;

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: body,
      );
      print("서재에 추가 호출 성공");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('서재에 성공적으로 추가되었습니다.')),
        );
      } else {
        if (!mounted) return;
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
      iconTheme: const IconThemeData(size: 32),
      foregroundColor: Colors.white,
      overlayOpacity: 0.0,
      spacing: 10,
      spaceBetweenChildren: 8,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.bookmark, size: 30, color: Colors.white),
          label: '완독',
          backgroundColor: Colors.grey.shade700,
          labelStyle: const TextStyle(fontSize: 14.0, color: Colors.white),
          labelBackgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('완독 표시되었습니다!')),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.rate_review, size: 30, color: Colors.white),
          label: '리뷰 쓰기',
          backgroundColor: Colors.grey.shade700,
          labelStyle: const TextStyle(fontSize: 14.0, color: Colors.white),
          labelBackgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WriteReview(
                        bookId: widget.bookId,
                        url: widget.url,
                      )),
            );
            print("bookId: ${widget.bookId}");
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.bookmark, size: 30, color: Colors.white),
          label: '스크랩 쓰기',
          backgroundColor: Colors.grey.shade700,
          labelStyle: const TextStyle(fontSize: 14.0, color: Colors.white),
          labelBackgroundColor: Colors.transparent,
          shape: const CircleBorder(),
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
          child: const Icon(Icons.bookmark, size: 30, color: Colors.white),
          label: '읽음 표시',
          backgroundColor: Colors.grey.shade700,
          labelStyle: const TextStyle(fontSize: 14.0, color: Colors.white),
          labelBackgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('표시되었습니다!')),
            );
          },
        ),
      ],
    );
  }
}
