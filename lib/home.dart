import 'package:flutter/material.dart';
import 'package:hope/Pendingscreen.dart';
import 'package:hope/addposts.dart';
import 'package:hope/postscreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF023E8A),
              Color(0xFF48CAE4),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20),
                    // Header section
                    Card(
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 20,
                        ),
                        child: Column(
                          children: [
                            Text(
                              "KID'S CLUB DASHBOARD",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF023E8A),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Welcome back, have a productive day!",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Action buttons
                Column(
                  children: [
                    _buildCardButton(
                      icon: Icons.add_circle_outline,
                      text: 'Add New Registration',
                      color: const Color(0xFF0077B6),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddPostScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildCardButton(
                      icon: Icons.fact_check,
                      text: 'Current Registrations',
                      color: const Color(0xFF00B4D8),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PostScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildCardButton(
                      icon: Icons.hourglass_empty,
                      text: 'Pending Registrations',
                      color: const Color(0xFFDC2F02),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PendingScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                // Footer (optional)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Developed with ❤️ by MIK",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
