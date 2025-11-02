import 'package:equatable/equatable.dart';

/// Base class for all WeatherBloc events.
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
  
  @override
  List<Object?> get props => [];
}

/// Event to load/refresh weather data.
class GetWeatherEvent extends WeatherEvent {
  const GetWeatherEvent();
}
