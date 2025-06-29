import 'package:flutter/material.dart';
import 'package:frontend/screens/scan/scanpage.dart';

void main() {
  // 1. App Entry Point
  runApp(const Lumen());
}

class Lumen extends StatelessWidget {
  const Lumen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins', primaryColor: Color(0xFFE6EDF2)),
      home: const ScanPage(),
    );
  }
}
