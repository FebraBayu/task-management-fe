import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:test_task_tracker/models/task.dart';
import 'package:test_task_tracker/pages/task_detail/screen/task_detail_screen.dart';
import 'package:test_task_tracker/pages/task_list/bloc/bloc/create_task_bloc.dart';
import 'package:test_task_tracker/pages/task_list/bloc/bloc/task_list_bloc.dart';
import 'package:test_task_tracker/pages/task_list/bloc/event/create_task_event.dart';
import 'package:test_task_tracker/pages/task_list/bloc/event/task_list_event.dart';
import 'package:test_task_tracker/pages/task_list/bloc/state/create_task_state.dart';
import 'package:test_task_tracker/pages/task_list/bloc/state/task_list_state.dart';
import 'package:test_task_tracker/pages/task_list/component/add_task_sheet.dart';
import 'package:test_task_tracker/pages/task_list/component/task_card.dart';
import 'package:test_task_tracker/pages/task_list/component/task_list_shimmer.dart';

class TaskListBody extends StatefulWidget {
  const TaskListBody({super.key});

  @override
  State<TaskListBody> createState() => _TaskListBodyState();
}

class _TaskListBodyState extends State<TaskListBody> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingTask = true;
  bool _isSubmittingTask = false;
  bool _isLoadingMoreTask = false;
  bool _hasMoreTask = true;
  int _taskPage = 1;
  final int _taskLimit = 5;
  List<Task> _taskList = [];

  late TaskListBloc _taskListBloc;
  late CreateTaskBloc _createTaskBloc;

  void fetchTask({bool showLoading = true}) {
    if (showLoading) {
      setState(() {
        _taskList.clear();
        _isLoadingTask = true;
        _isLoadingMoreTask = false;
        _hasMoreTask = true;
        _taskPage = 1;
      });
    }
    _taskListBloc.add(TaskListStarted(page: 1, limit: _taskLimit));
  }

  void fetchMoreTask() {
    if (_isLoadingTask || _isLoadingMoreTask || !_hasMoreTask) {
      return;
    }
    setState(() {
      _isLoadingMoreTask = true;
    });
    _taskListBloc.add(
      TaskListLoadedMore(page: _taskPage + 1, limit: _taskLimit),
    );
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 24.sp) {
      if (notification is ScrollUpdateNotification ||
          notification is OverscrollNotification) {
        fetchMoreTask();
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _taskListBloc = context.read<TaskListBloc>();
    _createTaskBloc = context.read<CreateTaskBloc>();
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) {
        return;
      }
      final position = _scrollController.position;
      if (position.pixels >= position.maxScrollExtent - 80.sp) {
        fetchMoreTask();
      }
    });
    fetchTask();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        callback();
      }
    });
  }

  void _onRefresh() async {
    setState(() {
      _taskList.clear();
      _isLoadingTask = true;
      _isLoadingMoreTask = false;
      _hasMoreTask = true;
      _taskPage = 1;
    });
    _taskListBloc.add(TaskListRefreshed(page: 1, limit: _taskLimit));
  }

  Future<void> _showToast(String message) async {
    if (message.isEmpty) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
            textScaler: TextScaler.noScaling,
          ),
          behavior: SnackBarBehavior.floating,
          width: 82.w,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.sp),
          ),
        ),
      );
  }

  Future<void> _openAddTask(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.sp)),
      ),
      builder: (sheetContext) {
        return AddTaskSheet(
          isSubmitting: _isSubmittingTask,
          onSubmit: (title, description) {
            _createTaskBloc.add(
              CreateTaskSubmitEvent(title: title, description: description),
            );
            Navigator.of(sheetContext).pop();
          },
        );
      },
    );
  }

  Future<void> _openDetail(BuildContext context, Task task) async {
    final isUpdated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => TaskDetailScreen(taskId: task.id)),
    );

    if (isUpdated == true) {
      fetchTask();
    }
  }

  Widget _emptyState(String message) {
    return Container(
      width: 100.w,
      margin: EdgeInsets.only(top: 70.sp),
      child: Column(
        children: [
          Text(
            'Belum ada task',
            textAlign: TextAlign.center,
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
          SizedBox(height: 6.sp),
          Text(
            message,
            textAlign: TextAlign.center,
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          _onRefresh();
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              width: 100.w,
              padding: EdgeInsets.only(left: 14.sp, right: 14.sp),
              margin: EdgeInsets.only(top: 10.sp, bottom: 70.sp),
              child: BlocBuilder<CreateTaskBloc, CreateTaskState>(
                bloc: _createTaskBloc,
                builder: (BuildContext context, CreateTaskState createState) {
                  if (createState.status == CreateTaskStatus.loading) {
                    _isSubmittingTask = true;
                    _createTaskBloc.add(CreateTaskIdleEvent());
                  }

                  if (createState.status == CreateTaskStatus.error) {
                    onWidgetDidBuild(() {
                      setState(() {
                        _isSubmittingTask = false;
                      });
                      if (createState.message.isNotEmpty) {
                        _showToast(createState.message);
                      }
                    });
                    _createTaskBloc.add(CreateTaskIdleEvent());
                  }

                  if (createState.status == CreateTaskStatus.loaded) {
                    onWidgetDidBuild(() {
                      setState(() {
                        _isSubmittingTask = false;
                      });
                      if (createState.message.isNotEmpty) {
                        _showToast(createState.message);
                      }
                      fetchTask(showLoading: true);
                    });
                    _createTaskBloc.add(CreateTaskIdleEvent());
                  }

                  return BlocBuilder<TaskListBloc, TaskListState>(
                    bloc: _taskListBloc,
                    builder: (BuildContext context, TaskListState state) {
                      if (state.status == TaskListStatus.loading) {
                        _isLoadingTask = true;
                        _isLoadingMoreTask = false;
                        _taskListBloc.add(TaskListIdleEvent());
                      }

                      if (state.status == TaskListStatus.loadingMore) {
                        _isLoadingMoreTask = true;
                        _taskListBloc.add(TaskListIdleEvent());
                      }

                      if (state.status == TaskListStatus.failure) {
                        onWidgetDidBuild(() {
                          Future.delayed(const Duration(seconds: 1), () {
                            if (mounted) {
                              setState(() {
                                _isLoadingTask = false;
                                _isLoadingMoreTask = false;
                              });
                            }
                          });
                          if (state.message.isNotEmpty) {
                            _showToast(state.message);
                          }
                        });
                        _taskListBloc.add(TaskListIdleEvent());
                      }

                      if (state.status == TaskListStatus.loadMoreFailure) {
                        onWidgetDidBuild(() {
                          setState(() {
                            _isLoadingMoreTask = false;
                          });
                          if (state.message.isNotEmpty) {
                            _showToast(state.message);
                          }
                        });
                        _taskListBloc.add(TaskListIdleEvent());
                      }

                      if (state.status == TaskListStatus.success) {
                        onWidgetDidBuild(() {
                          Future.delayed(const Duration(seconds: 1), () {
                            if (mounted) {
                              setState(() {
                                _taskList = state.tasks;
                                _isLoadingTask = false;
                                _isSubmittingTask = false;
                                _isLoadingMoreTask = false;
                                _hasMoreTask = state.hasMore;
                                _taskPage = state.page;
                              });
                            }
                          });
                          if (state.message.isNotEmpty) {
                            _showToast(state.message);
                          }
                        });
                        _taskListBloc.add(TaskListIdleEvent());
                      }

                      if (state.status == TaskListStatus.loadMoreSuccess) {
                        onWidgetDidBuild(() {
                          setState(() {
                            _taskList.addAll(state.tasks);
                            _isLoadingMoreTask = false;
                            _hasMoreTask = state.hasMore;
                            _taskPage = state.page;
                          });
                        });
                        _taskListBloc.add(TaskListIdleEvent());
                      }

                      return _isLoadingTask
                          ? const TaskListShimmer()
                          : _taskList.isEmpty
                          ? _emptyState(
                              state.status == TaskListStatus.failure
                                  ? state.message
                                  : 'Tambahkan task pertama untuk mulai mencatat pekerjaan.',
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100.w,
                                  margin: EdgeInsets.only(bottom: 10.sp),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.sp,
                                    vertical: 10.sp,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14.sp),
                                    border: Border.all(
                                      color: const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  child: Text(
                                    '${_taskList.length} task ditampilkan',
                                    textScaler: TextScaler.noScaling,
                                    style: TextStyle(
                                      color: const Color(0xFF334155),
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _taskList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                        return TaskCard(
                                          task: _taskList[index],
                                          onTap: () => _openDetail(
                                            context,
                                            _taskList[index],
                                          ),
                                        );
                                      },
                                ),
                                if (_isLoadingMoreTask)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.sp,
                                    ),
                                    child: SizedBox(
                                      height: 22.sp,
                                      width: 22.sp,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.sp,
                                      ),
                                    ),
                                  ),
                                if (!_hasMoreTask && _taskList.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.sp),
                                    child: Text(
                                      'Semua task sudah ditampilkan',
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.noScaling,
                                      style: TextStyle(
                                        color: const Color(0xFF64748B),
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Tracker')),
      body: _body(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddTask(context),
        label: const Text('Tambah Task'),
      ),
    );
  }
}
