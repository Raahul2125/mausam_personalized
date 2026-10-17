import 'weather_service.dart';
import 'package:flutter/foundation.dart';

Future<void> testWeather() async {
  try {
    final weather =
        await WeatherService.getChennaiWeather();

    debugPrint(
      'Location: ${weather.location}',
    );

    debugPrint(
      'Temperature: ${weather.temperature}°C',
    );

    debugPrint(
      'Feels Like: ${weather.feelsLike}°C',
    );

    debugPrint(
      'Humidity: ${weather.humidity}%',
    );

    debugPrint(
      'Wind: ${weather.windSpeed} km/h',
    );

    debugPrint(
      'Rain Chance: ${weather.rainChance}%',
    );

    debugPrint(
      'UV Index: ${weather.uvIndex}',
    );

    debugPrint(
      'Visibility: ${weather.visibility} km',
    );

    debugPrint(
      'Weather Code: ${weather.weatherCode}',
    );

    debugPrint(
      'Description: ${weather.description}',
    );

    debugPrint(
      'High: ${weather.maxTemperature}°C',
    );

    debugPrint(
      'Low: ${weather.minTemperature}°C',
    );
  } catch (e) {
    debugPrint(
      'Weather error: $e',
    );
  }
}