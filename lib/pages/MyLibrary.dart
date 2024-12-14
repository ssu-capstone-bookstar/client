import 'package:bookstar_app/components/BookCard5.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

class MyLibrary extends StatefulWidget {
  @override
  _MyLibraryState createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  Future<List<Map<String, dynamic>>> fetchBooks() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final accessToken = prefs.getString('accessToken');
    // final headers = {'Authorization': 'Bearer $accessToken'};

    final urls = [
      'http://localhost:8080/api/v1/memberbooks/1/reading-status?readingStatus=READING&sortType=MEMEBER_BOOK_RECENT',
      'http://localhost:8080/api/v1/memberbooks/1/reading-status?readingStatus=WANT_TO_READ&sortType=MEMEBER_BOOK_RECENT',
      'http://localhost:8080/api/v1/memberbooks/1/reading-status?readingStatus=READED&sortType=MEMEBER_BOOK_RECENT',
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
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                itemCount: (books.length / 4).ceil(),
                itemBuilder: (context, rowIndex) {
                  final startIndex = rowIndex * 4;
                  final endIndex = (startIndex + 4).clamp(0, books.length);
                  final bookRow = books.sublist(startIndex, endIndex);

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: bookRow.map((book) {
                          return BookCard5(
                            // title: book['title'],
                            bookId: book['bookId'].toString(),
                            imageUrl: book['bookCoverImage'],
                            // averageStar: book['averageStar'],
                            // myStar: book['myStar'],
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 3.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Container(
                          height: 5.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
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
