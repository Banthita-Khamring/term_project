import 'package:flutter/material.dart';
import 'package:term_project/widgets/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Term_proj_640710536',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 4, 44, 240)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}


