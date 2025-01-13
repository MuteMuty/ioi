import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'intro_screen.dart';

void main() {
  runApp(const PitchControlApp());
}

class PitchControlApp extends StatelessWidget {
  const PitchControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroScreen(),
        '/game': (context) => const GameScreen(),
      },
    );
  }
}
