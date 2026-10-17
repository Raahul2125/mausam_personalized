import '../../models/user_profile.dart';
import '../../models/weather.dart';

class PersonalizationEngine {
  // ============================================================
  // TITLE
  // ============================================================

  static String getTitle(UserPurpose purpose) {
    switch (purpose) {
      case UserPurpose.fitness:
        return 'Fitness Weather';

      case UserPurpose.travel:
        return 'Travel Weather';

      case UserPurpose.farming:
        return 'Farming Weather';

      case UserPurpose.health:
        return 'Health Weather';

      case UserPurpose.surfing:
        return 'Surfing Weather';

      case UserPurpose.eventPlanner:
        return 'Event Planner Weather';
    }
  }

  // ============================================================
  // ICON
  // ============================================================

  static String getIcon(UserPurpose purpose) {
    switch (purpose) {
      case UserPurpose.fitness:
        return '🏃';

      case UserPurpose.travel:
        return '✈️';

      case UserPurpose.farming:
        return '🌱';

      case UserPurpose.health:
        return '❤️';

      case UserPurpose.surfing:
        return '🏄';

      case UserPurpose.eventPlanner:
        return '🎉';
    }
  }

  // ============================================================
  // PERSONALIZED RECOMMENDATION
  // ============================================================

  static String getRecommendation(
    UserPurpose purpose,
    Weather weather,
  ) {
    switch (purpose) {
      case UserPurpose.fitness:
        return _fitnessRecommendation(weather);

      case UserPurpose.travel:
        return _travelRecommendation(weather);

      case UserPurpose.farming:
        return _farmingRecommendation(weather);

      case UserPurpose.health:
        return _healthRecommendation(weather);

      case UserPurpose.surfing:
        return _surfingRecommendation(weather);

      case UserPurpose.eventPlanner:
        return _eventRecommendation(weather);
    }
  }

  // ============================================================
  // FITNESS
  // ============================================================

  static String _fitnessRecommendation(Weather weather) {
    if (weather.rainChance >= 60) {
      return 'High chance of rain. Consider indoor exercise today.';
    }

    if (weather.temperature >= 35) {
      return 'It is quite hot outside. Exercise during the early morning or evening and stay hydrated.';
    }

    if (weather.uvIndex >= 8) {
      return 'UV levels are very high. Prefer early morning or evening exercise and use sun protection.';
    }

    if (weather.windSpeed >= 30) {
      return 'Strong winds are expected. Consider a lighter outdoor workout or exercise indoors.';
    }

    if (weather.aqi > 0 && weather.aqi > 150) {
      return 'Air quality is poor. Indoor exercise is recommended.';
    }

    return 'Good conditions for outdoor activity. Morning exercise is recommended.';
  }

  // ============================================================
  // TRAVEL
  // ============================================================

  static String _travelRecommendation(Weather weather) {
    if (weather.rainChance >= 70) {
      return 'High chance of rain today. Carry an umbrella and allow extra travel time.';
    }

    if (weather.windSpeed >= 35) {
      return 'Strong winds may affect travel comfort. Check local travel alerts before leaving.';
    }

    if (weather.temperature >= 36) {
      return 'Very warm conditions today. Carry water and avoid prolonged exposure to the sun.';
    }

    if (weather.visibility > 0 && weather.visibility < 3) {
      return 'Low visibility may affect travel. Drive carefully and allow extra time.';
    }

    return 'Travel conditions look comfortable today. Keep an eye on rain alerts.';
  }

  // ============================================================
  // FARMING
  // ============================================================

  static String _farmingRecommendation(Weather weather) {
    if (weather.rainChance >= 70) {
      return 'High chance of rain. Consider delaying irrigation and monitor rainfall.';
    }

    if (weather.rainChance >= 40) {
      return 'Moderate rain is possible. Check soil moisture before irrigation.';
    }

    if (weather.temperature >= 35 &&
        weather.humidity < 40) {
      return 'Hot and relatively dry conditions. Crops may require additional water.';
    }

    if (weather.windSpeed >= 30) {
      return 'Strong winds are expected. Protect sensitive crops and avoid spraying activities.';
    }

    return 'Weather conditions are suitable for farm activities. Monitor rainfall before irrigation.';
  }

