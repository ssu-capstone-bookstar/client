import 'package:bookstar_app/components/PopCard.dart';
import 'package:flutter/material.dart';

class BookCard1 extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String feedType;
  final int? reviewId;
  final int? scrapId;
  final int? memberId;

  BookCard1(
      {required this.imageUrl,
      required this.title,
      required this.feedType,
      required this.reviewId,
      required this.scrapId,
      required this.memberId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        PopCard.show(
            context: context,
            feedType: feedType,
            scrapId: scrapId,
            reviewId: reviewId,
            memberId: memberId);
        print('scrapId: $scrapId');
        print('reviewId: $reviewId');
        print('memberID: $memberId');
      },
      child: Container(
        width: 120.0,
        margin: EdgeInsets.only(right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                imageUrl,
                width: 120,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.0,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Text(
                feedType,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
