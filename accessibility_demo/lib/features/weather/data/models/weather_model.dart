import 'package:accessibility_demo/features/weather/domain/entities/weather.dart';
import 'package:intl/intl.dart';

/// Data model for Weather entity.
/// 
/// Extends Weather entity and adds serialization capabilities.
/// Handles conversion between API JSON, cache JSON, and domain entity.
class WeatherModel extends Weather {
  const WeatherModel({
    required super.date,
    required super.timestamp,
    required super.temperature,
    required super.minTemperature,
    required super.maxTemperature,
    required super.description,
    required super.humidity,
    required super.windSpeed,
    required super.precipitationProbability,
  });

  /// Create WeatherModel from API JSON response.
  /// 
  /// Generates timestamp at the moment of parsing (data download time).
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;
    
    // Generate timestamp: HH:MM:SS.mmm format
    final now = DateTime.now();
    final timestamp = DateFormat('HH:mm:ss.SSS').format(now);
    
    // Get weather code and convert to description
    final weatherCode = current['weather_code'] as int;
    final description = _getWeatherDescription(weatherCode);
    
    return WeatherModel(
      date: (daily['time'] as List<dynamic>)[0] as String,
      timestamp: timestamp,
      temperature: (current['temperature_2m'] as num).toDouble(),
      minTemperature: ((daily['temperature_2m_min'] as List<dynamic>)[0] as num).toDouble(),
      maxTemperature: ((daily['temperature_2m_max'] as List<dynamic>)[0] as num).toDouble(),
      description: description,
      humidity: current['relative_humidity_2m'] as int,
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      precipitationProbability: ((daily['precipitation_probability_max'] as List<dynamic>)[0] as num).toInt(),
    );
  }

  /// Create WeatherModel from cache JSON.
  /// 
  /// Used when loading data from SharedPreferences.
  /// Preserves the original timestamp from when data was cached.
  factory WeatherModel.fromCacheJson(Map<String, dynamic> json) {
    return WeatherModel(
      date: json['date'] as String,
      timestamp: json['timestamp'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      minTemperature: (json['minTemperature'] as num).toDouble(),
      maxTemperature: (json['maxTemperature'] as num).toDouble(),
      description: json['description'] as String,
      humidity: json['humidity'] as int,
      windSpeed: (json['windSpeed'] as num).toDouble(),
      precipitationProbability: json['precipitationProbability'] as int,
    );
  }

  /// Convert to JSON for caching.
  /// 
  /// Used when saving data to SharedPreferences.
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'timestamp': timestamp,
      'temperature': temperature,
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
      'description': description,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'precipitationProbability': precipitationProbability,
    };
  }

  /// Convert WMO weather code to Hungarian description.
  /// 
  /// Note: In localized app, this would use AppLocalizations.
  /// For now, returns key that matches ARB file entries.
  static String _getWeatherDescription(int code) {
    switch (code) {
      case 0:
        return 'weatherClearSky';
      case 1:
        return 'weatherMainlyClear';
      case 2:
        return 'weatherPartlyCloudy';
      case 3:
        return 'weatherCloudy';
      case 45:
      case 48:
        return 'weatherFog';
      case 51:
      case 53:
      case 55:
        return 'weatherDrizzle';
      case 56:
      case 57:
        return 'weatherFreezingDrizzle';
      case 61:
      case 63:
      case 65:
        return 'weatherRain';
      case 66:
      case 67:
        return 'weatherFreezingRain';
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return 'weatherSnow';
      case 80:
      case 81:
      case 82:
        return 'weatherRainShowers';
      case 95:
      case 96:
      case 99:
        return 'weatherThunderstorm';
      default:
        return 'weatherUnknown';
    }
  }
}
