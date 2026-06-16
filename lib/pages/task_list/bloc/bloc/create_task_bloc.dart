import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_tracker/data/repositories/task_repository.dart';
import 'package:test_task_tracker/pages/task_list/bloc/event/create_task_event.dart';
import 'package:test_task_tracker/pages/task_list/bloc/state/create_task_state.dart';

class CreateTaskBloc extends Bloc<CreateTaskEvent, CreateTaskState> {
  CreateTaskBloc({required TaskRepository repository})
    : _repository = repository,
      super(const CreateTaskState()) {
    on<CreateTaskIdleEvent>(_onIdle);
    on<CreateTaskSubmitEvent>(_onSubmit);
  }

  final TaskRepository _repository;

  void _onIdle(CreateTaskIdleEvent event, Emitter<CreateTaskState> emit) {
    emit(state.copyWith(status: CreateTaskStatus.idle, message: ''));
  }

  Future<void> _onSubmit(
    CreateTaskSubmitEvent event,
    Emitter<CreateTaskState> emit,
  ) async {
    emit(state.copyWith(status: CreateTaskStatus.loading, message: ''));
    try {
      await _repository.createTask(
        title: event.title,
        description: event.description,
      );
      emit(
        state.copyWith(
          status: CreateTaskStatus.loaded,
          message: 'Task berhasil ditambahkan',
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: CreateTaskStatus.error,
          message: 'Gagal menambahkan task',
        ),
      );
    }
  }
}
