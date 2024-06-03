import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ropulva_assignment/business_logic/bloc/tasks_bloc.dart';
import 'package:ropulva_assignment/constants/my_colors.dart';

import '../../data/models/tasks.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    super.initState();
    BlocProvider.of<TodoBloc>(context).add(LoadTodos());
  }


  @override
  Widget build(BuildContext context) {
    final TodoBloc _todoBloc = BlocProvider.of<TodoBloc>(context);
    var size = MediaQuery
        .of(context)
        .size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      appBar: null,
      body:BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            final todos = state.todos;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (value) {
                      final updatedTodo = todo.copyWith(completed: value);
                      _todoBloc.add(UpdateTodo(updatedTodo));
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _todoBloc.add(DeleteTodo(todo.id));
                    },
                  ),
                );
              },
            );
          } else if (state is TodoOperationSuccess) {
            _todoBloc.add(LoadTodos()); // Reload todos
            return Container(); // Or display a success message
          } else if (state is TodoError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  void _showAddTodoDialog(BuildContext context) {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const  Text('Add Todo'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Todo title'),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                final task = Todo(
                  id: DateTime.now().toString(),
                  title: titleController.text,
                  //dueDate: DateTime.now(),
                  completed: false,
                );
                BlocProvider.of<TodoBloc>(context).add(AddTodo(task));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
