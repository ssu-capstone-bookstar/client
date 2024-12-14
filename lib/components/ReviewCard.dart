import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String? url;
  final String title;
  final String text;
  final VoidCallback? onLikePressed;
  final VoidCallback? onMorePressed;
  final double iconSize;

  const ReviewCard({
    Key? key,
    required this.title,
    required this.text,
    required this.url,
    this.onLikePressed,
    this.onMorePressed,
    this.iconSize = 20, // 아이콘 크기를 조절할 수 있는 파라미터 추가
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          // 1행 1열: 회색 상자
          Container(
            height: 110,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(width: 10), // 열 간격
          // 1행 2열: ReviewCard의 기존 내용
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목과 별점을 같은 줄에 배치 (제목 -> 별점)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 제목
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    // 별점 (이미지)
                    Row(
                      children: List.generate(
                        3, // 별점 수
                        (index) => Image.asset(
                          'assets/images/star.png',
                          height: iconSize,
                          width: iconSize,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // 내용
                Text(
                  text,
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
                      onTap: onLikePressed,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/good.png',
                            height: iconSize,
                            width: iconSize,
                          ),
                          SizedBox(width: 5),
                        ],
                      ),
                    ),
                    // SizedBox(width: 20),
                    // 더보기 아이콘
                    GestureDetector(
                      onTap: onMorePressed,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/chat.png',
                            height: iconSize,
                            width: iconSize,
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
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: ReviewCard(
          title: "Sample Title",
          text: "This is a sample text for the review card.",
          url: null,
          onLikePressed: () {
            print("Like pressed");
          },
          onMorePressed: () {
            print("More pressed");
          },
          iconSize: 24, // 아이콘 크기를 조절
        ),
      ),
    ),
  ));
}
