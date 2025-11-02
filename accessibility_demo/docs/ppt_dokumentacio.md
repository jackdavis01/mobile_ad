# Budapest Időjárás - Prezentációs Anyag

**Clean Architecture + Dart VM futtathatóság + Akadálymentesség**

---

## Slide 1: Címoldal

### Budapest Időjárás
**Clean Architecture Demo Project**

- ♿ **Dart VM futtathatóság** - Folyamatos accessibility tesztek
- 🏗️ Clean Architecture
- 🧪 BLoC State Management
- 📱 Offline támogatás

**Flutter 3.35.5 | Dart 3.9.2**

---

## Slide 2: Projekt célja

### Miért készült ez a projekt?

**Oktatási célok:**
- ✅ Clean Architecture bemutatása Flutter-ben
- ✅ **Dart VM futtathatóság** mock datasource-szal
- ✅ **Folyamatos akadálymentességi ellenőrzés**
- ✅ BLoC state management gyakorlati alkalmazása
- ✅ Dependency Injection (GetIt + Injectable)
- ✅ Funkcionális hibakezelés (Either, Failure)
- ✅ Tesztelhetőség (Unit + Accessibility tesztek)

**Célközönség:**
- Flutter fejlesztők, akik Clean Architecture-t tanulnak
- Projektek, ahol akadálymentesség kritikus követelmény

---

## Slide 3: Dart VM futtathatóság ♿

### Miért fontos a Dart VM-ben való futtathatóság?

**Hagyományos módszer:**
1. UI fejlesztése emulatorban/fizikai eszközön
2. Akadálymentességi tesztek írása
3. Tesztek futtatása (lassú setup)
4. **Utólag** akadálymentesség javítása (REFAKTORÁLÁS!)

**Dart VM módszer** (ez a projekt):
1. ✅ **Mock datasource** használata
2. ✅ **Dart VM-ben futtatható** fejlesztés
3. ✅ **Akadálymentességi tesztek** folyamatosan
4. ✅ Semantics ellenőrzése valós időben

**Előnyök:**
- 🚫 Nincs emulator indítás
- ✅ Gyors feedback loop
- ✅ CI/CD integráció egyszerű
- ✅ Akadálymentesség az ELEJÉTŐL

---

## Slide 4: Mock DataSource - A kulcs

### Hogyan működik?

**Production mód:**
```dart
@Injectable(as: WeatherRemoteDataSource, env: [Environment.prod])
class WeatherRemoteDataSourceImpl {
  // Dio HTTP client → Open-Meteo API
  // ❌ Dart VM-ben NEM fut (platform-függő)
}
```

**Development mód:**
```dart
@Injectable(as: WeatherRemoteDataSource, env: [Environment.dev])
class WeatherMockDataSource {
  // Hardcoded teszt adatok
  // ✅ Dart VM-ben FUT! (platform-független)
}
```

**Eredmény:**
- `fvm flutter run -t lib/main_dev.dart` → Dart VM-ben futtatható
- Accessibility tesztek: `fvm flutter test` → Gyors

---

## Slide 5: Akadálymentesség - Semantics widgets

### Minden fontos widget Semantics-szel

```dart
Semantics(
  label: l10n.weatherTemperature,  // 'Hőmérséklet'
  value: '${weather.temperature}°C',
  child: Row(
    children: [
      Icon(Icons.thermostat, size: 28),
      Text('${weather.temperature}°C',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
)
```

**Előnyök:**
- ✅ Screen reader támogatás (TalkBack/VoiceOver)
- ✅ Accessibility tesztelhetőség
- ✅ WCAG megfelelés

---

## Slide 6: Accessibility tesztek - Dart VM-ben!

### Példa teszt

```dart
testWidgets('WeatherInfoCard should have proper semantics',
    (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: WeatherInfoCard(weather: testWeather),
    ),
  );

  // Screen reader számára látható szövegek
  expect(find.bySemanticsLabel('Hőmérséklet'), findsOneWidget);
  expect(find.bySemanticsLabel('Páratartalom'), findsOneWidget);
  
  // Értékek ellenőrzése
  final tempSemantic = tester.getSemantics(
    find.bySemanticsLabel('Hőmérséklet'),
  );
  expect(tempSemantic.value, contains('18.5°C'));
});
```

