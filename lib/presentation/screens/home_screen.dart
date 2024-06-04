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
    BlocProvider.of<TaskBloc>(context).add(LoadTasks());
  }


  @override
  Widget build(BuildContext context) {
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    var size = MediaQuery
        .of(context)
        .size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      appBar: null,
      body:BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            final tasks = state.tasks;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Good Morning",
                      style: TextStyle(fontSize: 40,color: Colors.black,fontWeight: FontWeight.bold),),
                     SizedBox(height: height * 0.020),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: MyColors.filterColorClicked,
                                ),
                                color: MyColors.filterColorClicked,
                                borderRadius: const BorderRadius.all(Radius.circular(20))
                            ),
                            height: height * 0.030,
                            width:  width * 0.2,
                            child: const Center(child: Text("All",style: TextStyle(color: Colors.white),)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: MyColors.filterColorClicked.withOpacity(0.10),
                                ),
                                color: MyColors.filterColorClicked.withOpacity(0.10),
                                borderRadius: const BorderRadius.all(Radius.circular(20))
                            ),
                            height: height * 0.030,
                            width:  width * 0.2,
                            child:   const Center(child: Text("Not Done",style: TextStyle(color: MyColors.filterColorClicked),)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: MyColors.filterColorClicked.withOpacity(0.10),
                                ),
                                color: MyColors.filterColorClicked.withOpacity(0.10),
                                borderRadius: const BorderRadius.all(Radius.circular(20))
                            ),
                            height: height * 0.030,
                            width:  width * 0.2,
                            child:  const Center(child: Text("Done",style: TextStyle(color: MyColors.filterColorClicked),)),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  ),
                              elevation: 6,
                              child: ListTile(
                                onTap: (){
                                },
                                trailing: Transform.scale(
                                  scale: 2.0,
                                  child: Checkbox(
                                    activeColor: MyColors.filterColorClicked,
                                    checkColor: MyColors.filterColorClicked,
                                    value: task.completed,
                                    fillColor: MaterialStatePropertyAll(MyColors.filterColorClicked.withOpacity(0.10)),
                                    side: BorderSide.none,
                                    shape:  RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(10),
                                    ),
                                    onChanged: (value) {
                                      final updatedTask = task.copyWith(completed: value);
                                      taskBloc.add(UpdateTask(updatedTask));
                                    },
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Text(task.title,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                                subtitle: Text("Due Date: ${task.dueDate.toString().substring(0,10)}"),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: width * 1,
                        height: height * 0.070,
                        child: ElevatedButton(
                            onPressed: (){
                              _showAddTaskDialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                              ),
                              backgroundColor: MyColors.filterColorClicked
                            ),
                            child: const Text("Create Task",style: TextStyle(color: Colors.white,fontSize: 16),)),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else if (state is TaskOperationSuccess) {
            taskBloc.add(LoadTasks()); // Reload tasks
            return Container(); // Or display a success message
          } else if (state is TaskError) {
            return Center(child: Text(state.errorMessage));
          } else {
            return Container();
          }
        },
      ),
    );
  }
  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final DueDateController = TextEditingController();
    var size = MediaQuery
        .of(context)
        .size;
    var height = size.height;
    var width = size.width;
    showBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurRadius: 3
                )
              ],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
            ),
            height: height * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close,
                        color: MyColors.closeButtonColor,)),
                ),
                Text("Create New Task"),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: 'Todo title'),
                ),
                TextField(
                  controller: DueDateController,
                  decoration: const InputDecoration(hintText: 'Todo title'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: width * 1,
                    height: height * 0.070,
                    child: ElevatedButton(
                        onPressed: (){
                          final task = Tasks(
                            id: DateTime.now().toString(),
                            title: titleController.text,
                            dueDate: DateTime.now(),
                            completed: false,
                          );
                          BlocProvider.of<TaskBloc>(context).add(AddTask(task));
                          Navigator.pop(context);

                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            backgroundColor: MyColors.filterColorClicked
                        ),
                        child: const Text("Save Task",style: TextStyle(color: Colors.white,fontSize: 16),)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
