import 'package:dartz/dartz.dart';
import 'package:accessibility_demo/core/error/failures.dart';
import 'package:accessibility_demo/features/weather/domain/repositories/weather_repository.dart';

/// Use case for getting current weather.
/// 
/// Follows Clean Architecture: use cases contain application business logic.
/// One use case = one action the user can perform.
class GetWeather {
  final WeatherRepository repository;
  
  const GetWeather(this.repository);
  
  /// Execute the use case.
  /// 
  /// Returns Either with Failure or WeatherResult:
  /// - Right(WeatherResult): Success with weather data and cache indicator
  /// - Left(Failure): Error (ServerFailure, NetworkFailure, CacheFailure)
  Future<Either<Failure, WeatherResult>> call() {
    return repository.getCurrentWeather();
  }
}
