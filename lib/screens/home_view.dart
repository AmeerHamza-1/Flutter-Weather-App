import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_ap/model.dart';
import 'package:weather_ap/models/post_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  PostModel? weatherData;
  final TextEditingController cityController = TextEditingController();

  bool isLoading = false;
  bool isError = false;

  Future<void> getWeatherData() async {
    setState(() {
      isLoading = true;
      isError = false;
      weatherData = null;
    });

    final data = await GetWeatherData(cityController.text);

    if (data != null) {
      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } else {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  String weatherAnimation(String? mainCondition, int? sunrise, int? sunset) {
    if (mainCondition == null) return 'assets/animation/sunny.json';

    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final bool isDayTime =
        currentTime >= (sunrise ?? 0) && currentTime <= (sunset ?? 0);

    switch (mainCondition.toLowerCase()) {
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'broken clouds':
      case 'few clouds':
        return isDayTime
            ? 'assets/animation/mist.json'
            : 'assets/animation/mist_night.json';
      case 'clouds':
      case 'overcast clouds':
        return 'assets/animation/clouds.json';
      case 'drizzle':
      case 'rain':
      case 'shower rain':
        return isDayTime
            ? 'assets/animation/rain.json'
            : 'assets/animation/rain_night.json';
      case 'snow':
      case 'light snow':
        return 'assets/animation/snow.json';
      case 'clear':
        return isDayTime
            ? 'assets/animation/sunny.json'
            : 'assets/animation/clear_night.json';
      case 'thunderstorm':
        return 'assets/animation/thunderstorm.json';
      default:
        return isDayTime
            ? 'assets/animation/sunny.json'
            : 'assets/animation/clear_night.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.tealAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: cityController,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.black54),
                      labelText: 'Enter City Name',
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            getWeatherData();
                            FocusScope.of(context).unfocus();
                          }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : weatherData != null
                      ? Column(
                          children: [
                            Lottie.asset(
                              weatherAnimation(
                                weatherData!.weather![0].description ?? "",
                                weatherData!.sys?.sunrise,
                                weatherData!.sys?.sunset,
                              ),
                              height: 200,
                              width: 200,
                            ),
                            const SizedBox(height: 20),
                            Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          weatherData!.name ?? "",
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${weatherData!.main!.temp?.toStringAsFixed(1)}°C',
                                      style: const TextStyle(
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      weatherData!.weather![0].description ??
                                          "",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        const Icon(Icons.water_drop,
                                            color: Colors.blue),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Humidity: ${weatherData!.main!.humidity}%',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Icon(Icons.air,
                                            color: Colors.lightBlue),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Wind: ${weatherData!.wind!.speed} m/s',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Container(
                            height: 300,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isError
                                    ? const Text(
                                        'City not found. Please enter a valid city name.',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    : const Text(
                                        'Enter a city to get weather information',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                              ],
                            ),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
