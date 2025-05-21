import 'package:bookstar_app/components/FloatingActionMenu4.dart';
import 'package:bookstar_app/global/state/single_book_cubit/single_book_cubit.dart';
import 'package:bookstar_app/model/pheed/pheed_item_dto.dart';
import 'package:bookstar_app/model/pheed/review_content_dto.dart';
import 'package:bookstar_app/model/pheed/scrap_content_dto.dart';
import 'package:bookstar_app/model/search/single_book_dto.dart';
import 'package:bookstar_app/pages/home/state/pheed_cubit/pheed_cubit.dart';
import 'package:bookstar_app/pages/review/screen/review_card_screen.dart';
import 'package:bookstar_app/pages/scrap/screen/scrap_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFeedPage extends StatelessWidget {
  static const String routePath = '/myfeed';
  static const String routeName = 'myfeed';

  final int id;

  const MyFeedPage({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    String formatDate(String dateTimeString) {
      if (dateTimeString.isEmpty) {
        return '';
      }

      try {
        // ISO 형식의 날짜 문자열을 DateTime 객체로 변환
        DateTime dateTime = DateTime.parse(dateTimeString);

        // 원하는 형식으로 날짜만 포맷팅 (yyyy.MM.dd)
        return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}';
      } catch (e) {
        // 파싱 오류 시 빈 문자열 반환
        return '';
      }
    }

    context.read<SingleBookCubit>().fetchSingleBooks(id: id);
    context.read<PheedCubit>().fetchMyFeedItems();

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('마이 피드', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 책 정보 가져오기
            BlocBuilder<SingleBookCubit, SingleBookState>(
              builder: (context, state) {
                if (state.singleBookDto == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                SingleBookDto singleBookDto = state.singleBookDto!;
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Image and title section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  // color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                width: 80,
                                height: 120,
                                child: singleBookDto.imageUrl != ''
                                    ? Image.network(
                                        singleBookDto.imageUrl,
                                        fit: BoxFit.cover,
                                      )
                                    : const Center(
                                        child: Text(
                                          '이미지 없음',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 90,
                                child: Text(
                                  singleBookDto.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          // Book status and memo section
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        '읽는 중',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(
                                      Icons.favorite,
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  height: 85,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.all(12.0),
                                  child: const Text(
                                    '메모',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            BlocBuilder<PheedCubit, PheedState>(
              builder: (context, state) {
                if (state.pheedMyItems == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final List<PheedItemDto> pheedItem = state.pheedMyItems!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 전체 왼쪽 정렬
                    children: pheedItem.expand((post) {
                      // post 타입에 따라 적절한 카드 위젯 반환
                      Widget cardWidget;
                      // 리뷰에서 404에러나오고 있음 존재하지 않는 리뷰라고 나옴
                      if (post.type == 'REVIEW' &&
                          post.content is ReviewContentDto) {
                        final reviewContent = post.content as ReviewContentDto;
                        cardWidget = ReviewCardScreen(
                          reviewId: reviewContent.reviewId,
                          memberId: reviewContent.memberId,
                        );
                      } else if (post.type == 'SCRAP' &&
                          post.content is ScrapContentDto) {
                        final scrapContent = post.content as ScrapContentDto;
                        cardWidget = ScrapCardScreen(
                          scrapId: scrapContent.scrapId,
                          memberId: scrapContent.memberId,
                        );
                      } else {
                        // 알 수 없는 타입의 경우 빈 컨테이너 반환
                        cardWidget = Container();
                      }

                      return [
                        Align(
                          alignment: Alignment.centerLeft, // 왼쪽 정렬
                          child: Text(
                            formatDate(post.createdAt),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        cardWidget,
                      ];
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionMenu4(bookId: id),
    );
  }
}
