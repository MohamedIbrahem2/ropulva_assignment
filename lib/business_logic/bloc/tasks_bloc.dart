import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ropulva_assignment/data/models/tasks.dart';

import '../../data/firestore_services/tasks_firestore_services.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final FireStoreService fireStoreService;

  TaskBloc(this.fireStoreService) : super(TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      try {
        emit(TaskLoading());
        final tasks = await fireStoreService.getTasks().first;
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError('Failed to load tasks.'));
      }
    });

    on<AddTask>((event, emit) async {
      try {
        emit(TaskLoading());
        await fireStoreService.addTask(event.task);
        emit(TaskOperationSuccess('Task added successfully.'));
      } catch (e) {
        emit(TaskError('Failed to add task.'));
      }
    });

    on<UpdateTask>((event, emit)  async {
      try {
        emit(TaskLoading());
        await fireStoreService.updateTask(event.task);
        emit(TaskOperationSuccess('Task updated successfully.'));
      } catch (e) {
        emit(TaskError('Failed to update task.'));
      }
    });

    on<DeleteTask>((event, emit) async {
      try {
        emit(TaskLoading());
        await fireStoreService.deleteTask(event.taskId);
        emit(TaskOperationSuccess('Task deleted successfully.'));
      } catch (e) {
        emit(TaskError('Failed to delete task.'));
      }
    });

  }
}

