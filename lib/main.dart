import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io' show Platform;
import 'package:ropulva_assignment/data/firestore_services/tasks_firestore_services.dart';
import 'package:ropulva_assignment/presentation/screens/android_screen/android_home_screen.dart';
import 'package:ropulva_assignment/presentation/screens/windows_screen/windows_home_screen.dart';

import 'business_logic/bloc/tasks_bloc/tasks_bloc.dart';

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


class TaskApp extends StatefulWidget {
  const TaskApp({super.key});

  @override
  State<TaskApp> createState() => _TaskAppState();
}


class _TaskAppState extends State<TaskApp> {
  bool isAndroid = false;
  bool isWindows = false;

  void checkPlatform() {
    if (Platform.isAndroid) {
      isAndroid = true;
    } else if (Platform.isWindows) {
      isWindows = true;
    }
  }

  @override
  void initState() {
    super.initState();
    checkPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          create: (context) => TaskBloc(FireStoreService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: isAndroid ? const AndroidScreen() : const WindowsScreen(),
        )
      ),
    );
  }
}
