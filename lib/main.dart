import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
