import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webinar/app/pages/introduction_page/intro_page.dart';
import 'package:webinar/common/data/app_data.dart';
import '../../../locator.dart';
import '../../providers/app_language_provider.dart';
import '../../../common/data/app_language.dart';
import '../main_page/main_page.dart';

class LanguageSelectionPage extends StatelessWidget {
  static const String pageName = '/language_page';
  Future<void> navigateToNextScreen(BuildContext context) async {
    String token = await AppData.getAccessToken();

    if (token.isEmpty) {
      bool isFirst = await AppData.getIsFirst();
      if (isFirst) {
        Navigator.pushReplacementNamed(context, IntroPage.pageName); // الانتقال إلى صفحة المقدمة
      } else {
        Navigator.pushReplacementNamed(context, MainPage.pageName); // الانتقال إلى الصفحة الرئيسية
      }
    } else {
      Navigator.pushReplacementNamed(context, MainPage.pageName); // الانتقال إلى الصفحة الرئيسية
    }
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguageProvider>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.purple.withOpacity(0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(65),
                bottomRight: Radius.circular(65),
              ),
            ),
            height: 70,
            width: double.infinity,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 220),
              LanguageButton(
                text: 'اللغه',
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LanguageButton(
                    text: 'English',
                    onPressed: () async {
                      await locator<AppLanguage>().saveLanguage('en');
                      locator<AppLanguageProvider>().changeState();
                      navigateToNextScreen(context);
                    },
                  ),
                  const SizedBox(width: 30),
                  LanguageButton(
                    text: 'عربي',
                    onPressed: () async {
                      await locator<AppLanguage>().saveLanguage('ar');
                      locator<AppLanguageProvider>().changeState();
                      navigateToNextScreen(context);
                    },
                  ),
                ],
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.7),
                      Colors.blue,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(65),
                    topRight: Radius.circular(65),
                  ),
                ),
                height: 55,
                width: double.infinity,
              ),
            ],
          ),
          const Positioned(
            top: 15,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'MENTAL SKILLS \n LEARN WITH LOVE ❤',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 10,
            child: ClipOval(
              child: Image.asset(
                'assets/image/png/anmka.png',
                width: 45,
                height: 45,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const LanguageButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink,
              Colors.redAccent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
