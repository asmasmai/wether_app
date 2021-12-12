import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/views/weatherPage.dart';

class WeatherTabbedPage extends StatefulWidget {
  @override
  __WeatherTabbedPage createState() => __WeatherTabbedPage();
}

class __WeatherTabbedPage extends State<WeatherTabbedPage> {
  final List<Location> locations = new List<Location>();
  @override
  void initState() {
    super.initState();
    initLocation();
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Simple Weather';
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        title: title,
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  flexibleSpace: new FlexibleSpaceBar(),
                  actions: [
                    IconButton(
                        icon: Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          showSearch(
                              context: context,
                              delegate: WeaatherCitiesSearch(locations));
                        })
                  ],
                  title: Text(
                    title,
                    textAlign: TextAlign.center,
                  ),
                  floating: true,
                  expandedHeight: 120.0,
                  bottom: new TabBar(
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    tabs: [
                      new Tab(text: 'Rio De Janneiro'),
                      new Tab(text: 'Beijing'),
                      new Tab(text: 'Los Angeles'),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    children: <Widget>[
                      WeatherPage(
                          this.context,
                          locations.firstWhere(
                              (element) => element.city == "Rio de Janeiro")),
                      WeatherPage(
                          this.context,
                          locations.firstWhere(
                              (element) => element.city == "Beijing")),
                      WeatherPage(
                          this.context,
                          locations.firstWhere(
                              (element) => element.city == "Los Angeles")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future initLocation() async {
    // Fetch data from csv file
    final linesData =
        File("/Users/asma/Projects/flutter/weather_app/assets/Cities.csv")
            .readAsLinesSync()
            .skip(1)
            .toList();
    for (var line in linesData) {
      final data = line.split(',');
      locations.add(Location.fromCsv(data));
    }
  }
}

// Cities search
class WeaatherCitiesSearch extends SearchDelegate<String> {
  final List<Location> locations;
  WeaatherCitiesSearch(this.locations);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    var searchedLocation =
        locations.firstWhere((element) => element.city == query);
    return WeatherPage(context, searchedLocation);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Display suggestionList For search
    final sugggestionCitiesList = locations
        .map((value) => value.city)
        .toList()
        .where((element) => element.startsWith(query))
        .toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: Icon(Icons.location_city),
        title: RichText(
          text: TextSpan(
              text: sugggestionCitiesList[index].substring(0, query.length),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: sugggestionCitiesList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey))
              ]),
        ),
      ),
      itemCount: sugggestionCitiesList.length,
    );
  }
}
