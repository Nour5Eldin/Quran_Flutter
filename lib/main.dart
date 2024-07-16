import 'package:flutter/material.dart';
import 'package:quran_tutorial/views/Splash_Screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en','EN'), // English
        Locale('ar', 'AR'), // Arabic
      ],
      title: 'القرآن الكريم',
      home:  SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
