import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherServices('de831ce130e9822173fc7f8543023f73');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    print("Detected City: $cityName");

    if (cityName.isEmpty || cityName == "Unknown City") {
      print("Error: City name is empty or invalid");
      return;
    }

    try {
      final weather = await _weatherService.getWeather(cityName);
      print("Weather Data: ${weather.cityName}, ${weather.temperature}");

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print("Error fetching weather: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _weather == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Fetching Weather...", style: TextStyle(fontSize: 16)),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_weather!.cityName,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Lottie.asset('assets/cloud.json'),
                  Text('${_weather!.temperature.round()}°C',
                      style: TextStyle(fontSize: 24, color: Colors.blueAccent)),
                ],
              ),
      ),
    );
  }
}
