import 'package:bookstar_app/global/functions/functions.dart';
import 'package:bookstar_app/global/state/collection_cubit/collection_cubit.dart';
import 'package:bookstar_app/global/state/member_book_cubit/member_book_cubit.dart';
import 'package:bookstar_app/main.dart';
import 'package:bookstar_app/model/search/single_book_dto.dart';
import 'package:bookstar_app/pages/search/scrap_page.dart';
import 'package:bookstar_app/pages/search/screen/write_review_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';

// TODO: 이것도 통일시켜서 재사용 할 수 있지 않을까?
class AladinFloatingActionButton extends StatefulWidget {
  final int bookId;
  final String imageUrl;
  final SingleBookDto singleBookDto;

  const AladinFloatingActionButton({
    super.key,
    required this.bookId,
    required this.imageUrl,
    required this.singleBookDto,
  });

  @override
  State<AladinFloatingActionButton> createState() =>
      _AladinFloatingActionButtonState();
}

class _AladinFloatingActionButtonState
    extends State<AladinFloatingActionButton> {
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController desctiptionTextController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameTextController.dispose();
    desctiptionTextController.dispose();
    super.dispose();
  }

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
                      builder: (context) => WriteReviewPage(
                            bookId: widget.bookId,
                            url: widget.imageUrl,
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
                            bookId: widget.bookId,
                          )),
                );
              },
            ),
            //TODO: 이거 서재 추가할때 readingStatus//star받아야죠..?
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
                      bookId: widget.bookId,
                      readingStatus: "WANT_TO_READ",
                      star: 5,
                    );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.note_add, size: 30, color: Colors.white),
              label: '내 컬렉션에 추가하기',
              backgroundColor: Colors.grey.shade700,
              labelStyle: const TextStyle(fontSize: 14.0, color: Colors.white),
              labelBackgroundColor: Colors.transparent,
              shape: const CircleBorder(),
              onTap: () async {
                int memberId = prefs.getInt('memberId')!;
                final CollectionCubit cubit = context.read<CollectionCubit>();
                await cubit.fetchCollection(memberId: memberId);
                if (!context.mounted) return;
                Functions.globalModal(
                  context: context,
                  widget: cubit.state.collectionList!.isEmpty
                      ? Column(
                          children: [
                            Text('새로운 컬렉션에 추가'),
                            TextField(
                              controller: nameTextController,
                            ),
                            TextField(
                              controller: desctiptionTextController,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            // DropdownButton(
                            //     value: _rating,
                            //     items: ["1", "2", "3", "4", "5"]
                            //         .map((value) => DropdownMenuItem(
                            //               value: value,
                            //               child: Text("$value 점"),
                            //             ))
                            //         .toList(),
                            //     onChanged: (value) {
                            //       setState(() {
                            //         _rating = value!;
                            //       });
                            //     },
                            //   ),
                          ],
                        ),
                  title: '컬렉션 추가',
                  content: '컬렉션을 추가합니다.',
                  submitTap: () async {
                    await cubit.postNewCollection(
                      name: nameTextController.text,
                      description: desctiptionTextController.text,
                      bookInfos: widget.singleBookDto.toJson(),
                    );
                    context.pop();
                  },
                  cancelTap: () => context.pop(),
                );
                // context.read<MemberBookCubit>().postMemberBooks(
                //       bookId: bookId,
                //       readingStatus: "WANT_TO_READ",
                //       star: 5,
                //     );
              },
            ),
          ],
        );
      },
    );
  }
}
