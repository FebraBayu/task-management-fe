enum UpdateTaskStatusStatus { initial, idle, loading, loaded, error }

class UpdateTaskStatusState {
  const UpdateTaskStatusState({
    this.status = UpdateTaskStatusStatus.initial,
    this.message = '',
  });

  final UpdateTaskStatusStatus status;
  final String message;

  UpdateTaskStatusState copyWith({
    UpdateTaskStatusStatus? status,
    String? message,
  }) {
    return UpdateTaskStatusState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
