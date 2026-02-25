import 'package:flutter/material.dart';

void main() {
  runApp(const DarkwoodApp());
}

class DarkwoodApp extends StatelessWidget {
  const DarkwoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Darkwood Coffee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B1F0A),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF1A0E06),
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Darkwood Coffee',
            style: TextStyle(
              color: Color(0xFFD4A96A),
              fontSize: 28,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
