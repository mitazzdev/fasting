import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screen/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false; // Move isDark into the state
  MaterialColor color = Colors.lime;
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
