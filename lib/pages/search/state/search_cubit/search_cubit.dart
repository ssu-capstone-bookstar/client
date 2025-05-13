import 'package:bookstar_app/api_service/api_service.dart';
import 'package:bookstar_app/model/common_dto.dart';
import 'package:bookstar_app/model/search/bestseller_aladin_dto.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchState.initial());

  Future<void> fetchAladinBooks({
    required int cursor,
  }) async {
    if (state.isLoadingMore!) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));

    if (cursor == 1) {
      final Response response = await ApiService.apiGetService(
        path: 'search/bestseller/aladin',
        body: {'start': cursor},
        options: Options(
          extra: {'requiresToken': true},
        ),
      );
      if (response.data is Map<String, dynamic>) {
        final CommonDto<List<BestsellerAladinDto>> commonResponse =
            CommonDto<List<BestsellerAladinDto>>.fromJson(
          response.data,
          (jsonData) {
            if (jsonData is List) {
              return jsonData
                  .map((item) => BestsellerAladinDto.fromJson(
                      item as Map<String, dynamic>))
                  .toList();
            }
            throw Exception('데이터 포맷 일치해야함!!');
          },
        );
        emit(state.copyWith(books: commonResponse.data));
        cursorIncrease();

        emit(state.copyWith(isLoadingMore: false));
      }
    } else {
      final Response response = await ApiService.apiGetService(
        path: 'search/bestseller/aladin',
        body: {'start': cursor},
        options: Options(
          extra: {'requiresToken': true},
        ),
      );
      if (response.data is Map<String, dynamic>) {
        final CommonDto<List<BestsellerAladinDto>> commonResponse =
            CommonDto<List<BestsellerAladinDto>>.fromJson(
          response.data,
          (jsonData) {
            if (jsonData is List) {
              return jsonData
                  .map((item) => BestsellerAladinDto.fromJson(
                      item as Map<String, dynamic>))
                  .toList();
            }
            throw Exception('데이터 포맷 일치해야함!!');
          },
        );
        emit(
          state.copyWith(books: [...state.books!, ...commonResponse.data]),
        );
        cursorIncrease();

        emit(state.copyWith(isLoadingMore: false));
      }
    }
  }

  void cursorIncrease() {
    emit(
      state.copyWith(cursor: state.cursor! + 1),
    );
  }

  void cursorReset() {
    emit(
      state.copyWith(cursor: 1),
    );
  }
}
