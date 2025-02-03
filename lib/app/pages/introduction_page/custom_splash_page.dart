import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:webinar/app/pages/introduction_page/intro_page.dart';
import 'package:webinar/app/pages/introduction_page/vedio_page.dart';
import 'package:webinar/app/pages/main_page/main_page.dart';
import 'package:webinar/app/pages/offline_page/internet_connection_page.dart';
import 'package:webinar/app/services/guest_service/guest_service.dart';
import 'package:webinar/common/data/app_data.dart';
import 'package:webinar/config/assets.dart';
import 'package:webinar/config/colors.dart';

import '../../../common/common.dart';
import 'language_page.dart';

class SplashPage extends StatefulWidget {
  static const String pageName = '/splash';

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );

    FlutterNativeSplash.remove();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animationController.forward();
      navigateToNextScreen();
    });

    GuestService.config();
  }

  /// **🔹 التحقق من حالة التطبيق والتنقل إلى الصفحة المناسبة**
  Future<void> navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    final List<ConnectivityResult> connectivityResult =
    await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      nextRoute(InternetConnectionPage.pageName, isClearBackRoutes: true);
      return;
    }

    // ✅ التحقق مما إذا كان المستخدم قد زار صفحة اللغة من قبل
    bool hasSeenLanguagePage = await AppData.getBool("hasSeenLanguagePage") ?? false;

    if (!hasSeenLanguagePage) {
      await AppData.saveBool("hasSeenLanguagePage", true);
      nextRoute(LanguageSelectionPage.pageName, isClearBackRoutes: true);
      return;
    }

    String token = await AppData.getAccessToken();

    if (mounted) {
      if (token.isEmpty) {
        bool isFirst = await AppData.getIsFirst();
        if (isFirst) {
          nextRoute(IntroPage.pageName, isClearBackRoutes: true);
        } else {
          nextRoute(VideoPage.pageName, isClearBackRoutes: true);
        }
      } else {
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
          const SizedBox(
            height: 100,
          ),
          Center(
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAssets.splash_logo_png),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20,),
           Text(
            textAlign: TextAlign.center,
            'MENTAL SKILLS \n LEARN WITH LOVE ❤',style: TextStyle(fontSize: 25,fontWeight:FontWeight.w600),),
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
            height: 70,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
