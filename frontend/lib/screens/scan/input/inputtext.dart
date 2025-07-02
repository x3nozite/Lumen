import 'package:flutter/material.dart';

class InputTextScreen extends StatelessWidget {
  const InputTextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Scan Text', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            _titleText(context),
            SizedBox(height: 24),
            _textInput(),
            Spacer(),
            Text(
              'Each upload will be archived and not editable. Please review to confirm completeness',
              style: TextStyle(fontSize: 10, color: Color(0xFF67656C)),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1982C4),
                  foregroundColor: Colors.white,
                ),
                child: Text('Scan Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextField _textInput() {
    return TextField(
      style: TextStyle(fontSize: 8),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1982C4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1982C4)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1982C4)),
        ),
        hintText: 'Paste text to scan here',
      ),
      keyboardType: TextInputType.multiline,
      minLines: 10,
      maxLines: 15,
    );
  }

  RichText _titleText(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.copyWith(
          fontFamily: 'Poppins',
          color: Colors.black,
          decoration: TextDecoration.none,
          height: 2,
        ),
        children: [
          TextSpan(
            text: 'Paste Text to Scan\n',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
                'Upload text to check for fraud, hoaxes, or misinformation in seconds.',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
