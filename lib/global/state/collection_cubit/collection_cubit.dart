import 'package:bookstar_app/api_service/api_service.dart';
import 'package:bookstar_app/model/collection/collection_list_dto.dart';
import 'package:bookstar_app/model/common_dto.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'collection_state.dart';

class CollectionCubit extends Cubit<CollectionState> {
  CollectionCubit() : super(CollectionState());

  Future<void> fetchCollection({
    required int memberId,
  }) async {
    try {
      final Response response = await ApiService.apiGetService(
        path: 'collections/$memberId',
        options: Options(
          extra: {'requiresToken': true},
        ),
      );
      if (response.data is Map<String, dynamic>) {
        final CommonDto<List<CollectionListDto>> commonResponse =
            CommonDto<List<CollectionListDto>>.fromJson(
          response.data,
          (jsonData) {
            if (jsonData is List) {
              return jsonData
                  .map((item) =>
                      CollectionListDto.fromJson(item as Map<String, dynamic>))
                  .toList();
            }
            debugPrint('fetchCollection - 데이터가 리스트형식이 아닙니다: $jsonData');
            throw Exception('데이터 포맷 일치해야함!!');
          },
        );
        emit(state.copyWith(collectionList: commonResponse.data));
      }
    } catch (e) {
      debugPrint('fetchCollection - 데이터 오류 발생: $e');
    }
  }

  Future<void> postNewCollection({
    required String name,
    required String description,
    required Map<String, dynamic> bookInfos,
  }) async {
    try {
      Map<String, dynamic> jsonBody = {
        "name": name,
        "description": description,
        "bookInfos": [bookInfos],
      };
      await ApiService.apiPostService(
        path: 'collections/collection',
        options: Options(
          extra: {'requiresToken': true},
        ),
        body: jsonBody,
      );
    } catch (e) {
      debugPrint('fetchCollection - 데이터 오류 발생: $e');
    }
  }
}
