import 'package:bookstar_app/constants/bookstar_color.dart';
import 'package:bookstar_app/constants/bookstar_typography.dart';
import 'package:flutter/material.dart';

class SecondaryBtn extends StatelessWidget {
  final bool isPressed;
  final String text;
  final VoidCallback onTap;

  const SecondaryBtn({
    super.key,
    required this.isPressed,
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
          color:
              isPressed ? BookstarColor.greyColor2 : BookstarColor.greyColor4,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
          child: SizedBox(
            width: 261,
            child: Text(
              text,
              style: BookstarTypography.body5,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
