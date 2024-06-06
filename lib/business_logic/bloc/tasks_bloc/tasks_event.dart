part of 'tasks_bloc.dart';
// this page take event from ui and send it to bloc to get data from backend.
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