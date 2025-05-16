import 'package:bookstar_app/api_service/api_service.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'member_book_state.dart';

class MemberBookCubit extends Cubit<MemberBookState> {
  MemberBookCubit() : super(MemberBookState());

  Future<void> postMemberBooks({
    required int bookId,
    required String readingStatus,
    required double star,
  }) async {
    try {
      await ApiService.apiPostService(
        path: 'memberbooks/$bookId/reading-status',
        body: {
          "readingStatus": "WANT_TO_READ",
          "star": 5,
        },
        options: Options(
          extra: {'requiresToken': true},
        ),
      );
      debugPrint("postMemberBooks 성공");
    } catch (e) {
      debugPrint("postMemberBooks 실패 - $e");
    }
  }
}
