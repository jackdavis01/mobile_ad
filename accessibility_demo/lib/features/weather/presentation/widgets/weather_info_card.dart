import 'package:flutter/material.dart';
import 'package:accessibility_demo/core/l10n/l10n_helper.dart';
import 'package:accessibility_demo/features/weather/domain/entities/weather.dart';

/// Widget displaying weather information in a card.
/// 
/// Shows all 8 weather data points including timestamp.
/// Uses L10nHelper for safe localization access (no ! operator).
/// Includes Semantics for accessibility.
class WeatherInfoCard extends StatelessWidget {
  final Weather weather;
  final bool isCached;
  
  const WeatherInfoCard({
    super.key,
    required this.weather,
    this.isCached = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final l10n = L10nHelper.of(context); // Safe access, no ! operator
    
    // Dátum formázás: YYYY. hónap D., napnév
    final date = DateTime.parse(weather.date);
    final formattedDate = 
        '${date.year}. ${_getMonthName(date.month, l10n)} ${date.day}., ${_getDayName(date.weekday, l10n)}';
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dátum
            Semantics(
              label: formattedDate,
              child: Text(
                formattedDate,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            
            // Timestamp (HH:MM:SS.mmm)
            Semantics(
              label: weather.timestamp,
              child: Text(
                weather.timestamp,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 24),
            
            // Hőmérséklet
            _buildInfoRow(
              context,
              icon: Icons.thermostat,
              label: l10n.temperatureLabel,
              value: '${weather.temperature.toStringAsFixed(1)}°C',
            ),
            const SizedBox(height: 16),
            
            // Min/Max Temperature
            _buildInfoRow(
              context,
              icon: Icons.device_thermostat,
              label: l10n.minMaxLabel,
              value: '${weather.minTemperature.toStringAsFixed(1)}°C / ${weather.maxTemperature.toStringAsFixed(1)}°C',
            ),
            const SizedBox(height: 16),
            
            // Weather Description
            _buildInfoRow(
              context,
              icon: Icons.wb_sunny,
              label: l10n.weatherLabel,
              value: _getLocalizedWeather(weather.description, l10n),
            ),
            const SizedBox(height: 16),
            
            // Humidity
            _buildInfoRow(
              context,
              icon: Icons.water_drop,
              label: l10n.humidityLabel,
              value: '${weather.humidity}%',
            ),
            const SizedBox(height: 16),
            
            // Wind Speed
            _buildInfoRow(
              context,
              icon: Icons.air,
              label: l10n.windSpeedLabel,
              value: '${weather.windSpeed.toStringAsFixed(1)} km/h',
            ),
            const SizedBox(height: 16),
            
            // Precipitation Probability
            _buildInfoRow(
              context,
              icon: Icons.umbrella,
              label: l10n.precipitationLabel,
              value: '${weather.precipitationProbability}%',
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build a row with icon, label and value.
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Semantics(
      label: '$label: $value',
      child: Row(
        children: [
          Icon(
            icon,
            size: 28,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// Get localized day name.
  String _getDayName(int weekday, dynamic l10n) {
    switch (weekday) {
      case 1: return l10n.dayMonday;
      case 2: return l10n.dayTuesday;
      case 3: return l10n.dayWednesday;
      case 4: return l10n.dayThursday;
      case 5: return l10n.dayFriday;
      case 6: return l10n.daySaturday;
      case 7: return l10n.daySunday;
      default: return '';
    }
  }
  
  /// Get localized month name.
  String _getMonthName(int month, dynamic l10n) {
    switch (month) {
      case 1: return l10n.monthJanuary;
      case 2: return l10n.monthFebruary;
      case 3: return l10n.monthMarch;
      case 4: return l10n.monthApril;
      case 5: return l10n.monthMay;
      case 6: return l10n.monthJune;
      case 7: return l10n.monthJuly;
      case 8: return l10n.monthAugust;
      case 9: return l10n.monthSeptember;
      case 10: return l10n.monthOctober;
      case 11: return l10n.monthNovember;
      case 12: return l10n.monthDecember;
      default: return '';
    }
  }
  
  /// Get localized weather description from key.
  String _getLocalizedWeather(String key, dynamic l10n) {
    switch (key) {
      case 'weatherClearSky': return l10n.weatherClearSky;
      case 'weatherMainlyClear': return l10n.weatherMainlyClear;
      case 'weatherPartlyCloudy': return l10n.weatherPartlyCloudy;
      case 'weatherCloudy': return l10n.weatherCloudy;
      case 'weatherFog': return l10n.weatherFog;
      case 'weatherDrizzle': return l10n.weatherDrizzle;
      case 'weatherFreezingDrizzle': return l10n.weatherFreezingDrizzle;
      case 'weatherRain': return l10n.weatherRain;
      case 'weatherFreezingRain': return l10n.weatherFreezingRain;
      case 'weatherSnow': return l10n.weatherSnow;
      case 'weatherRainShowers': return l10n.weatherRainShowers;
      case 'weatherThunderstorm': return l10n.weatherThunderstorm;
      default: return l10n.weatherUnknown;
    }
  }
}
