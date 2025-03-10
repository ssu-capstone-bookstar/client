import 'package:bookstar_app/components/BookCard5.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:bookstar_app/providers/UserProvider.dart';

import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class MyLibrary extends StatefulWidget {
  @override
  _MyLibraryState createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  Future<List<Map<String, dynamic>>> fetchBooks() async {
    final accessToken =
        Provider.of<UserProvider>(context, listen: false).accessToken;
    final int? userId =
        Provider.of<UserProvider>(context, listen: false).userId;

    print(userId);
    final urls = [
      'http://15.164.30.67:8080/api/v1/memberbooks/$userId/reading-status?readingStatus=READING&sortType=MEMEBER_BOOK_RECENT',
      'http://15.164.30.67:8080/api/v1/memberbooks/$userId/reading-status?readingStatus=WANT_TO_READ&sortType=MEMEBER_BOOK_RECENT',
      'http://15.164.30.67:8080/api/v1/memberbooks/$userId/reading-status?readingStatus=READED&sortType=MEMEBER_BOOK_RECENT',
    ];

    List<Map<String, dynamic>> books = [];

    for (String url in urls) {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null) {
          books.addAll(List<Map<String, dynamic>>.from(data['data']['data']));
        }
      } else {
        throw Exception('Failed to fetch books');
      }
    }

    return books;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '서재',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('책 정보를 불러오지 못했습니다.'));
          } else {
            final books = snapshot.data!;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ListView.builder(
                itemCount: (books.length / 4).ceil() + 1, // 맨 위 구분선 추가
                itemBuilder: (context, rowIndex) {
                  if (rowIndex == 0) {
                    // 첫 번째 아이템: 상단 구분선 추가
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Container(
                        height: 2.0,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 131, 131, 131),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    );
                  }

                  final startIndex = (rowIndex - 1) * 4;
                  final endIndex = (startIndex + 4).clamp(0, books.length);
                  final bookRow = books.sublist(startIndex, endIndex);

                  return Column(
                    children: [
                      SizedBox(height: 6.0), // 구분선과 카드 사이 여백
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: bookRow.map((book) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0), // 아이템 간격
                              child: BookCard5(
                                bookId: book['bookId'].toString(),
                                imageUrl: book['bookCoverImage'],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 5.0), // 구분선 위 여백
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Container(
                          height: 2.0,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 131, 131, 131),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
