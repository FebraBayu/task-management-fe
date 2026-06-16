import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_tracker/data/repositories/task_repository.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/event/task_detail_event.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/state/task_detail_state.dart';

class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState> {
  TaskDetailBloc({required TaskRepository repository})
    : _repository = repository,
      super(const TaskDetailState()) {
    on<TaskDetailIdleEvent>(_onIdle);
    on<TaskDetailSubmitEvent>(_onSubmit);
  }

  final TaskRepository _repository;

  void _onIdle(TaskDetailIdleEvent event, Emitter<TaskDetailState> emit) {
    emit(state.copyWith(status: TaskDetailStatus.idle, message: ''));
  }

  Future<void> _onSubmit(
    TaskDetailSubmitEvent event,
    Emitter<TaskDetailState> emit,
  ) async {
    emit(state.copyWith(status: TaskDetailStatus.loading, message: ''));
    try {
      final task = await _repository.getTaskById(event.id);
      emit(
        state.copyWith(
          status: TaskDetailStatus.success,
          task: task,
          message: '',
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: TaskDetailStatus.failure,
          message: 'Gagal memuat detail task',
        ),
      );
    }
  }
}
