sealed class TaskListEvent {}

class TaskListIdleEvent extends TaskListEvent {
  TaskListIdleEvent();
}

class TaskListStarted extends TaskListEvent {
  TaskListStarted({required this.page, required this.limit});

  final int page;
  final int limit;
}

class TaskListRefreshed extends TaskListEvent {
  TaskListRefreshed({required this.page, required this.limit});

  final int page;
  final int limit;
}

class TaskListLoadedMore extends TaskListEvent {
  TaskListLoadedMore({required this.page, required this.limit});

  final int page;
  final int limit;
}
