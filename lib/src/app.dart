import 'package:flutter/material.dart';
import 'package:help_now/screens/home_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      color: Colors.orange,
    );
  }
}
