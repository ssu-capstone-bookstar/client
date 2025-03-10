import 'package:bookstar_app/components/BookCard1.dart';
import 'package:bookstar_app/components/BookCard2.dart';
import 'package:bookstar_app/components/FloatingActionMenu1.dart';
import 'package:bookstar_app/components/CustomAppBar.dart';
import 'package:bookstar_app/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> recommendedBooks = [];
  List<Map<String, dynamic>> feedItems = [];
  List<Map<String, dynamic>> newItems = [];

  @override
  void initState() {
    super.initState();
    fetchRecommendations();
    fetchFeedItems();
    fetchNewFeedItems();
  }

  Future<void> fetchFeedItems() async {
    final token = Provider.of<UserProvider>(context, listen: false).accessToken;
    print('accessToken: $token');
    try {
      final response = await http.get(
        Uri.parse('http://15.164.30.67:8080/api/v1/pheed'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(utf8.decode(response.bodyBytes));

        setState(() {
          feedItems = List<Map<String, dynamic>>.from(
            decodedData['postItemResponses'].map((item) => {
                  'type': item['type']?.toString() ?? 'UNKNOWN',
                  'bookImage': item['content']['bookImage']?.toString() ??
                      'https://via.placeholder.com/150x200',
                  'bookTitle':
                      item['content']['bookTitle']?.toString() ?? '제목 없음',
                  'reviewId': item['content']['reviewId'] ?? 0,
                }),
          );
        });
        print("pheed/me 호출 성공");
      } else {
        print('Failed to fetch feed items: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching feed items: $e');
    }
  }

  Future<void> fetchNewFeedItems() async {
    final token = Provider.of<UserProvider>(context, listen: false).accessToken;
    try {
      final response = await http.get(
        Uri.parse('http://15.164.30.67:8080/api/v1/pheed/new'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(utf8.decode(response.bodyBytes));

        setState(() {
          newItems = List<Map<String, dynamic>>.from(
            decodedData['postItemResponses'].map((item) => {
                  'type': item['type']?.toString() ?? 'UNKNOWN',
                  'bookImage': item['content']['bookImage']?.toString() ??
                      'https://via.placeholder.com/150x200',
                  'bookTitle':
                      item['content']['bookTitle']?.toString() ?? '제목 없음',
                  'reviewId': item['content']['reviewId'] ?? 0,
                }),
          );
        });
        print("pheed/new 호출 성공");
      } else {
        print('Failed to fetch feed items: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching feed items: $e');
    }
  }

  Future<void> fetchRecommendations() async {
    final token = Provider.of<UserProvider>(context, listen: false).accessToken;
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      print('userId : $userId');

      if (userId == null) {
        print('User ID not found');
        return;
      }

      final response = await http.post(
        Uri.parse('http://15.164.30.67:8000/recommend_books'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(utf8.decode(response.bodyBytes));

        setState(() {
          recommendedBooks = List<Map<String, String>>.from(
            decodedData['recommendations'].map(
              (item) => {
                'imageUrl': item['image_url']?.toString() ??
                    'https://via.placeholder.com/150x200',
                'title': item['title']?.toString() ?? '제목 없음',
                'rate': item['author']?.toString() ?? '저자 정보 없음',
              },
            ),
          );
        });
      } else {
        print('Failed to fetch recommendations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching recommendations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                '친구 새 소식 📖',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              feedItems.isNotEmpty
                  ? SizedBox(
                      height: 270,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: feedItems.length,
                        itemBuilder: (context, index) {
                          final feedItem = feedItems[index];
                          return BookCard1(
                            imageUrl: feedItem['bookImage']!,
                            title: feedItem['bookTitle']!,
                            feedType: feedItem['type']!,
                            reviewId: feedItem['reviewId'],
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text(''),
                    ),
              SizedBox(height: 8),
              Text(
                '실시간 피드',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              feedItems.isNotEmpty
                  ? SizedBox(
                      height: 270,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: newItems.length,
                        itemBuilder: (context, index) {
                          final feedItem = newItems[index];
                          return BookCard1(
                            imageUrl: feedItem['bookImage']!,
                            title: feedItem['bookTitle']!,
                            feedType: feedItem['type']!,
                            reviewId: feedItem['reviewId'],
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text(''),
                    ),
              SizedBox(height: 8),
              Text(
                '추천 알고리즘',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              recommendedBooks.isNotEmpty
                  ? SizedBox(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: recommendedBooks.length,
                        itemBuilder: (context, index) {
                          final book = recommendedBooks[index];
                          return BookCard2(
                            imageUrl: book['imageUrl']!,
                            title: book['title']!,
                            rate: book['rate']!,
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text('추천 도서를 불러오는 중입니다...'),
                    ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionMenu1(),
    );
  }
}
