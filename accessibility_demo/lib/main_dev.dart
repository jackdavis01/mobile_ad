import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:accessibility_demo/app.dart';
import 'package:accessibility_demo/di/injection.dart';

/// Development entry point.
/// 
/// Uses mock data source (no real API calls).
/// Run with: fvm flutter run -t lib/main_dev.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize DI with development environment (mock data)
  await configureDependencies(Environment.dev);
  
  runApp(const App());
}
