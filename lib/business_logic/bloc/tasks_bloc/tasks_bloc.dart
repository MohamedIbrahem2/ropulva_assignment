import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ropulva_assignment/data/models/tasks.dart';

import '../../../data/firestore_services/tasks_firestore_services.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';
// bloc handle events and talk to backend so he can get the data and handle it before pass the state of data.
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final FireStoreService fireStoreService;

  TaskBloc(this.fireStoreService) : super(TaskInitial()) {
    on<LoadTasks>((task, emit) async { // this method talk to fireStore to get all data.
      try {
        final tasks = await fireStoreService.getTasks().first;
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError('Failed to load tasks.'));
      }
    });

    on<AddTask>((event, emit) async {// this method talk to backend to add tasks to fireStore.
      if(state is TaskLoaded) {
        // this condition handle data when user is offline.
        final updatedTasks = List<Tasks>.from((state as TaskLoaded).tasks)..add(event.task);
        emit(TaskLoaded(updatedTasks));
        try {
          await fireStoreService.addTask(event.task);
          emit(TaskOperationSuccess('Task added successfully.'));
        } catch (e) {
          emit(TaskError('Failed to add task.'));
        }
      }
    });

    on<UpdateTask>((event, emit)  async {// this method talk to backend to update tasks to fireStore.
      if(state is TaskLoaded) {
        // this condition handle data when user is offline.
        final updatedTasks = (state as TaskLoaded).tasks.map((task) {
          return task.id == event.task.id ? event.task : task;
        }).toList();
        emit(TaskLoaded(updatedTasks));
        try {
          await fireStoreService.updateTask(event.task);
          emit(TaskOperationSuccess('Task updated successfully.'));
        } catch (e) {
          emit(TaskError('Failed to update task.'));
        }
      }
    });

    on<DeleteTask>((event, emit) async {// this method talk to backend to delete tasks from fireStore.
      if(state is TaskLoaded) {
        // this condition handle data when user is offline.
        final updatedTasks = List<Tasks>.from((state as TaskLoaded).tasks)..remove(event.task);
        emit(TaskLoaded(updatedTasks));
        try {
          await fireStoreService.deleteTask(event.task);
          emit(TaskOperationSuccess('Task deleted successfully.'));
        } catch (e) {
          emit(TaskError('Failed to delete task.'));
        }
      }
    });

  }
}

