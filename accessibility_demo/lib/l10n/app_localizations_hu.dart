// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'Budapest Időjárás';

  @override
  String get errorTitle => 'Hiba';

  @override
  String get cachedDataLabel => 'Mentett adatok';

  @override
  String get refreshButton => 'Frissítés';

  @override
  String get refreshingButton => 'Frissítés...';

  @override
  String get timestampLabel => 'Időpont';

  @override
  String get temperatureLabel => 'Hőmérséklet';

  @override
  String get minMaxLabel => 'Min/Max';

  @override
  String get weatherLabel => 'Időjárás';

  @override
  String get humidityLabel => 'Páratartalom';

  @override
  String get windSpeedLabel => 'Szélsebesség';

  @override
  String get precipitationLabel => 'Csapadék valószínűség';

  @override
  String errorServerFailure(String error) {
    return 'Szerverhiba: $error';
  }

  @override
  String get errorNetworkFailure => 'Nincs internetkapcsolat';

  @override
  String get errorCacheFailure => 'Nincs gyorsítótárazott adat';

  @override
  String get weatherClearSky => 'Tiszta ég';

  @override
  String get weatherMainlyClear => 'Túlnyomóan tiszta';

  @override
  String get weatherPartlyCloudy => 'Részben felhős';

  @override
  String get weatherCloudy => 'Felhős';

  @override
  String get weatherFog => 'Köd';

  @override
  String get weatherDrizzle => 'Szitálás';

  @override
  String get weatherFreezingDrizzle => 'Fagyos szitálás';

  @override
  String get weatherRain => 'Eső';

  @override
  String get weatherFreezingRain => 'Fagyos eső';

  @override
  String get weatherSnow => 'Hó';

  @override
  String get weatherRainShowers => 'Záporok';

  @override
  String get weatherThunderstorm => 'Zivatar';

  @override
  String get weatherUnknown => 'Ismeretlen';

  @override
  String get monthJanuary => 'január';

  @override
  String get monthFebruary => 'február';

  @override
  String get monthMarch => 'március';

  @override
  String get monthApril => 'április';

  @override
  String get monthMay => 'május';

  @override
  String get monthJune => 'június';

  @override
  String get monthJuly => 'július';

  @override
  String get monthAugust => 'augusztus';

  @override
  String get monthSeptember => 'szeptember';

  @override
  String get monthOctober => 'október';

  @override
  String get monthNovember => 'november';

  @override
  String get monthDecember => 'december';

  @override
  String get dayMonday => 'hétfő';

  @override
  String get dayTuesday => 'kedd';

  @override
  String get dayWednesday => 'szerda';

  @override
  String get dayThursday => 'csütörtök';

  @override
  String get dayFriday => 'péntek';

  @override
  String get daySaturday => 'szombat';

  @override
  String get daySunday => 'vasárnap';
}
