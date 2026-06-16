import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_tracker/data/repositories/task_repository.dart';
import 'package:test_task_tracker/pages/task_list/bloc/event/task_list_event.dart';
import 'package:test_task_tracker/pages/task_list/bloc/state/task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  TaskListBloc({required TaskRepository repository})
    : _repository = repository,
      super(const TaskListState()) {
    on<TaskListIdleEvent>(_onIdle);
    on<TaskListStarted>(_onStarted);
    on<TaskListRefreshed>(_onRefreshed);
    on<TaskListLoadedMore>(_onLoadedMore);
  }

  final TaskRepository _repository;

  void _onIdle(TaskListIdleEvent event, Emitter<TaskListState> emit) {
    emit(state.copyWith(status: TaskListStatus.idle, message: ''));
  }

  Future<void> _onStarted(
    TaskListStarted event,
    Emitter<TaskListState> emit,
  ) async {
    emit(state.copyWith(status: TaskListStatus.loading, message: ''));
    await _loadTasks(emit, page: event.page, limit: event.limit);
  }

  Future<void> _onRefreshed(
    TaskListRefreshed event,
    Emitter<TaskListState> emit,
  ) async {
    emit(state.copyWith(status: TaskListStatus.loading, message: ''));
    await _loadTasks(emit, page: event.page, limit: event.limit);
  }

  Future<void> _onLoadedMore(
    TaskListLoadedMore event,
    Emitter<TaskListState> emit,
  ) async {
    emit(state.copyWith(status: TaskListStatus.loadingMore, message: ''));
    try {
      final tasks = await _repository.getTasks(
        page: event.page,
        limit: event.limit,
      );
      emit(
        state.copyWith(
          status: TaskListStatus.loadMoreSuccess,
          tasks: tasks,
          page: event.page,
          hasMore: tasks.length >= event.limit,
          message: '',
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: TaskListStatus.loadMoreFailure,
          message: 'Gagal memuat data berikutnya',
        ),
      );
    }
  }

  Future<void> _loadTasks(
    Emitter<TaskListState> emit, {
    required int page,
    required int limit,
  }) async {
    try {
      final tasks = await _repository.getTasks(page: page, limit: limit);
      emit(
        state.copyWith(
          status: TaskListStatus.success,
          tasks: tasks,
          page: page,
          hasMore: tasks.length >= limit,
          message: '',
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: TaskListStatus.failure,
          message: 'Gagal memuat daftar task',
        ),
      );
    }
  }
}
