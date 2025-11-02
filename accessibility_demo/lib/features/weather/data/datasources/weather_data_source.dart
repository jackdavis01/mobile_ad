import 'dart:convert';
import 'package:accessibility_demo/core/constants/api_constants.dart';
import 'package:accessibility_demo/features/weather/data/models/weather_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract interface for remote data source.
abstract class WeatherRemoteDataSource {
  /// Fetch weather data from Open-Meteo API.
  /// 
  /// Throws [DioException] on network/API errors.
  Future<WeatherModel> getCurrentWeather();
}

/// Abstract interface for local data source.
abstract class WeatherLocalDataSource {
  /// Get cached weather data.
  /// 
  /// Throws [Exception] if no cached data exists.
  Future<WeatherModel> getCachedWeather();
  
  /// Cache weather data for offline use.
  Future<void> cacheWeather(WeatherModel weather);
}

/// Implementation of remote data source using Dio.
class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;
  
  const WeatherRemoteDataSourceImpl(this.dio);
  
  @override
  Future<WeatherModel> getCurrentWeather() async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.weatherEndpoint}',
      queryParameters: {
        ApiConstants.paramLatitude: ApiConstants.budapestLatitude,
        ApiConstants.paramLongitude: ApiConstants.budapestLongitude,
        ApiConstants.paramCurrent: ApiConstants.currentParams,
        ApiConstants.paramDaily: ApiConstants.dailyParams,
        ApiConstants.paramTimezone: ApiConstants.timezone,
      },
    );
    
    return WeatherModel.fromJson(response.data as Map<String, dynamic>);
  }
}

/// Implementation of local data source using SharedPreferences.
class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  static const String _cacheKey = 'CACHED_WEATHER';
  
  const WeatherLocalDataSourceImpl(this.sharedPreferences);
  
  @override
  Future<WeatherModel> getCachedWeather() async {
    final jsonString = sharedPreferences.getString(_cacheKey);
    
    if (jsonString == null) {
      throw Exception('No cached weather data');
    }
    
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return WeatherModel.fromCacheJson(json);
  }
  
  @override
  Future<void> cacheWeather(WeatherModel weather) async {
    final jsonString = jsonEncode(weather.toJson());
    await sharedPreferences.setString(_cacheKey, jsonString);
  }
}

/// Mock data source for Dart VM testing/development.
/// 
/// Returns hardcoded weather data without network calls.
/// Used in dev mode (main_dev.dart) for testing without API dependency.
class WeatherMockDataSource implements WeatherRemoteDataSource {
  const WeatherMockDataSource();
  
  @override
  Future<WeatherModel> getCurrentWeather() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return mock data with current timestamp
    return WeatherModel.fromJson({
      'current': {
        'temperature_2m': 18.5,
        'relative_humidity_2m': 65,
        'weather_code': 2, // Partly cloudy
        'wind_speed_10m': 12.3,
      },
      'daily': {
        'time': ['2025-10-26'],
        'temperature_2m_min': [12.0],
        'temperature_2m_max': [22.0],
        'precipitation_probability_max': [20],
      },
    });
  }
}
