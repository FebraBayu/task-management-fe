import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:test_task_tracker/data/repositories/task_repository.dart';
import 'package:test_task_tracker/pages/task_list/bloc/bloc/create_task_bloc.dart';
import 'package:test_task_tracker/pages/task_list/bloc/bloc/task_list_bloc.dart';
import 'package:test_task_tracker/pages/task_list/body/task_list_body.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<TaskListBloc>(
          create: (BuildContext context) =>
              TaskListBloc(repository: TaskRepository()),
        ),
        BlocProvider<CreateTaskBloc>(
          create: (BuildContext context) =>
              CreateTaskBloc(repository: TaskRepository()),
        ),
      ],
      child: const TaskListBody(),
    );
  }
}
