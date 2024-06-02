import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ropulva_assignment/task_model.dart';

import 'bloc_event.dart';
import 'bloc_task.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => TaskBloc(FirebaseFirestore.instance, Connectivity()),
        child: TaskListScreen(),
      ),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tasks')),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  trailing: task.isCompleted ? Icon(Icons.check) : null,
                  onTap: () => context.read<TaskBloc>().add(FinishTask(task.id)),
                );
              },
            );
          } else {
            return Center(child: Text('Failed to load tasks'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTask(BuildContext context) {
    final task = Task(id: DateTime.now().toString(), title: 'New Task');
    context.read<TaskBloc>().add(AddTask(task));
  }
}
