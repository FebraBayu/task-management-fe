enum UpdateTaskStatus { initial, idle, loading, loaded, error }

class UpdateTaskState {
  const UpdateTaskState({
    this.status = UpdateTaskStatus.initial,
    this.message = '',
  });

  final UpdateTaskStatus status;
  final String message;

  UpdateTaskState copyWith({UpdateTaskStatus? status, String? message}) {
    return UpdateTaskState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
