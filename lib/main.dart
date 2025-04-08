import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Laundry App',
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 211, 182), // Set background color
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
