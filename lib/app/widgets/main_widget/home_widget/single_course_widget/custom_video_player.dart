import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_player/modern_player.dart';
import 'full_screen_video_page.dart'; // استيراد صفحة ملء الشاشة
import 'dart:async'; // استيراد مكتبة Timer

class PodVideoPlayerDev extends StatefulWidget {
  final String type;
  final String url;
  final String name;
  final RouteObserver<ModalRoute<void>> routeObserver;

  const PodVideoPlayerDev(this.url, this.type, this.routeObserver, {super.key, required this.name});

  @override
  State<PodVideoPlayerDev> createState() => _VimeoVideoPlayerState();
}

class _VimeoVideoPlayerState extends State<PodVideoPlayerDev> {
  bool _isFullScreen = false;
  double _watermarkPositionX = 0.0;  // متغير لتحديد مكان العلامة المائية أفقياً
  double _watermarkPositionY = 0.0;  // متغير لتحديد مكان العلامة المائية رأسياً
  late Timer _timer;

  // دالة لتبديل الوضع بين ملء الشاشة والوضع الطبيعي
  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      // الانتقال إلى الوضع الأفقي (ملء الشاشة)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenVideoPage(url: widget.url, name: widget.name),
        ),
      ).then((_) {
        // إعادة تعيين الحالة بعد العودة من ملء الشاشة
        setState(() {
          print(_isFullScreen);
          print("_isFullScreen");
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          _isFullScreen = false;
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        });
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // إعداد الـ Timer لتحريك العلامة المائية كل 3 ثواني
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        // التبديل بين مكانين مختلفين للعلامة المائية: من الزاوية العلوية اليسرى إلى المنتصف
        if (_watermarkPositionX == 0.0 && _watermarkPositionY == 0.0) {
          _watermarkPositionX = 0.5; // التحرك نحو المنتصف أفقياً
          _watermarkPositionY = 0.5; // التحرك نحو المنتصف رأسياً
        } else {
          _watermarkPositionX = 0.0; // العودة إلى الزاوية العلوية اليسرى أفقياً
          _watermarkPositionY = 0.0; // العودة إلى الزاوية العلوية اليسرى رأسياً
        }
      });
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  }

  @override
  void dispose() {
    // إلغاء الـ Timer عند تدمير الـ widget لتجنب التسريبات
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 400,  // نعرضه في الوضع العادي
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                      color: Colors.black,
                    ),
                    onPressed: (){
                      _toggleFullScreen();
                      // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                    },
                  ),
                ),
              ),
              Flexible(
                child: Stack(
                  children: [
                    SizedBox(
                      height: 250,  // عرض الفيديو في الوضع العادي
                      width: MediaQuery.of(context).size.width,
                      child: ModernPlayer.createPlayer(
                        controlsOptions: ModernPlayerControlsOptions(
                          showControls: true,
                          doubleTapToSeek: true,
                          showMenu: true,
                          showMute: false,
                          showBackbutton: false,
                          enableVolumeSlider: true,
                          enableBrightnessSlider: true,
                          showBottomBar: true,
                        ),
                        defaultSelectionOptions: ModernPlayerDefaultSelectionOptions(
                            defaultQualitySelectors: [DefaultSelectorLabel('360p')]
                        ),
                        video: ModernPlayerVideo.youtubeWithUrl(
                          url: widget.url,  // رابط الفيديو
                          fetchQualities: true,
                        ),
                      ),
                    ),
                    // إضافة العلامة المائية
                    AnimatedPositioned(
                      duration: Duration(seconds: 1),  // مدة الحركة
                      // الحساب لتحديد مكان العلامة المائية أفقيًا ورأسيًا في وسط الفيديو
                      left: _watermarkPositionX == 0.0
                          ? 0 // الزاوية العلوية اليسرى
                          : (MediaQuery.of(context).size.width / 2) - 100, // المنتصف أفقياً (للسهولة، قمنا بطرح 100 لأن عرض النص سيكون 200 تقريبًا)
                      top: _watermarkPositionY == 0.0
                          ? 0 // الزاوية العلوية اليسرى
                          : (250 / 2) - 50, // المنتصف رأسياً (حيث أن ارتفاع الفيديو هو 250، نقوم بتحديد المنتصف عن طريق الحساب
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.transparent,
                        child: Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: 10, // يمكن تعديل الحجم حسب الرغبة
                            color: Colors.white.withOpacity(0.5), // شفافية النص
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
