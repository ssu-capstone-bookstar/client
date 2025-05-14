import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bookstar_app/api_service/api_service.dart';
import 'package:bookstar_app/pages/review/state/review_dto.dart';
import 'package:dio/dio.dart';

part 'review_state.dart';

/// 리뷰 카드 Cubit
class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(const ReviewState());

  Future<void> fetchReviewDetail({
    required int memberId,
    required int reviewId,
  }) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final response = await ApiService.apiGetService(
        path: 'review/detail/$reviewId',
        options: Options(
          extra: {'requiresToken': true},
        ),
      );

      final data = response.data['data'];
      if (data != null) {
        emit(state.copyWith(
          review: ReviewDto.fromJson(data),
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: '리뷰 정보를 찾을 수 없습니다.',
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
