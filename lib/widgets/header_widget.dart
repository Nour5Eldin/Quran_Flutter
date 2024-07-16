import 'package:flutter/material.dart';
import 'package:quran/quran.dart';

class HeaderWidget extends StatelessWidget {
  final Map<String, dynamic> e;
  final List<dynamic> jsonData;

  HeaderWidget({Key? key, required this.e, required this.jsonData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/images/888-02.png",
              width: MediaQuery.of(context).size.width,
              height: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.7, vertical: 9.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "اياتها\n${getVerseCount(e["surah"])}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11, // Adjust the font size
                    fontFamily: "UthmanicHafs13",
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  getSurahNameArabic(e["surah"]), // Display Arabic Surah name
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "uthmanic",
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  "ترتيبها\n${e["surah"]}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11, // Adjust the font size
                    fontFamily: "UthmanicHafs13",
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
