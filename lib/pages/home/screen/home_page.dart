import 'dart:convert';

import 'package:bookstar_app/components/BookCard1.dart';
import 'package:bookstar_app/components/BookCard2.dart';
import 'package:bookstar_app/components/CustomAppBar.dart';
import 'package:bookstar_app/components/FloatingActionMenu1.dart';
import 'package:bookstar_app/model/pheed/post_item_responses_dto.dart';
import 'package:bookstar_app/pages/home/state/pheed_cubit/pheed_cubit.dart';
import 'package:bookstar_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'home';
  static const String routePath = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> recommendedBooks = [];

  @override
  void initState() {
    super.initState();
    fetchRecommendations();
    //fetchFeedItems();
    final PheedCubit cubit = context.read<PheedCubit>();
    cubit.fetchNewFeedItems();
    cubit.fetchFeedItems();
  }

  // Future<void> fetchFeedItems() async {
  //   final token = Provider.of<UserProvider>(context, listen: false).accessToken;
  //   print('accessToken: $token');
  //   try {
  //     final response = await http.get(
  //       Uri.parse('http://15.164.30.67:8080/api/v1/pheed'),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final decodedData = jsonDecode(utf8.decode(response.bodyBytes));

  //       setState(() {
  //         feedItems = List<Map<String, dynamic>>.from(
  //           decodedData['postItemResponses'].map((item) => {
  //                 'type': item['type']?.toString() ?? 'UNKNOWN',
  //                 'bookImage': item['content']['bookImage']?.toString() ??
  //                     'https://via.placeholder.com/150x200',
  //                 'bookTitle':
  //                     item['content']['bookTitle']?.toString() ?? '제목 없음',
  //                 'reviewId': item['content']['reviewId'],
  //                 'scrapId': item['content']['scrapId'],
  //                 'memberId': item['content']['memberId'],
  //               }),
  //         );
  //       });
  //       print("pheed/me 호출 성공");
  //     } else {
  //       print('Failed to fetch feed items: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching feed items: $e');
  //   }
  // }

  Future<void> fetchRecommendations() async {
    // final token = Provider.of<UserProvider>(context, listen: false).accessToken;
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
        // print(decodedData);
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
      appBar: const CustomAppBar(),
      body: BlocBuilder<PheedCubit, PheedState>(
        builder: (context, state) {
          List<PostItemResponse> newItems = state.pheedNewItems ?? [];
          List<PostItemResponse> pheedItems = state.pheedItems ?? [];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    '친구 새 소식 📖',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  pheedItems.isNotEmpty
                      ? SizedBox(
                          height: 270,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: pheedItems.length,
                            itemBuilder: (context, index) {
                              final feedItem = pheedItems[index];
                              return BookCard1(
                                imageUrl: feedItem.content.bookImage,
                                title: feedItem.content.bookTitle,
                                feedType: feedItem.type,
                                reviewId: feedItem.content.bookId,
                                scrapId: feedItem.content.scrapId,
                                memberId: feedItem.content.memberId,
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: Text(''),
                        ),
                  const SizedBox(height: 8),
                  const Text(
                    '실시간 피드',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  newItems.isNotEmpty
                      ? SizedBox(
                          height: 270,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: newItems.length,
                            itemBuilder: (context, index) {
                              final feedItem = newItems[index];
                              return BookCard1(
                                imageUrl: feedItem.content.bookImage,
                                title: feedItem.content.bookTitle,
                                feedType: feedItem.type,
                                reviewId: feedItem.content.bookId,
                                scrapId: feedItem.content.scrapId,
                                memberId: feedItem.content.memberId,
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: Text(''),
                        ),
                  const SizedBox(height: 8),
                  const Text(
                    '추천 알고리즘',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
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
                      : const Center(
                          child: Text('추천 도서를 불러오는 중입니다...'),
                        ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: const FloatingActionMenu1(),
    );
  }
}
