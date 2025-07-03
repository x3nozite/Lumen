import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage(this.data, {super.key});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Result Page')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Main claim: ${data['main_claim']}"),
            Text("Reasoning: ${data['reasoning']}"),
          ],
        ),
      ),
    );
  }
}
