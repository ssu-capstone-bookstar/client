import 'package:bookstar_app/pages/Scrap.dart';
import 'package:bookstar_app/pages/WriteReview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActionSheet1 {
  static void show(BuildContext context) async {
    final prefs =
        await SharedPreferences.getInstance(); // SharedPreferences 가져오기
    final bookId = prefs.getInt('bookId') ?? 0; // 저장된 bookId 불러오기

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text('읽음'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('읽음!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('스크랩'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Scrap(
                            bookId: bookId, // 저장된 bookId 사용
                          )),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.rate_review),
              title: const Text('리뷰 쓰기'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WriteReview(
                            bookId: bookId, // 저장된 bookId 사용
                            url: "",
                          )),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.done_all),
              title: const Text('완독'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('완독!')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
