import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bookstar_app/api_service/api_service.dart';
import 'package:bookstar_app/pages/scrap/state/scrap_text_dto.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

part 'scrap_text_state.dart';

/// 스크랩 텍스트 Cubit
class ScrapTextCubit extends Cubit<ScrapTextState> {
  ScrapTextCubit() : super(const ScrapTextState());

  Future<void> postScrap(ScrapTextDto scrapText) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final response = await ApiService.apiPostService(
        path: 'scrap',
        body: scrapText.toJson(),
        options: Options(
          extra: {'requiresToken': true},
        ),
      );

      final data = response.data['data'];
      if (data != null) {
        emit(state.copyWith(
          scrapImageUrl: data,
          isLoading: false,
        ));

        if (scrapText.images.isNotEmpty) {
          await _uploadImage(data, scrapText.images[0]);
        }
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: '스크랩 생성에 실패했습니다.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _uploadImage(String url, File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'image/png',
        },
        body: bytes,
      );

      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 204) {
        throw Exception('이미지 업로드에 실패했습니다: ${response.statusCode}');
      }
    } catch (e) {
      emit(state.copyWith(error: '이미지 업로드 중 오류가 발생했습니다: $e'));
    }
  }
}
