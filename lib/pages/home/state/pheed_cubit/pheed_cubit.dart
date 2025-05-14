import 'package:bookstar_app/api_service/api_service.dart';
import 'package:bookstar_app/model/pheed/post_item_responses_dto.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pheed_state.dart';

class PheedCubit extends Cubit<PheedState> {
  PheedCubit() : super(PheedState());

  Future<void> fetchFeedItems() async {
    try {
      final Response response = await ApiService.apiGetService(
        path: 'pheed/me',
        options: Options(
          extra: {'requiresToken': true},
        ),
      );
      final Map<String, dynamic> responseData = response.data;
      final List<dynamic> rawList = responseData['postItemResponses'];
      final List<PostItemResponse> items = rawList.map((itemJson) {
        return PostItemResponse.fromJson(itemJson);
      }).toList();
      emit(state.copyWith(pheedItems: items));
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
      final List<PostItemResponse> items = rawList.map((itemJson) {
        return PostItemResponse.fromJson(itemJson);
      }).toList();
      emit(state.copyWith(pheedNewItems: items));
      debugPrint("pheed/new 호출 및 파싱 성공: ${items.length} items loaded.");
    } catch (e) {
      debugPrint('fetchNewFeedItemsㅅ 실패 - $e');
    }
  }

  // Future<void> fetchMyFeedItems() async {
  //   try {
  //     final Response response = await ApiService.apiGetService(
  //       path: 'pheed/new',
  //       options: Options(
  //         extra: {'requiresToken': true},
  //       ),
  //     );
  //     final Map<String, dynamic> responseData = response.data;
  //     final List<dynamic> rawList = responseData['postItemResponses'];
  //     final List<PostItemResponse> items = rawList.map((itemJson) {
  //       return PostItemResponse.fromJson(itemJson);
  //     }).toList();
  //     emit(state.copyWith(pheedMyItems: items));
  //     debugPrint("pheed/my 호출 및 파싱 성공: ${items.length} items loaded.");
  //   } catch (e) {
  //     debugPrint('fetchMyFeedItems 실패 - $e');
  //   }
  // }
}
