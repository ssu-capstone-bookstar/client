import 'package:flutter/material.dart';

class Scrapcard extends StatelessWidget {
  final String? url;
  final String title;
  final String text;
  final VoidCallback? onLikePressed;
  final VoidCallback? onMorePressed;
  final double iconSize;

  const Scrapcard({
    Key? key,
    required this.title,
    required this.text,
    required this.url,
    this.onLikePressed,
    this.onMorePressed,
    this.iconSize = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
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
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    // 오른쪽 작은 회색 상자
                    Container(
                      width: 29,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5),
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
                      onTap: onLikePressed,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/good.png',
                            width: iconSize,
                            height: iconSize,
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onMorePressed,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/chat.png',
                            width: iconSize,
                            height: iconSize,
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
  }
}
