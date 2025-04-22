import 'package:bookstar_app/api_service/api_service.dart';
import 'package:bookstar_app/model/pheed/post_item_responses_dto.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pheed_state.dart';

class PheedCubit extends Cubit<PheedState> {
  PheedCubit() : super(PheedState());

  Future<void> fetchNewFeedItems() async {
    try {
      final Response response =
          await ApiService.apiGetService(path: 'pheed/new');
      final Map<String, dynamic> responseData = response.data;
      final List<dynamic> rawList = responseData['postItemResponses'];
      final List<PostItemResponse> items = rawList.map((itemJson) {
        return PostItemResponse.fromJson(itemJson);
      }).toList();
      emit(state.copyWith(newItems: items));
      debugPrint("pheed/new 호출 및 파싱 성공: ${items.length} items loaded.");
    } catch (e) {
      debugPrint('fetchNewFeedItems 실패 - $e');
    }
  }
}
