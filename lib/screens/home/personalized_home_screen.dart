import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/personalization/personalization_engine.dart';
import '../../core/weather/weather_service.dart';
import '../../models/user_profile.dart';
import '../../models/weather.dart';
import '../settings/settings_screen.dart';
import 'widgets/ai_button.dart';
import 'widgets/metric_card.dart';

class PersonalizedHomeScreen extends StatefulWidget {
  const PersonalizedHomeScreen({
    super.key,
  });

  @override
  State<PersonalizedHomeScreen> createState() =>
      _PersonalizedHomeScreenState();
}

class _PersonalizedHomeScreenState
    extends State<PersonalizedHomeScreen> {
  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  // ==========================================================================
  // LOAD WEATHER
  // ==========================================================================

  void _loadWeather() {
    _weatherFuture =
        WeatherService.getChennaiWeather();
  }

  // ==========================================================================
  // REFRESH WEATHER
  // ==========================================================================

  Future<void> _refreshWeather() async {
    setState(() {
      _loadWeather();
    });

    try {
      await _weatherFuture;
    } catch (_) {
      // FutureBuilder will display the error.
    }
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final user = AppState.instance.user;

        return Scaffold(
          backgroundColor:
              const Color(0xFFF5F9FF),

          floatingActionButton:
              const AIButton(),

          body: SafeArea(
            child: FutureBuilder<Weather>(
              future: _weatherFuture,

              builder: (
                context,
                snapshot,
              ) {
                // ============================================================
                // LOADING
                // ============================================================

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),

                        SizedBox(height: 16),

                        Text(
                          'Loading Chennai weather...',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // ============================================================
                // ERROR
                // ============================================================

                if (snapshot.hasError) {
                  return _WeatherError(
                    message:
                        snapshot.error.toString(),
                    onRetry:
                        _refreshWeather,
                  );
                }

                // ============================================================
                // NO DATA
                // ============================================================

                if (!snapshot.hasData) {
                  return _WeatherError(
                    message:
                        'No weather data available.',
                    onRetry:
                        _refreshWeather,
                  );
                }

                final weather =
                    snapshot.data!;

                // ============================================================
                // WEATHER CONTENT
                // ============================================================

                return RefreshIndicator(
                  onRefresh:
                      _refreshWeather,

                  child: CustomScrollView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),

                    slivers: [
                      // ======================================================
                      // HEADER
                      // ======================================================

                      SliverToBoxAdapter(
                        child: _Header(
                          userName:
                              user.name,
                          location:
                              weather.location,
                          purpose:
                              user.purpose,
                        ),
                      ),

                      // ======================================================
                      // WEATHER CARD
                      // ======================================================

                      SliverToBoxAdapter(
                        child: _WeatherCard(
                          weather:
                              weather,
                        ),
                      ),

                      // ======================================================
                      // 7-DAY FORECAST
                      // ======================================================

                      SliverToBoxAdapter(
                        child: _ForecastSection(
                          forecast:
                              weather.forecast,
                        ),
                      ),

                      // ======================================================
                      // RECOMMENDATION
                      // ======================================================

                      SliverToBoxAdapter(
                        child:
                            _RecommendationCard(
                          purpose:
                              user.purpose,
                          weather:
                              weather,
                        ),
                      ),

                      // ======================================================
                      // METRICS
                      // ======================================================

                      SliverToBoxAdapter(
                        child:
                            _MetricsSection(
                          purpose:
                              user.purpose,
                          weather:
                              weather,
                        ),
                      ),

                      // ======================================================
                      // ADVICE
                      // ======================================================

                      SliverToBoxAdapter(
                        child:
                            _AdviceSection(
                          purpose:
                              user.purpose,
                          weather:
                              weather,
                        ),
                      ),

                      const SliverToBoxAdapter(
                        child:
                            SizedBox(height: 100),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// HEADER
// ============================================================================

class _Header extends StatelessWidget {
  final String userName;
  final String location;
  final UserPurpose purpose;

  const _Header({
    required this.userName,
    required this.location,
    required this.purpose,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        15,
        20,
        24,
      ),

      decoration:
          const BoxDecoration(
        gradient: LinearGradient(
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
          colors: [
            Color(0xFF1976D2),
            Color(0xFF43A047),
          ],
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // LOCATION + SETTINGS

          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 22,
              ),

              const SizedBox(width: 5),

              Expanded(
                child: Text(
                  location,
                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),

              IconButton(
                tooltip: 'Settings',

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const SettingsScreen(),
                    ),
                  );
                },

                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Text(
            'Hi $userName!',

            style:
                const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            '${PersonalizationEngine.getIcon(purpose)} '
            '${PersonalizationEngine.getTitle(purpose)}',

            style:
                const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Your weather, personalized for you.',

            style:
                TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CURRENT WEATHER CARD
// ============================================================================

class _WeatherCard extends StatelessWidget {
  final Weather weather;

  const _WeatherCard({
    required this.weather,
  });

  String _weatherIcon(
    int code,
  ) {
    if (code == 0) {
      return '☀️';
    }

    if (code == 1) {
      return '🌤️';
    }

    if (code == 2) {
      return '⛅';
    }

    if (code == 3) {
      return '☁️';
    }

    if (code == 45 ||
        code == 48) {
      return '🌫️';
    }

    if (code >= 51 &&
        code <= 57) {
      return '🌦️';
    }

    if (code >= 61 &&
        code <= 67) {
      return '🌧️';
    }

    if (code >= 71 &&
        code <= 77) {
      return '❄️';
    }

    if (code >= 80 &&
        code <= 82) {
      return '🌦️';
    }

    if (code >= 85 &&
        code <= 86) {
      return '🌨️';
    }

    if (code >= 95) {
      return '⛈️';
    }

    return '🌤️';
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      margin:
          const EdgeInsets.all(16),

      padding:
          const EdgeInsets.all(20),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.06,
            ),
            blurRadius: 12,
            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          Text(
            _weatherIcon(
              weather.weatherCode,
            ),

            style:
                const TextStyle(
              fontSize: 55,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  '${weather.temperature.round()}°C',

                  style:
                      const TextStyle(
                    fontSize: 38,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  weather.description,

                  style:
                      const TextStyle(
                    color:
                        Colors.black54,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Feels like '
                  '${weather.feelsLike.round()}°C',

                  style:
                      const TextStyle(
                    color:
                        Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,

            children: [
              Text(
                'H: ${weather.maxTemperature.round()}°',

                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'L: ${weather.minTemperature.round()}°',

                style:
                    const TextStyle(
                  color:
                      Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 7-DAY FORECAST
// ============================================================================

class _ForecastSection
    extends StatelessWidget {
  final List<DailyForecast> forecast;

  const _ForecastSection({
    required this.forecast,
  });

  String _getDayName(
    String date,
    int index,
  ) {
    if (index == 0) {
      return 'Today';
    }

    try {
      final parsedDate =
          DateTime.parse(date);

      const days = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];

      return days[
          parsedDate.weekday - 1];
    } catch (_) {
      return date;
    }
  }

  String _getWeatherIcon(
    int code,
  ) {
    if (code == 0) {
      return '☀️';
    }

    if (code == 1 ||
        code == 2) {
      return '🌤️';
    }

    if (code == 3) {
      return '☁️';
    }

    if (code >= 45 &&
        code <= 48) {
      return '🌫️';
    }

    if (code >= 51 &&
        code <= 67) {
      return '🌧️';
    }

    if (code >= 71 &&
        code <= 77) {
      return '❄️';
    }

    if (code >= 80 &&
        code <= 82) {
      return '🌦️';
    }

    if (code >= 85 &&
        code <= 86) {
      return '🌨️';
    }

    if (code >= 95) {
      return '⛈️';
    }

    return '🌤️';
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    if (forecast.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        0,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            '7-Day Forecast',

            style:
                TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 180,

            child:
                ListView.separated(
              scrollDirection:
                  Axis.horizontal,

              itemCount:
                  forecast.length,

              separatorBuilder:
                  (_, __) =>
                      const SizedBox(
                width: 12,
              ),

              itemBuilder:
                  (
                context,
                index,
              ) {
                final day =
                    forecast[index];

                return Container(
                  width: 125,

                  padding:
                      const EdgeInsets.all(
                    14,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(
                          alpha: 0.05,
                        ),
                        blurRadius: 10,
                      ),
                    ],
                  ),

                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                    children: [
                      Text(
                        _getDayName(
                          day.date,
                          index,
                        ),

                        textAlign:
                            TextAlign.center,

                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(
                        _getWeatherIcon(
                          day.weatherCode,
                        ),

                        style:
                            const TextStyle(
                          fontSize: 32,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        '${day.maxTemperature.round()}° / '
                        '${day.minTemperature.round()}°',

                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                        children: [
                          const Icon(
                            Icons.umbrella,
                            size: 14,
                            color:
                                Colors.blue,
                          ),

                          const SizedBox(
                            width: 3,
                          ),

                          Text(
                            '${day.rainChance}%',

                            style:
                                const TextStyle(
                              fontSize: 12,
                              color:
                                  Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// RECOMMENDATION CARD
// ============================================================================

class _RecommendationCard
    extends StatelessWidget {
  final UserPurpose purpose;
  final Weather weather;

  const _RecommendationCard({
    required this.purpose,
    required this.weather,
  });

  String _getWeatherBasedRecommendation() {
    if (weather.rainChance >= 70) {
      return 'High chance of rain today. Consider indoor activities or carry an umbrella.';
    }

    if (weather.temperature >= 35) {
      return 'It is very hot today. Stay hydrated and avoid prolonged outdoor activity.';
    }

    if (weather.temperature <= 18) {
      return 'It is relatively cool today. Dress appropriately for outdoor activities.';
    }

    if (weather.windSpeed >= 30) {
      return 'Strong winds are expected. Take care during outdoor activities.';
    }

    return PersonalizationEngine
        .getRecommendation(
      purpose,
      weather,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final category =
        PersonalizationEngine
            .getTitle(purpose)
            .replaceAll(
              ' Weather',
              '',
            )
            .replaceAll(
              ' Conditions',
              '',
            );

    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color:
            const Color(0xFFE8F5E9),

        borderRadius:
            BorderRadius.circular(18),

        border:
            Border.all(
          color:
              Colors.green.withValues(
            alpha: 0.2,
          ),
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const CircleAvatar(
            backgroundColor:
                Colors.green,

            child: Icon(
              Icons.check,
              color:
                  Colors.white,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  '$category Recommendation',

                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  _getWeatherBasedRecommendation(),

                  style:
                      const TextStyle(
                    fontSize: 13,
                    color:
                        Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// METRICS SECTION
// ============================================================================

class _MetricsSection
    extends StatelessWidget {
  final UserPurpose purpose;
  final Weather weather;

  const _MetricsSection({
    required this.purpose,
    required this.weather,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final metrics =
        PersonalizationEngine
            .getPriorityMetrics(
      purpose,
    );

    return Padding(
      padding:
          const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            '${PersonalizationEngine.getTitle(purpose).replaceAll(' Weather', '').replaceAll(' Conditions', '')} Conditions',

            style:
                const TextStyle(
              fontSize: 19,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          GridView.count(
            crossAxisCount: 2,

            shrinkWrap: true,

            physics:
                const NeverScrollableScrollPhysics(),

            crossAxisSpacing: 12,

            mainAxisSpacing: 12,

            childAspectRatio: 1.45,

            children: metrics
                .take(6)
                .map(
                  (metric) =>
                      _buildMetric(
                    metric,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(
    String metric,
  ) {
    switch (metric) {
      // ======================================================================
      // AQI
      // ======================================================================

      case 'AQI':
        return MetricCard(
          title: 'AQI',

          value:
              weather.aqi > 0
                  ? '${weather.aqi}'
                  : '--',

          status:
              weather.aqi > 0
                  ? _aqiStatus(
                      weather.aqi,
                    )
                  : 'Unavailable',

          icon:
              Icons.air,
        );

      // ======================================================================
      // UV INDEX
      // ======================================================================

      case 'UV Index':
        return MetricCard(
          title: 'UV Index',

          value:
              weather.uvIndex > 0
                  ? '${weather.uvIndex}'
                  : '--',

          status:
              weather.uvIndex > 0
                  ? _uvStatus(
                      weather.uvIndex,
                    )
                  : 'Unavailable',

          icon:
              Icons.wb_sunny,
        );

      // ======================================================================
      // HUMIDITY
      // ======================================================================

      case 'Humidity':
        return MetricCard(
          title: 'Humidity',

          value:
              '${weather.humidity}%',

          status:
              _humidityStatus(
            weather.humidity,
          ),

          icon:
              Icons.water_drop,
        );

      // ======================================================================
      // TEMPERATURE
      // ======================================================================

      case 'Temperature':
        return MetricCard(
          title: 'Temperature',

          value:
              '${weather.temperature.round()}°C',

          status:
              _temperatureStatus(
            weather.temperature,
          ),

          icon:
              Icons.thermostat,
        );

      // ======================================================================
      // WIND
      // ======================================================================

      case 'Wind':
        return MetricCard(
          title: 'Wind',

          value:
              '${weather.windSpeed.round()} km/h',

          status:
              _windStatus(
            weather.windSpeed,
          ),

          icon:
              Icons.air,
        );

      // ======================================================================
      // RAIN CHANCE
      // ======================================================================

      case 'Rain Chance':
        return MetricCard(
          title: 'Rain Chance',

          value:
              '${weather.rainChance}%',

          status:
              _rainStatus(
            weather.rainChance,
          ),

          icon:
              Icons.umbrella,
        );

      // ======================================================================
      // VISIBILITY
      // ======================================================================

      case 'Visibility':
        return MetricCard(
          title: 'Visibility',

          value:
              weather.visibility > 0
                  ? '${weather.visibility.toStringAsFixed(1)} km'
                  : '--',

          status:
              weather.visibility > 0
                  ? _visibilityStatus(
                      weather.visibility,
                    )
                  : 'Unavailable',

          icon:
              Icons.visibility,
        );

      // ======================================================================
      // RAINFALL
      // ======================================================================

      case 'Rainfall':
        return MetricCard(
          title: 'Rainfall',

          value:
              '${weather.rainChance}%',

          status:
              'Rain probability',

          icon:
              Icons.water,
        );

      // ======================================================================
      // POLLEN
      // ======================================================================

      case 'Pollen':
        return const MetricCard(
          title: 'Pollen',
          value: '--',
          status: 'Unavailable',
          icon: Icons.grass,
        );

      // ======================================================================
      // DEFAULT
      // ======================================================================

      default:
        return MetricCard(
          title: metric,
          value: '--',
          status: 'Coming soon',
          icon:
              Icons.info_outline,
        );
    }
  }

  // ==========================================================================
  // AQI STATUS
  // ==========================================================================

  String _aqiStatus(
    int aqi,
  ) {
    if (aqi <= 50) {
      return 'Good';
    }

    if (aqi <= 100) {
      return 'Moderate';
    }

    if (aqi <= 150) {
      return 'Unhealthy';
    }

    if (aqi <= 200) {
      return 'Very Unhealthy';
    }

    if (aqi <= 300) {
      return 'Poor';
    }

    return 'Hazardous';
  }

  // ==========================================================================
  // UV STATUS
  // ==========================================================================

  String _uvStatus(
    int uv,
  ) {
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

  // ==========================================================================
  // HUMIDITY STATUS
  // ==========================================================================

  String _humidityStatus(
    int humidity,
  ) {
    if (humidity < 30) {
      return 'Dry';
    }

    if (humidity <= 60) {
      return 'Comfortable';
    }

    if (humidity <= 80) {
      return 'Humid';
    }

    return 'Very Humid';
  }

  // ==========================================================================
  // TEMPERATURE STATUS
  // ==========================================================================

  String _temperatureStatus(
    double temperature,
  ) {
    if (temperature < 18) {
      return 'Cool';
    }

    if (temperature <= 28) {
      return 'Comfortable';
    }

    if (temperature <= 35) {
      return 'Warm';
    }

    return 'Hot';
  }

  // ==========================================================================
  // WIND STATUS
  // ==========================================================================

  String _windStatus(
    double wind,
  ) {
    if (wind < 10) {
      return 'Light';
    }

    if (wind < 25) {
      return 'Moderate';
    }

    if (wind < 40) {
      return 'Strong';
    }

    return 'Very Strong';
  }

  // ==========================================================================
  // RAIN STATUS
  // ==========================================================================

  String _rainStatus(
    int rain,
  ) {
    if (rain < 20) {
      return 'Low';
    }

    if (rain < 50) {
      return 'Moderate';
    }

    if (rain < 70) {
      return 'High';
    }

    return 'Very High';
  }

  // ==========================================================================
  // VISIBILITY STATUS
  // ==========================================================================

  String _visibilityStatus(
    double visibility,
  ) {
    if (visibility >= 10) {
      return 'Excellent';
    }

    if (visibility >= 5) {
      return 'Good';
    }

    if (visibility >= 2) {
      return 'Moderate';
    }

    return 'Poor';
  }
}

// ============================================================================
// ADVICE SECTION
// ============================================================================

class _AdviceSection
    extends StatelessWidget {
  final UserPurpose purpose;
  final Weather weather;

  const _AdviceSection({
    required this.purpose,
    required this.weather,
  });

  String _getAdvice() {
    if (weather.rainChance >= 70) {
      return 'Rain is likely today. Plan outdoor activities carefully and keep an umbrella with you.';
    }

    if (weather.uvIndex >= 8) {
      return 'UV levels are very high. Use sunscreen, stay hydrated and avoid prolonged direct sunlight.';
    }

    if (weather.temperature >= 35) {
      return 'High temperatures are expected. Drink plenty of water and take breaks from outdoor activity.';
    }

    if (weather.aqi > 100) {
      return 'Air quality is not ideal. Consider reducing prolonged outdoor activity.';
    }

    return PersonalizationEngine
        .getRecommendation(
      purpose,
      weather,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final category =
        PersonalizationEngine
            .getTitle(purpose)
            .replaceAll(
              ' Weather',
              '',
            )
            .replaceAll(
              ' Conditions',
              '',
            );

    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.04,
            ),
            blurRadius: 8,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            '${PersonalizationEngine.getIcon(purpose)} '
            '$category Advice',

            style:
                const TextStyle(
              fontSize: 19,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          _AdviceTile(
            icon:
                Icons.check_circle,
            text:
                _getAdvice(),
          ),

          const SizedBox(height: 12),

          _AdviceTile(
            icon:
                Icons.thermostat,
            text:
                'Current temperature is '
                '${weather.temperature.round()}°C '
                'with ${weather.humidity}% humidity.',
          ),

          const SizedBox(height: 12),

          _AdviceTile(
            icon:
                Icons.notifications_active,
            text:
                'Refresh the page to get the latest Chennai weather conditions.',
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ADVICE TILE
// ============================================================================

class _AdviceTile
    extends StatelessWidget {
  final IconData icon;
  final String text;

  const _AdviceTile({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        const SizedBox(width: 2),

        Icon(
          icon,
          color:
              const Color(
            0xFF1976D2,
          ),
          size: 22,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            text,

            style:
                const TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// WEATHER ERROR
// ============================================================================

class _WeatherError
    extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _WeatherError({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.cloud_off,
              size: 70,
              color: Colors.grey,
            ),

            const SizedBox(height: 20),

            const Text(
              'Unable to load weather',

              textAlign:
                  TextAlign.center,

              style:
                  TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Please check your internet connection and try again.',

              textAlign:
                  TextAlign.center,

              style:
                  TextStyle(
                color:
                    Colors.black54,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              message.replaceFirst(
                'Exception: ',
                '',
              ),

              textAlign:
                  TextAlign.center,

              maxLines: 2,

              overflow:
                  TextOverflow.ellipsis,

              style:
                  const TextStyle(
                color:
                    Colors.grey,
                fontSize: 11,
              ),
            ),

            const SizedBox(height: 22),

            ElevatedButton.icon(
              onPressed: onRetry,

              icon:
                  const Icon(
                Icons.refresh,
              ),

              label:
                  const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }
}