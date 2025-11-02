import 'package:flutter/material.dart';
import 'package:accessibility_demo/l10n/app_localizations.dart';

/// Helper class for safe access to AppLocalizations without null assertion operator.
/// 
/// Instead of using `AppLocalizations.of(context)!` everywhere, use:
/// ```dart
/// final l10n = L10nHelper.of(context);
/// Text(l10n.appTitle)
/// ```
/// 
/// Benefits:
/// - No null assertion operator (!) needed in code
/// - Centralized null check with fallback
/// - Development-time assert helps catch missing localization setup
/// - Production fallback ensures app doesn't crash
class L10nHelper {
  /// Get AppLocalizations safely without null assertion operator.
  /// 
  /// If AppLocalizations is not found in context (missing localizationsDelegates):
  /// - In debug mode: triggers assert to alert developer
  /// - Always: returns fallback Hungarian localization
  static AppLocalizations of(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    if (localizations == null) {
      // Alert developer in debug mode
      assert(false, 
        'AppLocalizations not found in context! '
        'Did you forget to add localizationsDelegates to MaterialApp?'
      );
      
      // Fallback to Hungarian to prevent crashes in production
      return lookupAppLocalizations(const Locale('hu'));
    }
    
    return localizations;
  }
}
