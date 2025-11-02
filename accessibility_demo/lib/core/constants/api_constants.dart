/// API constants for Open-Meteo weather API.
class ApiConstants {
  const ApiConstants._();
  
  /// Base URL for Open-Meteo API
  static const String baseUrl = 'https://api.open-meteo.com';
  
  /// Weather forecast endpoint
  static const String weatherEndpoint = '/v1/forecast';
  
  /// Budapest coordinates
  static const double budapestLatitude = 47.4979;
  static const double budapestLongitude = 19.0402;
  
  /// API parameters
  static const String paramLatitude = 'latitude';
  static const String paramLongitude = 'longitude';
  static const String paramCurrent = 'current';
  static const String paramDaily = 'daily';
  static const String paramTimezone = 'timezone';
  
  /// Current weather parameters
  static const String currentParams =
      'temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m';
  
  /// Daily weather parameters
  static const String dailyParams =
      'temperature_2m_max,temperature_2m_min,precipitation_probability_max';
  
  /// Timezone
  static const String timezone = 'Europe/Budapest';
}
