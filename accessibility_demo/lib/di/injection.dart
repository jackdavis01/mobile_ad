import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:accessibility_demo/core/network/network_info.dart';
import 'package:accessibility_demo/di/injection.config.dart';
import 'package:accessibility_demo/features/weather/data/datasources/weather_data_source.dart';
import 'package:accessibility_demo/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:accessibility_demo/features/weather/domain/repositories/weather_repository.dart';
import 'package:accessibility_demo/features/weather/domain/usecases/get_weather.dart';
import 'package:accessibility_demo/features/weather/presentation/bloc/weather_bloc.dart';

final getIt = GetIt.instance;

/// Initialize dependency injection.
/// 
/// @environment defines which data source to use:
/// - prod: real API (WeatherRemoteDataSourceImpl)
/// - dev: mock data (WeatherMockDataSource)
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies(String environment) async {
  // Register SharedPreferences (async)
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  // Register Connectivity
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  
  // Register Dio with logger
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
      compact: true,
    ));
    
    return dio;
  });
  
  // Register NetworkInfo
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );
  
  // Register DataSources based on environment
  if (environment == Environment.prod) {
    // Production: Real API
    getIt.registerLazySingleton<WeatherRemoteDataSource>(
      () => WeatherRemoteDataSourceImpl(getIt<Dio>()),
    );
  } else {
    // Development: Mock API
    getIt.registerLazySingleton<WeatherRemoteDataSource>(
      () => const WeatherMockDataSource(),
    );
  }
  
  // Register Local DataSource
  getIt.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(getIt<SharedPreferences>()),
  );
  
  // Register Repository
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: getIt<WeatherRemoteDataSource>(),
      localDataSource: getIt<WeatherLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
  
  // Register Use Case
  getIt.registerLazySingleton<GetWeather>(
    () => GetWeather(getIt<WeatherRepository>()),
  );
  
  // Register BLoC (factory - new instance each time)
  getIt.registerFactory<WeatherBloc>(
    () => WeatherBloc(getWeather: getIt<GetWeather>()),
  );
  
  // Initialize generated code (if using @injectable annotations)
  getIt.init(environment: environment);
}
