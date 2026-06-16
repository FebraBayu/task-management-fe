sealed class TaskDetailEvent {}

class TaskDetailIdleEvent extends TaskDetailEvent {}

class TaskDetailSubmitEvent extends TaskDetailEvent {
  TaskDetailSubmitEvent({required this.id});

  final int id;
}
