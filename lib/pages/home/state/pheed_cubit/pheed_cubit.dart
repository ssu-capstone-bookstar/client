import 'package:bookstar_app/api_service/api_service.dart';
import 'package:bookstar_app/model/pheed/ai_recommed_book_dto.dart';
import 'package:bookstar_app/model/pheed/pheed_item_dto.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pheed_state.dart';

class PheedCubit extends Cubit<PheedState> {
  PheedCubit() : super(PheedState());

  Future<void> fetchMyFeedItems() async {
    try {
      final Response response = await ApiService.apiGetService(
        path: 'pheed/me',
        options: Options(
          extra: {'requiresToken': true},
        ),
      );
      final Map<String, dynamic> responseData = response.data;
      final List<dynamic> rawList = responseData['postItemResponses'];
      final List<PheedItemDto> items = rawList.map((itemJson) {
        return PheedItemDto.fromJson(itemJson);
      }).toList();
      emit(state.copyWith(pheedMyItems: items));
      debugPrint("pheed 호출 및 파싱 성공: ${items.length} items loaded.");
    } catch (e) {
      debugPrint('fetchFeedItems 실패 - $e');
    }
  }

  Future<void> fetchNewFeedItems() async {
    try {
      final Response response = await ApiService.apiGetService(
        path: 'pheed/new',
        options: Options(
          extra: {'requiresToken': true},
        ),
      );
      final Map<String, dynamic> responseData = response.data;
      final List<dynamic> rawList = responseData['postItemResponses'];
      final List<PheedItemDto> items = rawList.map((itemJson) {
        return PheedItemDto.fromJson(itemJson);
      }).toList();
      emit(state.copyWith(pheedNewItems: items));
      debugPrint("pheed/new 호출 및 파싱 성공: ${items.length} items loaded.");
    } catch (e) {
      debugPrint('fetchNewFeedItems 실패 - $e');
    }
  }

  Future<void> fetchAiRecommendBook({
    required int userId,
  }) async {
    try {
      final Response response = await ApiService.aiPostService(
        path: 'recommend_books',
        body: {
          'user_id': userId,
        },
      );
      final Map<String, dynamic> responseData = response.data;
      final List<dynamic> rawList = responseData['recommendations'];
      final List<AiRecommedBookDto> items = rawList.map((itemJson) {
        return AiRecommedBookDto.fromJson(itemJson);
      }).toList();
      emit(state.copyWith(aiRecommedBooks: items));
      debugPrint(
          "fetchAiRecommendBook 호출 및 파싱 성공: ${items.length} items loaded.");
    } catch (e) {
      debugPrint('fetchAiRecommendBook 실패 - $e');
    }
  }

  Future<void> fetchFriendsFeedItems() async {
    try {
      final Response response = await ApiService.apiGetService(
        path: 'pheed',
        options: Options(
          extra: {'requiresToken': true},
        ),
      );
      final Map<String, dynamic> responseData = response.data;
      final List<dynamic> rawList = responseData['postItemResponses'];
      final List<PheedItemDto> items = rawList.map((itemJson) {
        return PheedItemDto.fromJson(itemJson);
      }).toList();
      emit(state.copyWith(pheedItems: items));
      debugPrint("pheed 호출 및 파싱 성공: ${items.length} items loaded.");
    } catch (e) {
      debugPrint('fetchFriendsFeedItems 실패 - $e');
    }
  }
}
