import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApi {
  final String apiKey;

  WeatherApi(this.apiKey);

  Future<Map<String, dynamic>> getWeather(String city) async {
    final response = await http.get(
      'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey' as Uri,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
