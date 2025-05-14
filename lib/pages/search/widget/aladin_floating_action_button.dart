import 'package:bookstar_app/global/state/member_book_cubit/member_book_cubit.dart';
import 'package:bookstar_app/pages/search/WriteReview.dart';
import 'package:bookstar_app/pages/search/scrap_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class AladinFloatingActionButton extends StatelessWidget {
  final int bookId;
  final String imageUrl;

  const AladinFloatingActionButton({
    super.key,
    required this.bookId,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberBookCubit, MemberBookState>(
      builder: (context, state) {
        return SpeedDial(
          icon: Icons.menu,
          activeIcon: Icons.close,
          backgroundColor: Colors.grey.shade800,
          iconTheme: const IconThemeData(size: 32),
          foregroundColor: Colors.white,
          overlayOpacity: 0.0,
          spacing: 10,
          spaceBetweenChildren: 8,
          children: [
            SpeedDialChild(
              child:
                  const Icon(Icons.rate_review, size: 30, color: Colors.white),
              label: '리뷰 쓰기',
              backgroundColor: Colors.grey.shade700,
              labelStyle: const TextStyle(fontSize: 14.0, color: Colors.white),
              labelBackgroundColor: Colors.transparent,
              shape: const CircleBorder(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WriteReview(
                            bookId: bookId,
                            url: imageUrl,
                          )),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.bookmark, size: 30, color: Colors.white),
              label: '스크랩',
              backgroundColor: Colors.grey.shade700,
              labelStyle: const TextStyle(fontSize: 14.0, color: Colors.white),
              labelBackgroundColor: Colors.transparent,
              shape: const CircleBorder(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScrapPage(
                            bookId: bookId,
                          )),
                );
              },
            ),
            SpeedDialChild(
              child:
                  const Icon(Icons.library_add, size: 30, color: Colors.white),
              label: '내 서재에 추가하기',
              backgroundColor: Colors.grey.shade700,
              labelStyle: const TextStyle(fontSize: 14.0, color: Colors.white),
              labelBackgroundColor: Colors.transparent,
              shape: const CircleBorder(),
              onTap: () {
                context.read<MemberBookCubit>().postMemberBooks(
                      bookId: bookId,
                    );
              },
            ),
          ],
        );
      },
    );
  }
}
