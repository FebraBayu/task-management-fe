import 'package:test_task_tracker/models/task.dart';

enum TaskDetailStatus { initial, idle, loading, success, failure }

class TaskDetailState {
  const TaskDetailState({
    this.status = TaskDetailStatus.initial,
    this.task,
    this.message = '',
  });

  final TaskDetailStatus status;
  final Task? task;
  final String message;

  TaskDetailState copyWith({
    TaskDetailStatus? status,
    Task? task,
    String? message,
  }) {
    return TaskDetailState(
      status: status ?? this.status,
      task: task ?? this.task,
      message: message ?? this.message,
    );
  }
}
