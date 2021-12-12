import 'package:flutter/material.dart';
import 'package:weather_app/views/weatherTabbedPage.dart';

import 'models/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  List<Location> locations = [
    new Location(
        city: "rio de janeiro",
        country: "brazil",
        lat: "22.9068",
        lon: "43.1729"),
    new Location(
        city: "beijing", country: "china", lat: "39.9042", lon: "116.4074"),
    new Location(
        city: "los Angeles",
        country: "US State",
        lat: "34.0522",
        lon: "118.2437")
  ];
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WeatherTabbedPage(locations, context),
    );
  }
}
