import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Vault Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome to Time Vault!'),
            ElevatedButton(
              child: Text('Create Capsule'),
              onPressed: () {
                Navigator.pushNamed(context, '/create');
              },
            ),
            ElevatedButton(
              child: Text('View Capsules'),
              onPressed: () {
                Navigator.pushNamed(context, '/list');
              },
            ),
          ],
        ),
      ),
    );
  }
}
