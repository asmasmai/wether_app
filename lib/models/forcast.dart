import 'daily.dart';
import 'hourly.dart';

class Forcast {
  final List<Hourly> hourly;
  final List<Daily> daily;

  Forcast({this.hourly, this.daily});

  factory Forcast.fromJson(Map<String, dynamic> json) {
    List<dynamic> hourlyData = json['hourly'];
    List<dynamic> dailyData = json['daily'];

    List<Hourly> hourly = new List<Hourly>();
    List<Daily> daily = new List<Daily>();

    hourlyData.forEach((item) {
      var hour = Hourly.fromJson(item);
      hourly.add(hour);
    });

    dailyData.forEach((item) {
      var day = Daily.fromJson(item);
      daily.add(day);
    });

    return Forcast(hourly: hourly, daily: daily);
  }
}
