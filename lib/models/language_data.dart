import 'package:mapane/localization/locale_constant.dart';

class LanguageData {
  final String flag;
  final String name;
  final String languageCode;

  LanguageData(this.flag, this.name, this.languageCode);

  static List<LanguageData> languageList() {
    return <LanguageData>[
      LanguageData("fr", "Francais", "fr"),
      LanguageData("en", "English", 'en'),
    ];
  }
}