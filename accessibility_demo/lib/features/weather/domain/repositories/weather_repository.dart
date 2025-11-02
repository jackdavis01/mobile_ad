import 'package:dartz/dartz.dart';
import 'package:accessibility_demo/core/error/failures.dart';
import 'package:accessibility_demo/features/weather/domain/entities/weather.dart';

/// Weather result with cache indicator.
class WeatherResult {
  final Weather weather;
  final bool isFromCache;
  
  const WeatherResult({
    required this.weather,
    required this.isFromCache,
  });
}

/// Repository interface for weather data.
/// 
/// Defines the contract for data access without specifying implementation.
/// Returns `Either<Failure, WeatherResult>` for functional error handling.
abstract class WeatherRepository {
  /// Get current weather for Budapest.
  /// 
  /// Returns:
  /// - Right(WeatherResult) on success (from API or cache)
  /// - Left(ServerFailure) on API error
  /// - Left(NetworkFailure) on network error
  /// - Left(CacheFailure) when offline and no cache available
  Future<Either<Failure, WeatherResult>> getCurrentWeather();
}
