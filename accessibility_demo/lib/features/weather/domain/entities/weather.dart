import 'package:equatable/equatable.dart';

/// Weather entity representing weather data for Budapest.
/// 
/// This is a domain entity - pure business logic, no external dependencies.
/// Contains 8 data points including timestamp of data retrieval/cache.
class Weather extends Equatable {
  /// Date of the weather data (YYYY-MM-DD format from API)
  final String date;
  
  /// Timestamp when data was downloaded/retrieved from cache
  /// Format: HH:MM:SS.mmm (e.g., "14:23:45.123")
  final String timestamp;
  
  /// Current temperature in Celsius
  final double temperature;
  
  /// Minimum temperature in Celsius
  final double minTemperature;
  
  /// Maximum temperature in Celsius
  final double maxTemperature;
  
  /// Weather description (localized, e.g., "Tiszta ég", "Eső")
  final String description;
  
  /// Relative humidity percentage (0-100)
  final int humidity;
  
  /// Wind speed in km/h
  final double windSpeed;
  
  /// Precipitation probability percentage (0-100)
  final int precipitationProbability;
  
  const Weather({
    required this.date,
    required this.timestamp,
    required this.temperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.precipitationProbability,
  });
  
  @override
  List<Object?> get props => [
        date,
        timestamp,
        temperature,
        minTemperature,
        maxTemperature,
        description,
        humidity,
        windSpeed,
        precipitationProbability,
      ];
}
