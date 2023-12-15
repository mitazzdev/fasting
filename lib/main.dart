import 'package:flutter/material.dart';

import 'screen/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false; // Move isDark into the state
  MaterialColor color = Colors.deepOrange;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: isDark
              ? ColorScheme.fromSeed(
                  seedColor: color, brightness: Brightness.dark)
              : ColorScheme.fromSeed(
                  seedColor: color, brightness: Brightness.light)),
      home: MyHomePage(
        title: 'Fasting Tracker',
        isDark: isDark,
        toggleTheme: () {
          // Use setState to trigger a rebuild when the theme changes
          setState(() {
            isDark = !isDark;
            print(isDark);
          });
        },
      ),
    );
  }
}
