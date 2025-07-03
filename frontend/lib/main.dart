import 'package:flutter/material.dart';
import 'package:frontend/screens/scan/scanpage.dart';
import 'package:frontend/screens/scan/input/inputimage.dart';
import 'package:frontend/screens/scan/input/inputtext.dart';
import 'package:frontend/screens/scan/result/result.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const ScanPage(),
        '/input_text': (context) => const InputTextScreen(),
        '/input_image': (context) => const InputImageScreen(),
        '/result': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return ResultPage(args['data'], args['inputText']);
        },
      },
    );
  }
}
