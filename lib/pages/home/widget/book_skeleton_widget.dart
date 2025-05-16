import 'package:bookstar_app/global/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class BookSkeleton extends StatelessWidget {
  const BookSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: Functions.skeletonFrame(height: 180, width: 120),
            ),
            Gap(20),
            SizedBox(
              width: 120,
              child: Functions.skeletonFrame(height: 180, width: 120),
            ),
            Gap(20),
            SizedBox(
              width: 120,
              child: Functions.skeletonFrame(height: 180, width: 120),
            ),
          ],
        ),
      ),
    );
  }
}
