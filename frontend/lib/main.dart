import 'package:flutter/material.dart';
import 'package:frontend/screens/result/result.dart';

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
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const ResultPage(),
    );
  }
}
