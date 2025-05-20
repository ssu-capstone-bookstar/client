import 'package:bookstar_app/components/CustomAppBar.dart';
import 'package:bookstar_app/main.dart';
import 'package:bookstar_app/model/pheed/ai_recommed_book_dto.dart';
import 'package:bookstar_app/model/pheed/pheed_item_dto.dart';
import 'package:bookstar_app/pages/home/state/pheed_cubit/pheed_cubit.dart';
import 'package:bookstar_app/pages/home/widget/ai_recommend_book_widget.dart';
import 'package:bookstar_app/pages/home/widget/book_skeleton_widget.dart';
import 'package:bookstar_app/pages/home/widget/home_floating_action_button.dart';
import 'package:bookstar_app/pages/home/widget/pheed_book_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'home';
  static const String routePath = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final int memberId = prefs.getInt('memberId')!;
    final PheedCubit cubit = context.read<PheedCubit>();
    cubit.fetchNewFeedItems();
    cubit.fetchFeedItems();
    cubit.fetchAiRecommendBook(userId: memberId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: BlocBuilder<PheedCubit, PheedState>(
        builder: (context, state) {
          List<PheedItemDto> newItems = state.pheedNewItems ?? [];
          List<PheedItemDto> pheedItems = state.pheedItems ?? [];
          List<AiRecommedBookDto> recommendedBooks =
              state.aiRecommedBooks ?? [];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    '친구 새 소식 📖',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  pheedItems.isNotEmpty
                      ? SizedBox(
                          height: 270,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: pheedItems.length,
                            itemBuilder: (context, index) {
                              final feedItem = pheedItems[index];
                              return PheedBookWidget(
                                imageUrl: feedItem.content.bookImage,
                                title: feedItem.content.bookTitle,
                                feedType: feedItem.type,
                                reviewId: feedItem.content.bookId,
                                scrapId: feedItem.content.scrapId,
                                memberId: feedItem.content.memberId,
                              );
                            },
                          ),
                        )
                      : BookSkeleton(),
                  const SizedBox(height: 8),
                  const Text(
                    '실시간 피드',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  newItems.isNotEmpty
                      ? SizedBox(
                          height: 270,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: newItems.length,
                            itemBuilder: (context, index) {
                              final feedItem = newItems[index];
                              return PheedBookWidget(
                                imageUrl: feedItem.content.bookImage,
                                title: feedItem.content.bookTitle,
                                feedType: feedItem.type,
                                reviewId: feedItem.content.bookId,
                                scrapId: feedItem.content.scrapId,
                                memberId: feedItem.content.memberId,
                              );
                            },
                          ),
                        )
                      : BookSkeleton(),
                  const SizedBox(height: 8),
                  const Text(
                    '추천 알고리즘',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  recommendedBooks.isNotEmpty
                      ? SizedBox(
                          height: 300,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendedBooks.length,
                            itemBuilder: (context, index) {
                              final AiRecommedBookDto book =
                                  recommendedBooks[index];
                              return AiRecommendBookWidget(
                                imageUrl: book.imageUrl,
                                title: book.title,
                                author: book.author,
                              );
                            },
                          ),
                        )
                      : BookSkeleton(),

                  // const Center(
                  //     child: Text('추천 도서를 불러오는 중입니다...'),
                  //   ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: const HomeFloatingActionbutton(),
    );
  }
}
