import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bookstar_app/api_service/api_service.dart';
import 'package:bookstar_app/pages/scrap/state/scrap_dto.dart';
import 'package:dio/dio.dart';

part 'scrap_state.dart';

/// 스크랩 카드 Cubit
class ScrapCubit extends Cubit<ScrapState> {
  ScrapCubit() : super(const ScrapState());

  Future<void> fetchScrapDetail({
    required int memberId,
    required int scrapId,
  }) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final response = await ApiService.apiGetService(
        path: 'scrap/detail/$memberId/$scrapId',
        options: Options(
          extra: {'requiresToken': true},
        ),
      );
      final data = response.data['data'];
      if (data != null) {
        emit(state.copyWith(
          scrap: ScrapDto.fromJson(data),
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: '스크랩 정보를 찾을 수 없습니다.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}
