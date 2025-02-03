
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguageProvider extends ChangeNotifier {
  void changeState(){
    notifyListeners();
  }



  Locale _appLocale = Locale('ar'); // اللغة الافتراضية

  Locale get appLocale => _appLocale;

  AppLanguageProvider() {
    _loadSavedLanguage();
  }

  // 🔹 تحميل اللغة المحفوظة عند تشغيل التطبيق
  Future<void> _loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('app_language');
    if (savedLanguage != null) {
      _appLocale = Locale(savedLanguage);
      notifyListeners();
    }
  }

  // 🔹 تغيير اللغة وحفظها في `SharedPreferences`
  Future<void> changeLanguage(String languageCode) async {
    _appLocale = Locale(languageCode);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', languageCode);
    notifyListeners(); // تحديث التطبيق لعرض اللغة الجديدة
  }


}

