import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'dart:math' as math;

import '../services/weather_service.dart';
import 'home_skeleton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  dynamic _weather = {'temperature': 0, 'condition': ''};
  final TextEditingController _searchController = TextEditingController();
  String cityName = "";
  bool hasLoaded = false;
  double angle = 0;

  @override
  void initState() {
    if (mounted) {
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),
      );
      cityName = "Tallinn";
      getWeatherData(cityName);
    }
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.01,
                          horizontal: size.width * 0.05,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                width: size.width * 0.8,
                                alignment: Alignment.center,
                                child: Text(
                                  'Local Weather',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.questrial(
                                    color: const Color(0xff1D1617),
                                    fontSize: size.height * 0.025,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  hasLoaded = false;
                                  angle = angle + 90;
                                });
                                _weather = await getWeatherData(cityName);
                              },
                              child: Transform.rotate(
                                angle: angle * math.pi / 360,
                                child: const FaIcon(
                                  FontAwesomeIcons.arrowsRotate,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      searchWidget(size),
                      weatherInfoWidget(size),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchWidget(Size size) {
    return hasLoaded
        ? Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: size.width * 0.7,
                    child: searchCity(),
                  ),
                ),
                GestureDetector(
                  onTap: _searchController.text.isNotEmpty
                      ? () async {
                          setState(() {
                            cityName = toBeginningOfSentenceCase(_searchController.text)!;
                          });
                          _weather = await getWeatherData(toBeginningOfSentenceCase(_searchController.text)!);
                        }
                      : null,
                  child: Container(
                    width: size.width * 0.2,
                    padding: const EdgeInsets.only(top: 6, bottom: 6),
                    decoration: BoxDecoration(
                      color: _searchController.text.isNotEmpty ? Colors.blue : Colors.blue.shade200,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'Search',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(0.1, 0),
                end: const Alignment(-1, 0),
                colors: [Colors.grey.shade200, Colors.grey.shade100, Colors.grey.shade200],
              ),
            ),
          );
  }

  Widget weatherInfoWidget(Size size) {
    return hasLoaded
        ? _weather != null
            ? SizedBox(
                height: size.height,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: size.height * 0.03,
                      ),
                      child: Align(
                        child: Text(
                          cityName,
                          style: GoogleFonts.questrial(
                            color: Colors.black,
                            fontSize: size.height * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: size.height * 0.005,
                      ),
                      child: Align(
                        child: Text(
                          'Today',
                          style: GoogleFonts.questrial(
                            color: Colors.black54,
                            fontSize: size.height * 0.03,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: size.height * 0.03,
                      ),
                      child: Align(
                        child: Text(
                          '${_weather['temperature']}˚C',
                          style: GoogleFonts.questrial(
                            color: _weather['temperature'] <= 0
                                ? Colors.yellow
                                : _weather['temperature'] > 0 && _weather['temperature'] <= 15
                                    ? Colors.black
                                    : _weather['temperature'] > 15 && _weather['temperature'] < 30
                                        ? Colors.deepPurple
                                        : Colors.pink,
                            fontSize: size.height * 0.07,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.25),
                      child: const Divider(
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: size.height * 0.005,
                      ),
                      child: Align(
                        child: Text(
                          _weather['condition'],
                          style: GoogleFonts.questrial(
                            color: Colors.black54,
                            fontSize: size.height * 0.03,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox(
                width: size.width,
                height: size.height * 0.5,
                child: Center(
                  child: Text(
                    'No weather information for $cityName. Enter another city name.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.height * 0.022,
                    ),
                  ),
                ),
              )
        : Container(
            width: size.width,
            height: size.height,
            padding: EdgeInsets.only(
              top: size.height * 0.034,
            ),
            child: HomeSkeleton(),
          );
  }

  Future<dynamic> getWeatherData(String city) async {
    var weather = await _weatherService.getCurrentCityWeatherInfo(city);
    if (weather != null) {
      setState(() {
        _weather = weather;
        hasLoaded = true;
      });
      return weather;
    } else {
      setState(() {
        _weather = null;
        hasLoaded = true;
      });
      return null;
    }
  }

  Widget searchCity() {
    return TextFormField(
      controller: _searchController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      style: const TextStyle(fontSize: 17),
      enableSuggestions: false,
      onChanged: (String text) {
        setState(() {
          _searchController.text = text;
        });
        _searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: _searchController.text.length),
        );
      },
      decoration: InputDecoration(
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                icon: const Icon(Icons.clear, size: 25),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  _searchController.text = '';
                  setState(() {
                    cityName = 'Tallinn';
                  });
                  _weather = await getWeatherData("Tallinn");
                },
              )
            : null,
        hintText: 'Enter city name',
        hintStyle: const TextStyle(fontSize: 17),
        border: InputBorder.none,
      ),
    );
  }
}
