import 'package:flutter/material.dart';

/// 🏷️ 전역으로 사용하는 함수 및 메소드
class Functions {
  /// ✅ 텍스트 입력 키보드 사라지게 하는 메소드
  ///
  /// @param context - 해당 화면의 context

  static void unFocus({
    required BuildContext context,
  }) {
    FocusScope.of(context).unfocus();
  }
}
