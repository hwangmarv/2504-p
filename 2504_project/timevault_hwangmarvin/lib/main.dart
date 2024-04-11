import 'package:flutter/material.dart';
import 'home_screen.dart'; 
import 'create_capsule_screen.dart'; 
import 'capsule_list_screen.dart'; 

void main() => runApp(TimeVaultApp());

class TimeVaultApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Vault',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define the initial route
      initialRoute: '/',
      // Define the routes table
      routes: {
        '/': (context) => HomeScreen(),
        '/create': (context) => CreateCapsuleScreen(),
        '/list': (context) => CapsuleListScreen(),
      },
    );
  }
}
