// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_ap/models/post_model.dart';

Future<PostModel?> GetWeatherData(String cityName) async {
  // ignore: prefer_const_declarations
  final apiKey = "274fcc00167ac224bb1701b6d2786053"; 
  final apiUrl ='https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Response = jsonDecode(response.body);
      PostModel weatherData = PostModel.fromJson(Response);
      return weatherData;
    } else {
      print("Failed to load weather data");
      return null;
    }
  } catch (error) {
    print("Error: $error");
    return null;
  }
}
