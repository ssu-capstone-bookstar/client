import 'package:bookstar_app/constants/bookstar_color.dart';
import 'package:bookstar_app/constants/bookstar_typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomToggleBtnText extends StatefulWidget {
  const CustomToggleBtnText({super.key});

  @override
  State<CustomToggleBtnText> createState() => _CustomToggleBtnTextState();
}

class _CustomToggleBtnTextState extends State<CustomToggleBtnText> {
  bool toggle = true;

  final double toggleContainerWidth = 60;
  final double toggleContainerHeight = 30;
  final double innerPadding = 2;
  final double thumbsize = 24;
  final Duration animationDuration = const Duration(milliseconds: 250);
  final Curve animationCurve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    final double innerTrackWidth = toggleContainerWidth - (innerPadding * 2);
    final double thumbPositionSell = innerTrackWidth - thumbsize;

    return GestureDetector(
      onTap: () {
        setState(() {
          toggle = !toggle;
        });
      },
      child: Container(
        width: toggleContainerWidth,
        height: toggleContainerHeight,
        padding: EdgeInsets.all(innerPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: BookstarColor.greyColor3,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: animationDuration,
              curve: animationCurve,
              left: toggle ? thumbPositionSell : 0.0,
              top: 0,
              bottom: 0,
              child: Container(
                width: thumbsize,
                height: thumbsize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: BookstarColor.whiteColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      '주',
                      style: BookstarTypography.body9.copyWith(
                        color: toggle
                            ? BookstarColor.dimColor1
                            : BookstarColor.blackColor,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      '월',
                      style: BookstarTypography.body9.copyWith(
                        color: toggle
                            ? BookstarColor.blackColor
                            : BookstarColor.dimColor1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
