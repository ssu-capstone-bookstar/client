import 'package:bookstar_app/api_service/api_service.dart';
import 'package:bookstar_app/model/member/member_dto.dart';
import 'package:bookstar_app/model/member/profile_else_dto.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  Future<void> fetchProfile({
    required int memberId,
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

  Future<void> fetchProfileElse({
    required int memberId,
  }) async {
    try {
      final Response response =
          await ApiService.apiGetService(path: 'member/$memberId/profileInfo');
      final Map<String, dynamic> responseData = response.data;
      final ProfileElseDto profileElseDto =
          ProfileElseDto.fromJson(responseData);
      emit(state.copyWith(profileElseDto: profileElseDto));
      debugPrint("ProfileElseDto 호출 및 파싱 성공");
    } catch (e) {
      debugPrint('fetchProfileElse 실패 - $e');
    }
  }

  Future<void> putProfileNickname({
    required String nickname,
    required int memberId,
  }) async {
    try {
      final Response response = await ApiService.apiPatchService(
        path: 'member/nickName',
        body: {'nickName': nickname},
      );
      if (response.statusCode == 200) {
        fetchProfile(memberId: memberId);
      }
      debugPrint("닉네임 변경 성공");
    } catch (e) {
      debugPrint('putProfileNickname 실패 - $e');
    }
  }
}
