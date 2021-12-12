class Location {
  final String city;
  final String country;
  final String lat;
  final String lon;

  Location({this.city, this.country, this.lat, this.lon});

  factory Location.fromCsv(List<String> csvLine) {
    return Location(
      city: csvLine[1],
      country: csvLine[4],
      lat: csvLine[5],
      lon: csvLine[6],
    );
  }
}
