# Gyors Útmutató - Budapest Időjárás

Gyors parancsok és tippek a projekt használatához.

## ⚡ Első lépések

```bash
# 1. FVM aktiválás
cd accessibility_demo
fvm use 3.35.5

# 2. Függőségek telepítése
fvm flutter pub get

# 3. Code generation (DI)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# 4. Futtatás development módban (Dart VM-ben!)
fvm flutter run -t lib/main_dev.dart
```

**Kész! Az app Dart VM-ben fut mock adatokkal, akadálymentességi tesztek futtathatók.**

## 🚀 Futtatási módok

### Development (mock adatok - **Dart VM-ben fut!**)

```bash
fvm flutter run -t lib/main_dev.dart
```

**🎯 Előnyök:**
- ✅ Gyors fejlesztés (nincs emulator/eszköz szükséges)
- ✅ Akadálymentességi tesztek futtatása
- ✅ Semantics ellenőrzése valós időben

### Production (valós API)

```bash
fvm flutter run -t lib/main.dart
```

### Release build

```bash
# Android
fvm flutter run --release

# iOS
fvm flutter run --release -d ios
```

## 🧪 Tesztek

```bash
# Összes teszt (Dart VM-ben!)
fvm flutter test

# Accessibility tesztek
fvm flutter test test/features/weather/presentation/

# Domain tesztek
fvm flutter test test/features/weather/domain/
```

## ♿ Akadálymentesség

### Semantics ellenőrzése

```bash
# Tesztek futtatása (Dart VM-ben)
fvm flutter test test/features/weather/presentation/

# Analyze hibák
fvm flutter analyze
```

### Új widget Semantics-szel

```dart
Semantics(
  label: 'Widget leírás',
  value: 'Érték',
  child: YourWidget(),
)
```

## 🌐 Lokalizáció

### Új szöveg hozzáadása

1. **Szerkesztés**: `lib/l10n/app_hu.arb`

```json
{
  "myNewKey": "Új szöveg",
  "@myNewKey": {
    "description": "Leírás"
  }
```

3. **Használat**:

```dart
final l10n = L10nHelper.of(context);
Text(l10n.myNewKey)
```

## 🔧 Code Generation

### Injectable DI újragenerálása

```bash
# Delete conflicting outputs
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (automatikus újragenerálás)
fvm flutter pub run build_runner watch --delete-conflicting-outputs
```

## 📱 Hasznos parancsok

### Projekt tisztítás

```bash
# Build fájlok törlése
fvm flutter clean

# Függőségek újratelepítése
fvm flutter pub get
```

### Analyze & Format

```bash
# Kód analízis
fvm flutter analyze

# Kód formázás
fvm flutter format lib/ test/
```

### Device info

```bash
# Csatlakoztatott eszközök
fvm flutter devices

# Emulator indítása
fvm flutter emulators --launch <emulator_id>
```

## 🐛 Gyakori problémák

### "GetIt is not ready"

❌ **Probléma**: Dependency Injection nincs inicializálva.

✅ **Megoldás**: Ellenőrizd `main.dart`-ban:

```dart
await configureDependencies(Environment.prod);
```

### "Accessibility teszt nem fut"

❌ **Probléma**: Production módban próbálod futtatni.

✅ **Megoldás**: Használd Development módot:

```bash
fvm flutter run -t lib/main_dev.dart
fvm flutter test
```

### "Missing internet permission"

❌ **Probléma**: Release build-ben nem eléri az API-t.

✅ **Megoldás**: Már benne van az `AndroidManifest.xml`-ben.

## 🎯 Környezetek

| Mód | Entry point | Datasource | API | **Dart VM** |
|-----|-------------|-----------|-----|-------------|
| **Development** | `lib/main_dev.dart` | MockDataSource | Mock | ✅ **FUT** |
| **Production** | `lib/main.dart` | RemoteDataSource | Open-Meteo | ❌ Nem |

**🔑 Kulcs**: Development mód Dart VM-ben futtatható → folyamatos accessibility tesztek!

## 📦 Új package hozzáadása

```bash
# Dependency
fvm flutter pub add package_name

# Dev dependency
fvm flutter pub add --dev package_name
```

## 🔑 Gyors referencia

### Semantics hozzáadása

```dart
Semantics(
  label: 'Hőmérséklet',
  value: '18.5°C',
  child: Text('18.5°C'),
)
```

### BLoC event küldése

```dart
context.read<WeatherBloc>().add(const GetWeatherEvent());
```

### Lokalizáció használata

```dart
final l10n = L10nHelper.of(context);
Text(l10n.appTitle)  // 'Budapest Időjárás'
```

## 📚 Kapcsolódó dokumentumok

- **README.md** - Projekt áttekintés, Dart VM + akadálymentesség
- **docs/word_dokumentacio.md** - Részletes dokumentáció (L10nHelper részletek)
- **docs/ppt_dokumentacio.md** - Prezentációs anyag

## 🏆 Best Practices emlékeztető

1. ✅ **Dev környezetben dolgozz** (Dart VM-ben futtatható!)
2. ✅ **Semantics minden widgethez** (akadálymentesség!)
3. ✅ **Tesztek Dart VM-ben** (gyors feedback loop)
4. ✅ **Mock datasource** minden feature-hez
5. ✅ **Analyze gyakran** hibák elkerülésére

---

**Flutter**: 3.35.5 | **Dart**: 3.9.2 | **Fókusz**: Dart VM + Akadálymentesség ♿
