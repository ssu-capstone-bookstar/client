import 'dart:convert';
import 'package:bookstar_app/components/FloatingActionMenu2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bookstar_app/components/ReviewCard.dart';
import 'package:bookstar_app/components/ScrapCard.dart';

class MyFeed extends StatelessWidget {
  final int id;
  final String url;
  MyFeed({required this.id, required this.url});

  Future<Map<String, dynamic>> fetchBookData() async {
    print(id);
    final url = Uri.parse('http://15.164.30.67:8080/api/v1/books/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(utf8.decode(response.bodyBytes));
      return decodedData['data'];
    } else {
      throw Exception('Failed to load book data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이 피드', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchBookData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final bookData = snapshot.data!;
            final title = bookData['title'] ?? '제목 없음';
            final imageUrl = bookData['imageUrl'];

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Image and title section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                // color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              width: 80,
                              height: 120,
                              child: imageUrl != null
                                  ? Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                    )
                                  : const Center(
                                      child: Text(
                                        '이미지 없음',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 90,
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16),
                        // Book status and memo section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 22, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '읽는 중',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                height: 85,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  '메모',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Example cards
                    Text(
                      '2024.12.14',
                      style: TextStyle(fontSize: 14),
                    ),
                    ReviewCard(
                      title: title,
                      rate: 3,
                      text: "좋았다",
                      url: imageUrl,
                    ),
                    Text(
                      '2024.12.14',
                      style: TextStyle(fontSize: 14),
                    ),
                    Scrapcard(
                      title: title,
                      url: imageUrl,
                      text: "삶과 음식",
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
      floatingActionButton: FloatingActionMenu2(bookId: id, url: url),
    );
  }
}
