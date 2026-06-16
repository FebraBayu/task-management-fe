import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TaskStatusActions extends StatelessWidget {
  const TaskStatusActions({
    super.key,
    required this.status,
    required this.isSaving,
    required this.onChanged,
  });

  final String status;
  final bool isSaving;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDone = status.toLowerCase() == 'done';

    return Container(
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isSaving || !isDone
                  ? null
                  : () => onChanged('Pending'),
              child: const Text('Mark Pending'),
            ),
          ),
          SizedBox(width: 12.sp),
          Expanded(
            child: FilledButton(
              onPressed: isSaving || isDone ? null : () => onChanged('Done'),
              child: const Text('Mark Done'),
            ),
          ),
        ],
      ),
    );
  }
}