**🎯 Kulcs**: Teszt **Dart VM-ben fut** → gyors CI/CD!

---

## Slide 7: Clean Architecture rétegek

### Háromrétegű architektúra

```
┌─────────────────────────────────┐
│     PRESENTATION LAYER          │
│  (BLoC, Pages, Widgets)         │
│  + Semantics! ♿                 │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│       DOMAIN LAYER              │
│  (Entities, Use Cases, Repo)    │
│  - Platform-független!           │
└────────────┬────────────────────┘
             │
             ▼
┌─────────────────────────────────┐
│       DATA LAYER                │
│  - RemoteDataSource (Prod)      │
│  - MockDataSource (Dev) ← Kulcs!│
└─────────────────────────────────┘
```

**Kulcs:** Mock datasource → Dart VM futtathatóság!

---

## Slide 8: Domain Layer - Üzleti logika

### Weather Entity

```dart
class Weather extends Equatable {
  final String date;
  final String timestamp;  // HH:MM:SS.mmm
  final double temperature;
  final double minTemperature;
  final double maxTemperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final double precipitation;
  
  // ...
}
```

**Fontos:** Tiszta Dart kód, nincs Flutter/Dio függőség!

### WeatherResult wrapper

```dart
class WeatherResult {
  final Weather weather;
  final bool isFromCache;  // Cache jelző!
}
```

---

## Slide 9: Data Layer - Mock vs Remote

### Production DataSource

```dart
@Injectable(as: WeatherRemoteDataSource, env: [Environment.prod])
class WeatherRemoteDataSourceImpl {
  final Dio dio;

  Future<WeatherModel> getWeather() async {
    final response = await dio.get(ApiConstants.weatherEndpoint);
    // ... API hívás, JSON parsing
    return WeatherModel.fromJson(data);
  }
}
```

### Development DataSource (Mock)

```dart
@Injectable(as: WeatherRemoteDataSource, env: [Environment.dev])
class WeatherMockDataSource {
  Future<WeatherModel> getWeather() async {
    await Future.delayed(Duration(seconds: 1));
    
    return WeatherModel(
      date: '2024-10-26',
      timestamp: '14:30:45.123',
      temperature: 18.5,
      // ... hardcoded adatok
    );
  }
}
```

**🎯 Eredmény**: Mock verzió **Dart VM-ben fut**!

---

## Slide 10: Presentation Layer - BLoC

### BLoC States

```dart
abstract class WeatherState extends Equatable {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  final bool isCached;  // ← Cache flag UI-ba!
}

class WeatherError extends WeatherState {
  final String message;
}
```

### BLoC Event

```dart
class GetWeatherEvent extends WeatherEvent {}
```

---

## Slide 11: UI - WeatherPage + Semantics

### Cache banner + Akadálymentesség

```dart
BlocBuilder<WeatherBloc, WeatherState>(
  builder: (context, state) {
    if (state is WeatherLoaded) {
      return Column(
        children: [
          // ✅ CACHE BANNER (Semantics-szel!)
          if (state.isCached)
            Semantics(
              label: 'Figyelmeztetés',
              child: Container(
                color: Colors.orange.shade100,
                child: Row(
                  children: [
                    Icon(Icons.info_outline, semanticLabel: 'Info'),
                    Text(l10n.cachedDataNote),
                  ],
                ),
              ),
            ),
          
          // ✅ IDŐJÁRÁS KÁRTYA (Semantics minden adatnál!)
          WeatherInfoCard(weather: state.weather),
          
          // ✅ FRISSÍTÉS GOMB
          RefreshButton(onPressed: () {
            context.read<WeatherBloc>().add(const GetWeatherEvent());
          }),
        ],
      );
    }
  },
)
```

---

## Slide 12: Dependency Injection

### GetIt + Injectable

**Injectable annotációk:**

