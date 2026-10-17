import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/weather.dart';

class WeatherService {
  // ============================================================
  // CHENNAI LOCATION
  // ============================================================

  static const double chennaiLatitude = 13.0827;
  static const double chennaiLongitude = 80.2707;

  // ============================================================
  // GET CHENNAI WEATHER
  // ============================================================

  static Future<Weather> getChennaiWeather() async {
    // ------------------------------------------------------------
    // WEATHER API
    // ------------------------------------------------------------

    final weatherUrl = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$chennaiLatitude'
      '&longitude=$chennaiLongitude'
      '&current='
          'temperature_2m,'
          'relative_humidity_2m,'
          'apparent_temperature,'
          'weather_code,'
          'wind_speed_10m,'
          'visibility'
      '&hourly='
          'temperature_2m,'
          'precipitation_probability,'
          'visibility'
      '&daily='
          'temperature_2m_max,'
          'temperature_2m_min,'
          'precipitation_probability_max,'
          'uv_index_max'
      '&timezone=Asia%2FKolkata'
      '&forecast_days=7',
    );

    // ------------------------------------------------------------
    // AQI API
    // ------------------------------------------------------------

    final aqiUrl = Uri.parse(
      'https://air-quality-api.open-meteo.com/v1/air-quality'
      '?latitude=$chennaiLatitude'
      '&longitude=$chennaiLongitude'
      '&current=european_aqi'
      '&timezone=Asia%2FKolkata',
    );

    try {
      // ==========================================================
      // FETCH WEATHER
      // ==========================================================

      final weatherResponse = await http
          .get(weatherUrl)
          .timeout(
            const Duration(seconds: 15),
          );

      if (weatherResponse.statusCode != 200) {
        throw Exception(
          'Weather API returned ${weatherResponse.statusCode}',
        );
      }

      final weatherData =
          jsonDecode(weatherResponse.body)
              as Map<String, dynamic>;

      // ==========================================================
      // FETCH AQI
      // ==========================================================

      int aqi = 0;

      try {
        final aqiResponse = await http
            .get(aqiUrl)
            .timeout(
              const Duration(seconds: 10),
            );

        if (aqiResponse.statusCode == 200) {
          final aqiData =
              jsonDecode(aqiResponse.body)
                  as Map<String, dynamic>;

          final currentAqi =
              aqiData['current']
                  as Map<String, dynamic>?;

          final aqiValue =
              currentAqi?['european_aqi'];

          if (aqiValue is num) {
            aqi = aqiValue.round();
          }
        }
      } catch (_) {
        // --------------------------------------------------------
        // AQI FAILURE SHOULD NOT BREAK WEATHER
        // --------------------------------------------------------
        //
        // If AQI API fails, weather data will still be displayed.
        //
        aqi = 0;
      }

      // ==========================================================
      // CREATE WEATHER OBJECT
      // ==========================================================

      return Weather.fromJson(
        weatherData,
        aqi: aqi,
      );
    } catch (e) {
      throw Exception(
        'Unable to load Chennai weather: $e',
      );
    }
  }

  // ============================================================
  // WEATHER DESCRIPTION
  // ============================================================

  static String getWeatherDescription(
    int code,
  ) {
    switch (code) {
      // ----------------------------------------------------------
      // CLEAR
      // ----------------------------------------------------------

      case 0:
        return 'Clear Sky';

      case 1:
        return 'Mainly Clear';

      case 2:
        return 'Partly Cloudy';

      case 3:
        return 'Overcast';

      // ----------------------------------------------------------
      // FOG
      // ----------------------------------------------------------

      case 45:
      case 48:
        return 'Foggy';

      // ----------------------------------------------------------
      // DRIZZLE
      // ----------------------------------------------------------

      case 51:
        return 'Light Drizzle';

      case 53:
        return 'Moderate Drizzle';

      case 55:
        return 'Dense Drizzle';

      case 56:
        return 'Light Freezing Drizzle';

      case 57:
        return 'Dense Freezing Drizzle';

      // ----------------------------------------------------------
      // RAIN
      // ----------------------------------------------------------

      case 61:
        return 'Light Rain';

      case 63:
        return 'Moderate Rain';

      case 65:
        return 'Heavy Rain';

      case 66:
        return 'Light Freezing Rain';

      case 67:
        return 'Heavy Freezing Rain';

      // ----------------------------------------------------------
      // SNOW
      // ----------------------------------------------------------

      case 71:
        return 'Light Snow';

      case 73:
        return 'Moderate Snow';

      case 75:
        return 'Heavy Snow';

      case 77:
        return 'Snow Grains';

      // ----------------------------------------------------------
      // RAIN SHOWERS
      // ----------------------------------------------------------

      case 80:
        return 'Light Rain Showers';

      case 81:
        return 'Moderate Rain Showers';

      case 82:
        return 'Heavy Rain Showers';

      // ----------------------------------------------------------
      // SNOW SHOWERS
      // ----------------------------------------------------------

      case 85:
        return 'Light Snow Showers';

      case 86:
        return 'Heavy Snow Showers';

      // ----------------------------------------------------------
      // THUNDERSTORM
      // ----------------------------------------------------------

      case 95:
        return 'Thunderstorm';

      case 96:
        return 'Thunderstorm with Light Hail';

      case 99:
        return 'Thunderstorm with Heavy Hail';

      // ----------------------------------------------------------
      // UNKNOWN
      // ----------------------------------------------------------

      default:
        return 'Unknown';
    }
  }
}