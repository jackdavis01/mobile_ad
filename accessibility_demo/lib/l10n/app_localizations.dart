import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_hu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('hu')];

  /// Az alkalmazás címe
  ///
  /// In hu, this message translates to:
  /// **'Budapest Időjárás'**
  String get appTitle;

  /// Hiba címsor
  ///
  /// In hu, this message translates to:
  /// **'Hiba'**
  String get errorTitle;

  /// Cache-ből betöltött adatok jelzése
  ///
  /// In hu, this message translates to:
  /// **'Mentett adatok'**
  String get cachedDataLabel;

  /// Frissítés gomb szövege
  ///
  /// In hu, this message translates to:
  /// **'Frissítés'**
  String get refreshButton;

  /// Frissítés folyamatban gomb szövege
  ///
  /// In hu, this message translates to:
  /// **'Frissítés...'**
  String get refreshingButton;

  /// Adat letöltési/cache időpontjának címkéje
  ///
  /// In hu, this message translates to:
  /// **'Időpont'**
  String get timestampLabel;

  /// Hőmérséklet címke
  ///
  /// In hu, this message translates to:
  /// **'Hőmérséklet'**
  String get temperatureLabel;

  /// Minimum és maximum hőmérséklet címke
  ///
  /// In hu, this message translates to:
  /// **'Min/Max'**
  String get minMaxLabel;

  /// Időjárás leírás címke
  ///
  /// In hu, this message translates to:
  /// **'Időjárás'**
  String get weatherLabel;

  /// Páratartalom címke
  ///
  /// In hu, this message translates to:
  /// **'Páratartalom'**
  String get humidityLabel;

  /// Szélsebesség címke
  ///
  /// In hu, this message translates to:
  /// **'Szélsebesség'**
  String get windSpeedLabel;

  /// Csapadék valószínűség címke
  ///
  /// In hu, this message translates to:
  /// **'Csapadék valószínűség'**
  String get precipitationLabel;

  /// Szerverhiba üzenet paraméterrel
  ///
  /// In hu, this message translates to:
  /// **'Szerverhiba: {error}'**
  String errorServerFailure(String error);

  /// Hálózati hiba üzenet
  ///
  /// In hu, this message translates to:
  /// **'Nincs internetkapcsolat'**
  String get errorNetworkFailure;

  /// Cache hiba üzenet
  ///
  /// In hu, this message translates to:
  /// **'Nincs gyorsítótárazott adat'**
  String get errorCacheFailure;

  /// WMO kód 0
  ///
  /// In hu, this message translates to:
  /// **'Tiszta ég'**
  String get weatherClearSky;

  /// WMO kód 1
  ///
  /// In hu, this message translates to:
  /// **'Túlnyomóan tiszta'**
  String get weatherMainlyClear;

  /// WMO kód 2
  ///
  /// In hu, this message translates to:
  /// **'Részben felhős'**
  String get weatherPartlyCloudy;

  /// WMO kód 3
  ///
  /// In hu, this message translates to:
  /// **'Felhős'**
  String get weatherCloudy;

  /// WMO kód 45, 48
  ///
  /// In hu, this message translates to:
  /// **'Köd'**
  String get weatherFog;

  /// WMO kód 51, 53, 55
  ///
  /// In hu, this message translates to:
  /// **'Szitálás'**
  String get weatherDrizzle;

  /// WMO kód 56, 57
  ///
  /// In hu, this message translates to:
  /// **'Fagyos szitálás'**
  String get weatherFreezingDrizzle;

  /// WMO kód 61, 63, 65
  ///
  /// In hu, this message translates to:
  /// **'Eső'**
  String get weatherRain;

  /// WMO kód 66, 67
  ///
  /// In hu, this message translates to:
  /// **'Fagyos eső'**
  String get weatherFreezingRain;

  /// WMO kód 71, 73, 75, 77, 85, 86
  ///
  /// In hu, this message translates to:
  /// **'Hó'**
  String get weatherSnow;

  /// WMO kód 80, 81, 82
  ///
  /// In hu, this message translates to:
  /// **'Záporok'**
  String get weatherRainShowers;

  /// WMO kód 95, 96, 99
  ///
  /// In hu, this message translates to:
  /// **'Zivatar'**
  String get weatherThunderstorm;

  /// Ismeretlen időjárás kód
  ///
  /// In hu, this message translates to:
  /// **'Ismeretlen'**
  String get weatherUnknown;

  /// No description provided for @monthJanuary.
  ///
  /// In hu, this message translates to:
  /// **'január'**
  String get monthJanuary;

  /// No description provided for @monthFebruary.
  ///
  /// In hu, this message translates to:
  /// **'február'**
  String get monthFebruary;

  /// No description provided for @monthMarch.
  ///
  /// In hu, this message translates to:
  /// **'március'**
  String get monthMarch;

  /// No description provided for @monthApril.
  ///
  /// In hu, this message translates to:
  /// **'április'**
  String get monthApril;

  /// No description provided for @monthMay.
  ///
  /// In hu, this message translates to:
  /// **'május'**
  String get monthMay;

  /// No description provided for @monthJune.
  ///
  /// In hu, this message translates to:
  /// **'június'**
  String get monthJune;

  /// No description provided for @monthJuly.
  ///
  /// In hu, this message translates to:
  /// **'július'**
  String get monthJuly;

  /// No description provided for @monthAugust.
  ///
  /// In hu, this message translates to:
  /// **'augusztus'**
  String get monthAugust;

  /// No description provided for @monthSeptember.
  ///
  /// In hu, this message translates to:
  /// **'szeptember'**
  String get monthSeptember;

  /// No description provided for @monthOctober.
  ///
  /// In hu, this message translates to:
  /// **'október'**
  String get monthOctober;

  /// No description provided for @monthNovember.
  ///
  /// In hu, this message translates to:
  /// **'november'**
  String get monthNovember;

  /// No description provided for @monthDecember.
  ///
  /// In hu, this message translates to:
  /// **'december'**
  String get monthDecember;

  /// No description provided for @dayMonday.
  ///
  /// In hu, this message translates to:
  /// **'hétfő'**
  String get dayMonday;

  /// No description provided for @dayTuesday.
  ///
  /// In hu, this message translates to:
  /// **'kedd'**
  String get dayTuesday;

  /// No description provided for @dayWednesday.
  ///
  /// In hu, this message translates to:
  /// **'szerda'**
  String get dayWednesday;

  /// No description provided for @dayThursday.
  ///
  /// In hu, this message translates to:
  /// **'csütörtök'**
  String get dayThursday;

  /// No description provided for @dayFriday.
  ///
  /// In hu, this message translates to:
  /// **'péntek'**
  String get dayFriday;

  /// No description provided for @daySaturday.
  ///
  /// In hu, this message translates to:
  /// **'szombat'**
  String get daySaturday;

  /// No description provided for @daySunday.
  ///
  /// In hu, this message translates to:
  /// **'vasárnap'**
  String get daySunday;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['hu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'hu':
      return AppLocalizationsHu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
