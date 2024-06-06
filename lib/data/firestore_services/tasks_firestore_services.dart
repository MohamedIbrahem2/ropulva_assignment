import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/tasks.dart';

class FireStoreService {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('tasks');

  Stream<List<Tasks>> getTasks() {
    // get tasks from fireStore and pass it to bloc.
    return collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Tasks(
          id: doc.id,
          dueDate: data['dueDate'].toDate(),
          title: data['title'],
          completed: data['completed'],
        );
      }).toList();
    });
  }

  Future<void> addTask(Tasks task) {
    // add task that i get from bloc to fireStore.
    return collection.add({
      'title': task.title,
      'completed': task.completed,
      'dueDate' : task.dueDate
    });
  }

  Future<void> updateTask(Tasks task) {
    // update task that i get from bloc to fireStore.
    return collection.doc(task.id).update({
      'title': task.title,
      'completed': task.completed,
      'dueDate' : task.dueDate
    });
  }

  Future<void> deleteTask(Tasks task) {
    // delete task from fireStore.
    return collection.doc(task.id).delete();
  }
}