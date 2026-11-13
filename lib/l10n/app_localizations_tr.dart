// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Woosh';

  @override
  String get dawn => 'Şafak';

  @override
  String get day => 'Gündüz';

  @override
  String get sunset => 'Gün batımı';

  @override
  String get night => 'Gece';

  @override
  String get feelsLike => 'Hissedilen';

  @override
  String get humidity => 'Nem';

  @override
  String get wind => 'Rüzgar';

  @override
  String get uvIndex => 'UV indeksi';

  @override
  String get sunrise => 'Gün doğumu';

  @override
  String get rainChance => 'Yağış ihtimali';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get errLocationOff => 'Konum servisi kapalı. Açıp tekrar deneyin.';

  @override
  String get errLocationDenied =>
      'Bulunduğunuz yerin havasını göstermek için konum izni gerekir.';

  @override
  String get errLocationForever =>
      'Konum izni reddedildi. Uygulama ayarlarından açın.';

  @override
  String get errNetwork =>
      'İnternet bağlantısı kurulamadı. Bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get errData =>
      'Hava durumu verisi okunamadı. Daha sonra tekrar deneyin.';

  @override
  String get condClear => 'Açık';

  @override
  String get condPartlyCloudy => 'Parçalı bulutlu';

  @override
  String get condOvercast => 'Kapalı';

  @override
  String get condFog => 'Sisli';

  @override
  String get condDrizzle => 'Çisenti';

  @override
  String get condRain => 'Yağmurlu';

  @override
  String get condSnow => 'Karlı';

  @override
  String get condThunder => 'Gök gürültülü fırtına';

  @override
  String get reasonColderWind => 'Rüzgar daha soğuk hissettiriyor';

  @override
  String get reasonColderOther => 'Gerçek sıcaklıktan daha soğuk hissediliyor';

  @override
  String get reasonWarmerHumid => 'Nem daha sıcak hissettiriyor';

  @override
  String get reasonWarmerOther => 'Gerçek sıcaklıktan daha sıcak hissediliyor';

  @override
  String get reasonSimilar => 'Gerçek sıcaklığa yakın';

  @override
  String get alertUmbrella => 'Şemsiyeni al, yağış bekleniyor.';

  @override
  String get alertSunscreen => 'Güneş kremi sür, UV yüksek.';

  @override
  String get alertWind => 'Güçlü rüzgar, dışarıda dikkatli ol.';

  @override
  String get alertHeat => 'Aşırı sıcak, su iç ve güneşten kaçın.';

  @override
  String get alertCold => 'Çok soğuk, sıcak giyin.';

  @override
  String get searchCity => 'Şehir ara';

  @override
  String get searchHint => 'Şehir adı';

  @override
  String get noResults => 'Şehir bulunamadı';

  @override
  String get myLocation => 'Konumum';

  @override
  String get useMyLocation => 'Konumumu kullan';

  @override
  String get settings => 'Ayarlar';

  @override
  String get temperatureUnit => 'Sıcaklık';

  @override
  String get windUnit => 'Rüzgar hızı';

  @override
  String get language => 'Dil';

  @override
  String get systemDefault => 'Sistem varsayılanı';

  @override
  String offlineBanner(String time) {
    return '$time tarihli kayıtlı veriler gösteriliyor';
  }

  @override
  String get forecastHourly => 'Önümüzdeki 24 saat';

  @override
  String get forecastDaily => '7 günlük tahmin';

  @override
  String get today => 'Bugün';

  @override
  String get now => 'Şimdi';

  @override
  String get details => 'Ayrıntılar';

  @override
  String get sunTitle => 'Gün doğumu ve batımı';

  @override
  String get uvLow => 'Düşük';

  @override
  String get uvModerate => 'Orta';

  @override
  String get uvHigh => 'Yüksek';

  @override
  String get uvVeryHigh => 'Çok yüksek';

  @override
  String get uvExtreme => 'Aşırı';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';
}
