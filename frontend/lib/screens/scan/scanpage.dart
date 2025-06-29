import 'package:flutter/material.dart';
import 'package:frontend/screens/scan/input/inputtext.dart';
import 'package:frontend/screens/scan/input/inputimage.dart';

//ini harusny stateful kan
class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: Icon(Icons.account_circle),
        title: Text(
          'Hello, [Username]',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              //search bar function/class
            }, 
            icon: Icon(Icons.search)
          ),

          IconButton(
            onPressed: () {
              //notif page
            },
            icon: Icon(Icons.notifications))
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _titleText(context),
          SizedBox(height: 24),
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
                children: <Widget>[_scanbuttonRow(context)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _scanbuttonRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InputTextScreen()),
            );
          },
          child: const Text('Scan Text'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InputImageScreen()),
            );
          },
          child: const Text('Scan Image'),
        ),
      ],
    );
  }

  Padding _titleText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(
            fontFamily: 'Poppins',
            color: Colors.black,
            decoration: TextDecoration.none,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Worried It\'s Fake?\n',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            TextSpan(
              text: 'Let\'s Find Out!',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
