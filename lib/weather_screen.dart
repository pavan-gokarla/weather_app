// ignore_for_file: avoid_print

import "dart:convert";
import "dart:ui";
import "package:flutter/widgets.dart";
import "package:intl/intl.dart";
import 'package:loading_animation_widget/loading_animation_widget.dart';
import "package:flutter/material.dart";
import "package:weather_app/additonal_info_item.dart";
import "package:weather_app/hourly_forecast.dart";
import 'package:http/http.dart' as http;

const apiKey = "9296363117b5ce52c8e71568753ce8cc";

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?q=visakhapatnam&appid=$apiKey"),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != "200") {
        throw "An unexpected Error occur";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white, size: 50),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "An Unexpected Error has Occured",
                style: TextStyle(fontSize: 20),
              ),
            );
          }
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentHumdity = currentWeatherData['main']['humidity'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentWindspeed = currentWeatherData['wind']['speed'];
          return ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "$currentTemp °K",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Icon(
                              currentSky == 'Clouds' || currentSky == 'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                              size: 64,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "$currentSky",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Hourly Forecast",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: [
                    //       for (int i = 0; i < 5; i++)
                    //         HourlyForeCast(
                    //           time: data['list'][i + 1]['dt'].toString(),
                    //           icon: data['list'][i + 1]['weather'][0]['main'] ==
                    //                       "Rain" ||
                    //                   data['list'][i + 1]['weather'][0]
                    //                           ['main'] ==
                    //                       "Clouds"
                    //               ? Icons.cloud
                    //               : Icons.sunny,
                    //           temperature: data['list'][i + 1]['main']['temp']
                    //               .toString(),
                    //         ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          //final hourlyForeCast = data['list'][index + 1];
                          final time =
                              DateTime.parse(data['list'][index + 1]['dt_txt']);

                          return HourlyForeCast(
                            time: DateFormat("j").format(time),
                            temperature: data['list'][index + 1]['main']['temp']
                                .toString(),
                            icon: data['list'][index + 1]['weather'][0]
                                            ['main'] ==
                                        "Rain" ||
                                    data['list'][index + 1]['weather'][0]
                                            ['main'] ==
                                        "Clouds"
                                ? Icons.cloud
                                : Icons.sunny,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Weather Forecast",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalInfoItem(
                          icon: Icons.water_drop,
                          label: "Humidity",
                          value: "$currentHumdity",
                        ),
                        AdditionalInfoItem(
                          icon: Icons.air,
                          label: "Wind Speed",
                          value: "$currentWindspeed",
                        ),
                        AdditionalInfoItem(
                          icon: Icons.bubble_chart,
                          value: "$currentPressure",
                          label: "Pressure",
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
