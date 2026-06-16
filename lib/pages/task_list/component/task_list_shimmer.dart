import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:test_task_tracker/pages/task_list/component/shimmer_box.dart';

class TaskListShimmer extends StatelessWidget {
  const TaskListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 12.sp),
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ShimmerBox(
                        height: 18.sp,
                        width: MediaQuery.sizeOf(context).width,
                      ),
                    ),
                    SizedBox(width: 16.sp),
                    ShimmerBox(
                      height: 26.sp,
                      width: 70.sp,
                      borderRadius: 999.sp,
                    ),
                  ],
                ),
                SizedBox(height: 12.sp),
                ShimmerBox(height: 14.sp, width: double.infinity),
                SizedBox(height: 8.sp),
                ShimmerBox(
                  height: 14.sp,
                  width: MediaQuery.sizeOf(context).width * 0.55,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
