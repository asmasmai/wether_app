import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/views/weatherPage.dart';

class WeatherTabbedPage extends StatefulWidget {
  final List<Location> locations;
  final BuildContext context;
  const WeatherTabbedPage(this.locations, this.context);
  @override
  __WeatherTabbedPage createState() =>
      __WeatherTabbedPage(this.locations, this.context);
}

class __WeatherTabbedPage extends State<WeatherTabbedPage> {
  final List<Location> locations;
  final Location location;
  final BuildContext context;
  __WeatherTabbedPage(List<Location> locations, BuildContext context)
      : this.locations = locations,
        this.context = context,
        this.location = locations[0];
  @override
  void initState() {
    super.initState();
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
                              delegate:
                                  WeaatherCitiesSearch(location, locations));
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
                          this.locations, this.context, this.locations[0]),
                      WeatherPage(
                          this.locations, this.context, this.locations[1]),
                      WeatherPage(
                          this.locations, this.context, this.locations[2]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

// Cities search
class WeaatherCitiesSearch extends SearchDelegate<String> {
  final List<Location> locations;
  final Location location;
  WeaatherCitiesSearch(this.location, this.locations);

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
    return WeatherPage(locations, context, location);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
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
