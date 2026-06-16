sealed class UpdateTaskStatusEvent {}

class UpdateTaskStatusIdleEvent extends UpdateTaskStatusEvent {}

class UpdateTaskStatusSubmitEvent extends UpdateTaskStatusEvent {
  UpdateTaskStatusSubmitEvent({required this.id, required this.status});

  final int id;
  final String status;
}
