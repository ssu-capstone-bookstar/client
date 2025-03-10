import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String url;
  final String title;
  final String text;
  final int rate;
  final VoidCallback? onLikePressed;
  final VoidCallback? onMorePressed;
  final double iconSize;

  const ReviewCard({
    Key? key,
    required this.title,
    required this.text,
    required this.url,
    required this.rate,
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
              color: Colors.grey, // 배경색 (이미지 로드 전 기본 색상)
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(url), // 네트워크 이미지 추가
                fit: BoxFit.cover, // 이미지를 컨테이너에 맞게 채움
              ),
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
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1, // 최대 1줄
                        overflow: TextOverflow.ellipsis, // 영역 초과 시 ... 표시
                      ),
                    ),
                    // 별점 (이미지)
                    Row(
                      children: List.generate(
                        rate, // 별점 수
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
                  maxLines: 2, // 최대 2줄
                  overflow: TextOverflow.ellipsis, // 영역 초과 시 ... 표시
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
