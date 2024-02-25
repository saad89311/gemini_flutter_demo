import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gemini_test/chat_screen.dart';

void main() {
  Gemini.init(apiKey: 'AIzaSyBQCpAQyChKECuOgRCqXGZSfdPYzbZbTUU');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gemini Demo',
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          color: Colors.blueGrey[900],
        ),
      ),
      home: const ChatScreen(),
    );
  }
}
