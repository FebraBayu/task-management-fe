import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:test_task_tracker/models/task.dart';
import 'package:test_task_tracker/pages/task_list/component/status_badge.dart';

class TaskDetailHeader extends StatelessWidget {
  const TaskDetailHeader({super.key, required this.task});

  final Task task;

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }
    return DateFormat('dd MMM yyyy, HH:mm').format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(14.sp),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14.sp,
            offset: Offset(0, 6.sp),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(18.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    textScaler: TextScaler.noScaling,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                SizedBox(width: 12.sp),
                StatusBadge(status: task.status),
              ],
            ),
            SizedBox(height: 12.sp),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.sp),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12.sp),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                task.description,
                textScaler: TextScaler.noScaling,
                style: TextStyle(
                  color: const Color(0xFF334155),
                  fontSize: 10.sp,
                  height: 1.45,
                ),
              ),
            ),
            SizedBox(height: 16.sp),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12.sp),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dibuat: ${_formatDate(task.createdAt)}',
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                      color: const Color(0xFF64748B),
                      fontSize: 9.sp,
                    ),
                  ),
                  SizedBox(height: 4.sp),
                  Text(
                    'Diubah: ${_formatDate(task.updatedAt)}',
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                      color: const Color(0xFF64748B),
                      fontSize: 9.sp,
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
