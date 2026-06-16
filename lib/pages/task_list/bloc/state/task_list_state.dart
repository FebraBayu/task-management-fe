import 'package:test_task_tracker/models/task.dart';

enum TaskListStatus {
  initial,
  idle,
  loading,
  loadingMore,
  success,
  loadMoreSuccess,
  failure,
  loadMoreFailure,
}

class TaskListState {
  const TaskListState({
    this.status = TaskListStatus.initial,
    this.tasks = const [],
    this.message = '',
    this.page = 1,
    this.hasMore = true,
  });

  final TaskListStatus status;
  final List<Task> tasks;
  final String message;
  final int page;
  final bool hasMore;

  TaskListState copyWith({
    TaskListStatus? status,
    List<Task>? tasks,
    String? message,
    int? page,
    bool? hasMore,
  }) {
    return TaskListState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      message: message ?? this.message,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
