class Tasks {// model of tasks.
  String id;
  String title;
  bool completed;
  DateTime dueDate;

  Tasks({
    required this.id,
    required this.title,
    required this.completed,
    required this.dueDate
  });


  Tasks copyWith({
    String? id,
    String? title,
    bool? completed,
    DateTime? dueDate
  }) {
    return Tasks(
      id: id ?? this.id,
      dueDate: dueDate ?? this.dueDate,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}