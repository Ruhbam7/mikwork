import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hope/home.dart';
import 'package:hope/loginscreen.dart';
import 'package:hope/postscreen.dart';

class splashservices {
  void islogin(BuildContext context) {

    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if(user != null){
      Timer(
        const Duration(seconds: 3),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomeScreen())));
    }else {
      Timer(
        const Duration(seconds: 3),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const loginscreen())));
    }
  }
}
