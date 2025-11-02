import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:accessibility_demo/di/injection.dart';
import 'package:accessibility_demo/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:accessibility_demo/features/weather/presentation/pages/weather_page.dart';
import 'package:accessibility_demo/l10n/app_localizations.dart';

/// Main App widget.
/// 
/// Configures localization delegates and BLoC providers.
/// This widget is environment-independent (works for both prod and dev).
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budapest Időjárás',
      debugShowCheckedModeBanner: false,
      
      // Localization configuration
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('hu'), // Hungarian only
      ],
      locale: const Locale('hu'),
      
      // Theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
      ),
      
      // BLoC provider
      home: BlocProvider(
        create: (_) => getIt<WeatherBloc>(),
        child: const WeatherPage(),
      ),
    );
  }
}
