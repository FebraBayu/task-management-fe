import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:test_task_tracker/models/task.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/bloc/delete_task_bloc.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/bloc/task_detail_bloc.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/bloc/update_task_bloc.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/bloc/update_task_status_bloc.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/event/delete_task_event.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/event/task_detail_event.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/event/update_task_event.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/event/update_task_status_event.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/state/delete_task_state.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/state/task_detail_state.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/state/update_task_state.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/state/update_task_status_state.dart';
import 'package:test_task_tracker/pages/task_detail/component/detail_shimmer.dart';
import 'package:test_task_tracker/pages/task_detail/component/task_detail_header.dart';
import 'package:test_task_tracker/pages/task_detail/component/task_edit_form.dart';
import 'package:test_task_tracker/pages/task_detail/component/task_status_actions.dart';

class TaskDetailBody extends StatefulWidget {
  const TaskDetailBody({super.key, required this.taskId});

  final int taskId;

  @override
  State<TaskDetailBody> createState() => _TaskDetailBodyState();
}

class _TaskDetailBodyState extends State<TaskDetailBody> {
  bool _isLoadingTaskDetail = true;
  bool _isSavingTask = false;
  bool _isUpdatedTask = false;
  Task? _task;

  late TaskDetailBloc _taskDetailBloc;
  late UpdateTaskBloc _updateTaskBloc;
  late UpdateTaskStatusBloc _updateTaskStatusBloc;
  late DeleteTaskBloc _deleteTaskBloc;

  void fetchTaskDetail({bool showLoading = true}) {
    if (showLoading) {
      setState(() {
        _isLoadingTaskDetail = true;
      });
    }
    _taskDetailBloc.add(TaskDetailSubmitEvent(id: widget.taskId));
  }

  @override
  void initState() {
    super.initState();
    _taskDetailBloc = context.read<TaskDetailBloc>();
    _updateTaskBloc = context.read<UpdateTaskBloc>();
    _updateTaskStatusBloc = context.read<UpdateTaskStatusBloc>();
    _deleteTaskBloc = context.read<DeleteTaskBloc>();
    fetchTaskDetail();
  }

