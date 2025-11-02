import 'package:equatable/equatable.dart';
import 'package:accessibility_demo/features/weather/domain/entities/weather.dart';

/// Base class for all WeatherBloc states.
abstract class WeatherState extends Equatable {
  const WeatherState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state when bloc is created.
class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

/// Loading state while fetching weather data.
class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

/// Success state with weather data.
class WeatherLoaded extends WeatherState {
  final Weather weather;
  final bool isCached;
  
  const WeatherLoaded({
    required this.weather,
    this.isCached = false,
  });
  
  @override
  List<Object?> get props => [weather, isCached];
}

/// Error state with failure message.
class WeatherError extends WeatherState {
  final String message;
  
  const WeatherError(this.message);
  
  @override
  List<Object?> get props => [message];
}
