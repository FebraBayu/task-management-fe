import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:test_task_tracker/data/repositories/task_repository.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/bloc/delete_task_bloc.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/bloc/task_detail_bloc.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/bloc/update_task_bloc.dart';
import 'package:test_task_tracker/pages/task_detail/bloc/bloc/update_task_status_bloc.dart';
import 'package:test_task_tracker/pages/task_detail/body/task_detail_body.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final int taskId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<TaskDetailBloc>(
          create: (BuildContext context) =>
              TaskDetailBloc(repository: TaskRepository()),
        ),
        BlocProvider<UpdateTaskBloc>(
          create: (BuildContext context) =>
              UpdateTaskBloc(repository: TaskRepository()),
        ),
        BlocProvider<UpdateTaskStatusBloc>(
          create: (BuildContext context) =>
              UpdateTaskStatusBloc(repository: TaskRepository()),
        ),
        BlocProvider<DeleteTaskBloc>(
          create: (BuildContext context) =>
              DeleteTaskBloc(repository: TaskRepository()),
        ),
      ],
      child: TaskDetailBody(taskId: taskId),
    );
  }
}
