import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:ropulva_assignment/task_model.dart';

import 'bloc_event.dart';


class TaskBloc extends HydratedBloc<TaskEvent, TaskState> {
  final FirebaseFirestore firestore;
  final Connectivity connectivity;

  TaskBloc(this.firestore, this.connectivity) : super(TaskLoading()) {
    on<AddTask>(_onAddTask);
    on<FinishTask>(_onFinishTask);
    _syncTasks();
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final updatedTasks = List<Task>.from((state as TaskLoaded).tasks)
        ..add(event.task);
      emit(TaskLoaded(updatedTasks));
      await _saveTaskToFirestore(event.task);
    }
  }

  Future<void> _onFinishTask(FinishTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final updatedTasks = (state as TaskLoaded)
          .tasks
          .map((task) => task.id == event.taskId
          ? Task(id: task.id, title: task.title, isCompleted: true)
          : task)
          .toList();
      emit(TaskLoaded(updatedTasks));
      await _updateTaskInFirestore(event.taskId, {'isCompleted': true});
    }
  }

  Future<void> _saveTaskToFirestore(Task task) async {
    final connection = await connectivity.checkConnectivity();
    if (connection != ConnectivityResult.none) {
      await firestore.collection('tasks').doc(task.id).set(task.toMap());
    }
  }

  Future<void> _updateTaskInFirestore(String taskId, Map<String, dynamic> data) async {
    final connection = await connectivity.checkConnectivity();
    if (connection != ConnectivityResult.none) {
      await firestore.collection('tasks').doc(taskId).update(data);
    }
  }

  Future<void> _syncTasks() async {
    final connection = await connectivity.checkConnectivity();
    if (connection != ConnectivityResult.none) {
      // Fetch tasks from Firestore and emit TaskLoaded
      final snapshot = await firestore.collection('tasks').get();
      final tasks = snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
      emit(TaskLoaded(tasks));
    }
  }

  @override
  TaskState? fromJson(Map<String, dynamic> json) {
    try {
      final tasks = (json['tasks'] as List).map((task) => Task.fromMap(task)).toList();
      return TaskLoaded(tasks);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(TaskState state) {
    if (state is TaskLoaded) {
      return {'tasks': state.tasks.map((task) => task.toMap()).toList()};
    }
    return null;
  }
}
