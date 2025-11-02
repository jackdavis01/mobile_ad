# Budapest Időjárás - Részletes Dokumentáció

**Clean Architecture + Dart VM futtathatóság + Akadálymentesség Flutter-ben**

---

## Tartalomjegyzék

1. [Bevezetés](#1-bevezetés)
2. [Projekt célja és célközönség](#2-projekt-célja-és-célközönség)
3. [Követelmények](#3-követelmények)
4. [Projekt létrehozása lépésről-lépésre](#4-projekt-létrehozása-lépésről-lépésre)
5. [Lokalizáció beállítása](#5-lokalizáció-beállítása)
6. [Clean Architecture rétegek](#6-clean-architecture-rétegek)
7. [Dependency Injection (GetIt + Injectable)](#7-dependency-injection-getit--injectable)
8. [BLoC State Management](#8-bloc-state-management)
9. [API integráció](#9-api-integráció)
10. [Offline támogatás és cache](#10-offline-támogatás-és-cache)
11. [Környezetek (Dev/Prod) - Dart VM kulcs!](#11-környezetek-devprod---dart-vm-kulcs)
12. [Akadálymentesség - Folyamatos ellenőrzés](#12-akadálymentesség---folyamatos-ellenőrzés)
13. [Tesztelés](#13-tesztelés)
14. [Fejlesztői eszközök](#14-fejlesztői-eszközök)
15. [Gyakori problémák és megoldások](#15-gyakori-problémák-és-megoldások)
16. [Best Practices](#16-best-practices)
17. [Összefoglalás](#17-összefoglalás)

---

## 1. Bevezetés

Ez a dokumentáció a **Budapest Időjárás** Flutter projekt részletes leírását tartalmazza. A projekt fő célja bemutatni, hogyan lehet Flutter alkalmazást fejleszteni **Clean Architecture** mintával, **Dart VM-ben történő futtathatósággal**, ami lehetővé teszi a **folyamatos akadálymentességi ellenőrzést**.

### Miért Dart VM futtathatóság?

Hagyományos megközelítés:
1. UI fejlesztése emulatorban/fizikai eszközön
2. Akadálymentességi tesztek írása
3. Tesztek futtatása (lassú, nehézkes setup)
4. **Utólag** akadálymentesség javítása (refaktorálás!)

**Dart VM megközelítés** (ez a projekt):
1. ✅ **Mock datasource** használata (nincs platform-függőség)
2. ✅ **Dart VM-ben futtatható** fejlesztés (gyors iteráció)
3. ✅ **Akadálymentességi tesztek** folyamatosan futnak
4. ✅ Semantics ellenőrzése valós időben

**Előnyök:**
- Gyors feedback loop (nincs emulator indítás)
- Folyamatos akadálymentességi tesztelés (CI/CD)
- Mock adatok → platform-független fejlesztés
- Tisztább kód: akadálymentesség az ELEJÉTŐL

---

## 2. Projekt célja és célközönség

### Célok

- **Oktatási projekt**: Clean Architecture bemutatása Flutter-ben
- **Dart VM futtathatóság**: Mock datasource használata
- **Folyamatos akadálymentesség**: Semantics tesztek Dart VM-ben
- **Best practices**: BLoC, DI, funkcionális hibakezelés (Either)
- **Tesztelhetőség**: Unit tesztek, accessibility tesztek
- **Környezet szeparáció**: Dev (mock - Dart VM) és Prod (API) módok

### Célközönség

- Flutter fejlesztők, akik Clean Architecture-t tanulnak
- Projektek, ahol akadálymentesség kritikus követelmény
- Csapatok, akik Dart VM-ben futtatható fejlesztést keresnek
- Folyamatos integráció (CI/CD) akadálymentességi tesztekkel

---

## 3. Követelmények

### Szoftver követelmények

| Eszköz | Verzió | Telepítés |
|--------|--------|-----------|
| **Flutter SDK** | 3.35.5 | FVM-mel |
| **Dart SDK** | 3.9.2 | Automatikus (Flutter-rel) |
| **FVM** | Latest | `brew install fvm` |
| **Android Studio** / **VS Code** | Latest | IDE választása |
| **Xcode** | Latest (macOS) | iOS fejlesztéshez |

### Platform követelmények

- ✅ **Android**: API 21+ (Android 5.0+)
- ✅ **iOS**: iOS 12.0+
- ❌ **Web/Desktop**: Nem támogatott (csak mobile)

---

## 4. Projekt létrehozása lépésről-lépésre

### 4.1. FVM telepítése és Flutter verzió beállítása

```bash
# FVM telepítése (macOS/Linux)
brew install fvm

# Flutter 3.35.5 telepítése FVM-mel
fvm install 3.35.5

# Új Flutter projekt létrehozása (empty template)
fvm flutter create --empty accessibility_demo

# Belépés a projektbe
cd accessibility_demo

# FVM verzió használata
fvm use 3.35.5
```

### 4.2. Pubspec.yaml alapkonfiguráció

**Fontos**: Lokalizációs beállítások az ELEJÉTŐL!

```yaml
name: accessibility_demo
description: "Clean Architecture + Lokalizáció-első demo"
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.9.2

# 🌐 LOKALIZÁCIÓ KONFIGURÁLÁSA ELŐSZÖR!
flutter:
  uses-material-design: true
  generate: true  # ← ARB fájlok automatikus generálása

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:  # ← Lokalizáció
    sdk: flutter
  intl: ^0.20.2  # ← ARB támogatás

  # State Management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.7

  # Dependency Injection
  get_it: ^8.0.2
  injectable: ^2.5.0

  # Networking
  dio: ^5.7.0
  connectivity_plus: ^6.1.1

  # Local Storage
  shared_preferences: ^2.3.3

  # Functional Programming
  dartz: ^0.10.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.13
  injectable_generator: ^2.6.2
  mocktail: ^1.0.4
```

```bash
# Függőségek telepítése
fvm flutter pub get
```

---

## 5. Lokalizáció beállítása - ELSŐ LÉPÉS!

### 5.1. l10n.yaml létrehozása

Hozz létre `l10n.yaml` fájlt a projekt gyökerében:

```yaml
arb-dir: lib/l10n
template-arb-file: app_hu.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
```

### 5.2. ARB fájl létrehozása

Hozz létre `lib/l10n/app_hu.arb` fájlt:

```json
{
  "@@locale": "hu",
  "appTitle": "Budapest Időjárás",
  "@appTitle": {
    "description": "Az alkalmazás címe"
  },
  "refreshButton": "Időjárás frissítése",
  "@refreshButton": {
    "description": "Frissítés gomb szövege"
  },
  "cachedDataNote": "Mentett adatok (nincs internetkapcsolat)",
  "@cachedDataNote": {
    "description": "Cache-ből betöltött adatok jelzése"
  },
  "loading": "Betöltés...",
  "@loading": {
    "description": "Betöltési állapot"
  },
  "errorNoInternet": "Nincs internetkapcsolat. Mentett adatok betöltése...",
  "@errorNoInternet": {
    "description": "Nincs internet hiba"
  },
  "weatherDate": "Dátum",
  "weatherTimestamp": "Időpont",
  "weatherTemperature": "Hőmérséklet",
  "weatherMinTemp": "Minimum hőmérséklet",
  "weatherMaxTemp": "Maximum hőmérséklet",
  "weatherDescription": "Leírás",
  "weatherHumidity": "Páratartalom",
  "weatherWindSpeed": "Szélsebesség",
  "weatherPrecipitation": "Csapadék"
}
```

**⚠️ Fontos**: Futtasd le a generálást:

```bash
fvm flutter pub get
```

Ez generálja a `lib/l10n/app_localizations*.dart` fájlokat!

### 5.3. L10nHelper osztály létrehozása

**Ez a projekt kulcsa**: Biztonságos lokalizáció hozzáférés **! operátor nélkül**.

Hozz létre `lib/core/l10n/l10n_helper.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:accessibility_demo/l10n/app_localizations.dart';

/// Lokalizációs helper osztály.
/// 
/// NEM használja az `!` operátort, biztonságosabb mint:
/// `AppLocalizations.of(context)!`
/// 
/// Használat:
/// ```dart
/// final l10n = L10nHelper.of(context);
/// Text(l10n.appTitle)
/// ```
class L10nHelper {
  const L10nHelper._();

  /// Biztonságos lokalizáció lekérése.
  /// 
  /// - Fejlesztés közben: assert, ha nincs localizationsDelegates
  /// - Production: fallback magyar nyelvre
  static AppLocalizations of(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    assert(
      localizations != null,
      'AppLocalizations is null. Did you add localizationsDelegates to MaterialApp?',
    );
    
    // Production-ben magyar nyelv fallback
    return localizations ?? lookupAppLocalizations(const Locale('hu'));
  }
}
```

**Előnyök:**
- ✅ Nincs `!` operátor → biztonságosabb
- ✅ Assert figyelmezteti dev-et, ha hiányzik a delegate
- ✅ Production-ben automatikus fallback
- ✅ Egyszerűbb használat: `L10nHelper.of(context)`

### 5.4. App widget konfiguráció

`lib/app.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:accessibility_demo/l10n/app_localizations.dart';
import 'package:accessibility_demo/core/l10n/l10n_helper.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      // 🌐 LOKALIZÁCIÓ BEÁLLÍTÁSOK
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('hu'),
      ],
      
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      
      home: const WeatherPage(),
    );
  }
}
```

### 5.5. Lokalizáció használata widget-ben

```dart
import 'package:accessibility_demo/core/l10n/l10n_helper.dart';

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ✅ BIZTONSÁGOS HOZZÁFÉRÉS (nincs !)
    final l10n = L10nHelper.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),  // 'Budapest Időjárás'
      ),
      body: Center(
        child: Text(l10n.loading),  // 'Betöltés...'
      ),
    );
  }
}
```

**Lokalizáció beállítása kész!** ✅  
Most már minden szöveg lokalizált, és a Clean Architecture implementálható lokalizált string-ekkel.

---

## 6. Clean Architecture rétegek

### 6.1. Áttekintés

```
lib/features/weather/
├── data/           # Data layer (külső világ)
│   ├── models/     # API modellek (JSON ↔ Dart)
│   ├── datasources/# API/Cache hozzáférés
│   └── repositories/ # Repository implementáció
├── domain/         # Domain layer (üzleti logika)
│   ├── entities/   # Domain entitások
│   ├── repositories/ # Repository interface
│   └── usecases/   # Use case-ek
└── presentation/   # Presentation layer (UI)
    ├── bloc/       # BLoC state management
    ├── pages/      # Teljes oldalak
    └── widgets/    # Újrafelhasználható widgetek
```

### 6.2. Domain Layer (üzleti logika)

**Entity**: `lib/features/weather/domain/entities/weather.dart`

```dart
import 'package:equatable/equatable.dart';

/// Domain entitás - időjárás adatok.
/// 
/// ⚠️ NE függjön külső library-ktől (pl. Dio, SharedPreferences)!
class Weather extends Equatable {
  final String date;
  final String timestamp;  // HH:MM:SS.mmm formátum
  final double temperature;
  final double minTemperature;
  final double maxTemperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final double precipitation;

  const Weather({
    required this.date,
    required this.timestamp,
    required this.temperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
  });

  @override
  List<Object?> get props => [
        date,
        timestamp,
        temperature,
        minTemperature,
        maxTemperature,
        description,
        humidity,
        windSpeed,
        precipitation,
      ];
}
```

**Repository Interface**: `lib/features/weather/domain/repositories/weather_repository.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:accessibility_demo/core/error/failures.dart';
import 'package:accessibility_demo/features/weather/domain/entities/weather.dart';

/// WeatherResult wrapper - cache jelzővel.
/// 
/// Domain layer ismeri a cache-elés tényét (nem csak a Data layer).
class WeatherResult {
  final Weather weather;
  final bool isFromCache;

  const WeatherResult({
    required this.weather,
    required this.isFromCache,
  });
}

/// Repository interface.
/// 
/// Domain layer definiálja, Data layer implementálja.
abstract class WeatherRepository {
  Future<Either<Failure, WeatherResult>> getWeather();
}
```

**Use Case**: `lib/features/weather/domain/usecases/get_weather.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:accessibility_demo/core/error/failures.dart';
import 'package:accessibility_demo/features/weather/domain/entities/weather.dart';
import 'package:accessibility_demo/features/weather/domain/repositories/weather_repository.dart';

/// Use case: időjárás lekérése.
/// 
/// Egyetlen felelősség: repository hívása.
class GetWeather {
  final WeatherRepository repository;

  GetWeather(this.repository);

  Future<Either<Failure, WeatherResult>> call() async {
    return await repository.getWeather();
  }
}
```

### 6.3. Data Layer (külső világ)

**Model**: `lib/features/weather/data/models/weather_model.dart`

```dart
import 'package:accessibility_demo/features/weather/domain/entities/weather.dart';

/// Weather model - JSON konverzió.
class WeatherModel extends Weather {
  const WeatherModel({
    required super.date,
    required super.timestamp,
    required super.temperature,
    required super.minTemperature,
    required super.maxTemperature,
    required super.description,
    required super.humidity,
    required super.windSpeed,
    required super.precipitation,
  });

  /// JSON → Model
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    final timestamp = '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}.'
        '${now.millisecond.toString().padLeft(3, '0')}';

    return WeatherModel(
      date: json['date'] ?? '',
      timestamp: timestamp,
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      minTemperature: (json['minTemperature'] ?? 0.0).toDouble(),
      maxTemperature: (json['maxTemperature'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      humidity: json['humidity'] ?? 0,
      windSpeed: (json['windSpeed'] ?? 0.0).toDouble(),
      precipitation: (json['precipitation'] ?? 0.0).toDouble(),
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'timestamp': timestamp,
      'temperature': temperature,
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
      'description': description,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'precipitation': precipitation,
    };
  }
}
```

**Remote DataSource**: `lib/features/weather/data/datasources/weather_remote_datasource.dart`

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:accessibility_demo/core/constants/api_constants.dart';
import 'package:accessibility_demo/features/weather/data/models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getWeather();
}

@Injectable(as: WeatherRemoteDataSource, env: [Environment.prod])
class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSourceImpl(this.dio);

  @override
  Future<WeatherModel> getWeather() async {
    final response = await dio.get(
      ApiConstants.weatherEndpoint,
      queryParameters: {
        'latitude': ApiConstants.budapestLat,
        'longitude': ApiConstants.budapestLon,
        'current_weather': true,
        'hourly': 'temperature_2m,relative_humidity_2m,wind_speed_10m,precipitation',
        'timezone': 'Europe/Budapest',
      },
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final current = data['current_weather'];
      final hourly = data['hourly'];

      return WeatherModel.fromJson({
        'date': current['time'] ?? '',
        'temperature': current['temperature'] ?? 0.0,
        'minTemperature': hourly['temperature_2m'][0] ?? 0.0,
        'maxTemperature': hourly['temperature_2m'][23] ?? 0.0,
        'description': _getWeatherDescription(current['weathercode'] ?? 0),
        'humidity': hourly['relative_humidity_2m'][0] ?? 0,
        'windSpeed': current['windspeed'] ?? 0.0,
        'precipitation': hourly['precipitation'][0] ?? 0.0,
      });
    } else {
      throw Exception('Failed to load weather');
    }
  }

  String _getWeatherDescription(int code) {
    if (code == 0) return 'Tiszta ég';
    if (code <= 3) return 'Részben felhős';
    if (code <= 48) return 'Ködös';
    if (code <= 67) return 'Esős';
    if (code <= 77) return 'Havas';
    if (code <= 82) return 'Zápor';
    if (code <= 99) return 'Viharos';
    return 'Ismeretlen';
  }
}
```

**Repository Implementation**: `lib/features/weather/data/repositories/weather_repository_impl.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:accessibility_demo/core/error/failures.dart';
import 'package:accessibility_demo/core/network/network_info.dart';
import 'package:accessibility_demo/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:accessibility_demo/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:accessibility_demo/features/weather/domain/entities/weather.dart';
import 'package:accessibility_demo/features/weather/domain/repositories/weather_repository.dart';

@Injectable(as: WeatherRepository)
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final WeatherLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.networkInfo,
  );

  @override
  Future<Either<Failure, WeatherResult>> getWeather() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteWeather = await remoteDataSource.getWeather();
        await localDataSource.cacheWeather(remoteWeather);
        
        // API-ból betöltve, NEM cache
        return Right(WeatherResult(
          weather: remoteWeather,
          isFromCache: false,
        ));
      } catch (e) {
        // API hiba, próbáljuk meg cache-ből
        try {
          final cachedWeather = await localDataSource.getLastWeather();
          
          // Cache fallback
          return Right(WeatherResult(
            weather: cachedWeather,
            isFromCache: true,
          ));
        } catch (_) {
          return const Left(CacheFailure());
        }
      }
    } else {
      // Nincs internet, cache-ből töltünk
      try {
        final cachedWeather = await localDataSource.getLastWeather();
        
        // Offline, cache
        return Right(WeatherResult(
          weather: cachedWeather,
          isFromCache: true,
        ));
      } catch (_) {
        return const Left(CacheFailure());
      }
    }
  }
}
```

### 6.4. Presentation Layer (UI)

**BLoC**: `lib/features/weather/presentation/bloc/weather_bloc.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:accessibility_demo/features/weather/domain/entities/weather.dart';
import 'package:accessibility_demo/features/weather/domain/usecases/get_weather.dart';
import 'package:accessibility_demo/core/error/failures.dart';

// Events
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class GetWeatherEvent extends WeatherEvent {
  const GetWeatherEvent();
}

// States
abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  final bool isCached;

  const WeatherLoaded({
    required this.weather,
    required this.isCached,
  });

  @override
  List<Object> get props => [weather, isCached];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeather getWeather;

  WeatherBloc({required this.getWeather}) : super(const WeatherInitial()) {
    on<GetWeatherEvent>(_onGetWeather);
  }

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

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case CacheFailure:
        return 'Cache Failure';
      case NetworkFailure:
        return 'Network Failure';
      default:
        return 'Unexpected Error';
    }
  }
}
```

**Page**: `lib/features/weather/presentation/pages/weather_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:accessibility_demo/core/l10n/l10n_helper.dart';
import 'package:accessibility_demo/di/injection.dart';
import 'package:accessibility_demo/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:accessibility_demo/features/weather/presentation/widgets/weather_info_card.dart';
import 'package:accessibility_demo/features/weather/presentation/widgets/refresh_button.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10nHelper.of(context);

    return BlocProvider(
      create: (_) => getIt<WeatherBloc>()..add(const GetWeatherEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
          elevation: 0,
        ),
        body: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherInitial || state is WeatherLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WeatherLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    if (state.isCached)
                      Container(
                        width: double.infinity,
                        color: Colors.orange.shade100,
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, size: 20),
                            const SizedBox(width: 8),
                            Text(l10n.cachedDataNote),
                          ],
                        ),
                      ),
                    WeatherInfoCard(weather: state.weather),
                    const SizedBox(height: 16),
                    RefreshButton(
                      onPressed: () {
                        context.read<WeatherBloc>().add(const GetWeatherEvent());
                      },
                    ),
                  ],
                ),
              );
            } else if (state is WeatherError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

---

## 7. Dependency Injection (GetIt + Injectable)

### 7.1. Injectable konfiguráció

`lib/di/injection.dart`:

```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies(String environment) async {
  await getIt.init(environment: environment);
}
```

### 7.2. Module regisztrációk

`lib/di/register_module.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio();
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
    return dio;
  }

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  Connectivity get connectivity => Connectivity();
}
```

### 7.3. Code generation

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Ez generálja az `injection.config.dart` fájlt az összes `@Injectable` annotációval ellátott osztályhoz.

---

## 8. BLoC State Management

### 8.1. Miért BLoC?

- ✅ Separation of concerns (UI ↔ Logic)
- ✅ Tesztelhetőség (BLoC unit tesztelése)
- ✅ Reaktív programozás (Stream)
- ✅ Állapot menedzsment egyszerűsége

### 8.2. BLoC használata

```dart
// BLoC provider
BlocProvider(
  create: (_) => getIt<WeatherBloc>()..add(const GetWeatherEvent()),
  child: WeatherPage(),
)

// Event küldése
context.read<WeatherBloc>().add(const GetWeatherEvent());

// State figyelése
BlocBuilder<WeatherBloc, WeatherState>(
  builder: (context, state) {
    if (state is WeatherLoading) {
      return CircularProgressIndicator();
    }
    // ...
  },
)
```

---

## 9. API integráció

### 9.1. Open-Meteo API

- **URL**: `https://api.open-meteo.com/v1/forecast`
- **Koordináták**: Budapest (47.4979, 19.0402)
- **Nincs API kulcs**: Ingyenes használat

### 9.2. Dio konfiguráció

```dart
@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio();
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
    return dio;
  }
}
```

---

## 10. Offline támogatás és cache

### 10.1. Local DataSource

`lib/features/weather/data/datasources/weather_local_datasource.dart`:

```dart
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:accessibility_demo/features/weather/data/models/weather_model.dart';

abstract class WeatherLocalDataSource {
  Future<WeatherModel> getLastWeather();
  Future<void> cacheWeather(WeatherModel weather);
}

const cachedWeatherKey = 'CACHED_WEATHER';

@Injectable(as: WeatherLocalDataSource)
class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;

  WeatherLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<WeatherModel> getLastWeather() {
    final jsonString = sharedPreferences.getString(cachedWeatherKey);
    if (jsonString != null) {
      return Future.value(WeatherModel.fromJson(json.decode(jsonString)));
    } else {
      throw Exception('No cached data');
    }
  }

  @override
  Future<void> cacheWeather(WeatherModel weather) {
    return sharedPreferences.setString(
      cachedWeatherKey,
      json.encode(weather.toJson()),
    );
  }
}
```

### 10.2. WeatherResult wrapper

**Domain layer** ismeri a cache-elés tényét:

```dart
class WeatherResult {
  final Weather weather;
  final bool isFromCache;

  const WeatherResult({
    required this.weather,
    required this.isFromCache,
  });
}
```

**Repository** beállítja a `isFromCache` flag-et:

```dart
// API-ból betöltve
return Right(WeatherResult(
  weather: remoteWeather,
  isFromCache: false,
));

// Cache-ből betöltve
return Right(WeatherResult(
  weather: cachedWeather,
  isFromCache: true,
));
```

**UI** megjeleníti a cache banner-t:

```dart
if (state.isCached)
  Container(
    width: double.infinity,
    color: Colors.orange.shade100,
    padding: const EdgeInsets.all(12),
    child: Row(
      children: [
        const Icon(Icons.info_outline, size: 20),
        const SizedBox(width: 8),
        Text(l10n.cachedDataNote),  // 'Mentett adatok (nincs internetkapcsolat)'
      ],
    ),
  ),
```

---

## 11. Környezetek (Dev/Prod)

### 11.1. Production környezet

`lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'app.dart';
import 'di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 🔧 PRODUCTION KÖRNYEZET
  await configureDependencies(Environment.prod);
  
  runApp(const MyApp());
}
```

### 11.2. Development környezet

`lib/main_dev.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'app.dart';
import 'di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 🛠️ DEVELOPMENT KÖRNYEZET (mock adatok)
  await configureDependencies(Environment.dev);
  
  runApp(const MyApp());
}
```

### 11.3. Mock DataSource

`lib/features/weather/data/datasources/weather_mock_datasource.dart`:

```dart
import 'package:injectable/injectable.dart';
import 'package:accessibility_demo/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:accessibility_demo/features/weather/data/models/weather_model.dart';

@Injectable(as: WeatherRemoteDataSource, env: [Environment.dev])
class WeatherMockDataSource implements WeatherRemoteDataSource {
  @override
  Future<WeatherModel> getWeather() async {
    // Szimulált késleltetés
    await Future.delayed(const Duration(seconds: 1));

    final now = DateTime.now();
    final timestamp = '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}.'
        '${now.millisecond.toString().padLeft(3, '0')}';

    return WeatherModel(
      date: '2024-10-26',
      timestamp: timestamp,
      temperature: 18.5,
      minTemperature: 12.0,
      maxTemperature: 22.0,
      description: 'Részben felhős',
      humidity: 65,
      windSpeed: 5.2,
      precipitation: 0.0,
    );
  }
}
```

### 11.4. Futtatás

```bash
# Production (valós API)
fvm flutter run -t lib/main.dart

# Development (mock)
fvm flutter run -t lib/main_dev.dart
```

---

## 12. Akadálymentesség - Folyamatos ellenőrzés

### 12.1. Semantics widget használata

Minden interaktív és informatív UI elemhez Semantics wrappelés:

**Példa - WeatherInfoCard widgetek:**

```dart
// lib/features/weather/presentation/widgets/weather_info_card.dart
Semantics(
  label: l10n.weatherTemperature,  // 'Hőmérséklet'
  value: '${weather.temperature}°C',
  child: Row(
    children: [
      const Icon(Icons.thermostat, size: 28),
      const SizedBox(width: 8),
      Text(
        '${weather.temperature}°C',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),

Semantics(
  label: l10n.weatherHumidity,  // 'Páratartalom'
  value: '${weather.humidity}%',
  child: Row(
    children: [
      const Icon(Icons.water_drop, size: 28),
      const SizedBox(width: 8),
      Text('${weather.humidity}%',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ],
  ),
),
```

**Előnyök:**
- ✅ Screen reader (TalkBack/VoiceOver) támogatás
- ✅ WCAG 2.1 megfelelés
- ✅ Tesztelhetőség (accessibility tesztek)

### 12.2. Accessibility tesztek Dart VM-ben

**Fontos:** Ezek a tesztek **Dart VM-ben futnak**, nem kell emulator!

`test/features/weather/presentation/widgets/weather_info_card_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_demo/features/weather/domain/entities/weather.dart';
import 'package:accessibility_demo/features/weather/presentation/widgets/weather_info_card.dart';

void main() {
  final testWeather = Weather(
    date: '2024-10-26',
    timestamp: '14:30:45.123',
    temperature: 18.5,
    minTemperature: 12.0,
    maxTemperature: 22.0,
    description: 'Napos',
    humidity: 65,
    windSpeed: 12.5,
    precipitation: 0.0,
  );

  testWidgets('WeatherInfoCard should have proper semantics for temperature',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeatherInfoCard(weather: testWeather),
        ),
      ),
    );

    // Screen reader számára látható szövegek
    expect(find.bySemanticsLabel('Hőmérséklet'), findsOneWidget);
    
    // Értékek ellenőrzése
    final tempSemantic = tester.getSemantics(
      find.bySemanticsLabel('Hőmérséklet'),
    );
    expect(tempSemantic.value, contains('18.5°C'));
  });

  testWidgets('WeatherInfoCard should have proper semantics for humidity',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeatherInfoCard(weather: testWeather),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Páratartalom'), findsOneWidget);
    
    final humiditySemantic = tester.getSemantics(
      find.bySemanticsLabel('Páratartalom'),
    );
    expect(humiditySemantic.value, contains('65%'));
  });
}
```

**Futtatás:**

```bash
# Accessibility tesztek Dart VM-ben
fvm flutter test test/features/weather/presentation/

# Vagy összes teszt
fvm flutter test
```

### 12.3. Cache banner Semantics

```dart
// WeatherPage cache figyelmeztetés
if (state.isCached)
  Semantics(
    label: 'Figyelmeztetés',
    child: Container(
      padding: const EdgeInsets.all(12),
      color: Colors.orange.shade100,
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.orange.shade800,
            semanticLabel: 'Info',
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.cachedDataNote,
              style: TextStyle(
                color: Colors.orange.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
```

**Kulcs:** Mind a 3 akadálymentességi teszt **Dart VM-ben fut** → gyors CI/CD!

---

## 13. Tesztelés - Unit tesztek

### 13.1. Unit teszt

`test/features/weather/domain/usecases/get_weather_test.dart`:

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:accessibility_demo/features/weather/domain/entities/weather.dart';
import 'package:accessibility_demo/features/weather/domain/repositories/weather_repository.dart';
import 'package:accessibility_demo/features/weather/domain/usecases/get_weather.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetWeather usecase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    usecase = GetWeather(mockRepository);
  });

  const tWeather = Weather(
    date: '2024-10-26',
    timestamp: '14:30:45.123',
    temperature: 18.5,
    minTemperature: 12.0,
    maxTemperature: 22.0,
    description: 'Részben felhős',
    humidity: 65,
    windSpeed: 5.2,
    precipitation: 0.0,
  );

  const tWeatherResult = WeatherResult(
    weather: tWeather,
    isFromCache: false,
  );

  test('should get weather from the repository', () async {
    // Arrange
    when(() => mockRepository.getWeather())
        .thenAnswer((_) async => const Right(tWeatherResult));

    // Act
    final result = await usecase();

    // Assert
    expect(result, const Right(tWeatherResult));
    verify(() => mockRepository.getWeather());
    verifyNoMoreInteractions(mockRepository);
  });
}
```

### 13.2. Tesztek futtatása

```bash
# Összes teszt
fvm flutter test

# Csak domain tesztek
fvm flutter test test/features/weather/domain/
```

---

## 14. Fejlesztői eszközök

### 14.1. Analyze

```bash
fvm flutter analyze
```

### 14.2. Format

```bash
fvm flutter format lib/ test/
```

### 14.3. Clean & Pub Get

```bash
fvm flutter clean
fvm flutter pub get
```

---

## 15. Gyakori problémák és megoldások

### Probléma 1: "Null check operator used on a null value"

❌ **Probléma**: `AppLocalizations.of(context)!` null lehet.

✅ **Megoldás**: Használd **L10nHelper**-t:

```dart
final l10n = L10nHelper.of(context);
```

### Probléma 2: "GetIt is not ready"

❌ **Probléma**: DI nincs inicializálva.

✅ **Megoldás**: Ellenőrizd `main.dart`-ban:

```dart
await configureDependencies(Environment.prod);
```

### Probléma 3: "Missing internet permission"

❌ **Probléma**: Release build-ben nem eléri az API-t.

✅ **Megoldás**: `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

---

## 16. Best Practices

1. ✅ **Dart VM futtathatóság**: Mock datasource minden feature-hez
2. ✅ **Semantics widgets**: Akadálymentesség az ELEJÉTŐL
3. ✅ **Accessibility tesztek**: Dart VM-ben futtatható CI/CD
4. ✅ **WeatherResult**: Explicit cache flag a Domain-ben
5. ✅ **Timestamp string**: Egyszerűbb cache és megjelenítés
6. ✅ **Initial state**: Automatikus betöltés induláskor
7. ✅ **Clean Architecture**: Rétegek szeparációja
8. ✅ **Unit tesztek**: Domain layer lefedése
9. ✅ **Mock környezet**: Gyorsabb fejlesztés

---

## 17. Összefoglalás

Ez a projekt bemutatta:
- ✅ **Dart VM futtathatóság**: Mock datasource-szal platform-független fejlesztés
- ✅ **Folyamatos akadálymentesség**: Semantics + tesztek CI/CD-ben
- ✅ **Clean Architecture** implementálását
- ✅ **BLoC** state management-et
- ✅ **Dependency Injection**-t (GetIt + Injectable)
- ✅ **Offline támogatást** WeatherResult wrapper-rel
- ✅ **Környezet szeparációt** (Dev/Prod)
- ✅ **Tesztelést** (Unit, Mock)

**A projekt kulcsa**: Lokalizáció ELŐSZÖR lett implementálva, nem utólag hozzáadva!

---

**Készítve**: 2025. október 26.  
**Flutter**: 3.35.5  
**Dart**: 3.9.2  
**Lokalizáció**: Magyar (ARB + L10nHelper) ✨