```dart
// Production datasource
@Injectable(as: WeatherRemoteDataSource, env: [Environment.prod])
class WeatherRemoteDataSourceImpl {
  // Dio → API hívás
  // ❌ Dart VM-ben NEM fut
}

// Development datasource
@Injectable(as: WeatherRemoteDataSource, env: [Environment.dev])
class WeatherMockDataSource {
  // Mock adatok
  // ✅ Dart VM-ben FUT!
}

// Repository
@Injectable(as: WeatherRepository)
class WeatherRepositoryImpl {
  // Közös repository mindkét környezethez
}
```

**Code generation:**

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Slide 13: Környezetek (Dev/Prod)

### Production környezet

```dart
// lib/main.dart
void main() async {
  await configureDependencies(Environment.prod);
  runApp(const MyApp());
}
```

- ✅ Valós API hívások (Open-Meteo)
- ❌ Dart VM-ben **NEM** fut

### Development környezet ← **KULCS!**

```dart
// lib/main_dev.dart
void main() async {
  await configureDependencies(Environment.dev);
  runApp(const MyApp());
}
```

- ✅ Mock datasource (hardcoded adatok)
- ✅ **Dart VM-ben FUT!** ← Akadálymentességi tesztek!
- ✅ Gyorsabb fejlesztés
- ✅ CI/CD egyszerű

---

## Slide 14: Tesztelés - Dart VM előnye

### Unit teszt

```dart
test('should get weather from repository', () async {
  // Arrange
  when(() => mockRepository.getWeather())
      .thenAnswer((_) async => Right(tWeatherResult));

  // Act
  final result = await usecase();

  // Assert
  expect(result, Right(tWeatherResult));
  verify(() => mockRepository.getWeather());
});
```

### Accessibility teszt ← **Dart VM-ben fut!**

```dart
testWidgets('should have temperature semantics', (tester) async {
  await tester.pumpWidget(WeatherInfoCard(weather: testWeather));
  
  expect(find.bySemanticsLabel('Hőmérséklet'), findsOneWidget);
});
```

**🎯 Előny**: Nincs emulator/eszköz szükséges!

---

## Slide 15: Best Practices a projektben

### 7 arany szabály

1. ✅ **Dart VM futtathatóság**: Mock datasource minden feature-hez
2. ✅ **Semantics widgets**: Akadálymentesség az ELEJÉTŐL
3. ✅ **Accessibility tesztek**: Dart VM-ben futtatható CI/CD
4. ✅ **WeatherResult**: Explicit cache flag a Domain-ben
5. ✅ **Clean Architecture**: Rétegek szigorú szeparációja
6. ✅ **Dependency Injection**: GetIt + Injectable
7. ✅ **Functional programming**: Either, Failure típusok

---

## Slide 16: Projekt struktúra

```
lib/
├── core/
│   ├── l10n/              # Lokalizációs helper
│   ├── error/             # Failure osztályok
│   ├── network/           # Hálózati ellenőrzés
│   └── constants/         # API konstansok
├── features/
│   └── weather/
│       ├── data/          # Data layer
│       │   ├── models/    # WeatherModel (JSON ↔ Dart)
│       │   ├── datasources/
│       │   │   ├── weather_remote_datasource.dart (Prod)
│       │   │   ├── weather_mock_datasource.dart (Dev) ← Kulcs!
│       │   │   └── weather_local_datasource.dart (Cache)
│       │   └── repositories/
│       │       └── weather_repository_impl.dart
│       ├── domain/        # Domain layer
│       │   ├── entities/  # Weather entity
│       │   ├── repositories/ # WeatherRepository interface
│       │   └── usecases/  # GetWeather use case
│       └── presentation/  # Presentation layer
│           ├── bloc/      # WeatherBloc (State Management)
│           ├── pages/     # WeatherPage
│           └── widgets/   # WeatherInfoCard (Semantics!)
├── l10n/                  # Lokalizációs fájlok (ARB)
│   └── app_hu.arb
├── di/                    # Dependency Injection
│   ├── injection.dart
│   └── register_module.dart
├── app.dart               # App widget
├── main.dart              # Production entry (API)
└── main_dev.dart          # Development entry (Mock - Dart VM!)
```

---

## Slide 17: Gyors parancsok

### Telepítés és futtatás

