import 'package:flutter/material.dart';
import 'package:hope/splashservices.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashservices _splashServices = splashservices();

  @override
  void initState() {
    super.initState();
    _splashServices.islogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 31, 56),
      body: Center(
        child: Image.asset(
          'assets/images/background.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
