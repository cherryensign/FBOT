import 'package:flutter/material.dart';
import 'package:fbot/chatscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FBOT',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}
