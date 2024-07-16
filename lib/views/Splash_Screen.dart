import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:quran_tutorial/views/quran_sura_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var widgejsonData;

  loadJsonAsset() async {
    final String jsonString =
    await rootBundle.loadString('assets/json/surahs.json');
    var data = jsonDecode(jsonString);
    setState(() {
      widgejsonData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadJsonAsset();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuranPage(suraJsonData: widgejsonData),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1EEE5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20), // Margin at the top
            Image.asset(
              "assets/images/splashBismallah.png",
              width: 200, // Set your desired width
              height: 200, // Set your desired height
            ),
            const SizedBox(height: 20), // Space between the image and the animation
            SizedBox(
              height: 400, // Adjusted size
              width: 400, // Adjusted size
              child: Lottie.asset("assets/json/quranicon.json"),
            ),
          ],
        ),
      ),
    );
  }
}



