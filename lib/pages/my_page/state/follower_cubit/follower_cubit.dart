import 'package:bookstar_app/api_service/api_service.dart';
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
      final List<dynamic> responseData = response.data as List<dynamic>;
      if (responseData.isEmpty) {
        emit(state.copyWith(followerList: []));
      } else {
        final List<FollowerDto> parsedList = responseData
            .map((item) => FollowerDto.fromJson(item as Map<String, dynamic>))
            .toList();
        emit(state.copyWith(followerList: parsedList));
        debugPrint("Follower 리스트 호출 및 파싱 성공: ${parsedList.length} 명");
      }
    } catch (e) {
      debugPrint('fetchFollowerList 실패 - $e');
      emit(state.copyWith(followerList: []));
    }
  }
}
