import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_tracker/data/repositories/task_repository.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/event/update_task_event.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/state/update_task_state.dart';

class UpdateTaskBloc extends Bloc<UpdateTaskEvent, UpdateTaskState> {
  UpdateTaskBloc({required TaskRepository repository})
    : _repository = repository,
      super(const UpdateTaskState()) {
    on<UpdateTaskIdleEvent>(_onIdle);
    on<UpdateTaskSubmitEvent>(_onSubmit);
  }

  final TaskRepository _repository;

  void _onIdle(UpdateTaskIdleEvent event, Emitter<UpdateTaskState> emit) {
    emit(state.copyWith(status: UpdateTaskStatus.idle, message: ''));
  }

  Future<void> _onSubmit(
    UpdateTaskSubmitEvent event,
    Emitter<UpdateTaskState> emit,
  ) async {
    emit(state.copyWith(status: UpdateTaskStatus.loading, message: ''));
    try {
      await _repository.updateTask(
        id: event.id,
        title: event.title,
        description: event.description,
      );
      emit(
        state.copyWith(
          status: UpdateTaskStatus.loaded,
          message: 'Task berhasil diperbarui',
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: UpdateTaskStatus.error,
          message: 'Gagal memperbarui task',
        ),
      );
    }
  }
}
