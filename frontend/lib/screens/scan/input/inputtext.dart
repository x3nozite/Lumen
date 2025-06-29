import 'package:flutter/material.dart';

class InputTextScreen extends StatelessWidget {
  const InputTextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(title: Text('Scan Text'), centerTitle: true),
    );
  }
}
