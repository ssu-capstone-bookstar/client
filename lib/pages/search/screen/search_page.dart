import 'package:bookstar_app/components/CustomSearchBar.dart';
import 'package:bookstar_app/model/search/bestseller_aladin_dto.dart';
import 'package:bookstar_app/pages/search/state/search_cubit/search_cubit.dart';
import 'package:bookstar_app/pages/search/widget/aladin_book_card_widget.dart';
import 'package:bookstar_app/pages/search/widget/recent_book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static const String routeName = 'search';
  static const String routePath = '/search';

  const SearchPage({super.key});

  // Future<void> _openCamera(BuildContext context) async {
  //   await _picker.pickImage(source: ImageSource.camera);
  // }

  @override
  Widget build(BuildContext context) {
    context.read<SearchCubit>().fetchAladinBooks(cursor: 1);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            showSearch(
              context: context,
              delegate: CustomSearchBar(),
            );
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                SizedBox(width: 16),
                Icon(Icons.search, color: Colors.black54),
                SizedBox(width: 8),
                Text(
                  '검색창',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              // _openCamera(context);
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state.books == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!state.isLoadingMore! &&
                    scrollInfo.metrics.maxScrollExtent > 0 &&
                    scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 100) {
                  context
                      .read<SearchCubit>()
                      .fetchAladinBooks(cursor: state.cursor!);
                }
                return true;
              },
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '최근 본 작품',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("기록 삭제"),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: const Text(
                              '기록 삭제',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 170,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 1,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          return const RecentBookCard(
                            imageUrl:
                                'https://image.aladin.co.kr/product/29137/2/coversum/8936434594_2.jpg',
                            id: 9,
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text(
                        '추천 책',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        BestsellerAladinDto book = state.books![index];
                        final bool isLastItem =
                            index == state.books!.length - 1;
                        return Padding(
                          padding: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom: isLastItem ? 0 : 16),
                          child: AladinBookCardWidget(
                            imageUrl: book.bookCover,
                            title: book.title,
                            author: book.author,
                            year: book.pubDate,
                            id: book.bookId,
                          ),
                        );
                      },
                      childCount: state.books!.length,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
