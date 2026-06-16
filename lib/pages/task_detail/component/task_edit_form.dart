import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:test_task_tracker/models/task.dart';

class TaskEditForm extends StatefulWidget {
  const TaskEditForm({
    super.key,
    required this.task,
    required this.isSaving,
    required this.onSubmit,
  });

  final Task task;
  final bool isSaving;
  final void Function(String title, String description) onSubmit;

  @override
  State<TaskEditForm> createState() => _TaskEditFormState();
}

class _TaskEditFormState extends State<TaskEditForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description,
    );
  }

  @override
  void didUpdateWidget(covariant TaskEditForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task.id != widget.task.id ||
        oldWidget.task.title != widget.task.title ||
        oldWidget.task.description != widget.task.description) {
      _titleController.text = widget.task.title;
      _descriptionController.text = widget.task.description;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    widget.onSubmit(
      _titleController.text.trim(),
      _descriptionController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Padding(
        padding: EdgeInsets.all(18.sp),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Task',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 16.sp),
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.sp),
              TextFormField(
                controller: _descriptionController,
                minLines: 4,
                maxLines: 7,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.sp),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: widget.isSaving ? null : _submit,
                  child: Text(
                    widget.isSaving ? 'Menyimpan...' : 'Simpan Perubahan',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
