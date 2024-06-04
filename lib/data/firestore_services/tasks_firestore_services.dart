import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/tasks.dart';

class FireStoreService {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('tasks');

  Stream<List<Tasks>> getTasks() {
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
    return collection.add({
      'title': task.title,
      'completed': task.completed,
      'dueDate' : task.dueDate
    });
  }

  Future<void> updateTask(Tasks task) {
    return collection.doc(task.id).update({
      'title': task.title,
      'completed': task.completed,
      'dueDate' : task.dueDate
    });
  }

  Future<void> deleteTask(String taskId) {
    return collection.doc(taskId).delete();
  }
}