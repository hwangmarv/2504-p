import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home_screen.dart'; 
import 'create_capsule_screen.dart'; 
import 'capsule_list_screen.dart';
import 'data/time_capsule.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  // Initialize Hive for Flutter
  await Hive.initFlutter();

  // Register the adapter
  Hive.registerAdapter(TimeCapsuleAdapter()); 

  // Open a box (a single table/collection of key-value pairs)
  await Hive.openBox<TimeCapsule>('timeCapsuleBox');
  
  runApp(TimeVaultApp());
}

class TimeVaultApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Vault',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/create': (context) => CreateCapsuleScreen(),
        '/list': (context) => CapsuleListScreen(),
      },
    );
  }
}
