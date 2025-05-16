import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookstar_app/global/state/Index_cubit/index_cubit.dart';
import 'package:bookstar_app/pages/home/screen/home_page.dart';
import 'package:bookstar_app/pages/scrap/state/scrap_text_cubit/scrap_text_cubit.dart';
import 'package:bookstar_app/pages/scrap/state/scrap_text_dto.dart';

/// 스크랩 작성 화면
class ScrapTextScreen extends StatefulWidget {
  final List<File> images;
  final List<List<Offset?>> highlights;

  const ScrapTextScreen({
    super.key,
    required this.images,
    required this.highlights,
  });

  @override
  State<ScrapTextScreen> createState() => _ScrapTextScreenState();
}

class _ScrapTextScreenState extends State<ScrapTextScreen> {
  final TextEditingController _textController = TextEditingController();

  Future<void> _handlePostScrap() async {
    final prefs = await SharedPreferences.getInstance();
    final bookId = prefs.getInt('bookId');

    if (bookId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('bookId가 없습니다.')),
      );
      return;
    }

    final scrapText = ScrapTextDto(
      images: widget.images,
      highlights: widget.highlights,
      text: _textController.text,
      bookId: bookId,
    );

    if (!mounted) return;
    await context.read<ScrapTextCubit>().postScrap(scrapText);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScrapTextCubit, ScrapTextState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        } else if (state.scrapImageUrl != null) {
          context.read<IndexCubit>().setIndex(index: 1);
          context.goNamed(HomePage.routeName);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('닫기'),
          backgroundColor: Colors.white,
          actions: [
            BlocBuilder<ScrapTextCubit, ScrapTextState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state.isLoading ? null : _handlePostScrap,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 34, 78, 255),
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: state.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('완료'),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.grey,
                child: PageView.builder(
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      widget.images[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: '자유 메모',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
