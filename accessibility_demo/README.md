# Budapest Időjárás - Clean Architecture Demo

Flutter oktatási projekt, amely bemutatja a **Clean Architecture** használatát Flutter-ben, **folyamatos akadálymentességi ellenőrzéssel** Dart VM-ben történő futtatás révén.

## 🎯 Projekt célja

Ez egy oktatási projekt, amely bemutatja:
- ✅ **Dart VM-ben futtatható** fejlesztés (mock adatokkal)
- ✅ **Folyamatos akadálymentességi ellenőrzés** (Semantics tesztek)
- ✅ Clean Architecture implementálását Flutter-ben
- ✅ Dependency Injection (GetIt + Injectable)
- ✅ BLoC state management
- ✅ Dev/Prod környezet szeparáció (Mock vs API)
- ✅ Offline támogatás cache-eléssel
- ✅ Lokalizáció (ARB fájlok)

## 📋 Követelmények

- **Flutter SDK**: 3.35.5 (FVM-mel telepítve)
- **Dart SDK**: 3.9.2 (automatikusan párosítva Flutter-rel)
- **FVM**: Flutter Version Management
- **iOS/Android**: Csak ezekre a platformokra készült

## 🚀 Telepítés

### 1. FVM beállítása

```bash
# FVM használata a projektben
cd accessibility_demo
fvm use 3.35.5

# Függőségek telepítése (lokalizációs kód is generálódik!)
fvm flutter pub get
```

### 2. Code Generation

```bash
# Injectable config generálása
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

## 🏃 Futtatás

### Production mód (valós API)

```bash
fvm flutter run -t lib/main.dart
```

### Development mód (mock adatok - **Dart VM-ben is fut!**)

```bash
fvm flutter run -t lib/main_dev.dart
```

**🎯 Kulcs előny**: Mock datasource használatával a projekt **Dart VM-ben futtatható**, így:
- ✅ Gyorsabb fejlesztési ciklus (nincs emulator/fizikai eszköz szükséges)
- ✅ **Folyamatos akadálymentességi tesztek** futtatása
- ✅ Semantics ellenőrzése valós futás közben
- ✅ Screen reader tesztelés szimuláció nélkül

### Release build

```bash
# Android release
fvm flutter run --release

# iOS release
fvm flutter run --release -d ios
```

**⚠️ Fontos**: Az internet eléréshez szükséges engedélyek már be vannak állítva:

#### Android (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

## ♿ Akadálymentesség - Folyamatos ellenőrzés

Ez a projekt **központi eleme az akadálymentességi megfelelés folyamatos ellenőrzése**.

### Miért Dart VM?

Hagyományos megközelítés:
1. UI fejlesztése emulatorban/eszközön
2. Akadálymentességi tesztek írása
3. Tesztek futtatása (lassú, nehézkes)
4. Problémák javítása → újra 1.

**Dart VM megközelítés** (ez a projekt):
1. ✅ **Dev környezet** mock adatokkal (Dart VM-ben fut!)
2. ✅ Akadálymentességi tesztek **folyamatosan** futnak
3. ✅ Semantics ellenőrzése **valós időben**
4. ✅ Gyors iterációs ciklus

### Accessibility Features

- ✅ **Semantics labels**: Minden fontos widget szemantikai címkével
- ✅ **Screen reader support**: TalkBack/VoiceOver kompatibilis
- ✅ **Tesztelhetőség**: Accessibility tesztek Dart VM-ben
- ✅ **Kontrasztok**: WCAG AA megfelelés
- ✅ **Érintési területek**: Minimum 48x48 dp

### Semantic példák a kódban

```dart
Semantics(
  label: l10n.weatherTemperature,
  value: '${weather.temperature}°C',
  child: Text('${weather.temperature}°C'),
)
```

## 🌐 Lokalizáció

A projekt lokalizációt használ a szövegek kezelésére:

- **Forrás**: `lib/l10n/app_hu.arb` - Magyar fordítások
- **Generált kód**: Automatikus (`flutter pub get`)
- **Használat**: `L10nHelper.of(context).appTitle`

```

### Új szöveg hozzáadása

1. Szerkeszd a `lib/l10n/app_hu.arb` fájlt:

```json
{
  "myNewText": "Új szöveg",
  "@myNewText": {
    "description": "Leírás"
  }
}
```

2. Generálás:

```bash
fvm flutter pub get
```

3. Használat:

