import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:accessibility_demo/core/error/failures.dart';
import 'package:accessibility_demo/features/weather/domain/usecases/get_weather.dart';
import 'package:accessibility_demo/features/weather/presentation/bloc/weather_event.dart';
import 'package:accessibility_demo/features/weather/presentation/bloc/weather_state.dart';

/// BLoC for managing weather state.
/// 
/// Handles GetWeatherEvent and emits appropriate states.
/// Uses GetWeather use case to fetch data.
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeather getWeather;
  
  WeatherBloc({required this.getWeather}) : super(const WeatherInitial()) {
    on<GetWeatherEvent>(_onGetWeather);
  }
  
  /// Handle GetWeatherEvent.
  Future<void> _onGetWeather(
    GetWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());
    
    final result = await getWeather();
    
    result.fold(
      (failure) => emit(WeatherError(_mapFailureToMessage(failure))),
      (weatherResult) => emit(WeatherLoaded(
        weather: weatherResult.weather,
        isCached: weatherResult.isFromCache,
      )),
    );
  }
  
  /// Map Failure to user-friendly error message.
  /// 
  /// Returns localization keys that match app_hu.arb entries.
  String _mapFailureToMessage(Failure failure) {
    return switch (failure) {
      ServerFailure() => 'errorServerFailure:${failure.message}',
      NetworkFailure() => 'errorNetworkFailure',
      CacheFailure() => 'errorCacheFailure',
      _ => 'errorServerFailure:Unknown error',
    };
  }
}
