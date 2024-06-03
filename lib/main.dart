import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ropulva_assignment/business_logic/bloc/tasks_bloc.dart';
import 'package:ropulva_assignment/data/firestore_services/tasks_firestore_services.dart';
import 'package:ropulva_assignment/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyBPmQtoBga8ZyQMn6U2BF2qcRniDkz0-bc',
        appId: '1:389561436980:android:d31ad55db980110680b361',
        messagingSenderId: '389561436980',
        projectId: 'ropulva-assignment',
        storageBucket: 'ropulva-assignment.appspot.com'
    ),
  );
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(FirestoreService()),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  HomeScreen(),
      ),
    );
  }
}