  void onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        callback();
      }
    });
  }

  Future<void> _confirmDelete(BuildContext context, int id) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Task'),
          content: const Text('Task ini akan dihapus dari daftar.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      _deleteTaskBloc.add(DeleteTaskSubmitEvent(id: id));
    }
  }

  void _showToast(String message) {
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

  Widget _emptyState(String message) {
    return Container(
      width: 100.w,
      margin: EdgeInsets.only(top: 70.sp),
      padding: EdgeInsets.symmetric(horizontal: 18.sp),
      child: Column(
        children: [
          Text(
            'Task tidak ditemukan',
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

  Widget _content(Task task) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        TaskDetailHeader(task: task),
        SizedBox(height: 10.sp),
        TaskStatusActions(
          status: task.status,
          isSaving: _isSavingTask,
          onChanged: (status) {
            _updateTaskStatusBloc.add(
              UpdateTaskStatusSubmitEvent(id: task.id, status: status),
            );
          },
        ),
        SizedBox(height: 10.sp),
        TaskEditForm(
          task: task,
          isSaving: _isSavingTask,
          onSubmit: (title, description) {
            _updateTaskBloc.add(
              UpdateTaskSubmitEvent(
                id: task.id,
                title: title,
                description: description,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTaskDetail() {
    return BlocBuilder<DeleteTaskBloc, DeleteTaskState>(
      bloc: _deleteTaskBloc,
      builder: (BuildContext context, DeleteTaskState deleteState) {
        if (deleteState.status == DeleteTaskStatus.loading) {
          _isSavingTask = true;
          _deleteTaskBloc.add(DeleteTaskIdleEvent());
        }

        if (deleteState.status == DeleteTaskStatus.error) {
          onWidgetDidBuild(() {
            setState(() {
              _isSavingTask = false;
            });
            _showToast(deleteState.message);
          });
          _deleteTaskBloc.add(DeleteTaskIdleEvent());
        }

        if (deleteState.status == DeleteTaskStatus.loaded) {
          onWidgetDidBuild(() {
            Navigator.of(context).pop(true);
          });
          _deleteTaskBloc.add(DeleteTaskIdleEvent());
        }

        return BlocBuilder<UpdateTaskStatusBloc, UpdateTaskStatusState>(
          bloc: _updateTaskStatusBloc,
          builder: (BuildContext context, UpdateTaskStatusState statusState) {
            if (statusState.status == UpdateTaskStatusStatus.loading) {
              _isSavingTask = true;
              _updateTaskStatusBloc.add(UpdateTaskStatusIdleEvent());
            }

            if (statusState.status == UpdateTaskStatusStatus.error) {
              onWidgetDidBuild(() {
                setState(() {
                  _isSavingTask = false;
                });
                _showToast(statusState.message);
              });
              _updateTaskStatusBloc.add(UpdateTaskStatusIdleEvent());
            }

            if (statusState.status == UpdateTaskStatusStatus.loaded) {
              onWidgetDidBuild(() {
                setState(() {
                  _isSavingTask = false;
                  _isUpdatedTask = true;
                });
                _showToast(statusState.message);
                fetchTaskDetail(showLoading: true);
              });
              _updateTaskStatusBloc.add(UpdateTaskStatusIdleEvent());
            }

            return BlocBuilder<UpdateTaskBloc, UpdateTaskState>(
              bloc: _updateTaskBloc,
              builder: (BuildContext context, UpdateTaskState updateState) {
                if (updateState.status == UpdateTaskStatus.loading) {
                  _isSavingTask = true;
                  _updateTaskBloc.add(UpdateTaskIdleEvent());
                }

                if (updateState.status == UpdateTaskStatus.error) {
                  onWidgetDidBuild(() {
                    setState(() {
                      _isSavingTask = false;
                    });
                    _showToast(updateState.message);
                  });
                  _updateTaskBloc.add(UpdateTaskIdleEvent());
                }

                if (updateState.status == UpdateTaskStatus.loaded) {
                  onWidgetDidBuild(() {
                    setState(() {
                      _isSavingTask = false;
                      _isUpdatedTask = true;
                    });
                    _showToast(updateState.message);
                    fetchTaskDetail(showLoading: true);
                  });
                  _updateTaskBloc.add(UpdateTaskIdleEvent());
                }

                return BlocBuilder<TaskDetailBloc, TaskDetailState>(
                  bloc: _taskDetailBloc,
                  builder: (BuildContext context, TaskDetailState state) {
                    if (state.status == TaskDetailStatus.loading) {
                      _isLoadingTaskDetail = true;
                      _taskDetailBloc.add(TaskDetailIdleEvent());
                    }

                    if (state.status == TaskDetailStatus.failure) {
                      onWidgetDidBuild(() {
                        Future.delayed(const Duration(seconds: 1), () {
                          if (mounted) {
                            setState(() {
                              _isLoadingTaskDetail = false;
                            });
                          }
                        });
                        _showToast(state.message);
                      });
                      _taskDetailBloc.add(TaskDetailIdleEvent());
                    }

                    if (state.status == TaskDetailStatus.success) {
                      onWidgetDidBuild(() {
                        Future.delayed(const Duration(seconds: 1), () {
                          if (mounted) {
                            setState(() {
                              _task = state.task;
                              _isLoadingTaskDetail = false;
                            });
                          }
                        });
                      });
                      _taskDetailBloc.add(TaskDetailIdleEvent());
                    }

                    return _isLoadingTaskDetail
                        ? const DetailShimmer()
                        : _task == null
                        ? _emptyState(
                            state.message.isEmpty
                                ? 'Silakan kembali ke daftar task.'
                                : state.message,
                          )
                        : _content(_task!);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _body() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          fetchTaskDetail(showLoading: true);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            width: 100.w,
            padding: EdgeInsets.only(left: 14.sp, right: 14.sp),
            margin: EdgeInsets.only(top: 10.sp, bottom: 24.sp),
            child: _buildTaskDetail(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        Navigator.of(context).pop(_isUpdatedTask);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail Task'),
          actions: [
            if (_task != null)
              TextButton(
                onPressed: _isSavingTask
                    ? null
                    : () => _confirmDelete(context, _task!.id),
                child: const Text('Hapus'),
              ),
          ],
        ),
        body: _body(),
      ),
    );
  }
}
