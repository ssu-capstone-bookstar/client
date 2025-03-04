import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:bookstar_app/components/FloatingActionMenu2.dart';

class BookInfo extends StatefulWidget {
  final int id;

  BookInfo({required this.id});

  @override
  _BookInfoState createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  String title = "책 제목";
  String author = "저자";
  String star = "별점 정보";
  String description = "도서 설명 정보";
  String publishedDate = "출판일 정보";
  String publisher = "출판사 정보";
  String categoryName = "분류 정보";
  String imageUrl = "";
  String starValue = "";

  @override
  void initState() {
    super.initState();
    fetchBookInfo();
  }

  Future<void> fetchBookInfo() async {
    print(widget.id);
    final int bookId = widget.id;
    final url = Uri.parse('http://15.164.30.67:8080/api/v1/books/$bookId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(utf8.decode(response.bodyBytes));

        setState(() {
          title = decodedData['data']['title'] ?? "책 제목";
          author = decodedData['data']['author'] ?? "저자";
          starValue = decodedData['data']['star']?.toString() ?? "별점 정보";
          star = _convertStarToIcons(starValue);
          description = decodedData['data']['description'] ?? "도서 설명 정보";
          publishedDate = decodedData['data']['publishedDate'] ?? "출판일 정보";
          publisher = decodedData['data']['publisher'] ?? "출판사 정보";
          categoryName = decodedData['data']['categoryName'] ?? "분류 정보";
          imageUrl = decodedData['data']['imageUrl'] ?? "";
        });
      } else {
        print('Failed to fetch book info: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching book info: $e');
    }
  }

  String _convertStarToIcons(String starValue) {
    switch (starValue) {
      case "1.0":
        return "⭐ ($starValue)";
      case "2.0":
        return "⭐⭐ ($starValue)";
      case "3.0":
        return "⭐⭐⭐ ($starValue)";
      case "4.0":
        return "⭐⭐⭐⭐ ($starValue)";
      case "5.0":
        return "⭐⭐⭐⭐⭐ ($starValue)";
      default:
        return "별점 정보 없음";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/images/aladin.png',
              height: 40,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // 배경색
                      borderRadius: BorderRadius.circular(16), // 모든 모서리를 둥글게
                      image: imageUrl.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0), // 좌우 마진 16
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8), // 텍스트 간의 간격
                        Text(
                          author,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // 배경색 추가
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), // 왼쪽 위 모서리를 둥글게
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  _buildSection('별점', star),
                  _buildSection('도서 설명', description),
                  _buildSection('출판일', publishedDate),
                  _buildSection('출판사', publisher),
                  _buildSection('분류', categoryName),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionMenu2(bookId: widget.id, url: imageUrl),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black, width: 0.5),
              ),
            ),
            child: Text(
              content,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
