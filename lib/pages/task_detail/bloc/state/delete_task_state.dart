enum DeleteTaskStatus { initial, idle, loading, loaded, error }

class DeleteTaskState {
  const DeleteTaskState({
    this.status = DeleteTaskStatus.initial,
    this.message = '',
  });

  final DeleteTaskStatus status;
  final String message;

  DeleteTaskState copyWith({DeleteTaskStatus? status, String? message}) {
    return DeleteTaskState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
