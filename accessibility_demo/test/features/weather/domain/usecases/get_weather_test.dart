import 'package:accessibility_demo/core/error/failures.dart';
import 'package:accessibility_demo/features/weather/domain/entities/weather.dart';
import 'package:accessibility_demo/features/weather/domain/repositories/weather_repository.dart';
import 'package:accessibility_demo/features/weather/domain/usecases/get_weather.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetWeather useCase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetWeather(mockRepository);
  });

  /// Test 1: Verify that GetWeather returns Weather with timestamp
  test('should return Weather with timestamp from repository', () async {
    // Arrange
    const tWeather = Weather(
      date: '2025-10-26',
      timestamp: '14:23:45.123', // Timestamp present!
      temperature: 18.5,
      minTemperature: 12.0,
      maxTemperature: 22.0,
      description: 'weatherPartlyCloudy',
      humidity: 65,
      windSpeed: 12.3,
      precipitationProbability: 20,
    );
    
    const tWeatherResult = WeatherResult(
      weather: tWeather,
      isFromCache: false,
    );
    
    when(() => mockRepository.getCurrentWeather())
        .thenAnswer((_) async => const Right(tWeatherResult));

    // Act
    final result = await useCase();

    // Assert
    expect(result, const Right(tWeatherResult));
    expect(result.isRight(), true);
    
    result.fold(
      (_) => fail('Should not return failure'),
      (weatherResult) {
        expect(weatherResult.weather, tWeather);
        expect(weatherResult.weather.timestamp, '14:23:45.123'); // Verify timestamp
        expect(weatherResult.weather.date, '2025-10-26');
        expect(weatherResult.isFromCache, false);
      },
    );
    
    verify(() => mockRepository.getCurrentWeather()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  /// Test 2: Verify that GetWeather forwards failures from repository
  test('should return NetworkFailure when repository fails', () async {
    // Arrange
    when(() => mockRepository.getCurrentWeather())
        .thenAnswer((_) async => const Left(NetworkFailure()));

    // Act
    final result = await useCase();

    // Assert
    expect(result, const Left(NetworkFailure()));
    expect(result.isLeft(), true);
    
    result.fold(
      (failure) {
        expect(failure, isA<NetworkFailure>());
      },
      (_) => fail('Should not return weather'),
    );
    
    verify(() => mockRepository.getCurrentWeather()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
