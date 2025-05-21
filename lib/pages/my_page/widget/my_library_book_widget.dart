import 'package:bookstar_app/pages/my_page/screen/my_feed_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyLibraryBookWidget extends StatelessWidget {
  final String imageUrl;
  final String bookId;
  final double bookWidth;
  final double bookHeight;

  const MyLibraryBookWidget({
    super.key,
    required this.imageUrl,
    required this.bookId,
    this.bookWidth = 81, // 기본값 설정
    this.bookHeight = 108, // 기본값 설정
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(MyFeedPage.routeName, extra: {'id': bookId});
      },
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imageUrl,
                width: bookWidth, // 입력값 없으면 기본값 81
                height: bookHeight, // 입력값 없으면 기본값 108
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
