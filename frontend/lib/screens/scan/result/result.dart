import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage(this.data, this.inputText, {super.key});

  final Map<String, dynamic> data; // result from ai

  final String inputText; // user's previous text

  String get safeInputText =>
      (inputText.isEmpty) ? 'No input Provided' : inputText;
  final String test =
      'The Great Wall of China is the only man-made structure visible from the Moon. It was built in a single continuous project during the Ming Dynasty and stretches over 10,000 miles';

  // function to determine background color based on AI's rating
  Color getScoreColor(int score) {
    if (score == 0) {
      return Colors.grey; // default
    } else if (score < 20) {
      return Color(0xFF4CD11B); // good score
    } else if (score <= 40) {
      return Color(0xFFD1C21B); // meh score
    } else if (score > 41) {
      return Color(0xFFFF5752); // bad score
    } else {
      return Colors.grey; // jaga-jaga
    }
  }

  @override
  Widget build(BuildContext context) {
    final int score = data['rating'] ?? 0; // if NULL = 0

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Result Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: getScoreColor(score),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: getScoreColor(score),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.all(32), child: _scannedText()),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _mainVerdict(),
                  SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Conclusion',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _scoreCard(context, score),
                          _verdictCard(context, score),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1982C4),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Back to Scan Page'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _scannedText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.4),
                blurRadius: 2,
                spreadRadius: 2,
                offset: Offset(0.0, 4.0),
              ),
            ],
          ),
          child: Text('"$safeInputText"', style: const TextStyle(fontSize: 10)),
        ),
        SizedBox(height: 12),
        Text('Scanned Text', style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Column _mainVerdict() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Main Claim',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.4),
                blurRadius: 2,
                spreadRadius: 2,
                offset: Offset(0.0, 4.0),
              ),
            ],
          ),
          child: Text(
            "\"${data['main_claim']}\"",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Container _verdictCard(BuildContext context, int score) {
    return Container(
      width: 140,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.4),
            blurRadius: 2,
            spreadRadius: 2,
            offset: Offset(0.0, 4.0),
          ),
        ],
        borderRadius: BorderRadius.all((Radius.circular(16))),
      ),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(
            fontFamily: 'Poppins',
            color: Colors.black,
            decoration: TextDecoration.none,
          ),
          children: <TextSpan>[
            TextSpan(
              text: '${data['verdict']}\n',
              style: TextStyle(
                color: getScoreColor(score),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'Main Verdict',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Container _scoreCard(BuildContext context, int score) {
    return Container(
      width: 140,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.4),
            blurRadius: 2,
            spreadRadius: 2,
            offset: Offset(0.0, 4.0),
          ),
        ],
      ),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(
            fontFamily: 'Poppins',
            color: Colors.black,
            decoration: TextDecoration.none,
          ),
          children: <TextSpan>[
            TextSpan(
              text: '$score\n',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: getScoreColor(score),
              ),
            ),
            TextSpan(
              text: 'Risk Score',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
