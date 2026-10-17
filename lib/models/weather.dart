// ============================================================================
// WEATHER MODEL
// ============================================================================

class Weather {
  final String location;

  final double temperature;
  final double feelsLike;

  final int humidity;

  final double windSpeed;

  final int rainChance;

  final int weatherCode;

  final String description;

  final double maxTemperature;
  final double minTemperature;

  final int uvIndex;

  final int aqi;

  final double visibility;

  final List<DailyForecast> forecast;

  const Weather({
    required this.location,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.rainChance,
    required this.weatherCode,
    required this.description,
    required this.maxTemperature,
    required this.minTemperature,
    required this.uvIndex,
    required this.aqi,
    required this.visibility,
    required this.forecast,
  });

  // ==========================================================================
  // FROM JSON
  // ==========================================================================

  factory Weather.fromJson(
    Map<String, dynamic> json, {
    int? aqi,
  }) {
    final current =
        json['current'] is Map<String, dynamic>
            ? json['current'] as Map<String, dynamic>
            : <String, dynamic>{};

    final daily =
        json['daily'] is Map<String, dynamic>
            ? json['daily'] as Map<String, dynamic>
            : <String, dynamic>{};

    // ------------------------------------------------------------------------
    // CURRENT WEATHER
    // ------------------------------------------------------------------------

    final temperature = _toDouble(
      current['temperature_2m'],
    );

    final feelsLike = _toDouble(
      current['apparent_temperature'],
    );

    final humidity = _toInt(
      current['relative_humidity_2m'],
    );

    final windSpeed = _toDouble(
      current['wind_speed_10m'],
    );

    final weatherCode = _toInt(
      current['weather_code'],
    );

    final visibility = _visibilityFromCurrent(
      current['visibility'],
    );

    // ------------------------------------------------------------------------
    // DAILY DATA
    // ------------------------------------------------------------------------

    final dates = _toList(
      daily['time'],
    );

    final maxTemps = _toList(
      daily['temperature_2m_max'],
    );

    final minTemps = _toList(
      daily['temperature_2m_min'],
    );

    final rainChances = _toList(
      daily['precipitation_probability_max'],
    );

    final uvValues = _toList(
      daily['uv_index_max'],
    );

    final weatherCodes = _toList(
      daily['weather_code'],
    );

    // ------------------------------------------------------------------------
    // TODAY VALUES
    // ------------------------------------------------------------------------

    final maxTemperature =
        maxTemps.isNotEmpty
            ? _toDouble(maxTemps[0])
            : temperature;

    final minTemperature =
        minTemps.isNotEmpty
            ? _toDouble(minTemps[0])
            : temperature;

    final rainChance =
        rainChances.isNotEmpty
            ? _toInt(rainChances[0])
            : 0;

    final uvIndex =
        uvValues.isNotEmpty
            ? _toInt(uvValues[0])
            : 0;

    // ------------------------------------------------------------------------
    // 7-DAY FORECAST
    // ------------------------------------------------------------------------

    final List<DailyForecast> forecast = [];

    final forecastLength = dates.length;

    for (int i = 0; i < forecastLength; i++) {
      final date = dates[i].toString();

      final max =
          i < maxTemps.length
              ? _toDouble(maxTemps[i])
              : 0.0;

      final min =
          i < minTemps.length
              ? _toDouble(minTemps[i])
              : 0.0;

      final rain =
          i < rainChances.length
              ? _toInt(rainChances[i])
              : 0;

      final code =
          i < weatherCodes.length
              ? _toInt(weatherCodes[i])
              : 0;

      forecast.add(
        DailyForecast(
          date: date,
          maxTemperature: max,
          minTemperature: min,
          rainChance: rain,
          weatherCode: code,
          description: _descriptionFromCode(code),
        ),
      );
    }

    // ------------------------------------------------------------------------
    // RETURN WEATHER
    // ------------------------------------------------------------------------

    return Weather(
      location: 'Chennai',
      temperature: temperature,
      feelsLike: feelsLike,
      humidity: humidity,
      windSpeed: windSpeed,
      rainChance: rainChance,
      weatherCode: weatherCode,
      description: _descriptionFromCode(weatherCode),
      maxTemperature: maxTemperature,
      minTemperature: minTemperature,
      uvIndex: uvIndex,
      aqi: aqi ?? 0,
      visibility: visibility,
      forecast: forecast,
    );
  }

  // ==========================================================================
  // WEATHER DESCRIPTION
  // ==========================================================================

  static String _descriptionFromCode(
    int code,
  ) {
    switch (code) {
      case 0:
        return 'Clear Sky';

      case 1:
        return 'Mainly Clear';

      case 2:
        return 'Partly Cloudy';

      case 3:
        return 'Overcast';

      case 45:
      case 48:
        return 'Foggy';

      case 51:
      case 53:
      case 55:
        return 'Drizzle';

      case 56:
      case 57:
        return 'Freezing Drizzle';

      case 61:
      case 63:
      case 65:
        return 'Rain';

      case 66:
      case 67:
        return 'Freezing Rain';

      case 71:
      case 73:
      case 75:
        return 'Snow';

      case 77:
        return 'Snow Grains';

      case 80:
      case 81:
      case 82:
        return 'Rain Showers';

      case 85:
      case 86:
        return 'Snow Showers';

      case 95:
        return 'Thunderstorm';

      case 96:
      case 99:
        return 'Thunderstorm with Hail';

      default:
        return 'Unknown';
    }
  }

  // ==========================================================================
  // SAFE DOUBLE CONVERSION
  // ==========================================================================

  static double _toDouble(
    dynamic value,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }

  // ==========================================================================
  // SAFE INT CONVERSION
  // ==========================================================================

  static int _toInt(
    dynamic value,
  ) {
    if (value is num) {
      return value.round();
    }

    if (value is String) {
      return double.tryParse(value)?.round() ?? 0;
    }

    return 0;
  }

  // ==========================================================================
  // SAFE LIST CONVERSION
  // ==========================================================================

  static List<dynamic> _toList(
    dynamic value,
  ) {
    if (value is List) {
      return value;
    }

    return <dynamic>[];
  }

  // ==========================================================================
  // VISIBILITY
  // ==========================================================================

  static double _visibilityFromCurrent(
    dynamic value,
  ) {
    if (value is num) {
      // Open-Meteo visibility is normally in metres.
      // Convert to kilometres.
      return value.toDouble() / 1000;
    }

    return 0.0;
  }
}

// ============================================================================
// DAILY FORECAST MODEL
// ============================================================================

class DailyForecast {
  final String date;

  final double maxTemperature;
  final double minTemperature;

  final int rainChance;

  final int weatherCode;

  final String description;

  const DailyForecast({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.rainChance,
    required this.weatherCode,
    required this.description,
  });
}