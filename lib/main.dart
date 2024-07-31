import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pl_PL', null);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class _MainAppState extends State<MainApp> {
  int index = 0;
  String miasto = "Wroclaw";
  List<String> temperatura = ["", "", "", "", "", "", ""];
  List<String> temperaturaMax = ["", "", "", "", "", "", ""];
  List<String> temperaturaMin = ["", "", "", "", "", "", ""];
  List<String> niebo = ["", "", "", "", "", "", ""];
  List<String> zachmurzenie = ["", "", "", "", "", "", ""];
  List<String> wiatr = ["", "", "", "", "", "", ""];
  List<String> wilgotnosc = ["", "", "", "", "", "", ""];
  List<String> szansaopady = ["", "", "", "", "", "", ""];
  final TextEditingController _textFieldController =
      TextEditingController(text: "");

  void sendStringToPython(String text) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/send_string'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'text': text}),
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to send string');
    }
  }

  Future api() async {
    const String url = 'http://127.0.0.1:5000';
    var response = await http.get(Uri.parse(url));

    Map<String, dynamic> data = json.decode(response.body);

    for (int i = 0; i < 7; i++) {
      miasto = data['city'];
      temperatura[i] = data['temperatura$i'];
      temperaturaMax[i] = data['tempmax$i'];
      temperaturaMin[i] = data['tempmin$i'];
      zachmurzenie[i] = data['zachmurzenie$i'];
      wiatr[i] = data['wiatr$i'];
      wilgotnosc[i] = data['wilgotnosc$i'];
      szansaopady[i] = data["szansaopady$i"];
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 15), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var dzis = DateTime.now().add(Duration(days: index));
    var format = DateFormat('EEEE', 'pl');
    var format2 = DateFormat('LLLL', 'pl');
    String dzienTygodia = format.format(dzis).capitalize();
    String miesiac = format2.format(dzis);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.01,
              ),
              SizedBox(
                width: screenWidth * 0.8,
                child: SearchBar(
                  hintText: "miasto",
                  leading: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        api();
                        sendStringToPython(
                            _textFieldController.text.toString());
                        Future.delayed(const Duration(seconds: 12), () {
                          api();
                          setState(() {
                            api();
                          });
                        });
                      });
                    },
                  ),
                  controller: _textFieldController,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(80, 0, 0, 0),
                      blurRadius: 6,
                      offset: Offset(6, 6), 
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: const LinearGradient(colors: [
                        Color.fromARGB(180, 82, 209, 255),
                        Color.fromARGB(180, 55, 47, 200),
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.8,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                _textFieldController.text.toString(),
                                style: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontSize: screenHeight * 0.03,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                        255, 212, 238, 255)),
                              ),
                              SizedBox(
                                width: screenHeight * 0.04,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "$dzienTygodia, ${dzis.day} $miesiac",
                                style: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontSize: screenHeight * 0.01,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                        180, 212, 238, 255)),
                              ),
                              SizedBox(
                                width: screenHeight * 0.05,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: screenHeight * 0.06),
                          Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: screenHeight * 0.04),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: screenHeight * 0.01,
                                          ),
                                          Text(
                                            "${temperaturaMin[index]}° - ${temperaturaMax[index]}°",
                                            style: TextStyle(
                                                fontFamily: "OpenSans",
                                                fontSize: screenHeight * 0.02,
                                                color: const Color.fromARGB(
                                                    255, 212, 238, 255)),
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.01,
                                          ),
                                          Image.asset(
                                            obrazki(zachmurzenie[index]),
                                            height: screenHeight * 0.1,
                                            width: screenHeight * 0.1,
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.01,
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.28,
                                            child: Text(
                                              zachmurzenie[index],
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: "OpenSans",
                                                  fontSize:
                                                      screenHeight * 0.012,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color.fromARGB(
                                                      180, 212, 238, 255)),
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: screenHeight * 0.025,
                                        top: screenHeight * 0.03),
                                    child: Text(
                                      "${temperatura[index]}°",
                                      style: TextStyle(
                                          fontFamily: "OpenSans",
                                          fontSize: screenHeight * 0.08,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(
                                              255, 212, 238, 255)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        height: screenWidth * 0.2,
                        width: screenWidth * 0.2,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(55, 14, 136, 217),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Image.asset("assets/wind-2.png"),
                      ),
                      Text(
                        wiatr[index],
                        style: TextStyle(
                            fontFamily: "TitanOne",
                            fontSize: screenHeight * 0.015,
                            color: const Color.fromARGB(70, 0, 0, 0)),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: screenWidth * 0.1,
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.035,
                            right: screenWidth * 0.026),
                        height: screenWidth * 0.2,
                        width: screenWidth * 0.2,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(55, 23, 73, 199),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Image.asset("assets/humidity.png"),
                      ),
                      Text(
                        wilgotnosc[index],
                        style: TextStyle(
                            fontFamily: "TitanOne",
                            fontSize: screenHeight * 0.015,
                            color: const Color.fromARGB(70, 0, 0, 0)),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: screenWidth * 0.1,
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.035),
                        height: screenWidth * 0.2,
                        width: screenWidth * 0.2,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(55, 32, 23, 199),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Image.asset("assets/umbrella-2.png"),
                      ),
                      Text(
                        wilgotnosc[index],
                        style: TextStyle(
                            fontFamily: "TitanOne",
                            fontSize: screenHeight * 0.015,
                            color: const Color.fromARGB(70, 0, 0, 0)),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.06,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: screenWidth * 0.05),
                    card(temperatura[0], obrazki(zachmurzenie[0]), context, 0),
                    card(temperatura[1], obrazki(zachmurzenie[1]), context, 1),
                    card(temperatura[2], obrazki(zachmurzenie[2]), context, 2),
                    card(temperatura[3], obrazki(zachmurzenie[3]), context, 3),
                    card(temperatura[4], obrazki(zachmurzenie[4]), context, 4),
                    card(temperatura[5], obrazki(zachmurzenie[5]), context, 5),
                    card(temperatura[6], obrazki(zachmurzenie[6]), context, 6),
                    SizedBox(width: screenWidth * 0.05),
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth * 0.8,
                child: const Divider(
                  thickness: 0.5,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String skrot(String dzien) {
    if (dzien == "Poniedziałek") {
      return "Pon";
    }

    if (dzien == "Wtorek") {
      return "Wt";
    }
    if (dzien == "Środa") {
      return "Śr";
    }

    if (dzien == "Czwartek") {
      return "Czw";
    }
    if (dzien == "Piątek") {
      return "Pt";
    }

    if (dzien == "Sobota") {
      return "Sb";
    }
    if (dzien == "Niedziela") {
      return "Ndz";
    } else {
      return "error";
    }
  }

  Widget card(
    String temp,
    String photo,
    context,
    int dayIndex,
  ) {
    var dzien = DateTime.now().add(Duration(days: dayIndex));
    var format = DateFormat('EEEE', 'pl');
    String dzienTygodia = format.format(dzien).capitalize();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool same = dayIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          index = dayIndex;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenWidth * 0.02),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            same
                ? const BoxShadow(
                    color: Color.fromARGB(120, 0, 0, 0),
                    blurRadius: 4,
                    spreadRadius: 0.5,
                    offset: Offset(6, 6),
                  )
                : const BoxShadow(
                    color: Color.fromARGB(80, 0, 0, 0),
                    blurRadius: 6,
                    offset: Offset(4, 4),
                  )
          ],
        ),
        child: Container(
          width: screenWidth * 0.2,
          height: screenWidth * 0.45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(colors: [
              Color.fromARGB(140, 82, 209, 255),
              Color.fromARGB(140, 55, 47, 200),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$temp°",
                style: TextStyle(
                    fontFamily: "OpenSans",
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 212, 238, 255)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenWidth * 0.015),
                child: Image.asset(photo),
              ),
              Text(
                skrot(dzienTygodia),
                style: TextStyle(
                    fontFamily: "OpenSans",
                    fontSize: screenHeight * 0.015,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 212, 238, 255)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String obrazki(String stanPogody) {
  if (stanPogody.contains("Przeważnie słonecznie")) {
    return "assets/day_partial_cloud.png";
  }
  if (stanPogody.contains("Niebo niewidoczne, bez")) {
    return "assets/cloudy.png";
  }
  if (stanPogody.contains("Częściowe zachmurzenie")) {
    return "assets/day_partial_cloud.png";
  }
  if (stanPogody.contains("Przewaga chmur")) {
    return "assets/cloudy.png";
  }
  if (stanPogody.contains("Niebo niewidoczne, niewielki")) {
    return "assets/rain.png";
  }
  if (stanPogody.contains("Bezchmurnie")) {
    return "assets/day_clear.png";
  }
  if (stanPogody.contains("opady")) {
    return "assets/rain.png";
  }
  if (stanPogody.contains("Zachmurzenie")) {
    return "assets/cloudy.png";
  }
  if (stanPogody.contains("Niebo niewidoczne, bez")) {
    return "assets/cloudy.png";
  }
  if (stanPogody.contains("śnieg")) {
    return "assets/snow.png";
  }
  if (stanPogody.contains("grad")) {
    return "assets/day_rain_thunder.png";
  }
  if (stanPogody.contains("mgł")) {
    return "assets/mist.png";
  } else {
    return "assets/day_partial_cloud.png";
  }
}

