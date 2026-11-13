import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Woosh'**
  String get appTitle;

  /// No description provided for @dawn.
  ///
  /// In en, this message translates to:
  /// **'Dawn'**
  String get dawn;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @sunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunset;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels like'**
  String get feelsLike;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @uvIndex.
  ///
  /// In en, this message translates to:
  /// **'UV index'**
  String get uvIndex;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @rainChance.
  ///
  /// In en, this message translates to:
  /// **'Rain chance'**
  String get rainChance;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @errLocationOff.
  ///
  /// In en, this message translates to:
  /// **'Location services are off. Turn them on and try again.'**
  String get errLocationOff;

  /// No description provided for @errLocationDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is needed to show the weather where you are.'**
  String get errLocationDenied;

  /// No description provided for @errLocationForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission was denied. Enable it in the app settings.'**
  String get errLocationForever;

  /// No description provided for @errNetwork.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t connect to the internet. Check your connection and try again.'**
  String get errNetwork;

  /// No description provided for @errData.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read the weather data. Please try again later.'**
  String get errData;

  /// No description provided for @condClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get condClear;

  /// No description provided for @condPartlyCloudy.
  ///
  /// In en, this message translates to:
  /// **'Partly cloudy'**
  String get condPartlyCloudy;

  /// No description provided for @condOvercast.
  ///
  /// In en, this message translates to:
  /// **'Overcast'**
  String get condOvercast;

  /// No description provided for @condFog.
  ///
  /// In en, this message translates to:
  /// **'Foggy'**
  String get condFog;

  /// No description provided for @condDrizzle.
  ///
  /// In en, this message translates to:
  /// **'Drizzle'**
  String get condDrizzle;

  /// No description provided for @condRain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get condRain;

  /// No description provided for @condSnow.
  ///
  /// In en, this message translates to:
  /// **'Snow'**
  String get condSnow;

  /// No description provided for @condThunder.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get condThunder;

  /// No description provided for @reasonColderWind.
  ///
  /// In en, this message translates to:
  /// **'Wind makes it feel colder'**
  String get reasonColderWind;

  /// No description provided for @reasonColderOther.
  ///
  /// In en, this message translates to:
  /// **'Feels colder than the actual temperature'**
  String get reasonColderOther;

  /// No description provided for @reasonWarmerHumid.
  ///
  /// In en, this message translates to:
  /// **'Humidity makes it feel warmer'**
  String get reasonWarmerHumid;

  /// No description provided for @reasonWarmerOther.
  ///
  /// In en, this message translates to:
  /// **'Feels warmer than the actual temperature'**
  String get reasonWarmerOther;

  /// No description provided for @reasonSimilar.
  ///
  /// In en, this message translates to:
  /// **'Close to the actual temperature'**
  String get reasonSimilar;

  /// No description provided for @alertUmbrella.
  ///
  /// In en, this message translates to:
  /// **'Take an umbrella, rain is expected.'**
  String get alertUmbrella;

  /// No description provided for @alertSunscreen.
  ///
  /// In en, this message translates to:
  /// **'Wear sunscreen, the UV index is high.'**
  String get alertSunscreen;

  /// No description provided for @alertWind.
  ///
  /// In en, this message translates to:
  /// **'Strong wind, take care outside.'**
  String get alertWind;

  /// No description provided for @alertHeat.
  ///
  /// In en, this message translates to:
  /// **'Extreme heat, drink water and avoid the sun.'**
  String get alertHeat;

  /// No description provided for @alertCold.
  ///
  /// In en, this message translates to:
  /// **'Very cold, dress warmly.'**
  String get alertCold;

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search for a city'**
  String get searchCity;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'City name'**
  String get searchHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No cities found'**
  String get noResults;

  /// No description provided for @myLocation.
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get myLocation;

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get useMyLocation;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @temperatureUnit.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperatureUnit;

  /// No description provided for @windUnit.
  ///
  /// In en, this message translates to:
  /// **'Wind speed'**
  String get windUnit;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'Showing saved data from {time}'**
  String offlineBanner(String time);

  /// No description provided for @forecastHourly.
  ///
  /// In en, this message translates to:
  /// **'Next 24 hours'**
  String get forecastHourly;

  /// No description provided for @forecastDaily.
  ///
  /// In en, this message translates to:
  /// **'7-day forecast'**
  String get forecastDaily;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @sunTitle.
  ///
  /// In en, this message translates to:
  /// **'Sunrise and sunset'**
  String get sunTitle;

  /// No description provided for @uvLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get uvLow;

  /// No description provided for @uvModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get uvModerate;

  /// No description provided for @uvHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get uvHigh;

  /// No description provided for @uvVeryHigh.
  ///
  /// In en, this message translates to:
  /// **'Very high'**
  String get uvVeryHigh;

  /// No description provided for @uvExtreme.
  ///
  /// In en, this message translates to:
  /// **'Extreme'**
  String get uvExtreme;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;
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
      <String>['ar', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
