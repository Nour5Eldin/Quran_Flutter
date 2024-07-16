import 'package:flutter/material.dart';
import 'package:quran/quran.dart';
import 'package:quran_tutorial/globalhelpers/constants.dart';
import 'package:quran_tutorial/models/sura.dart';
import 'package:easy_container/easy_container.dart';
import 'package:quran_tutorial/views/quran_page.dart';
import 'package:string_validator/string_validator.dart';

class QuranPage extends StatefulWidget {
  final suraJsonData;

  QuranPage({super.key, required this.suraJsonData});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = true;
  var searchQuery = "";
  var filteredData;
  List<Surah> surahList = [];
  var ayatFiltered;
  List pageNumbers = [];
  List name = [];

  addFilteredData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      filteredData = widget.suraJsonData;
      isLoading = false;
      name = filteredData.map((sura) => sura["name_arabic"]).toList();
      print(name);
    });
  }

  @override
  void initState() {
    addFilteredData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: quranPagesColor,
      appBar: AppBar(
        title: const Text("سور القرآن الكريم",
            textDirection: TextDirection.rtl, textAlign: TextAlign.right),
        backgroundColor: const Color(0xffF1EEE5),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textDirection: TextDirection.rtl,
              controller: textEditingController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });

                if (value == "") {
                  filteredData = widget.suraJsonData;
                  pageNumbers = [];
                  setState(() {});
                }

                if (searchQuery.isNotEmpty &&
                    isInt(searchQuery) &&
                    toInt(searchQuery) < 605 &&
                    toInt(searchQuery) > 0) {
                  pageNumbers.add(toInt(searchQuery));
                }

                if (searchQuery.length > 3 ||
                    searchQuery.toString().contains(" ")) {
                  setState(() {
                    ayatFiltered = [];
                    ayatFiltered = searchWords(searchQuery);
                    filteredData = widget.suraJsonData.where((sura) {
                      final suraName = sura['englishName'].toLowerCase();
                      final suraNameTranslated =
                      getSurahNameArabic(sura["number"]);
                      final name = sura['name_arabic'].toString();

                      return suraName.contains(searchQuery.toLowerCase()) ||
                          suraNameTranslated.contains(searchQuery.toLowerCase()) ||
                          name.contains(searchQuery.toLowerCase());
                    }).toList();
                  });
                }
              },
              style: const TextStyle(
                  color: Color.fromARGB(190, 0, 0, 0)),
              decoration: InputDecoration(
                hintText: 'ابحث عن الآيات القرآن ',
                hintTextDirection: TextDirection.rtl,
                hintStyle: const TextStyle(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                prefixIcon: const Icon(Icons.search),
                iconColor: Colors.black,
              ),
            ),
          ),
          if (pageNumbers.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("الصفحة"),
            ),
          ListView.separated(
            reverse: true,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: EasyContainer(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(pageNumbers[index].toString()),
                        Text(getSurahName(
                            getPageData(pageNumbers[index])[0]["surah"]))
                      ],
                    ),
                  ),
                ),
              );
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(
                color: Colors.grey.withOpacity(.5),
              ),
            ),
            itemCount: pageNumbers.length,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(
                color: Colors.grey.withOpacity(.5),
              ),
            ),
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              int suraNumber = index + 1;
              String suraName = filteredData[index]["englishName"];
              String suraNameEnglishTranslated =
              filteredData[index]["englishNameTranslation"];
              int suraNumberInQuran = filteredData[index]["number"];
              String suraNameTranslated =
              getSurahNameArabic(suraNumber);
              int ayahCount = getVerseCount(suraNumber);

              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  child: ListTile(
                    leading: SizedBox(
                      width: 45,
                      height: 45,
                      child: Center(
                        child: Text(
                          suraNumber.toString(),
                          style: const TextStyle(
                              color: orangeColor, fontSize: 14),
                        ),
                      ),
                    ),
                    minVerticalPadding: 0,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          suraName,
                          style: const TextStyle(
                            color: blueColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          suraNameTranslated,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Quranfont"
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      "$suraNameEnglishTranslated ($ayahCount)",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.withOpacity(.8)),
                    ),
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => QuranViewPage(
                            shouldHighlightText: false,
                            highlightVerse: "",
                            jsonData: widget.suraJsonData,
                            pageNumber:
                            getPageNumber(suraNumberInQuran, 1),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          if (ayatFiltered != null)
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: ayatFiltered["occurences"] > 10
                  ? 10
                  : ayatFiltered["occurences"],
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: EasyContainer(
                    color: Colors.white70,
                    borderRadius: 14,
                    onTap: () async {},
                    child: Text(
                      "سورة ${getSurahNameArabic(ayatFiltered["result"][index]["surah"])} - ${getVerse(ayatFiltered["result"][index]["surah"], ayatFiltered["result"][index]["verse"], verseEndSymbol: true)}",
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                          color: Colors.black, fontSize: 17),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
