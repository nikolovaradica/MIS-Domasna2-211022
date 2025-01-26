import 'package:flutter/material.dart';
import 'package:lifelog/providers/daily_entry_provider.dart';
import 'package:lifelog/screens/landing_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DailyEntryProvider(), 
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeLog',
      theme: ThemeData(
        fontFamily: 'Inter'
      ),
      home: const LandingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
