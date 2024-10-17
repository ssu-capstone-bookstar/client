import 'package:flutter/material.dart';
import 'package:bookstar_app/pages/ScrapWhite.dart';

class ActionSheet2 {
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
              leading: Icon(Icons.delete),
              title: Text('삭제'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('삭제!')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('수정'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScrapWhite()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
