import 'package:bookstar_app/pages/home/widget/book_pop_card.dart';
import 'package:flutter/material.dart';

//TODO:이것 포함해서 대부분의 Book들을 위젯화 시켜서 재사용하는게 나을것같은데?
class PheedBookWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String feedType;
  final int? reviewId;
  final int? scrapId;
  final int? memberId;

  const PheedBookWidget(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.feedType,
      this.reviewId,
      this.scrapId,
      this.memberId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BookPopCard.show(
            context: context,
            feedType: feedType,
            scrapId: scrapId,
            reviewId: reviewId,
            memberId: memberId);
      },
      child: Container(
        width: 120.0,
        margin: const EdgeInsets.only(right: 20.0),
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
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14.0,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4.0),
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
