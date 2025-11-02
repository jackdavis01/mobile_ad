import 'package:accessibility_demo/features/weather/domain/entities/weather.dart';
import 'package:accessibility_demo/features/weather/presentation/widgets/refresh_button.dart';
import 'package:accessibility_demo/features/weather/presentation/widgets/weather_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:accessibility_demo/l10n/app_localizations.dart';

/// Helper to wrap widget with MaterialApp and localization
Widget wrapWithApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('hu')],
    locale: const Locale('hu'),
    home: Scaffold(body: child),
  );
}

void main() {
  group('Accessibility Tests with L10nHelper', () {
    /// Test 1: RefreshButton accessibility with L10nHelper
    testWidgets('RefreshButton has correct semantics with L10nHelper',
        (tester) async {
      // Arrange
      var pressed = false;
      
      // Act
      await tester.pumpWidget(
        wrapWithApp(
          RefreshButton(
            onPressed: () => pressed = true,
          ),
        ),
      );

      // Assert - verify semantics
      expect(find.bySemanticsLabel('Frissítés'), findsOneWidget);
      
      // Test interaction
      await tester.tap(find.byType(RefreshButton));
      await tester.pump();
      
      expect(pressed, isTrue);
    });

    /// Test 2: RefreshButton loading state accessibility
    testWidgets('RefreshButton loading state has correct semantics',
        (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        wrapWithApp(
          RefreshButton(
            onPressed: () {},
            isLoading: true,
          ),
        ),
      );

      // Assert - verify loading semantics
      expect(find.bySemanticsLabel('Frissítés...'), findsOneWidget);
    });

    /// Test 3: WeatherInfoCard accessibility with timestamp and L10nHelper
    testWidgets('WeatherInfoCard has correct semantics with timestamp',
        (tester) async {
      // Arrange
      const weather = Weather(
        date: '2025-10-26',
        timestamp: '14:23:45.123', // Timestamp must be present!
        temperature: 18.5,
        minTemperature: 12.0,
        maxTemperature: 22.0,
        description: 'weatherPartlyCloudy',
        humidity: 65,
        windSpeed: 12.3,
        precipitationProbability: 20,
      );

      // Act
      await tester.pumpWidget(
        wrapWithApp(
          WeatherInfoCard(weather: weather),
        ),
      );

      // Assert - verify all data points have semantics (including timestamp!)
      expect(find.text('2025. október 26., vasárnap'), findsOneWidget);
      expect(find.text('Időpont: 14:23:45.123'), findsOneWidget); // Timestamp!
      expect(find.text('Hőmérséklet'), findsOneWidget);
      expect(find.text('18.5°C'), findsOneWidget);
      expect(find.text('Min/Max'), findsOneWidget);
      expect(find.text('12.0°C / 22.0°C'), findsOneWidget);
      expect(find.text('Időjárás'), findsOneWidget);
      expect(find.text('Részben felhős'), findsOneWidget);
      expect(find.text('Páratartalom'), findsOneWidget);
      expect(find.text('65%'), findsOneWidget);
      expect(find.text('Szélsebesség'), findsOneWidget);
      expect(find.text('12.3 km/h'), findsOneWidget);
      expect(find.text('Csapadék valószínűség'), findsOneWidget);
      expect(find.text('20%'), findsOneWidget);
    });
  });
}
