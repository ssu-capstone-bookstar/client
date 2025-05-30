import 'package:bookstar_app/pages/search/screen/aladin_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AladinBookCardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final String year;
  final int id;

  const AladinBookCardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.year,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          AladinBookScreen.routeName,
          extra: {
            'id': id,
          },
        );
      },
      child: SizedBox(
        width: 300.0,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  imageUrl,
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      author,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      year,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
