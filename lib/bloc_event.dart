import 'package:equatable/equatable.dart';
import 'package:ropulva_assignment/task_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class AddTask extends TaskEvent {
  final Task task;
  const AddTask(this.task);
}

class FinishTask extends TaskEvent {
  final String taskId;
  const FinishTask(this.taskId);
}

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  const TaskLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}
