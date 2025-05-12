import 'package:bookstar_app/api_service/api_service.dart';
import 'package:bookstar_app/model/common_dto.dart';
import 'package:bookstar_app/model/member/following_dto.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'following_state.dart';

class FollowingCubit extends Cubit<FollowingState> {
  FollowingCubit() : super(FollowingState());

  Future<void> fetchFollowingList({
    required int memberId,
  }) async {
    try {
      final Response response =
          await ApiService.apiGetService(path: 'follow/following/$memberId');
      if (response.data is Map<String, dynamic>) {
        final CommonDto<List<FollowingDto>> commonResponse =
            CommonDto<List<FollowingDto>>.fromJson(
          response.data,
          (jsonData) {
            if (jsonData is List) {
              return jsonData
                  .map((item) =>
                      FollowingDto.fromJson(item as Map<String, dynamic>))
                  .toList();
            }
            debugPrint('fetchFollowingList - 데이터가 리스트형식이 아닙니다: $jsonData');
            throw Exception('데이터 포맷 일치해야함!!');
          },
        );
        emit(state.copyWith(followingList: commonResponse.data));
      }
    } catch (e) {
      debugPrint('fetchFollowingList 실패 - $e');
      emit(state.copyWith(followingList: []));
    }
  }
}
