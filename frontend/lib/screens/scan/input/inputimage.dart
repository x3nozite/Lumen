import 'package:flutter/material.dart';

class InputImageScreen extends StatelessWidget {
  const InputImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(title: Text('Scan Image'), centerTitle: true),
    );
  }
}
