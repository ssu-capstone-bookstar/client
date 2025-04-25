import 'package:bookstar_app/api_service/api_service.dart';
import 'package:bookstar_app/model/member/member_dto.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  Future<void> fetchProfile({
    required String memberId,
  }) async {
    try {
      final Response response =
          await ApiService.apiGetService(path: 'member/$memberId');
      final Map<String, dynamic> responseData = response.data;
      final MemberDto memberDto = MemberDto.fromJson(responseData);
      emit(state.copyWith(memberDto: memberDto));
      debugPrint("Member 호출 및 파싱 성공");
    } catch (e) {
      debugPrint('fetchProfile 실패 - $e');
    }
  }
}
