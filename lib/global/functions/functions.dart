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

  static Widget skeletonFrame({
    EdgeInsets padding = EdgeInsets.zero,
    BoxShape shape = BoxShape.rectangle,
    double borderRadius = 12,
    required double height,
    required double width,
  }) {
    return Padding(
      padding: padding,
      child: ClipRect(
        child: DecoratedBox(
          decoration: BoxDecoration(
              shape: shape,
              borderRadius: shape == BoxShape.circle
                  ? null
                  : BorderRadius.all(Radius.circular(borderRadius)),
              color: Colors.white),
          child: SizedBox(
            height: height,
            width: width,
          ),
        ),
      ),
    );
  }
}
