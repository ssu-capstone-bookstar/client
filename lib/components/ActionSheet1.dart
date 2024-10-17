import 'package:bookstar_app/pages/Scrap.dart';
import 'package:flutter/material.dart';
import 'package:bookstar_app/pages/AddRecord.dart';
import 'package:bookstar_app/pages/WriteReview.dart';

class ActionSheet1 {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.check),
              title: Text('읽음'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('읽음!')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text('스크랩'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Scrap()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.rate_review),
              title: Text('리뷰 쓰기'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WriteReview(
                            bookName: '홍길동전',
                          )),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.done_all),
              title: Text('완독'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('완독!')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
