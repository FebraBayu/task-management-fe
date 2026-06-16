sealed class DeleteTaskEvent {}

class DeleteTaskIdleEvent extends DeleteTaskEvent {}

class DeleteTaskSubmitEvent extends DeleteTaskEvent {
  DeleteTaskSubmitEvent({required this.id});

  final int id;
}
