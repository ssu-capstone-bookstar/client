import 'dart:convert';

import 'package:bookstar_app/components/FloatingActionMenu4.dart';
import 'package:bookstar_app/components/ReviewCard.dart';
import 'package:bookstar_app/components/ScrapCard.dart';
import 'package:bookstar_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MyFeed extends StatelessWidget {
  final int id;
  final String url;
  const MyFeed({super.key, required this.id, required this.url});

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

  Future<Map<String, dynamic>> fetchMyFeedData(BuildContext context) async {
    final token = Provider.of<UserProvider>(context, listen: false).accessToken;
    final url = Uri.parse('http://15.164.30.67:8080/api/v1/pheed/me/$id');
    print('Fetching MyFeed data for id: $id');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(utf8.decode(response.bodyBytes));
      print('MyFeed response: $decodedData');
      return decodedData;
    } else {
      print('Failed to fetch MyFeed data: ${response.statusCode}');
      throw Exception('Failed to load MyFeed data');
    }
  }

  String _formatDate(String dateTimeString) {
    if (dateTimeString.isEmpty) {
      return '';
    }

    try {
      // ISO 형식의 날짜 문자열을 DateTime 객체로 변환
      DateTime dateTime = DateTime.parse(dateTimeString);

      // 원하는 형식으로 날짜만 포맷팅 (yyyy.MM.dd)
      return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      // 파싱 오류 시 빈 문자열 반환
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('마이 피드', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 책 정보 가져오기
            FutureBuilder<Map<String, dynamic>>(
              future: fetchBookData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                                  const SizedBox(height: 8),
                                  SizedBox(
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
                              const SizedBox(width: 16),
                              // Book status and memo section
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 22, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Text(
                                            '읽는 중',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(
                                          Icons.favorite,
                                          color: Colors.black,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      height: 85,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: const EdgeInsets.all(12.0),
                                      child: const Text(
                                        '메모',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
            // 마이 피드 데이터 가져오기
            FutureBuilder<Map<String, dynamic>>(
              future: fetchMyFeedData(context),
              builder: (context, snapshot) {
                final int? userId =
                    Provider.of<UserProvider>(context, listen: false).userId;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final myFeedData = snapshot.data!;
                  final List<dynamic> posts =
                      myFeedData['postItemResponses'] ?? [];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // 전체 왼쪽 정렬
                        children: posts.expand((post) {
                          // post 타입에 따라 적절한 카드 위젯 반환
                          Widget cardWidget;
                          if (post['type'] == 'REVIEW') {
                            cardWidget = ReviewCard(
                              reviewId: post['content']['reviewId'],
                              memberId: userId ?? 0,
                            );
                          } else if (post['type'] == 'SCRAP') {
                            cardWidget = Scrapcard(
                              scrapId: post['content']['scrapId'],
                              memberId: userId ?? 0,
                            );
                          } else {
                            // 알 수 없는 타입의 경우 빈 컨테이너 반환
                            cardWidget = Container();
                          }

                          return [
                            Align(
                              alignment: Alignment.centerLeft, // 왼쪽 정렬
                              child: Text(
                                _formatDate(post['createdAt']),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            cardWidget,
                          ];
                        }).toList(),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionMenu4(bookId: id, url: url),
    );
  }
}
