import 'package:darkwood/views/login.dart';
import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/constants.dart';

void main() {
  runApp(const DarkwoodApp());
}

class DarkwoodApp extends StatelessWidget {
  const DarkwoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: DarkwoodConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: DarkwoodTheme.light,
      home: LoginScreen(),
    );
  }
}