```dart
final l10n = L10nHelper.of(context);
Text(l10n.myNewText)

### Paraméterezett szövegek

```json
{
  "errorServerFailure": "Szerverhiba: {error}",
  "@errorServerFailure": {
    "description": "Hibaüzenet paraméterrel",
    "placeholders": {
      "error": {
        "type": "String"
      }
    }
  }
}
```

Használat:

```dart
final l10n = L10nHelper.of(context);
Text(l10n.errorServerFailure(errorMessage))
```

## 🧪 Tesztelés

### Unit tesztek

```bash
fvm flutter test test/features/weather/domain/
```

### Accessibility tesztek (Dart VM-ben!)

```bash
fvm flutter test test/features/weather/presentation/
```

**🎯 Kulcs**: Accessibility tesztek **Dart VM-ben futnak**, így:
- ✅ Gyors feedback loop (nincs emulator indítás)
- ✅ Folyamatos integráció (CI/CD)
- ✅ Semantics ellenőrzése automatizáltan

### Összes teszt

```bash
fvm flutter test
```

**Teszt eredmények:**
- ✅ 2/2 domain unit test PASSED
- ⚠️ 3 accessibility test (Semantics duplikációk vártak)

## 📁 Projekt struktúra

```
lib/
├── core/
│   ├── l10n/            # Lokalizációs helper
│   ├── error/           # Failure osztályok
│   ├── network/         # Hálózati ellenőrzés
│   └── constants/       # API konstansok
├── features/
│   └── weather/
│       ├── data/        # Data layer (repository impl, datasources, models)
│       ├── domain/      # Domain layer (entities, repository interface, use cases)
│       └── presentation/ # Presentation layer (BLoC, pages, widgets)
├── l10n/                # Lokalizációs fájlok (ARB)
├── di/                  # Dependency Injection
├── app.dart             # App widget
├── main.dart            # Production entry (API)
└── main_dev.dart        # Development entry (Mock - Dart VM!)
```

## 🎨 Funkciók

- ✅ Budapest időjárás adatok megjelenítése
- ✅ **Akadálymentesség**: Semantics minden widgetnél
- ✅ **Dart VM futtathatóság**: Mock datasource
- ✅ Timestamp mező (HH:MM:SS.mmm)
- ✅ "Mentett adatok" fejléc (cache indikátor)
- ✅ Frissítés gomb (loading state)
- ✅ Offline támogatás (cache)
- ✅ Clean Architecture
- ✅ Lokalizáció (ARB)
- ✅ Ikonok minden adatpontnál

## 🔧 Használt technológiák

### Akadálymentesség
- `Semantics` widgets - Screen reader támogatás
- Accessibility tesztek - Dart VM-ben futtatható

### State Management
- `flutter_bloc` 8.1.6 - BLoC pattern
- `equatable` - Value equality

### Dependency Injection
- `get_it` - Service locator
- `injectable` - Code generation (@dev/@prod)

### Networking
- `dio` - HTTP client
- `connectivity_plus` - Hálózat ellenőrzés

### Local Storage
- `shared_preferences` - Key-value tárolás (cache)

### Functional Programming
- `dartz` - Either, Option típusok (funkcionális hibakezelés)

### Testing
- `mocktail` - Mock objektumok

## 📚 API

A projekt az **Open-Meteo** ingyenes Weather API-t használja:
- 🔗 URL: `https://api.open-meteo.com/v1/forecast`
- ✅ Nincs szükség API kulcsra
- ✅ Budapest koordináták: 47.4979, 19.0402

## 🌐 Környezetek

### Production (`main.dart`)
- Valós API hívások (`WeatherRemoteDataSourceImpl`)
- Dio HTTP client
- Hálózat ellenőrzés
- Futtatás: `fvm flutter run -t lib/main.dart`

### Development (`main_dev.dart`)
- Mock datasource (`WeatherMockDataSource`)
- Nincs valós API hívás
- **Dart VM-ben futtatható** ← Kulcs!
- Hardcoded teszt adatok
- Futtatás: `fvm flutter run -t lib/main_dev.dart`

## 📖 Dokumentáció

- `GYORSUTMUTATO.md` - Gyors indítási útmutató
- `docs/word_dokumentacio.md` - Részletes dokumentáció (L10nHelper részletek)
- `docs/ppt_dokumentacio.md` - Prezentációs anyag

## 👨‍💻 Fejlesztés

### Új feature hozzáadása

1. **Domain layer**: Entity, Repository interface, Use case
2. **Data layer**: Model, DataSource (Mock + Remote), Repository implementáció
3. **Presentation layer**: BLoC, UI (Semantics!)
4. **DI regisztráció**: `injection.dart`
5. **Tesztek**: Domain unit + Accessibility (Dart VM-ben!)
6. **Lokalizáció**: Szövegek `app_hu.arb`-ba

### Code generation újrafuttatása

```bash
# Injectable DI kód generálása
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Lokalizációs kód generálása
fvm flutter pub get
```

## 🏆 Best Practices ebben a projektben

1. ✅ **Dart VM futtathatóság**: Mock datasource minden feature-hez
2. ✅ **Akadálymentesség első**: Semantics minden widgethez
3. ✅ **Folyamatos tesztelés**: Accessibility tesztek Dart VM-ben
4. ✅ **WeatherResult**: Explicit cache flag a Domain-ben
5. ✅ **Clean Architecture**: Rétegek szeparációja
6. ✅ **Initial state**: Automatikus betöltés induláskor
7. ✅ **Cache banner**: Offline adat jelzése

## 📝 Licenc

Ez egy oktatási projekt.

---

**Készítve**: 2025. október 26.  
**Flutter**: 3.35.5  
**Dart**: 3.9.2  
**Fókusz**: Dart VM futtathatóság + Akadálymentesség ♿
