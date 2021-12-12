import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/models/forcast.dart';
import 'package:weather_app/models/location.dart';

class WeatherPage extends StatefulWidget {
  final BuildContext context;
  final Location location;
  const WeatherPage(this.context, this.location);
  @override
  _WeatherPage createState() => _WeatherPage(this.context, this.location);
}

class _WeatherPage extends State<WeatherPage> {
  final Location location;
  final BuildContext context;
  _WeatherPage(BuildContext context, Location location)
      : this.context = context,
        this.location = location;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: RefreshIndicator(
          onRefresh: () async {
            getForecast(this.location);
          },
          child: ListView(children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 0.0),
              height: 180.0,
              child: Column(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 15, top: 5, bottom: 0, right: 10),
                    child: Text(
                      "Next hours",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                  ),
                ),
                forcastViewsHourly(this.location),
              ]),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
              height: 500.0,
              child: Column(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 10, top: 5, bottom: 5, right: 10),
                    child: Text(
                      "Next days",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0.0),
                  height: 400.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 1), // changes position of shadow
                        )
                      ]),
                  child: Row(children: [
                    forcastViewsDaily(this.location),
                  ]),
                )
              ]),
            ),
          ]),
        ));
  }
}

// hours Forecat
Widget forcastViewsHourly(Location location) {
  Forcast _forcast;

  return FutureBuilder(
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        _forcast = snapshot.data;
        if (_forcast == null) {
          return Text("Error getting weather");
        } else {
          return hourlyBoxes(_forcast);
        }
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
    future: getForecast(location),
  );
}

// days Forecat
Widget forcastViewsDaily(Location location) {
  Forcast _forcast;

  return FutureBuilder(
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        _forcast = snapshot.data;
        if (_forcast == null) {
          return Text("Error getting weather");
        } else {
          return dailyBoxes(_forcast);
        }
      } else {
        return Center(child: CircularProgressIndicator());
      }
    },
    future: getForecast(location),
  );
}

// Hour Box widget
Widget hourlyBoxes(Forcast _forecast) {
  return Container(
      margin: EdgeInsets.symmetric(vertical: 0.0),
      height: 150.0,
      child: ListView.builder(
          padding: const EdgeInsets.only(left: 8, top: 0, bottom: 0, right: 8),
          scrollDirection: Axis.horizontal,
          itemCount: _forecast.hourly.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: const EdgeInsets.only(
                    left: 10, top: 10, bottom: 10, right: 10),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 1), // changes position of shadow
                      )
                    ]),
                child: Column(children: [
                  Text(
                    "${_forecast.hourly[index].temp}°",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: Colors.black),
                  ),
                  Text(
                    "${_forecast.hourly[index].feelsLike}°",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.blue),
                  ),
                  getWeatherIcon(_forecast.hourly[index].icon),
                  Text(
                    "${getTimeFromTimestamp(_forecast.hourly[index].dt)}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.grey),
                  ),
                ]));
          }));
}

// Daily Box Widget
Widget dailyBoxes(Forcast _forcast) {
  return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.only(left: 8, top: 0, bottom: 0, right: 8),
          itemCount: _forcast.daily.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: const EdgeInsets.only(
                    left: 0, top: 5, bottom: 5, right: 10),
                margin: const EdgeInsets.all(5),
                child: Row(children: [
                  Expanded(
                    child: Row(children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            padding: const EdgeInsets.only(
                                left: 15, top: 5, bottom: 0, right: 10),
                            child: getWeatherIconSmall(
                                _forcast.daily[index].icon)),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Column(children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 15, top: 5, bottom: 0, right: 10),
                          child: Text(
                            "${getDateFromTimestamp(_forcast.daily[index].dt)}",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 15, top: 5, bottom: 0, right: 10),
                          child: Text(
                            "${_forcast.daily[index].description}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                      child: Text(
                    "${_forcast.daily[index].high.toInt()}°  ${_forcast.daily[index].low.toInt()}°",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  )),
                ]));
          }));
}

//Time Converter
String getTimeFromTimestamp(int timestamp) {
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var formatter = new DateFormat('h:mm a');
  return formatter.format(date);
}

// Date Converter
String getDateFromTimestamp(int timestamp) {
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var formatter = new DateFormat('E, MMMd');
  return formatter.format(date);
}

Image getWeatherIcon(String _icon) {
  String urlPath = 'http://openweathermap.org/img/wn/';
  String imageExtension = ".png";
  return Image.network(
    urlPath + _icon + imageExtension,
    width: 70,
    height: 70,
  );
}

Image getWeatherIconSmall(String _icon) {
  String urlPath = 'http://openweathermap.org/img/wn/';
  String imageExtension = ".png";
  return Image.network(
    urlPath + _icon + imageExtension,
    width: 40,
    height: 40,
  );
}

// Fetch data
Future getForecast(Location location) async {
  Forcast forecast;
  String apiKey = "482944e26d320a80bd5e4f23b3de7d1f";
  String lat = location.lat;
  String lon = location.lon;
  var url =
      "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&appid=$apiKey&units=metric";

  final response = await http.get(url);

  if (response.statusCode == 200) {
    forecast = Forcast.fromJson(jsonDecode(response.body));
  }

  return forecast;
}
