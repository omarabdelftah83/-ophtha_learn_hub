import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class ContactUtils {
  /// إرسال إلى رابط ///
  static Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// إجراء مكالمة هاتفية ///
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  /// إرسال بريد إلكتروني ///
  static Future<void> sendEmail(String emailAddress) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: emailAddress);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailAddress';
    }
  }

  /// نسخ إلى الحافظة ///
  static void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم نسخ الرقم إلى الحافظة')),
    );
  }

  static Future<void> sendWhatsAppMessage(String phoneNumber, {String message = ''}) async {
    final String whatsappUrl = "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'لا يمكن فتح واتساب، تأكد من تثبيته على جهازك';
    }
  }
}
