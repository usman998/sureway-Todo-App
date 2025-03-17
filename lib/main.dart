import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/auth_screen/auth_screen.dart';
import 'package:todo_app/screens/task_screen/task_screen.dart';
import 'package:todo_app/user_preference.dart';
import 'package:todo_app/utils/snack_bar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: SnackBarService.messengerKey,
      theme: ThemeData(

        useMaterial3: true,
      ),
      home: FirebaseAuth.instance.currentUser!=null?TaskScreen():AuthScreen(),
    );
  }
}


