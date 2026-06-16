import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isDone = status.toLowerCase() == 'done';
    final backgroundColor = isDone
        ? const Color(0xFFF0FDF4)
        : const Color(0xFFFFFBEB);
    final foregroundColor = isDone
        ? const Color(0xFF166534)
        : const Color(0xFF92400E);
    final borderColor = isDone
        ? const Color(0xFFBBF7D0)
        : const Color(0xFFFDE68A);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.sp),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        isDone ? 'Done' : 'Pending',
        style: TextStyle(
          color: foregroundColor,
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