  // ============================================================
  // HEALTH
  // ============================================================

  static String _healthRecommendation(Weather weather) {
    if (weather.aqi > 0 && weather.aqi > 150) {
      return 'Air quality is poor. Reduce prolonged outdoor activity and consider staying indoors.';
    }

    if (weather.aqi > 0 && weather.aqi > 100) {
      return 'Air quality is moderate to unhealthy for sensitive people. Limit prolonged outdoor activity.';
    }

    if (weather.uvIndex >= 8) {
      return 'UV levels are very high. Use sunscreen, protective clothing and avoid prolonged midday exposure.';
    }

    if (weather.temperature >= 36) {
      return 'Hot weather can increase heat stress. Stay hydrated and avoid prolonged outdoor exposure.';
    }

    return 'Current conditions are generally comfortable. Check AQI and UV levels before extended outdoor activity.';
  }

  // ============================================================
  // SURFING
  // ============================================================

  static String _surfingRecommendation(Weather weather) {
    if (weather.windSpeed >= 35) {
      return 'Strong winds may make water conditions challenging. Check local surf warnings before entering the water.';
    }

    if (weather.rainChance >= 70) {
      return 'Rain is likely. Check local weather and water conditions before surfing.';
    }

    return 'Conditions look suitable for surfing. Check local wind and wave conditions before entering the water.';
  }

  // ============================================================
  // EVENT PLANNER
  // ============================================================

  static String _eventRecommendation(Weather weather) {
    if (weather.rainChance >= 60) {
      return 'Rain is likely. Consider an indoor venue or prepare a backup plan.';
    }

    if (weather.temperature >= 35) {
      return 'Hot conditions are expected. Provide shade, water and cooling areas for guests.';
    }

    if (weather.windSpeed >= 30) {
      return 'Strong winds may affect outdoor arrangements. Secure temporary structures and decorations.';
    }

    return 'Current conditions look suitable for outdoor events.';
  }

  // ============================================================
  // PRIORITY METRICS
  // ============================================================

  static List<String> getPriorityMetrics(
    UserPurpose purpose,
  ) {
    switch (purpose) {
      case UserPurpose.fitness:
        return [
          'AQI',
          'UV Index',
          'Humidity',
          'Temperature',
          'Wind',
          'Rain Chance',
        ];

      case UserPurpose.travel:
        return [
          'Temperature',
          'Rain Chance',
          'Wind',
          'Visibility',
          'AQI',
          'Humidity',
        ];

      case UserPurpose.farming:
        return [
          'Rainfall',
          'Rain Chance',
          'Humidity',
          'Wind',
          'Temperature',
          'UV Index',
        ];

      case UserPurpose.health:
        return [
          'AQI',
          'UV Index',
          'Humidity',
          'Temperature',
          'Pollen',
          'Rain Chance',
        ];

      case UserPurpose.surfing:
        return [
          'Wind',
          'Temperature',
          'Rain Chance',
          'Visibility',
          'Humidity',
          'UV Index',
        ];

      case UserPurpose.eventPlanner:
        return [
          'Rain Chance',
          'Temperature',
          'Humidity',
          'Wind',
          'Visibility',
          'UV Index',
        ];
    }
  }

  // ============================================================
  // AQI STATUS
  // ============================================================

  static String getAqiStatus(int aqi) {
    if (aqi <= 0) {
      return 'Unavailable';
    }

    if (aqi <= 50) {
      return 'Good';
    }

    if (aqi <= 100) {
      return 'Moderate';
    }

    if (aqi <= 150) {
      return 'Unhealthy for sensitive groups';
    }

    if (aqi <= 200) {
      return 'Unhealthy';
    }

    if (aqi <= 300) {
      return 'Very Unhealthy';
    }

    return 'Hazardous';
  }

  // ============================================================
  // UV STATUS
  // ============================================================

  static String getUvStatus(int uv) {
    if (uv <= 2) {
      return 'Low';
    }

    if (uv <= 5) {
      return 'Moderate';
    }

    if (uv <= 7) {
      return 'High';
    }

    if (uv <= 10) {
      return 'Very High';
    }

    return 'Extreme';
  }
}