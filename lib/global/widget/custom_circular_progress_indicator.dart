import 'dart:math' as math;

import 'package:bookstar_app/constants/bookstar_color.dart';
import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatefulWidget {
  const CustomCircularProgressIndicator({
    super.key,
  });

  @override
  State<CustomCircularProgressIndicator> createState() =>
      _CustomCircularProgressIndicatorState();
}

class _CustomCircularProgressIndicatorState
    extends State<CustomCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size(50, 50),
            painter: _CircularDotsPainter(
              progress: _controller.value,
            ),
          );
        },
      ),
    );
  }
}

class _CircularDotsPainter extends CustomPainter {
  final double progress;

  _CircularDotsPainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double dotRadius = 4.0;
    final double effectiveRadius = math.min(centerX, centerY) - dotRadius * 1.5;
    final int dotCount = 8;

    final Paint paint = Paint()..style = PaintingStyle.fill;

    int headDotIndex = (progress * dotCount).floor() % dotCount;

    for (int i = 0; i < dotCount; i++) {
      final double angle = (2 * math.pi / dotCount) * i - (math.pi / 2);

      int offset = (i - headDotIndex + dotCount) % dotCount;

      Color dotColor;

      if (offset == 0) {
        dotColor = BookstarColor.greyColor6;
      } else if (offset >= 1 && offset <= 5) {
        dotColor = BookstarColor.greyColor5;
      } else if (offset == 6 && dotCount > 6) {
        dotColor = BookstarColor.greyColor3;
      } else if (offset == 7 && dotCount > 7) {
        dotColor = BookstarColor.greyColor2;
      } else {
        dotColor = BookstarColor.greyColor2;
      }

      paint.color = dotColor;

      final double dotX = centerX + effectiveRadius * math.cos(angle);
      final double dotY = centerY + effectiveRadius * math.sin(angle);

      canvas.drawCircle(Offset(dotX, dotY), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(_CircularDotsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
