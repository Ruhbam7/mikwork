import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:hope/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCuutGqD4KwrRSQWSTvQ0JQ0iP8BjlhFmY",
      appId: "1:978907495834:android:4b1aa82ffd201d961f8e23",
      messagingSenderId: "978907495834",
      projectId: "hope-testing",
      authDomain: "hope-testing.firebaseapp.com",
      databaseURL: "https://hope-testing-default-rtdb.firebaseio.com/",
      storageBucket: "hope-testing.appspot.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'KIDS CLUB APP',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
