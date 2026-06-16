import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_tracker/data/repositories/task_repository.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/event/update_task_status_event.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/state/update_task_status_state.dart';

class UpdateTaskStatusBloc
    extends Bloc<UpdateTaskStatusEvent, UpdateTaskStatusState> {
  UpdateTaskStatusBloc({required TaskRepository repository})
    : _repository = repository,
      super(const UpdateTaskStatusState()) {
    on<UpdateTaskStatusIdleEvent>(_onIdle);
    on<UpdateTaskStatusSubmitEvent>(_onSubmit);
  }

  final TaskRepository _repository;

  void _onIdle(
    UpdateTaskStatusIdleEvent event,
    Emitter<UpdateTaskStatusState> emit,
  ) {
    emit(state.copyWith(status: UpdateTaskStatusStatus.idle, message: ''));
  }

  Future<void> _onSubmit(
    UpdateTaskStatusSubmitEvent event,
    Emitter<UpdateTaskStatusState> emit,
  ) async {
    emit(state.copyWith(status: UpdateTaskStatusStatus.loading, message: ''));
    try {
      await _repository.updateTaskStatus(id: event.id, status: event.status);
      emit(
        state.copyWith(
          status: UpdateTaskStatusStatus.loaded,
          message: 'Status berhasil diperbarui',
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: UpdateTaskStatusStatus.error,
          message: 'Gagal memperbarui status',
        ),
      );
    }
  }
}
