import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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

  static void globalModal({
    required BuildContext context,
    required Widget widget,
    required String title,
    required String content,
    required VoidCallback submitTap,
    required VoidCallback cancelTap,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title),
                Gap(20),
                Text(content),
                Gap(20),
                widget,
                Gap(20),
                Row(
                  children: [
                    CupertinoButton(
                      onPressed: cancelTap,
                      child: Text('취소'),
                    ),
                    CupertinoButton(
                      onPressed: submitTap,
                      child: Text('확인'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
