import 'package:flutter/material.dart';

class roundbutton extends StatelessWidget {
  final String title;
  final VoidCallback ontap;
  final bool loading;
  const roundbutton({
    super.key,
    required this.title,
    required this.ontap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 65, 152, 223),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                )
              : Text(title, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
