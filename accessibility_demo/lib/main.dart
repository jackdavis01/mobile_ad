import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:accessibility_demo/app.dart';
import 'package:accessibility_demo/di/injection.dart';

/// Production entry point.
/// 
/// Uses real Open-Meteo API for weather data.
/// Run with: fvm flutter run -t lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize DI with production environment
  await configureDependencies(Environment.prod);
  
  runApp(const App());
}
