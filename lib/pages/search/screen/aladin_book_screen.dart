import 'package:bookstar_app/components/FloatingActionMenu2.dart';
import 'package:bookstar_app/model/search/single_book_dto.dart';
import 'package:bookstar_app/pages/search/state/single_book_cubit/single_book_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class AladinBookScreen extends StatelessWidget {
  static const String routeName = 'aladinbook';
  static const String routePath = '/aladinbook';

  final int id;

  const AladinBookScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    context.read<SingleBookCubit>().fetchSingleBooks(id: id);

    String convertStarToIcons(String starValue) {
      switch (starValue) {
        case "1.0":
          return "⭐ ($starValue)";
        case "2.0":
          return "⭐⭐ ($starValue)";
        case "3.0":
          return "⭐⭐⭐ ($starValue)";
        case "4.0":
          return "⭐⭐⭐⭐ ($starValue)";
        case "5.0":
          return "⭐⭐⭐⭐⭐ ($starValue)";
        default:
          return "별점 정보 없음";
      }
    }

    return BlocBuilder<SingleBookCubit, SingleBookState>(
      builder: (context, state) {
        if (state.singleBookDto == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final SingleBookDto singleBookDto = state.singleBookDto!;
          final String star = convertStarToIcons(singleBookDto.star.toString());

          return Scaffold(
            appBar: AppBar(
              title: const Text(''),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      launchUrl(
                        Uri.parse(
                          'https://www.aladin.co.kr/shop/wproduct.aspx?ItemId=${singleBookDto.aladingBookId}',
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/aladin.png',
                      height: 40,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[300], // 배경색
                            borderRadius:
                                BorderRadius.circular(16), // 모든 모서리를 둥글게
                            image: singleBookDto.imageUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(singleBookDto.imageUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0), // 좌우 마진 16
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                singleBookDto.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8), // 텍스트 간의 간격
                              Text(
                                singleBookDto.author,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // 배경색 추가
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50), // 왼쪽 위 모서리를 둥글게
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        _buildSection('별점', star),
                        _buildSection('도서 설명', singleBookDto.description),
                        _buildSection('출판일', singleBookDto.publishedDate),
                        _buildSection('출판사', singleBookDto.publisher),
                        _buildSection('분류', singleBookDto.categoryName),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  FloatingActionMenu2(bookId: id, url: singleBookDto.imageUrl),
            ),
          );
        }
      },
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black, width: 0.5),
              ),
            ),
            child: Text(
              content,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
