import 'package:bookstar_app/constants/bookstar_color.dart';
import 'package:bookstar_app/constants/bookstar_typography.dart';
import 'package:flutter/material.dart';

class PrimaryBtn extends StatelessWidget {
  final bool isAble;
  final String text;
  final VoidCallback onTap;

  const PrimaryBtn({
    super.key,
    required this.isAble,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isAble ? BookstarColor.greyColor3 : BookstarColor.greyColor6,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
          child: SizedBox(
            width: 261,
            child: Text(
              text,
              style: BookstarTypography.body5.copyWith(
                color: BookstarColor.whiteColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
