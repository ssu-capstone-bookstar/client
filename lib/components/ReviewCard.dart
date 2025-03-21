import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookstar_app/providers/UserProvider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReviewCard extends StatefulWidget {
  final int reviewId;
  final int memberId;
  final VoidCallback? onLikePressed;
  final VoidCallback? onMorePressed;
  final double iconSize;

  const ReviewCard({
    Key? key,
    required this.reviewId,
    required this.memberId,
    this.onLikePressed,
    this.onMorePressed,
    this.iconSize = 20,
  }) : super(key: key);

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  late Future<Map<String, dynamic>> reviewDetail;

  @override
  void initState() {
    super.initState();
    reviewDetail = fetchReviewDetail(context);
  }

  Future<Map<String, dynamic>> fetchReviewDetail(BuildContext context) async {
    final token = Provider.of<UserProvider>(context, listen: false).accessToken;
    final url = Uri.parse(
        'http://15.164.30.67:8080/api/v1/review/detail/${widget.memberId}/${widget.reviewId}');

    print('Fetching review detail for ID: ${widget.reviewId}');
    print('memberId: ${widget.memberId}');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(utf8.decode(response.bodyBytes));
      print('Review Detail Response: $decodedData');
      return decodedData['data'];
    } else {
      print('Failed to fetch review detail: ${response.statusCode}');
      throw Exception('Failed to load review detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: reviewDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final reviewData = snapshot.data!;
          final reviewText = reviewData['content'] ?? '리뷰 내용 없음';
          final reviewRate = (reviewData['rating'] ?? 0).toInt();
          final imageUrl = reviewData['bookImage'] ?? '';
          final bookTitle = reviewData['bookTitle'] ?? '제목 없음';

          return Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1행 1열: 책 이미지
                Container(
                  height: 110,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey, // 배경색 (이미지 로드 전 기본 색상)
                    borderRadius: BorderRadius.circular(10),
                    image: imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(imageUrl), // API에서 가져온 이미지
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imageUrl.isEmpty
                      ? Center(
                          child: Text(
                            '이미지 없음',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : null,
                ),

                SizedBox(width: 10), // 열 간격

                // 1행 2열: 리뷰 내용
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 제목과 별점을 같은 줄에 배치
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 책 제목 (API에서 가져온 값으로 변경됨)
                          Expanded(
                            child: Text(
                              bookTitle,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // 별점
                          Row(
                            children: List.generate(
                              reviewRate,
                              (index) => Image.asset(
                                'assets/images/star.png',
                                height: widget.iconSize,
                                width: widget.iconSize,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),

                      // 리뷰 내용
                      Text(
                        reviewText,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 15),

                      // 하단 좋아요와 더보기 아이콘
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // 좋아요 아이콘
                          GestureDetector(
                            onTap: widget.onLikePressed,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/good.png',
                                  height: widget.iconSize,
                                  width: widget.iconSize,
                                ),
                                SizedBox(width: 5),
                              ],
                            ),
                          ),
                          // 더보기 아이콘
                          GestureDetector(
                            onTap: widget.onMorePressed,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/chat.png',
                                  height: widget.iconSize,
                                  width: widget.iconSize,
                                ),
                                SizedBox(width: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }
}
