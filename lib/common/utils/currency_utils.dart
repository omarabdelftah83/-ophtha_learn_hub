import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:webinar/app/models/currency_model.dart';
import 'package:webinar/app/services/guest_service/guest_service.dart';
import 'package:webinar/common/data/api_public_data.dart';
import 'package:webinar/common/data/app_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyUtils {
  static String userCurrency = "USD"; // العملة الافتراضية
  static late String previousCurrency;

  // دالة لتحميل العملة بناءً على الموقع الجغرافي
  static Future<void> fetchCurrencyBasedOnLocation() async {
    try {
      // الحصول على الإحداثيات الجغرافية
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude,
      );

      if (placemarks.isNotEmpty) {
        String countryCode = placemarks.first.isoCountryCode ?? "US";

        // جلب العملة باستخدام API
        String currency = await getCurrencyByCountryCode(countryCode);

        // تحقق من تغير العملة
        if (currency != userCurrency) {
          previousCurrency = userCurrency;
          userCurrency = currency;
          print("تم تحديث العملة: $userCurrency");
        }
      }
    } catch (e) {
      print("خطأ في تحديد العملة: $e");
    }
  }

  // دالة للحصول على العملة بناءً على كود البلد باستخدام API
  static Future<String> getCurrencyByCountryCode(String countryCode) async {
    final url = Uri.parse('https://restcountries.com/v3.1/alpha/$countryCode');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data.isNotEmpty) {
          String currencyCode = data[0]['currencies']?.keys?.first ?? 'USD';
          return currencyCode;
        }
      }
    } catch (e) {
      print("خطأ في جلب البيانات من API: $e");
    }
    return 'USD'; // إرجاع الدولار كافتراضي في حال عدم العثور على عملة
  }

  // دالة للحصول على رمز العملة بناءً على الكود
  static String getSymbol(String currencyCode) {
    return NumberFormat.simpleCurrency(name: currencyCode).currencySymbol;
  }

  // دالة لحساب السعر بناءً على العملة
  static String calculator(var price) {
    String symbol = getSymbol(userCurrency);

    if (PublicData.currencyListData.indexWhere((element) => element.currency == userCurrency) == -1) {
      return PublicData.apiConfigData['currency_position']?.toString().toLowerCase() == 'right' ? '$price$symbol' : '$symbol$price';
    }

    CurrencyModel currency = PublicData.currencyListData[PublicData.currencyListData.indexWhere((element) => element.currency == userCurrency)];
    double newPrice = (price ?? 0.0) * (currency.exchangeRate ?? 1.0);

    return currency.currencyPosition?.toString().toLowerCase() == 'right'
        ? '${newPrice.toStringAsFixed(currency.currencyDecimal ?? 0)}$symbol'
        : '$symbol${newPrice.toStringAsFixed(currency.currencyDecimal ?? 0)}';
  }
}
