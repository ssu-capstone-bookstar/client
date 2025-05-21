import 'package:bookstar_app/api_service/api_service.dart';
import 'package:bookstar_app/model/common_dto.dart';
import 'package:bookstar_app/model/search/single_book_dto.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'single_book_state.dart';

class SingleBookCubit extends Cubit<SingleBookState> {
  SingleBookCubit() : super(SingleBookState());

  Future<void> fetchSingleBooks({
    required int id,
  }) async {
    try {
      final Response response = await ApiService.apiGetService(
        path: 'books/$id',
        options: Options(
          extra: {'requiresToken': true},
        ),
      );
      if (response.data is Map<String, dynamic>) {
        final CommonDto<SingleBookDto> commonResponse =
            CommonDto<SingleBookDto>.fromJson(
          response.data,
          (jsonData) =>
              SingleBookDto.fromJson(jsonData as Map<String, dynamic>),
        );
        emit(state.copyWith(singleBookDto: commonResponse.data));
        debugPrint("fetchSingleBooks 호출 및 파싱 성공");
      }
    } catch (e) {
      debugPrint("fetchSingleBooks 에러 - $e");
    }
  }
}
