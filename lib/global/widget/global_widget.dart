import 'package:flutter/material.dart';

class GlobalWidget {
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
