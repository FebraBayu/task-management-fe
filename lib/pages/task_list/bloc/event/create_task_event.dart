sealed class CreateTaskEvent {}

class CreateTaskIdleEvent extends CreateTaskEvent {}

class CreateTaskSubmitEvent extends CreateTaskEvent {
  CreateTaskSubmitEvent({required this.title, required this.description});

  final String title;
  final String description;
}
