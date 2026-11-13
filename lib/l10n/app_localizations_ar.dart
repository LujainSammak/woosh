// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Woosh';

  @override
  String get dawn => 'الفجر';

  @override
  String get day => 'النهار';

  @override
  String get sunset => 'الغروب';

  @override
  String get night => 'الليل';

  @override
  String get feelsLike => 'الشعور بالحرارة';

  @override
  String get humidity => 'الرطوبة';

  @override
  String get wind => 'الرياح';

  @override
  String get uvIndex => 'الأشعة فوق البنفسجية';

  @override
  String get sunrise => 'الشروق';

  @override
  String get rainChance => 'احتمال المطر';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get errLocationOff => 'خدمة الموقع متوقفة. فعّلها ثم أعد المحاولة.';

  @override
  String get errLocationDenied => 'نحتاج إذن الموقع لعرض طقس منطقتك.';

  @override
  String get errLocationForever =>
      'تم رفض إذن الموقع. فعّله من إعدادات التطبيق.';

  @override
  String get errNetwork =>
      'تعذّر الاتصال بالإنترنت. تحقق من الاتصال وأعد المحاولة.';

  @override
  String get errData => 'تعذّر قراءة بيانات الطقس. أعد المحاولة لاحقاً.';

  @override
  String get condClear => 'صافٍ';

  @override
  String get condPartlyCloudy => 'غائم جزئياً';

  @override
  String get condOvercast => 'غائم';

  @override
  String get condFog => 'ضباب';

  @override
  String get condDrizzle => 'رذاذ';

  @override
  String get condRain => 'مطر';

  @override
  String get condSnow => 'ثلج';

  @override
  String get condThunder => 'عاصفة رعدية';

  @override
  String get reasonColderWind => 'الرياح تجعل الجو أبرد';

  @override
  String get reasonColderOther => 'الجو يبدو أبرد من الحرارة الفعلية';

  @override
  String get reasonWarmerHumid => 'الرطوبة تجعل الجو أدفأ';

  @override
  String get reasonWarmerOther => 'الجو يبدو أدفأ من الحرارة الفعلية';

  @override
  String get reasonSimilar => 'قريب من الحرارة الفعلية';

  @override
  String get alertUmbrella => 'خذ مظلتك، من المتوقع هطول أمطار.';

  @override
  String get alertSunscreen => 'ضع واقي الشمس، الأشعة فوق البنفسجية عالية.';

  @override
  String get alertWind => 'رياح قوية، انتبه في الخارج.';

  @override
  String get alertHeat => 'حرارة شديدة، اشرب الماء وتجنب الشمس.';

  @override
  String get alertCold => 'برد شديد، ارتدِ ملابس دافئة.';

  @override
  String get searchCity => 'ابحث عن مدينة';

  @override
  String get searchHint => 'اسم المدينة';

  @override
  String get noResults => 'لم يتم العثور على مدن';

  @override
  String get myLocation => 'موقعي';

  @override
  String get useMyLocation => 'استخدم موقعي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get temperatureUnit => 'درجة الحرارة';

  @override
  String get windUnit => 'سرعة الرياح';

  @override
  String get language => 'اللغة';

  @override
  String get systemDefault => 'لغة النظام';

  @override
  String offlineBanner(String time) {
    return 'عرض بيانات محفوظة من $time';
  }

  @override
  String get forecastHourly => 'الساعات الـ 24 القادمة';

  @override
  String get forecastDaily => 'توقعات 7 أيام';

  @override
  String get today => 'اليوم';

  @override
  String get now => 'الآن';

  @override
  String get details => 'التفاصيل';

  @override
  String get sunTitle => 'الشروق والغروب';

  @override
  String get uvLow => 'منخفض';

  @override
  String get uvModerate => 'متوسط';

  @override
  String get uvHigh => 'مرتفع';

  @override
  String get uvVeryHigh => 'مرتفع جدًا';

  @override
  String get uvExtreme => 'شديد';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';
}
