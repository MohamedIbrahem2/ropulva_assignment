part of 'tasks_bloc.dart';
// this page take state from backend and sen it ui.
@immutable
sealed class TaskState {

}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Tasks> tasks;

   TaskLoaded(this.tasks);

}

class TaskOperationSuccess extends TaskState {
  final String message;

   TaskOperationSuccess(this.message);

}

class TaskError extends TaskState {
  final String errorMessage;

   TaskError(this.errorMessage);

}