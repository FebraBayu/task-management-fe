enum CreateTaskStatus { initial, idle, loading, loaded, error }

class CreateTaskState {
  const CreateTaskState({
    this.status = CreateTaskStatus.initial,
    this.message = '',
  });

  final CreateTaskStatus status;
  final String message;

  CreateTaskState copyWith({CreateTaskStatus? status, String? message}) {
    return CreateTaskState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
