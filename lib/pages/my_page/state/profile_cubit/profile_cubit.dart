import 'dart:io';

import 'package:bookstar_app/api_service/api_service.dart';
import 'package:bookstar_app/model/common_dto.dart';
import 'package:bookstar_app/model/member/profile_dto.dart';
import 'package:bookstar_app/model/member/profile_else_dto.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  Future<void> fetchProfile({
    required int memberId,
  }) async {
    try {
      final Response response = await ApiService.apiGetService(
        path: 'member/$memberId',
        options: Options(
          extra: {'requiresToken': true},
        ),
      );
      if (response.data is Map<String, dynamic>) {
        final CommonDto<ProfileDto> commonResponse =
            CommonDto<ProfileDto>.fromJson(
          response.data,
          (jsonData) => ProfileDto.fromJson(jsonData as Map<String, dynamic>),
        );
        emit(state.copyWith(memberDto: commonResponse.data));
        debugPrint("Member 호출 및 파싱 성공");
      }
    } catch (e) {
      debugPrint('fetchProfile 실패 - $e');
    }
  }

  Future<void> fetchProfileElse({
    required int memberId,
  }) async {
    try {
      final Response response = await ApiService.apiGetService(
        path: 'member/$memberId/profileInfo',
        options: Options(
          extra: {'requiresToken': true},
        ),
      );
      if (response.data is Map<String, dynamic>) {
        final CommonDto<ProfileElseDto> commonResponse =
            CommonDto<ProfileElseDto>.fromJson(
          response.data,
          (jsonData) =>
              ProfileElseDto.fromJson(jsonData as Map<String, dynamic>),
        );
        emit(state.copyWith(profileElseDto: commonResponse.data));
        debugPrint("ProfileElseDto 호출 및 파싱 성공");
      }
    } catch (e) {
      debugPrint('fetchProfileElse 실패 - $e');
    }
  }

  Future<void> patchProfileNickname({
    required String nickname,
    required int memberId,
  }) async {
    try {
      final Response response = await ApiService.apiPatchService(
        path: 'member/nickName',
        queryParameters: {'nickname': nickname},
        options: Options(
          extra: {'requiresToken': true},
        ),
      );
      if (response.statusCode == 200) {
        fetchProfile(memberId: memberId);
      }
      debugPrint("닉네임 변경 성공");
    } catch (e) {
      debugPrint('patchProfileNickname 실패 - $e');
    }
  }

  void writing() {
    emit(state.copyWith(isWrite: true));
  }

  void notWriting() {
    emit(state.copyWith(isWrite: false));
  }

  Future<void> pickImage({
    required int memberId,
  }) async {
    XFile? file;
    try {
      final ImagePicker picker = ImagePicker();
      file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        patchProfileImage(
          filePath: File(file.path),
          memberId: memberId,
        );
      }
    } catch (e) {
      debugPrint('pickImage 실패 - $e');
    }
  }

  Future<void> patchProfileImage({
    required File filePath,
    required int memberId,
  }) async {
    try {
      final Response response = await ApiService.apiPatchService(
        path: 'member/profileImage',
        queryParameters: {'fileName': filePath.path.split('/').last},
        options: Options(
          extra: {'requiresToken': true},
        ),
      );
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          final CommonDto<String> commonResponse = CommonDto<String>.fromJson(
            response.data,
            (jsonData) => jsonData as String,
          );
          try {
            final Response uploadResponse =
                await ApiService.awsPutFileToPresignedUrl(
              presignedUrl: commonResponse.data,
              file: filePath,
            );
            if (uploadResponse.statusCode == 200) {
              fetchProfile(memberId: memberId);
            }
          } catch (e) {
            debugPrint('Aws업로드 실패 - $e');
          }
        }
      }
      debugPrint("아바타 변경 성공");
    } catch (e) {
      debugPrint('patchProfileImage 실패 - $e');
    }
  }
}
