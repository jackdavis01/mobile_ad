import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:accessibility_demo/core/error/failures.dart';
import 'package:accessibility_demo/core/network/network_info.dart';
import 'package:accessibility_demo/features/weather/data/datasources/weather_data_source.dart';
import 'package:accessibility_demo/features/weather/domain/repositories/weather_repository.dart';

/// Implementation of WeatherRepository.
/// 
/// Coordinates between remote and local data sources:
/// - If online: fetch from API, cache result, return data
/// - If offline: return cached data or CacheFailure
/// 
/// Converts exceptions to Failures for functional error handling.
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  const WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, WeatherResult>> getCurrentWeather() async {
    final isConnected = await networkInfo.isConnected;
    
    if (isConnected) {
      // Online: try to fetch from API
      return await _getRemoteWeather();
    } else {
      // Offline: try to get cached data
      return await _getCachedWeather();
    }
  }
  
  /// Fetch weather from remote API and cache it.
  Future<Either<Failure, WeatherResult>> _getRemoteWeather() async {
    try {
      final weather = await remoteDataSource.getCurrentWeather();
      
      // Cache the weather data for offline use
      await localDataSource.cacheWeather(weather);
      
      return Right(WeatherResult(weather: weather, isFromCache: false));
    } on DioException catch (e) {
      // API error - try cache as fallback
      final errorMessage = e.response?.data?.toString() ?? e.message ?? 'Unknown error';
      
      // If API fails, try to return cached data
      try {
        final cachedWeather = await localDataSource.getCachedWeather();
        return Right(WeatherResult(weather: cachedWeather, isFromCache: true));
      } catch (_) {
        // No cache available, return server failure
        return Left(ServerFailure(errorMessage));
      }
    } catch (e) {
      // Unexpected error
      return Left(ServerFailure(e.toString()));
    }
  }
  
  /// Get cached weather data (offline mode).
  Future<Either<Failure, WeatherResult>> _getCachedWeather() async {
    try {
      final weather = await localDataSource.getCachedWeather();
      return Right(WeatherResult(weather: weather, isFromCache: true));
    } catch (e) {
      // No cached data available
      return const Left(CacheFailure());
    }
  }
}
