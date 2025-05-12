import 'package:bookstar_app/api_service/api_service.dart';
import 'package:bookstar_app/model/common_dto.dart';
import 'package:bookstar_app/model/member/follower_dto.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'follower_state.dart';

class FollowerCubit extends Cubit<FollowerState> {
  FollowerCubit() : super(FollowerState());

  Future<void> fetchFollowerList({
    required int memberId,
  }) async {
    try {
      final Response response =
          await ApiService.apiGetService(path: 'follow/followers/$memberId');
      if (response.data is Map<String, dynamic>) {
        final CommonDto<List<FollowerDto>> commonResponse =
            CommonDto<List<FollowerDto>>.fromJson(
          response.data,
          (jsonData) {
            if (jsonData is List) {
              return jsonData
                  .map((item) =>
                      FollowerDto.fromJson(item as Map<String, dynamic>))
                  .toList();
            }
            debugPrint('fetchFollowerList - 데이터가 리스트형식이 아닙니다: $jsonData');
            throw Exception('데이터 포맷 일치해야함!!');
          },
        );
        print('111111111${commonResponse.data}');
        emit(state.copyWith(followerList: commonResponse.data));
      }
    } catch (e) {
      debugPrint('fetchFollowerList 실패 - $e');
      emit(state.copyWith(followerList: []));
    }
  }
}
