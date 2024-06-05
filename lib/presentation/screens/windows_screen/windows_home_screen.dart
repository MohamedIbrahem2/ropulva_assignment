import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ropulva_assignment/business_logic/bloc/tasks_bloc/tasks_bloc.dart';
import 'package:ropulva_assignment/constants/my_colors.dart';
import '../../../data/models/tasks.dart';
class WindowsScreen extends StatefulWidget {
  const WindowsScreen({super.key});

  @override
  State<WindowsScreen> createState() => _WindowsScreenState();
}

class _WindowsScreenState extends State<WindowsScreen> {
  DateTime dueDate = DateTime.now();
  final titleController = TextEditingController();


  @override
  void initState() {
    super.initState();
    BlocProvider.of<TaskBloc>(context).add(LoadTasks());
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    var height = size.height;
    var width = size.width;
    return Scaffold(
      appBar: null,
      body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Good Morning",
                            style: TextStyle(fontSize: 40,color: Colors.black,fontWeight: FontWeight.bold),),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                _showAddTaskDialog(context);
                              },
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: MyColors.filterColorClicked,
                                     borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: const Center(child:Icon(Icons.add,color: Colors.white,size: 40,)),
                              ),
                                                      ),
                            )
                          )
                        ],
                      ),
                    ),
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
                            height: 27,
                            width:  57,
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
                            height: 27,
                            width:  90,
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
                            height: 27,
                            width:  70,
                            child:  const Center(child: Text("Done",style: TextStyle(color: MyColors.filterColorClicked),)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Expanded(
                      child: BlocBuilder<TaskBloc,TaskState>(
                        builder: (context, taskState) {
                          if (taskState is TaskLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          else if (taskState is TaskLoaded) {
                            final tasks = taskState.tasks;
                            return SizedBox(
                              height: height * 0.5,
                              width: width * 0.5,
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 3.6,
                                    crossAxisCount: 2
                                ),
                                itemCount: tasks.length,
                                itemBuilder: (context, index) {
                                  final task = tasks[index];
                                  String formattedDate = DateFormat.yMEd()
                                      .format(task.dueDate);
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onLongPress: (){
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Center(
                                              child: AlertDialog(
                                                title: const Center(child:Text("Edit Task")),
                                                actions: [
                                                  ElevatedButton(
                                                    child: const Text('Delete'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      taskBloc.add(DeleteTask(task));
                                                    },
                                                  ),
                                                  ElevatedButton(
                                                    child: const Text('Edit'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const  Text('Update Task'),
                                                            content: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                TextField(
                                                                  controller: titleController,
                                                                  decoration: const InputDecoration(hintText: 'Task title'),
                                                                ),
                                                                TextField(
                                                                  readOnly: true,
                                                                  onTap: (){
                                                                    _selectDate(context);
                                                                  },
                                                                  decoration: const InputDecoration(hintText: 'due date'),
                                                                ),
                                                              ],
                                                            ),
                                                            actions: [
                                                              ElevatedButton(
                                                                child: const Text('Cancel'),
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                              ),
                                                              ElevatedButton(
                                                                child: const Text('Update'),
                                                                onPressed: () {
                                                                  final taskEdit = Tasks(
                                                                    id: task.id,
                                                                    title: titleController.text,
                                                                    dueDate: dueDate,
                                                                    completed: task.completed,
                                                                  );
                                                                  BlocProvider.of<TaskBloc>(context).add(UpdateTask(taskEdit));
                                                                  titleController.clear();
                                                                  dueDate = DateTime.now();
                                                                  Navigator.pop(context);
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );

                                      },
                                      child: Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              15),
                                        ),
                                        elevation: 6,
                                        child: ListTile(
                                          onTap: () {},
                                          trailing: Transform.scale(
                                            scale: 2.0,
                                            child: Checkbox(
                                              activeColor: MyColors
                                                  .filterColorClicked,
                                              checkColor: MyColors
                                                  .filterColorClicked,
                                              value: task.completed,
                                              fillColor: MaterialStatePropertyAll(
                                                  MyColors.filterColorClicked
                                                      .withOpacity(0.10)),
                                              side: BorderSide.none,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(
                                                    10),
                                              ),
                                              onChanged: (value) {
                                                final updatedTask = task
                                                    .copyWith(
                                                    completed: value);
                                                taskBloc.add(
                                                    UpdateTask(updatedTask));
                                              },
                                            ),
                                          ),
                                          title: Row(
                                            children: [
                                              Text(task.title,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight
                                                        .bold),),
                                            ],
                                          ),
                                          subtitle: Text(
                                              "Due Date: $formattedDate"),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                         }
                          else if (taskState is TaskOperationSuccess) {
                            taskBloc.add(LoadTasks()); // Reload tasks
                            return Container(); // Or display a success message
                          } else if (taskState is TaskError) {
                            return Center(child: Text(taskState.errorMessage));
                          } else {
                            return Container();
                          }
                        }
                      ),
                    ),

                  ],
                ),
              ),
            )
    );
  }
  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(

          elevation: 3,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Create New Task',style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close,
                      color: MyColors.closeButtonColor,)),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 50,
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: MyColors.textFieldColor.withOpacity(0.50)),
                      fillColor: MyColors.textFieldBackgroundColor.withOpacity(0.30),
                      hintText: 'Task title'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 50,
                child: TextField(
                  readOnly: true,
                  onTap: () {
                    _selectDate(context);
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: MyColors.textFieldColor.withOpacity(0.50)),
                      fillColor: MyColors.textFieldBackgroundColor.withOpacity(0.30),
                      hintText: 'Due Date'),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: (){
                      final task = Tasks(
                        id: DateTime.now().toString(),
                        title: titleController.text,
                        dueDate: dueDate,
                        completed: false,
                      );
                      BlocProvider.of<TaskBloc>(context).add(AddTask(task));
                      dueDate = DateTime.now();
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
            ),

          ],
        );
      },
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dueDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != dueDate) {
      setState(() {
        dueDate = picked;
      });
    }
  }
}