```bash
# FVM használata
fvm use 3.35.5

# Függőségek telepítése
fvm flutter pub get

# Code generation (DI)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Futtatás Development módban (Dart VM!)
fvm flutter run -t lib/main_dev.dart

# Futtatás Production-ben
fvm flutter run -t lib/main.dart
```

### Tesztelés (Dart VM-ben!)

```bash
# Összes teszt
fvm flutter test

# Accessibility tesztek
fvm flutter test test/features/weather/presentation/

# Analyze
fvm flutter analyze
```

---

## Slide 18: Következő lépések

### Mire használható ez a projekt?

**Oktatás:**
- ✅ Clean Architecture tanulása
- ✅ Dart VM futtathatóság bemutatása
- ✅ Akadálymentesség folyamatos ellenőrzése
- ✅ BLoC state management gyakorlás
- ✅ Dependency Injection megértése

**Továbbfejlesztési lehetőségek:**
- 🔄 Több nyelv támogatása (angol, német, stb.)
- 🔄 7 napos előrejelzés
- 🔄 Több város támogatása
- 🔄 Dark mode
- 🔄 Grafikon (hőmérséklet alakulása)
- 🔄 Push notification (időjárás változás)

---

## Slide 19: Dokumentáció

### További információk

**Elérhető dokumentumok:**

1. **README.md**
   - Projekt áttekintés
   - Dart VM + Akadálymentesség hangsúly
   - Gyors telepítési útmutató

2. **GYORSUTMUTATO.md**
   - Gyors parancsok
   - Gyakori problémák
   - Referencia táblázatok

3. **docs/word_dokumentacio.md**
   - Részletes lépésről-lépésre útmutató
   - Clean Architecture rétegek részletesen
   - L10nHelper részletek (csak itt!)
   - Kód példák minden réteghez

4. **docs/ppt_dokumentacio.md** (ez a fájl)
   - Prezentációs anyag
   - Slide-ok formátumban

---

## Slide 20: Összefoglalás

### Mit tanultunk?

1. **Dart VM futtathatóság**
   - Mock datasource használata
   - Platform-független fejlesztés

2. **Folyamatos akadálymentesség**
   - Semantics widgets minden UI elemhez
   - Accessibility tesztek CI/CD-ben

3. **Clean Architecture**
   - Domain/Data/Presentation rétegek
   - Dependency inversion

4. **BLoC State Management**
   - Events, States, BLoC
   - Reaktív programozás

5. **Dependency Injection**
   - GetIt + Injectable
   - Dev/Prod környezetek

6. **Tesztelhetőség**
   - Unit tesztek
   - Accessibility tesztek Dart VM-ben

---

## Slide 21: Kérdések & Kapcsolat

### Köszönöm a figyelmet!

**Projekt információk:**
- Flutter: 3.35.5
- Dart: 3.9.2
- **Fókusz**: Dart VM futtathatóság + Akadálymentesség ♿
- Architecture: Clean Architecture
- State Management: BLoC
- DI: GetIt + Injectable

**Készítve:** 2025. október 26.

**Kérdések?** 🤔

---

## Függelék: Hasznos linkek

### Flutter dokumentáció

- [Flutter Official Docs](https://docs.flutter.dev/)
- [Flutter Accessibility](https://docs.flutter.dev/ui/accessibility-and-localization/accessibility)
- [Semantics Class](https://api.flutter.dev/flutter/widgets/Semantics-class.html)
- [Flutter Bloc Package](https://pub.dev/packages/flutter_bloc)
- [GetIt Package](https://pub.dev/packages/get_it)
- [Injectable Package](https://pub.dev/packages/injectable)
- [Dartz Package](https://pub.dev/packages/dartz)

### Clean Architecture

- [Clean Architecture (Robert C. Martin)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture Example](https://github.com/ResoCoder/flutter-tdd-clean-architecture-course)

### Akadálymentesség

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Flutter Accessibility Testing](https://docs.flutter.dev/ui/accessibility/accessibility-testing)
- [Semantics in Flutter](https://medium.com/flutter-community/a-deep-dive-into-flutters-accessibility-widgets-eb0ef9455bc)

### API

- [Open-Meteo API](https://open-meteo.com/)

---

**Vége a prezentációnak** 🎉
