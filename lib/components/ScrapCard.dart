import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookstar_app/providers/UserProvider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Scrapcard extends StatefulWidget {
  final int scrapId;
  final VoidCallback? onLikePressed;
  final VoidCallback? onMorePressed;
  final double iconSize;

  const Scrapcard({
    Key? key,
    required this.scrapId,
    this.onLikePressed,
    this.onMorePressed,
    this.iconSize = 20,
  }) : super(key: key);

  @override
  _ScrapCardState createState() => _ScrapCardState();
}

class _ScrapCardState extends State<Scrapcard> {
  late Future<Map<String, dynamic>> scrapDetail;

  @override
  void initState() {
    super.initState();
    scrapDetail = fetchScrapDetail(context);
  }

  Future<Map<String, dynamic>> fetchScrapDetail(BuildContext context) async {
    final token = Provider.of<UserProvider>(context, listen: false).accessToken;
    final url = Uri.parse(
        'http://15.164.30.67:8080/api/v1/scrap/detail/${widget.scrapId}');

    print('Fetching scrap detail for ID: ${widget.scrapId}');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(utf8.decode(response.bodyBytes));
      print('Scrap Detail Response: $decodedData');
      return decodedData['data'];
    } else {
      print('Failed to fetch scrap detail: ${response.statusCode}');
      throw Exception('Failed to load scrap detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: scrapDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final scrapData = snapshot.data!;
          // final scrapText = scrapData['content'] ?? '리뷰 내용 없음';
          // final scrapRate = (scrapData['rating'] ?? 0).toInt();
          final url = scrapData['bookImage'] ?? '';
          final bookTitle = scrapData['bookTitle'] ?? '제목 없음';
          final scrapImages = scrapData['scrapImages'] ?? '';
          final text = scrapData['content'] ?? '';
          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 왼쪽 회색 상자 (이미지 대체)
                Container(
                  height: 240,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey, // 이미지 로드 전 기본 배경색
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(scrapImages), // 에셋 이미지 경로
                      fit: BoxFit.cover, // 이미지를 컨테이너에 맞게 채움
                    ),
                  ),
                ),

                const SizedBox(width: 12),
                // 오른쪽 텍스트 및 아이콘
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // 제목
                          Flexible(
                            child: Text(
                              bookTitle,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Spacer(),
                          // 오른쪽 작은 회색 상자
                          Container(
                            width: 29,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.grey, // 이미지 로드 전 기본 배경색
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: NetworkImage(url), // 네트워크 이미지 URL
                                fit: BoxFit.cover, // 이미지를 컨테이너에 맞게 채움
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // 본문 텍스트
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      // 하단 아이콘
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: widget.onLikePressed,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/good.png',
                                  width: widget.iconSize,
                                  height: widget.iconSize,
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onMorePressed,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/chat.png',
                                  width: widget.iconSize,
                                  height: widget.iconSize,
                                ),
                                const SizedBox(width: 5),
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
