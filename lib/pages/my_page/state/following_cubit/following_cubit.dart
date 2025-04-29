import 'package:bookstar_app/api_service/api_service.dart';
import 'package:bookstar_app/model/member/following_dto.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'following_state.dart';

class FollowingCubit extends Cubit<FollowingState> {
  FollowingCubit() : super(FollowingState());

  Future<void> fetchFolloingList({
    required int memberId,
  }) async {
    try {
      final Response response =
          await ApiService.apiGetService(path: 'follow/following/$memberId');
      final List<dynamic> responseData = response.data as List<dynamic>;
      if (responseData.isEmpty) {
        emit(state.copyWith(followingList: []));
      } else {
        final List<FollowingDto> parsedList = responseData
            .map((item) => FollowingDto.fromJson(item as Map<String, dynamic>))
            .toList();
        emit(state.copyWith(followingList: parsedList));
        debugPrint("Following 리스트 호출 및 파싱 성공: ${parsedList.length} 명");
      }
    } catch (e) {
      debugPrint('fetchFolloingList 실패 - $e');
      emit(state.copyWith(followingList: []));
    }
  }
}
