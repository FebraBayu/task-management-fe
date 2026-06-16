import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:test_task_tracker/pages/task_list/component/shimmer_box.dart';

class DetailShimmer extends StatelessWidget {
  const DetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        ShimmerBox(height: 56.sp, width: double.infinity),
        SizedBox(height: 12.sp),
        ShimmerBox(height: 132.sp, width: double.infinity),
        SizedBox(height: 16.sp),
        Row(
          children: [
            Expanded(
              child: ShimmerBox(
                height: 48.sp,
                width: MediaQuery.sizeOf(context).width,
              ),
            ),
            SizedBox(width: 12.sp),
            Expanded(
              child: ShimmerBox(
                height: 48.sp,
                width: MediaQuery.sizeOf(context).width,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.sp),
        ShimmerBox(height: 48.sp, width: double.infinity),
      ],
    );
  }
}
