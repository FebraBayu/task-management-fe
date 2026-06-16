sealed class UpdateTaskEvent {}

class UpdateTaskIdleEvent extends UpdateTaskEvent {}

class UpdateTaskSubmitEvent extends UpdateTaskEvent {
  UpdateTaskSubmitEvent({
    required this.id,
    required this.title,
    required this.description,
  });

  final int id;
  final String title;
  final String description;
}
