import 'package:bookstar_app/api_service/api_service.dart';
import 'package:bookstar_app/main.dart';
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
      final Response response = await ApiService.apiGetService(
        path: 'follow/followers/$memberId',
        options: Options(
          extra: {'requiresToken': true},
        ),
      );
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
        emit(state.copyWith(followerList: commonResponse.data));
      }
    } catch (e) {
      debugPrint('fetchFollowerList 실패 - $e');
      emit(state.copyWith(followerList: []));
    }
  }

  Future<void> checkFollowing({
    required int memberId,
  }) async {
    try {
      final int? myId = prefs.getInt('memberId');
      final Response response = await ApiService.apiGetService(
        path: 'follow/following/$myId',
        options: Options(
          extra: {'requiresToken': true},
        ),
      );
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
            debugPrint('fetchFollowingList - 데이터가 리스트형식이 아닙니다: $jsonData');
            throw Exception('데이터 포맷 일치해야함!!');
          },
        );

        bool isFollower = false;
        isFollower = commonResponse.data
            .any((followerDto) => followerDto.memberId == memberId);
        emit(state.copyWith(isFollow: isFollower));
      }
    } catch (e) {
      debugPrint('checkFollowing 실패 - $e');
      emit(state.copyWith(isFollow: false));
    }
  }

  Future<void> deleteFollower({
    required int followerID,
  }) async {
    try {
      final Response response = await ApiService.apiDeleteService(
        path: 'follow/$followerID/follower',
        options: Options(
          extra: {'requiresToken': true},
        ),
      );
      emit(state.copyWith(isFollow: false));
      debugPrint('deleteFollower 성공 - $response');
    } catch (e) {
      debugPrint('deleteFollower 실패 - $e');
    }
  }
}
