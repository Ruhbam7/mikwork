import 'package:flutter/material.dart';
import 'package:hope/Pendingscreen.dart';
import 'package:hope/addposts.dart';
import 'package:hope/postscreen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/aa.jpeg'), // Make sure the image path is correct
                        fit: BoxFit.cover, // Adjust the fit as needed
                    ),
                ),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text(
                                    "Hello Mentor! Hope you're having a great day!",
                                    style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 1, 31, 56),
                                    ),
                                ),
                            ),
                            const SizedBox(height: 50),
                            ElevatedButton(
                                onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPostScreen()));
                                    // Add New Registration button logic
                                },
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.amber, backgroundColor: const Color.fromARGB(255, 1, 31, 56),
                                    shadowColor: Colors.amberAccent,
                                    elevation: 5,
                                    fixedSize: const Size(200, 50),
                                ),
                                child: const Text(
                                    'Add New Registration',
                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                                onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PostScreen()));
                                    // Current Registrations button logic
                                },
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.amber, backgroundColor: const Color.fromARGB(255, 1, 31, 56),
                                    shadowColor: Colors.amberAccent,
                                    elevation: 5,
                                    fixedSize: const Size(200, 50),
                                ),
                                child: const Text(
                                    'Current Registrations',
                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                            ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                                onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PendingScreen()));
                                    // Current Registrations button logic
                                },
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.amber, backgroundColor: const Color.fromARGB(255, 1, 31, 56),
                                    shadowColor: Colors.amberAccent,
                                    elevation: 5,
                                    fixedSize: const Size(200, 50),
                                ),
                                child: const Text(
                                    'Pending Registrations',
                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                            ),

                        ],
                    ),
                ),
            ),
        );
    }
}
