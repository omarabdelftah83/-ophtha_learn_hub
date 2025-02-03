import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/data/app_data.dart';

import '../main_page/main_page.dart';
import 'language_page.dart';

class VideoPage extends StatefulWidget {
  static const String pageName = '/videoPage';

  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/image/vedio/vedio.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();

        _controller.addListener(() {
          if (_controller.value.position == _controller.value.duration) {
            _navigateToNextPage();
          }
        });
      });
  }

  void _navigateToNextPage() async{
    String token = await AppData.getAccessToken();

    if (mounted) {
      if (token.isEmpty) {
        bool isFirst = await AppData.getIsFirst();
        if (isFirst) {
          nextRoute(LanguageSelectionPage.pageName, isClearBackRoutes: true);
        } else {
          Navigator.pushReplacementNamed(context, MainPage.pageName); // الانتقال إلى الصفحة الرئيسية
        }
      } }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
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
                const SizedBox(height: 50),
                Center(
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                      : const CircularProgressIndicator(),
                ),
                const SizedBox(height: 10),
                const Text(
                  textAlign: TextAlign.center,
                  'MENTAL SKILLS \n LEARN WITH LOVE ❤',
                  style: TextStyle(
                    fontSize: 25,
                  ),
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
                  height: 70,
                  width: double.infinity,
                ),
              ],
            ),
          ),

          Positioned(
            top: 20,
            left:160,
            child: ClipOval(
              child: Image.asset(
                'assets/image/png/anmka.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
