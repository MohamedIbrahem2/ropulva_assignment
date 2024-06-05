part of 'tasks_bloc.dart';

@immutable
sealed class TaskEvent {
}
class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Tasks task;

 AddTask(this.task);


}

class UpdateTask extends TaskEvent {
  final Tasks task;

   UpdateTask(this.task);


}

class DeleteTask extends TaskEvent {
  final Tasks task;

  DeleteTask(this.task);

}